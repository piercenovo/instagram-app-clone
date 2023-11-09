import 'package:instagram_app/features/auth/domain/entities/user_entity.dart';
import 'package:instagram_app/features/auth/domain/repositories/firebase_repository.dart';

class GetSingleUserUseCase {
  final FirebaseRepository repository;

  GetSingleUserUseCase({required this.repository});

  Stream<List<UserEntity>> call(String uuid) {
    return repository.getSingleUser(uuid);
  }
}
