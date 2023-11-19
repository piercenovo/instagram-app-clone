import 'package:instagram_app/features/post/domain/entities/replay_entity.dart';
import 'package:instagram_app/features/post/domain/repositories/post_repository.dart';

class CreateReplayUseCase {
  final PostRepository repository;

  CreateReplayUseCase({required this.repository});

  Future<void> call(ReplayEntity replay) {
    return repository.createReplay(replay);
  }
}
