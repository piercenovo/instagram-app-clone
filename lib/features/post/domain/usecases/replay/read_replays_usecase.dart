import 'package:instagram_app/features/post/domain/entities/replay_entity.dart';
import 'package:instagram_app/features/post/domain/repositories/post_repository.dart';

class ReadReplaysUseCase {
  final PostRepository repository;

  ReadReplaysUseCase({required this.repository});

  Stream<List<ReplayEntity>> call(ReplayEntity replay) {
    return repository.readReplays(replay);
  }
}
