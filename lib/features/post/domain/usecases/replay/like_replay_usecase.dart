import 'package:instagram_app/features/post/domain/entities/replay_entity.dart';
import 'package:instagram_app/features/post/domain/repositories/post_repository.dart';

class LikeReplayUseCase {
  final PostRepository repository;

  LikeReplayUseCase({required this.repository});

  Future<void> call(ReplayEntity replay) {
    return repository.likeReplay(replay);
  }
}
