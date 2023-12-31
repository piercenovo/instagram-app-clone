import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_app/core/utils/constants/firebase.dart';
import 'package:instagram_app/features/user/domain/entities/user_entity.dart';
import 'package:instagram_app/features/user/domain/usecases/user/follow_unfollow_usecase.dart';
import 'package:instagram_app/features/user/domain/usecases/user/get_users_usecase.dart';
import 'package:instagram_app/features/user/domain/usecases/user/update_user_usecase.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UpdateUserUseCase updateUserUseCase;
  final GetUsersUseCase getUsersUseCase;
  final FollowUnFollowUseCase followUnfollowUseCase;

  UserCubit({
    required this.updateUserUseCase,
    required this.getUsersUseCase,
    required this.followUnfollowUseCase,
  }) : super(UserInitial());

  Future<void> getUsers({required UserEntity user}) async {
    emit(UserLoading());

    try {
      final streamResponse = getUsersUseCase.call(user);
      streamResponse.listen((users) {
        emit(UserLoaded(users: users));
      });
    } on SocketException catch (_) {
      emit(UserFailure());
    } catch (_) {
      emit(UserFailure());
    }
  }

  Future<void> updateUser({required UserEntity user}) async {
    try {
      await updateUserUseCase.call(user);
      toast('User Updated');
    } on SocketException catch (_) {
      emit(UserFailure());
    } catch (_) {
      emit(UserFailure());
    }
  }

  Future<void> followUnFollowUser({required UserEntity user}) async {
    try {
      await followUnfollowUseCase.call(user);
    } on SocketException catch (_) {
      emit(UserFailure());
    } catch (_) {
      emit(UserFailure());
    }
  }
}
