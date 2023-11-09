import 'package:instagram_app/features/auth/domain/entities/user_entity.dart';
import 'package:instagram_app/features/auth/domain/repositories/firebase_repository.dart';

class UpdateUserUseCase {
  final FirebaseRepository repository;

  UpdateUserUseCase({required this.repository});

  Future<void> call(UserEntity userEntity) {
    return repository.updateUser(userEntity);
  }
}
