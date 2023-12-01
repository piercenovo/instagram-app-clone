import 'dart:io';

import 'package:instagram_app/features/user/domain/entities/user_entity.dart';

abstract class UserRepository {
  // Credential
  Future<void> sigInUser(UserEntity user);
  Future<void> signUpUser(UserEntity user);
  Future<bool> isSignIn();
  Future<void> signOut();

  // User
  Stream<List<UserEntity>> getUsers(UserEntity user);
  Stream<List<UserEntity>> getSingleUser(String uid);
  Stream<List<UserEntity>> getSingleOtherUser(String otherUid);
  Future<String> getCurrentUid();
  Future<void> createUser(UserEntity user, String profileUrl);
  Future<void> updateUser(UserEntity user);
  Future<void> followUnFollowUser(UserEntity user);

  // Cloud Storage
  Future<String> uploadImageToStorage(
      File? file, bool isPost, String childName);
}
