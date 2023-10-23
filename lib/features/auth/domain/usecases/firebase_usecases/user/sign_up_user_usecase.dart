import 'package:instagram_app/features/auth/domain/entities/user_entity.dart';
import 'package:instagram_app/features/auth/domain/repository/firebase_repository.dart';

class SignUpUserUseCase {
  final FirebaseRepository repository;

  SignUpUserUseCase({required this.repository});

  Future<void> call(UserEntity userEntity) {
    return repository.sigUpUser(userEntity);
  }
}