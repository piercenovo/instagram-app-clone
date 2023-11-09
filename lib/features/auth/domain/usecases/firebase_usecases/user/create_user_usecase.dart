import 'package:instagram_app/features/auth/domain/entities/user_entity.dart';
import 'package:instagram_app/features/auth/domain/repositories/firebase_repository.dart';

class CreateUserUseCase {
  final FirebaseRepository repository;

  CreateUserUseCase({required this.repository});

  Future<void> call(UserEntity user) {
    return repository.createUser(user);
  }
}
