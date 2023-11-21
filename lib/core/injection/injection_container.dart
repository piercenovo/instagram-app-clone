import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:instagram_app/features/post/presentation/injection/post_injection_container.dart';
import 'package:instagram_app/features/user/domain/usecases/storage/upload_image_to_storage_usecase.dart';
import 'package:instagram_app/features/user/presentation/injection/user_injection_container.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await userInjectionContainer();

  await postInjectionContainer();

  // Cloud Storage
  sl.registerLazySingleton<UploadImageToStorageUseCase>(
      () => UploadImageToStorageUseCase(repository: sl.call()));

  // Externals
  final fireStore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;

  sl.registerLazySingleton(() => fireStore);
  sl.registerLazySingleton(() => auth);
  sl.registerLazySingleton(() => storage);
}
