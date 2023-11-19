import 'package:instagram_app/features/post/domain/entities/replay_entity.dart';
import 'package:instagram_app/features/post/domain/repositories/post_repository.dart';

class UpdateReplayUseCase {
  final PostRepository repository;

  UpdateReplayUseCase({required this.repository});

  Future<void> call(ReplayEntity replay) {
    return repository.updateReplay(replay);
  }
}
