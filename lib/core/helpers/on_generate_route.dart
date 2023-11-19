import 'package:flutter/material.dart';
import 'package:instagram_app/core/entities/app_entity.dart';
import 'package:instagram_app/core/pages/no_page_found/no_page_found.dart';
import 'package:instagram_app/core/utils/constants/pages.dart';
import 'package:instagram_app/features/post/domain/entities/comment_entity.dart';
import 'package:instagram_app/features/post/domain/entities/post_entity.dart';
import 'package:instagram_app/features/post/domain/entities/replay_entity.dart';
import 'package:instagram_app/features/post/presentation/pages/comment/edit_comment/edit_comment_page.dart';
import 'package:instagram_app/features/post/presentation/pages/comment/edit_replay/edit_replay_page.dart';
import 'package:instagram_app/features/post/presentation/pages/post/update_post/update_post_page.dart';
import 'package:instagram_app/features/user/domain/entities/user_entity.dart';
import 'package:instagram_app/features/user/presentation/pages/sign_in/sign_in_page.dart';
import 'package:instagram_app/features/user/presentation/pages/sign_up/sign_up_page.dart';
import 'package:instagram_app/features/post/presentation/pages/comment/comment/comment_page.dart';
import 'package:instagram_app/core/pages/profile/edit_profile_page.dart';

class OnGenerateRoute {
  static Route<dynamic>? route(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case PageConst.editProfilePage:
        {
          if (args is UserEntity) {
            return routeBuilder(
              EditProfilePage(
                currentUser: args,
              ),
            );
          } else {
            return routeBuilder(const NoPageFound());
          }
        }
      case PageConst.updatePostPage:
        {
          if (args is PostEntity) {
            return routeBuilder(
              UpdatePostPage(
                post: args,
              ),
            );
          } else {
            return routeBuilder(const NoPageFound());
          }
        }
      case PageConst.commentPage:
        {
          if (args is AppEntity) {
            return routeBuilder(
              CommentPage(
                appEntity: args,
              ),
            );
          } else {
            return routeBuilder(const NoPageFound());
          }
        }
      case PageConst.updateCommentPage:
        {
          if (args is CommentEntity) {
            return routeBuilder(
              EditCommentPage(
                comment: args,
              ),
            );
          } else {
            return routeBuilder(const NoPageFound());
          }
        }
      case PageConst.updateReplayPage:
        {
          if (args is ReplayEntity) {
            return routeBuilder(
              EditReplayPage(
                replay: args,
              ),
            );
          } else {
            return routeBuilder(const NoPageFound());
          }
        }
      case PageConst.signInPage:
        {
          return routeBuilder(const SignInPage());
        }
      case PageConst.signUpPage:
        {
          return routeBuilder(const SingUpPage());
        }
      default:
        {
          const NoPageFound();
        }
    }
    return null;
  }

  static dynamic routeBuilder(Widget child) {
    return MaterialPageRoute(builder: (context) => child);
  }
}
