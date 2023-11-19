// ignore_for_file: overridden_fields, annotate_overrides

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_app/features/post/domain/entities/replay_entity.dart';

class ReplayModel extends ReplayEntity {
  final String? creatorUid;
  final String? replayId;
  final String? commentId;
  final String? postId;
  final String? description;
  final String? username;
  final String? userProfileUrl;
  final List<String>? likes;
  final Timestamp? createAt;

  const ReplayModel({
    this.creatorUid,
    this.replayId,
    this.commentId,
    this.postId,
    this.description,
    this.username,
    this.userProfileUrl,
    this.likes,
    this.createAt,
  }) : super(
          creatorUid: creatorUid,
          replayId: replayId,
          commentId: commentId,
          postId: postId,
          description: description,
          username: username,
          userProfileUrl: userProfileUrl,
          likes: likes,
          createAt: createAt,
        );

  factory ReplayModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ReplayModel(
      creatorUid: snapshot['creatorUid'],
      replayId: snapshot['replayId'],
      commentId: snapshot['commentId'],
      postId: snapshot['postId'],
      description: snapshot['description'],
      username: snapshot['username'],
      userProfileUrl: snapshot['userProfileUrl'],
      likes: List.from(snap.get("likes")),
      createAt: snapshot['createAt'],
    );
  }

  Map<String, dynamic> toJson() => {
        "creatorUid": creatorUid,
        "replayId": replayId,
        "commentId": commentId,
        "postId": postId,
        "description": description,
        "username": username,
        "userProfileUrl": userProfileUrl,
        "likes": likes,
        "createAt": createAt,
      };
}
