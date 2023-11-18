import 'package:instagram_app/features/post/domain/entities/comment_entity.dart';
import 'package:instagram_app/features/post/domain/repositories/post_repository.dart';

class CreateCommentUseCase {
  final PostRepository repository;

  CreateCommentUseCase({required this.repository});

  Future<void> call(CommentEntity comment) {
    return repository.createComment(comment);
  }
}
