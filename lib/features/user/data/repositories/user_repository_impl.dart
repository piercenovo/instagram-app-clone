import 'dart:io';

import 'package:instagram_app/features/user/data/data_sources/remote_data_source/user_remote_data_source.dart';
import 'package:instagram_app/features/user/domain/entities/user_entity.dart';
import 'package:instagram_app/features/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> createUser(UserEntity user, String profileUrl) async =>
      remoteDataSource.createUser(user, profileUrl);

  @override
  Future<String> getCurrentUid() async => remoteDataSource.getCurrentUid();

  @override
  Stream<List<UserEntity>> getSingleUser(String uid) =>
      remoteDataSource.getSingleUser(uid);

  @override
  Stream<List<UserEntity>> getUsers(UserEntity user) =>
      remoteDataSource.getUsers(user);

  @override
  Future<bool> isSignIn() async => remoteDataSource.isSignIn();

  @override
  Future<void> sigInUser(UserEntity user) async =>
      remoteDataSource.sigInUser(user);

  @override
  Future<void> signUpUser(UserEntity user) async =>
      remoteDataSource.signUpUser(user);

  @override
  Future<void> signOut() async => remoteDataSource.signOut();

  @override
  Future<void> updateUser(UserEntity user) async =>
      remoteDataSource.updateUser(user);

  @override
  Future<String> uploadImageToStorage(
          File? file, bool isPost, String childName) async =>
      remoteDataSource.uploadImageToStorage(file, isPost, childName);

  @override
  Future<void> followUnFollowUser(UserEntity user) async =>
      remoteDataSource.followUnFollowUser(user);

  @override
  Stream<List<UserEntity>> getSingleOtherUser(String otherUid) =>
      remoteDataSource.getSingleOtherUser(otherUid);
}
