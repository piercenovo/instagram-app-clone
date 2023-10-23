import 'package:instagram_app/features/auth/domain/entities/user_entity.dart';

abstract class FirebaseRepository {
  // Credential
  Future<void> sigInUser(UserEntity user);
  Future<void> sigUpUser(UserEntity user);
  Future<bool> isSignIn();
  Future<void> signOut();

  // User
  Stream<List<UserEntity>> getUsers(UserEntity user);
  Stream<List<UserEntity>> getSingleUser(String uid);
  Future<String> getCurrentUid();
  Future<String> createUser(UserEntity user);
  Future<void> updateUser(UserEntity user);
}
