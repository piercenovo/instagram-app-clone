// ignore_for_file: overridden_fields, annotate_overrides

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_app/features/post/domain/entities/comment_entity.dart';

class CommentModel extends CommentEntity {
  final String? commentId;
  final String? postId;
  final String? creatorUid;
  final String? description;
  final String? username;
  final String? userProfileUrl;
  final Timestamp? createAt;
  final List<String>? likes;
  final num? totalReplays;

  const CommentModel({
    this.commentId,
    this.postId,
    this.creatorUid,
    this.description,
    this.username,
    this.userProfileUrl,
    this.createAt,
    this.likes,
    this.totalReplays,
  }) : super(
          commentId: commentId,
          postId: postId,
          creatorUid: creatorUid,
          description: description,
          username: username,
          userProfileUrl: userProfileUrl,
          createAt: createAt,
          likes: likes,
          totalReplays: totalReplays,
        );

  factory CommentModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return CommentModel(
      commentId: snapshot['commentId'],
      postId: snapshot['postId'],
      creatorUid: snapshot['creatorUid'],
      description: snapshot['description'],
      username: snapshot['username'],
      userProfileUrl: snapshot['userProfileUrl'],
      createAt: snapshot['createAt'],
      likes: List.from(snap.get('likes')),
      totalReplays: snapshot['totalReplays'],
    );
  }

  Map<String, dynamic> toJson() => {
        "commentId": commentId,
        "postId": postId,
        "creatorUid": creatorUid,
        "description": description,
        "username": username,
        "userProfileUrl": userProfileUrl,
        "createAt": createAt,
        "likes": likes,
        "totalReplays": totalReplays,
      };
}
