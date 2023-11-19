import 'package:instagram_app/features/post/domain/entities/replay_entity.dart';
import 'package:instagram_app/features/post/domain/repositories/post_repository.dart';

class DeleteReplayUseCase {
  final PostRepository repository;

  DeleteReplayUseCase({required this.repository});

  Future<void> call(ReplayEntity replay) {
    return repository.deleteReplay(replay);
  }
}
