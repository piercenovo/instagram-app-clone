import 'package:instagram_app/features/post/data/data_sources/remote_data_source/post_remote_data_source.dart';
import 'package:instagram_app/features/post/data/data_sources/remote_data_source/post_remote_data_source_impl.dart';
import 'package:instagram_app/features/post/data/repositories/post_repository_impl.dart';
import 'package:instagram_app/features/post/domain/repositories/post_repository.dart';
import 'package:instagram_app/features/post/domain/usecases/create_post_usecase.dart';
import 'package:instagram_app/features/post/domain/usecases/delete_post_usecase.dart';
import 'package:instagram_app/features/post/domain/usecases/like_post_usecase.dart';
import 'package:instagram_app/features/post/domain/usecases/read_posts_usecase.dart';
import 'package:instagram_app/features/post/domain/usecases/update_post_usecase.dart';
import 'package:instagram_app/features/post/presentation/cubit/post/post_cubit.dart';
import 'package:instagram_app/core/injection/injection_container.dart';

Future<void> postInjectionContainer() async {
  // * CUBITS INJECTION

  sl.registerFactory<PostCubit>(
    () => PostCubit(
      createPostUseCase: sl.call(),
      readPostsUseCase: sl.call(),
      likePostUseCase: sl.call(),
      updatePostUseCase: sl.call(),
      deletePostUseCase: sl.call(),
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

  // * REPOSITORY & DATA SOURCES INJECTION

  // Repository
  sl.registerLazySingleton<PostRepository>(
      () => PostRepositoryImpl(remoteDataSource: sl.call()));

  // Remote Data Source
  sl.registerLazySingleton<PostRemoteDataSource>(
    () => PostRemoteDataSourceImpl(
      storage: sl.call(),
      fireStore: sl.call(),
    ),
  );
}
