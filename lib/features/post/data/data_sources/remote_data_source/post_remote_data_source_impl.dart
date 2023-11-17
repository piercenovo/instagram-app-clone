import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_app/core/utils/constants/firebase.dart';
import 'package:instagram_app/features/post/data/data_sources/remote_data_source/post_remote_data_source.dart';
import 'package:instagram_app/features/post/data/models/post_model.dart';
import 'package:instagram_app/features/post/domain/entities/post_entity.dart';

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
        postCollection.doc(post.postId).set(newPost);
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
      postCollection.doc(post.postId).delete();
    } catch (e) {
      toast('Some error occurred');
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
  Future<void> updatePost(PostEntity post) async {
    final postCollection = fireStore.collection(FirebaseConst.posts);

    Map<String, dynamic> postInformation = {};

    if (post.description != '' && post.description != null) {
      postInformation['description'] = post.description;
    }

    if (post.postImageUrl != '' && post.postImageUrl != null) {
      postInformation['postImageUrl'] = post.postImageUrl;
    }

    postCollection.doc(post.postId).update(postInformation);
  }
}
