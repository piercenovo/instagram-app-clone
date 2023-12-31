// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_app/core/utils/constants/firebase.dart';
import 'package:instagram_app/features/post/data/data_sources/remote_data_source/post_remote_data_source.dart';
import 'package:instagram_app/features/post/data/models/comment_model.dart';
import 'package:instagram_app/features/post/data/models/post_model.dart';
import 'package:instagram_app/features/post/data/models/replay_model.dart';
import 'package:instagram_app/features/post/domain/entities/comment_entity.dart';
import 'package:instagram_app/features/post/domain/entities/post_entity.dart';
import 'package:instagram_app/features/post/domain/entities/replay_entity.dart';

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final FirebaseFirestore fireStore;
  final FirebaseStorage storage;
  final FirebaseAuth auth;

  PostRemoteDataSourceImpl({
    required this.storage,
    required this.fireStore,
    required this.auth,
  });

  @override
  Future<void> createPost(PostEntity post) async {
    final postCollection = fireStore.collection(FirebaseConst.posts);

    final newPost = PostModel(
      postId: post.postId,
      creatorUid: post.creatorUid,
      username: post.username,
      description: post.description,
      postImageUrl: post.postImageUrl,
      likes: const [],
      totalLikes: 0,
      totalComments: 0,
      createAt: post.createAt,
      userProfileUrl: post.userProfileUrl,
    ).toJson();

    try {
      final postDocRef = await postCollection.doc(post.postId).get();

      if (!postDocRef.exists) {
        postCollection.doc(post.postId).set(newPost).then((value) {
          final userCollection =
              fireStore.collection(FirebaseConst.users).doc(post.creatorUid);

          userCollection.get().then((value) {
            if (value.exists) {
              final totalPosts = value.get('totalPosts');
              userCollection.update({'totalPosts': totalPosts + 1});
              return;
            }
          });
        });
      } else {
        postCollection.doc(post.postId).update(newPost);
      }
    } catch (e) {
      toast('Some error occurred');
    }
  }

  @override
  Future<void> deletePost(PostEntity post) async {
    final postCollection = fireStore.collection(FirebaseConst.posts);

    try {
      postCollection.doc(post.postId).delete().then((value) {
        final userCollection =
            fireStore.collection(FirebaseConst.users).doc(post.creatorUid);

        userCollection.get().then((value) {
          if (value.exists) {
            final totalPosts = value.get('totalPosts');
            userCollection.update({'totalPosts': totalPosts - 1});
            return;
          }
        });
      });
    } catch (e) {
      print("some error occured $e");
    }
  }

  @override
  Future<void> likePost(PostEntity post) async {
    final postCollection = fireStore.collection(FirebaseConst.posts);

    final currentUid = auth.currentUser!.uid;
    final postRef = await postCollection.doc(post.postId).get();

    if (postRef.exists) {
      List likes = postRef.get('likes');
      final totalLikes = postRef.get('totalLikes');
      if (likes.contains(currentUid)) {
        postCollection.doc(post.postId).update({
          'likes': FieldValue.arrayRemove([currentUid]),
          'totalLikes': totalLikes - 1
        });
      } else {
        postCollection.doc(post.postId).update({
          'likes': FieldValue.arrayUnion([currentUid]),
          'totalLikes': totalLikes + 1
        });
      }
    }
  }

  @override
  Stream<List<PostEntity>> readPosts(PostEntity post) {
    final postCollection = fireStore
        .collection(FirebaseConst.posts)
        .orderBy('createAt', descending: true);

    return postCollection.snapshots().map(
          (querySnapshot) =>
              querySnapshot.docs.map((e) => PostModel.fromSnapshot(e)).toList(),
        );
  }

  @override
  Stream<List<PostEntity>> readSinglePost(String postId) {
    final postCollection = fireStore
        .collection(FirebaseConst.posts)
        .orderBy('createAt', descending: true)
        .where(
          'postId',
          isEqualTo: postId,
        );

    return postCollection.snapshots().map(
          (querySnapshot) =>
              querySnapshot.docs.map((e) => PostModel.fromSnapshot(e)).toList(),
        );
  }

  @override
  Future<void> updatePost(PostEntity post) async {
    final postCollection = fireStore.collection(FirebaseConst.posts);

    Map<String, dynamic> postInfo = {};

    if (post.description != '' && post.description != null) {
      postInfo['description'] = post.description;
    }

    if (post.postImageUrl != '' && post.postImageUrl != null) {
      postInfo['postImageUrl'] = post.postImageUrl;
    }

    postCollection.doc(post.postId).update(postInfo);
  }

  @override
  Future<void> createComment(CommentEntity comment) async {
    final commentCollection = fireStore
        .collection(FirebaseConst.posts)
        .doc(comment.postId)
        .collection(FirebaseConst.comment);

    final newComment = CommentModel(
      commentId: comment.commentId,
      postId: comment.postId,
      creatorUid: comment.creatorUid,
      description: comment.description,
      username: comment.username,
      userProfileUrl: comment.userProfileUrl,
      createAt: comment.createAt,
      likes: const [],
      totalReplays: comment.totalReplays,
    ).toJson();

    try {
      final commentDocRef =
          await commentCollection.doc(comment.commentId).get();

      if (!commentDocRef.exists) {
        commentCollection.doc(comment.commentId).set(newComment).then((value) {
          final postCollection =
              fireStore.collection(FirebaseConst.posts).doc(comment.postId);

          postCollection.get().then((value) {
            if (value.exists) {
              final totalComments = value.get('totalComments');
              postCollection.update({'totalComments': totalComments + 1});
              return;
            }
          });
        });
      } else {
        commentCollection.doc(comment.commentId).update(newComment);
      }
    } catch (e) {
      toast('Some error occurred');
    }
  }

  @override
  Future<void> deleteComment(CommentEntity comment) async {
    final commentCollection = fireStore
        .collection(FirebaseConst.posts)
        .doc(comment.postId)
        .collection(FirebaseConst.comment);

    try {
      commentCollection.doc(comment.commentId).delete().then((value) {
        final postCollection =
            fireStore.collection(FirebaseConst.posts).doc(comment.postId);

        postCollection.get().then((value) {
          if (value.exists) {
            final totalComments = value.get('totalComments');
            postCollection.update({'totalComments': totalComments - 1});
            return;
          }
        });
      });
    } catch (e) {
      toast('Some error occurred');
    }
  }

  @override
  Future<void> likeComment(CommentEntity comment) async {
    final commentCollection = fireStore
        .collection(FirebaseConst.posts)
        .doc(comment.postId)
        .collection(FirebaseConst.comment);

    final currentUid = auth.currentUser!.uid;

    final commentRef = await commentCollection.doc(comment.commentId).get();

    if (commentRef.exists) {
      List likes = commentRef.get('likes');
      if (likes.contains(currentUid)) {
        commentCollection.doc(comment.commentId).update({
          'likes': FieldValue.arrayRemove([currentUid]),
        });
      } else {
        commentCollection.doc(comment.commentId).update({
          'likes': FieldValue.arrayUnion([currentUid]),
        });
      }
    }
  }

  @override
  Stream<List<CommentEntity>> readComments(String postId) {
    final commentCollection = fireStore
        .collection(FirebaseConst.posts)
        .doc(postId)
        .collection(FirebaseConst.comment)
        .orderBy('createAt', descending: true);

    return commentCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => CommentModel.fromSnapshot(e)).toList());
  }

  @override
  Future<void> updateComment(CommentEntity comment) async {
    final commentCollection = fireStore
        .collection(FirebaseConst.posts)
        .doc(comment.postId)
        .collection(FirebaseConst.comment);

    Map<String, dynamic> commentInfo = {};

    if (comment.description != '' && comment.description != null) {
      commentInfo['description'] = comment.description;
    }

    commentCollection.doc(comment.commentId).update(commentInfo);
  }

  @override
  Future<void> createReplay(ReplayEntity replay) async {
    final replayCollection = fireStore
        .collection(FirebaseConst.posts)
        .doc(replay.postId)
        .collection(FirebaseConst.comment)
        .doc(replay.commentId)
        .collection(FirebaseConst.replay);

    final newReplay = ReplayModel(
      creatorUid: replay.creatorUid,
      replayId: replay.replayId,
      commentId: replay.commentId,
      postId: replay.postId,
      description: replay.description,
      username: replay.username,
      userProfileUrl: replay.userProfileUrl,
      likes: const [],
      createAt: replay.createAt,
    ).toJson();

    try {
      final replayDocRef = await replayCollection.doc(replay.replayId).get();
      if (!replayDocRef.exists) {
        replayCollection.doc(replay.replayId).set(newReplay).then((value) {
          final commentCollection = fireStore
              .collection(FirebaseConst.posts)
              .doc(replay.postId)
              .collection(FirebaseConst.comment)
              .doc(replay.commentId);

          commentCollection.get().then((value) {
            if (value.exists) {
              final totalReplays = value.get('totalReplays');
              commentCollection.update({'totalReplays': totalReplays + 1});
              return;
            }
          });
        });
      } else {
        replayCollection.doc(replay.replayId).update(newReplay);
      }
    } catch (e) {
      toast('Some errr ocurred $e');
    }
  }

  @override
  Future<void> deleteReplay(ReplayEntity replay) async {
    final replayCollection = fireStore
        .collection(FirebaseConst.posts)
        .doc(replay.postId)
        .collection(FirebaseConst.comment)
        .doc(replay.commentId)
        .collection(FirebaseConst.replay);

    try {
      replayCollection.doc(replay.replayId).delete().then((value) {
        final commentCollection = fireStore
            .collection(FirebaseConst.posts)
            .doc(replay.postId)
            .collection(FirebaseConst.comment)
            .doc(replay.commentId);

        commentCollection.get().then((value) {
          if (value.exists) {
            final totalReplays = value.get('totalReplays');
            commentCollection.update({'totalReplays': totalReplays - 1});
            return;
          }
        });
      });
    } catch (e) {
      toast('Some errr ocurred $e');
    }
  }

  @override
  Future<void> likeReplay(ReplayEntity replay) async {
    final replayCollection = fireStore
        .collection(FirebaseConst.posts)
        .doc(replay.postId)
        .collection(FirebaseConst.comment)
        .doc(replay.commentId)
        .collection(FirebaseConst.replay);

    final currentUid = auth.currentUser!.uid;

    final replayRef = await replayCollection.doc(replay.replayId).get();

    if (replayRef.exists) {
      List likes = replayRef.get('likes');
      if (likes.contains(currentUid)) {
        replayCollection.doc(replay.replayId).update({
          'likes': FieldValue.arrayRemove([currentUid]),
        });
      } else {
        replayCollection.doc(replay.replayId).update({
          'likes': FieldValue.arrayUnion([currentUid]),
        });
      }
    }
  }

  @override
  Stream<List<ReplayEntity>> readReplays(ReplayEntity replay) {
    final replayCollection = fireStore
        .collection(FirebaseConst.posts)
        .doc(replay.postId)
        .collection(FirebaseConst.comment)
        .doc(replay.commentId)
        .collection(FirebaseConst.replay)
        .orderBy('createAt', descending: true);

    return replayCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => ReplayModel.fromSnapshot(e)).toList());
  }

  @override
  Future<void> updateReplay(ReplayEntity replay) async {
    final replayCollection = fireStore
        .collection(FirebaseConst.posts)
        .doc(replay.postId)
        .collection(FirebaseConst.comment)
        .doc(replay.commentId)
        .collection(FirebaseConst.replay);

    Map<String, dynamic> replayInfo = {};

    if (replay.description != '' && replay.description != null) {
      replayInfo['description'] = replay.description;
    }

    replayCollection.doc(replay.replayId).update(replayInfo);
  }
}
