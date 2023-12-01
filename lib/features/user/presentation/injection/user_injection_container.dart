import 'package:instagram_app/features/user/data/data_sources/remote_data_source/user_remote_data_source.dart';
import 'package:instagram_app/features/user/data/data_sources/remote_data_source/user_remote_data_source_impl.dart';
import 'package:instagram_app/features/user/data/repositories/user_repository_impl.dart';
import 'package:instagram_app/features/user/domain/repositories/user_repository.dart';
import 'package:instagram_app/features/user/domain/usecases/credential/get_current_uid_usecase.dart';
import 'package:instagram_app/features/user/domain/usecases/credential/is_sign_in_usecase.dart';
import 'package:instagram_app/features/user/domain/usecases/credential/sign_in_user_usecase.dart';
import 'package:instagram_app/features/user/domain/usecases/credential/sign_out_user_usecase.dart';
import 'package:instagram_app/features/user/domain/usecases/credential/sign_up_user_usecase.dart';
import 'package:instagram_app/features/user/domain/usecases/user/create_user_usecase.dart';
import 'package:instagram_app/features/user/domain/usecases/user/follow_unfollow_usecase.dart';
import 'package:instagram_app/features/user/domain/usecases/user/get_single_other_user_usecase.dart';
import 'package:instagram_app/features/user/domain/usecases/user/get_single_user_usecase.dart';
import 'package:instagram_app/features/user/domain/usecases/user/get_users_usecase.dart';
import 'package:instagram_app/features/user/domain/usecases/user/update_user_usecase.dart';
import 'package:instagram_app/features/user/presentation/cubit/auth/auth_cubit.dart';
import 'package:instagram_app/features/user/presentation/cubit/credential/credential_cubit.dart';
import 'package:instagram_app/features/user/presentation/cubit/get_single_other_user/get_single_other_user_cubit.dart';
import 'package:instagram_app/features/user/presentation/cubit/get_single_user/get_single_user_cubit.dart';
import 'package:instagram_app/features/user/presentation/cubit/user/user_cubit.dart';
import 'package:instagram_app/core/injection/injection_container.dart';

Future<void> userInjectionContainer() async {
  // * CUBITS INJECTION

  sl.registerFactory<AuthCubit>(
    () => AuthCubit(
      signOutUseCase: sl.call(),
      isSignInUseCase: sl.call(),
      getCurrentUidUseCase: sl.call(),
    ),
  );

  sl.registerFactory<CredentialCubit>(
    () => CredentialCubit(
      signInUserUseCase: sl.call(),
      signUpUserUseCase: sl.call(),
    ),
  );

  sl.registerFactory<UserCubit>(
    () => UserCubit(
      updateUserUseCase: sl.call(),
      getUsersUseCase: sl.call(),
      followUnfollowUseCase: sl.call(),
    ),
  );

  sl.registerFactory<GetSingleUserCubit>(
    () => GetSingleUserCubit(
      getSingleUserUseCase: sl.call(),
    ),
  );

  sl.registerFactory<GetSingleOtherUserCubit>(
    () => GetSingleOtherUserCubit(
      getSingleOtherUserUseCase: sl.call(),
    ),
  );

  // * USE CASES INJECTION

  sl.registerLazySingleton<SignOutUseCase>(
      () => SignOutUseCase(repository: sl.call()));
  sl.registerLazySingleton<IsSignInUseCase>(
      () => IsSignInUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetCurrentUidUseCase>(
      () => GetCurrentUidUseCase(repository: sl.call()));
  sl.registerLazySingleton<SignUpUserUseCase>(
      () => SignUpUserUseCase(repository: sl.call()));
  sl.registerLazySingleton<SignInUserUseCase>(
      () => SignInUserUseCase(repository: sl.call()));
  sl.registerLazySingleton<UpdateUserUseCase>(
      () => UpdateUserUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetUsersUseCase>(
      () => GetUsersUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetSingleOtherUserUseCase>(
      () => GetSingleOtherUserUseCase(repository: sl.call()));
  sl.registerLazySingleton<CreateUserUseCase>(
      () => CreateUserUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetSingleUserUseCase>(
      () => GetSingleUserUseCase(repository: sl.call()));
  sl.registerLazySingleton<FollowUnFollowUseCase>(
      () => FollowUnFollowUseCase(repository: sl.call()));

  // * REPOSITORY & DATA SOURCES INJECTION

  // Repository
  sl.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(remoteDataSource: sl.call()));

  // Remote Data Source
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(
      storage: sl.call(),
      fireStore: sl.call(),
      auth: sl.call(),
    ),
  );
}
