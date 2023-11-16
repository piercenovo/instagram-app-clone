import 'package:instagram_app/features/post/domain/entities/post_entity.dart';

abstract class PostRemoteDataSource {
  // Post
  Future<void> createPost(PostEntity post);
  Stream<List<PostEntity>> readPosts(PostEntity post);
  Future<void> updatePost(PostEntity post);
  Future<void> deletePost(PostEntity post);
  Future<void> likePost(PostEntity post);
}
