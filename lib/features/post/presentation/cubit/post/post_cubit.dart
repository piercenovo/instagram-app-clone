import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_app/core/utils/constants/firebase.dart';
import 'package:instagram_app/features/post/domain/entities/post_entity.dart';
import 'package:instagram_app/features/post/domain/usecases/post/create_post_usecase.dart';
import 'package:instagram_app/features/post/domain/usecases/post/delete_post_usecase.dart';
import 'package:instagram_app/features/post/domain/usecases/post/like_post_usecase.dart';
import 'package:instagram_app/features/post/domain/usecases/post/read_posts_usecase.dart';
import 'package:instagram_app/features/post/domain/usecases/post/update_post_usecase.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final CreatePostUseCase createPostUseCase;
  final DeletePostUseCase deletePostUseCase;
  final LikePostUseCase likePostUseCase;
  final ReadPostsUseCase readPostsUseCase;
  final UpdatePostUseCase updatePostUseCase;

  PostCubit({
    required this.createPostUseCase,
    required this.deletePostUseCase,
    required this.likePostUseCase,
    required this.readPostsUseCase,
    required this.updatePostUseCase,
  }) : super(PostInitial());

  Future<void> getPosts({required PostEntity post}) async {
    emit(PostLoading());

    try {
      final streamResponse = readPostsUseCase.call(post);
      streamResponse.listen((posts) {
        emit(PostLoaded(posts: posts));
      });
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }

  Future<void> likePost({required PostEntity post}) async {
    try {
      await likePostUseCase.call(post);
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }

  Future<void> createPost({required PostEntity post}) async {
    try {
      await createPostUseCase.call(post);
      toast('Post Created');
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }

  Future<void> updatePost({required PostEntity post}) async {
    try {
      await updatePostUseCase.call(post);
      toast('Post Updated');
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }

  Future<void> deletePost({required PostEntity post}) async {
    try {
      await deletePostUseCase.call(post);
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }
}
