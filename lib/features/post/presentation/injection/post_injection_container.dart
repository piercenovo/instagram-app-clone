import 'package:instagram_app/features/post/data/data_sources/remote_data_source/post_remote_data_source.dart';
import 'package:instagram_app/features/post/data/data_sources/remote_data_source/post_remote_data_source_impl.dart';
import 'package:instagram_app/features/post/data/repositories/post_repository_impl.dart';
import 'package:instagram_app/features/post/domain/repositories/post_repository.dart';
import 'package:instagram_app/features/post/domain/usecases/comment/create_comment_usecase.dart';
import 'package:instagram_app/features/post/domain/usecases/comment/delete_comment_usecase.dart';
import 'package:instagram_app/features/post/domain/usecases/comment/like_comment_usecase.dart';
import 'package:instagram_app/features/post/domain/usecases/comment/read_comments_usecase.dart';
import 'package:instagram_app/features/post/domain/usecases/comment/update_comment_usecase.dart';
import 'package:instagram_app/features/post/domain/usecases/post/create_post_usecase.dart';
import 'package:instagram_app/features/post/domain/usecases/post/delete_post_usecase.dart';
import 'package:instagram_app/features/post/domain/usecases/post/like_post_usecase.dart';
import 'package:instagram_app/features/post/domain/usecases/post/read_posts_usecase.dart';
import 'package:instagram_app/features/post/domain/usecases/post/update_post_usecase.dart';
import 'package:instagram_app/features/post/presentation/cubit/comment/comment_cubit.dart';
import 'package:instagram_app/features/post/presentation/cubit/post/post_cubit.dart';
import 'package:instagram_app/core/injection/injection_container.dart';

Future<void> postInjectionContainer() async {
  // * CUBITS INJECTION

  // Post
  sl.registerFactory<PostCubit>(
    () => PostCubit(
      createPostUseCase: sl.call(),
      readPostsUseCase: sl.call(),
      likePostUseCase: sl.call(),
      updatePostUseCase: sl.call(),
      deletePostUseCase: sl.call(),
    ),
  );

  // Comment
  sl.registerFactory<CommentCubit>(
    () => CommentCubit(
      createCommentUseCase: sl.call(),
      readCommentsUseCase: sl.call(),
      likeCommentUseCase: sl.call(),
      updateCommentUseCase: sl.call(),
      deleteCommentUseCase: sl.call(),
    ),
  );

  // * USE CASES INJECTION

  // Post
  sl.registerLazySingleton<CreatePostUseCase>(
      () => CreatePostUseCase(repository: sl.call()));
  sl.registerLazySingleton<ReadPostsUseCase>(
      () => ReadPostsUseCase(repository: sl.call()));
  sl.registerLazySingleton<LikePostUseCase>(
      () => LikePostUseCase(repository: sl.call()));
  sl.registerLazySingleton<UpdatePostUseCase>(
      () => UpdatePostUseCase(repository: sl.call()));
  sl.registerLazySingleton<DeletePostUseCase>(
      () => DeletePostUseCase(repository: sl.call()));

  // Comment
  sl.registerLazySingleton<CreateCommentUseCase>(
      () => CreateCommentUseCase(repository: sl.call()));
  sl.registerLazySingleton<ReadCommentsUseCase>(
      () => ReadCommentsUseCase(repository: sl.call()));
  sl.registerLazySingleton<LikeCommentUseCase>(
      () => LikeCommentUseCase(repository: sl.call()));
  sl.registerLazySingleton<UpdateCommentUseCase>(
      () => UpdateCommentUseCase(repository: sl.call()));
  sl.registerLazySingleton<DeleteCommentUseCase>(
      () => DeleteCommentUseCase(repository: sl.call()));

  // * REPOSITORY & DATA SOURCES INJECTION

  // Repository
  sl.registerLazySingleton<PostRepository>(
      () => PostRepositoryImpl(remoteDataSource: sl.call()));

  // Remote Data Source
  sl.registerLazySingleton<PostRemoteDataSource>(
    () => PostRemoteDataSourceImpl(
      storage: sl.call(),
      fireStore: sl.call(),
      auth: sl.call(),
    ),
  );
}
