import 'package:instagram_app/features/user/domain/entities/user_entity.dart';
import 'package:instagram_app/features/user/domain/repositories/user_repository.dart';

class GetSingleOtherUserUseCase {
  final UserRepository repository;

  GetSingleOtherUserUseCase({required this.repository});

  Stream<List<UserEntity>> call(String otherUid) {
    return repository.getSingleOtherUser(otherUid);
  }
}
