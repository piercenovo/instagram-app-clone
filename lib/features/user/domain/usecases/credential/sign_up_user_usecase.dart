import 'package:instagram_app/features/user/domain/entities/user_entity.dart';
import 'package:instagram_app/features/user/domain/repositories/user_repository.dart';

class SignUpUserUseCase {
  final UserRepository repository;

  SignUpUserUseCase({required this.repository});

  Future<void> call(UserEntity userEntity) {
    return repository.signUpUser(userEntity);
  }
}
