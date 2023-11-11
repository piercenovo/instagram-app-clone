import 'package:flutter/material.dart';
import 'package:instagram_app/core/pages/no_page_found.dart';
import 'package:instagram_app/core/utils/constants/pages.dart';
import 'package:instagram_app/features/user/presentation/pages/sign_in/sign_in_page.dart';
import 'package:instagram_app/features/user/presentation/pages/sign_up/sign_up_page.dart';
import 'package:instagram_app/features/post/presentation/pages/comment/comment_page.dart';
import 'package:instagram_app/features/post/presentation/pages/update_post/update_post_page.dart';
import 'package:instagram_app/features/profile/presentation/screens/profile/edit_profile_page.dart';

class OnGenerateRoute {
  static Route<dynamic>? route(RouteSettings settings) {
    // final args = settings.arguments;

    switch (settings.name) {
      case PageConst.editProfilePage:
        {
          return routeBuilder(const EditProfilePage());
        }
      case PageConst.updatePostPage:
        {
          return routeBuilder(const UpdatePostPage());
        }
      case PageConst.commentPage:
        {
          return routeBuilder(const CommentPage());
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
