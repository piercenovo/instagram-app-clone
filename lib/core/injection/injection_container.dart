import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:instagram_app/features/user/data/data_sources/remote_data_source/user_data_source.dart';
import 'package:instagram_app/features/user/data/data_sources/remote_data_source/user_data_source_impl.dart';
import 'package:instagram_app/features/user/data/repositories/user_repository_impl.dart';
import 'package:instagram_app/features/user/domain/repositories/user_repository.dart';
import 'package:instagram_app/features/user/domain/usecases/credential/get_current_uid_usecase.dart';
import 'package:instagram_app/features/user/domain/usecases/credential/is_sign_in_usecase.dart';
import 'package:instagram_app/features/user/domain/usecases/credential/sign_in_user_usecase.dart';
import 'package:instagram_app/features/user/domain/usecases/credential/sign_out_user_usecase.dart';
import 'package:instagram_app/features/user/domain/usecases/credential/sign_up_user_usecase.dart';
import 'package:instagram_app/features/user/domain/usecases/storage/upload_image_to_storage_usecase.dart';
import 'package:instagram_app/features/user/domain/usecases/user/create_user_usecase.dart';
import 'package:instagram_app/features/user/domain/usecases/user/get_single_user_usecase.dart';
import 'package:instagram_app/features/user/domain/usecases/user/get_users_usecase.dart';
import 'package:instagram_app/features/user/domain/usecases/user/update_user_usecase.dart';
import 'package:instagram_app/features/user/presentation/cubit/auth/auth_cubit.dart';
import 'package:instagram_app/features/user/presentation/cubit/credential/credential_cubit.dart';
import 'package:instagram_app/features/user/presentation/cubit/get_single_user/get_single_user_cubit.dart';
import 'package:instagram_app/features/user/presentation/cubit/user/user_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Cubits
  sl.registerFactory(
    () => AuthCubit(
      signOutUseCase: sl.call(),
      isSignInUseCase: sl.call(),
      getCurrentUidUseCase: sl.call(),
    ),
  );

  sl.registerFactory(
    () => CredentialCubit(
      signInUserUseCase: sl.call(),
      signUpUserUseCase: sl.call(),
    ),
  );

  sl.registerFactory(
    () => UserCubit(
      updateUserUseCase: sl.call(),
      getUsersUseCase: sl.call(),
    ),
  );

  sl.registerFactory(
    () => GetSingleUserCubit(
      getSingleUserUseCase: sl.call(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => SignOutUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => IsSignInUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => GetCurrentUidUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => SignUpUserUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => SignInUserUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdateUserUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => GetUsersUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => CreateUserUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => GetSingleUserUseCase(repository: sl.call()));

  // Cloud Storage
  sl.registerLazySingleton(
      () => UploadImageToStorageUseCase(repository: sl.call()));

  // Repository
  sl.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(remoteDataSource: sl.call()));

  // Remote Data Source
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(
        firebaseStorage: sl.call(),
        firebaseAuth: sl.call(),
        firebaseFirestore: sl.call()),
  );

  // Externals
  final firebaseFirestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseStorage = FirebaseStorage.instance;

  sl.registerLazySingleton(() => firebaseFirestore);
  sl.registerLazySingleton(() => firebaseAuth);
  sl.registerLazySingleton(() => firebaseStorage);
}
