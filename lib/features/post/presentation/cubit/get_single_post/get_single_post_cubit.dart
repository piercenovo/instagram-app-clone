import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_app/features/post/domain/entities/post_entity.dart';
import 'package:instagram_app/features/post/domain/usecases/post/read_single_post_usecase.dart';

part 'get_single_post_state.dart';

class GetSinglePostCubit extends Cubit<GetSinglePostState> {
  final ReadSinglePostUseCase readSinglePostUseCase;

  GetSinglePostCubit({
    required this.readSinglePostUseCase,
  }) : super(GetSinglePostInitial());

  Future<void> getSinglePost({required String uid}) async {
    emit(GetSinglePostLoading());
    try {
      final streamResponse = readSinglePostUseCase.call(uid);
      streamResponse.listen((posts) {
        emit(GetSinglePostLoaded(post: posts.first));
      });
    } on SocketException catch (_) {
      emit(GetSinglePostFailure());
    } catch (_) {
      emit(GetSinglePostFailure());
    }
  }
}
