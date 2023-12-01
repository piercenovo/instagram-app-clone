import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:instagram_app/core/helpers/navigator.dart';
import 'package:instagram_app/core/helpers/profile_widget.dart';
import 'package:instagram_app/core/utils/constants/colors.dart';
import 'package:instagram_app/core/utils/constants/pages.dart';
import 'package:instagram_app/core/utils/constants/sizes.dart';
import 'package:instagram_app/core/utils/strings/text_strings.dart';
import 'package:instagram_app/features/post/domain/entities/post_entity.dart';
import 'package:instagram_app/features/post/presentation/cubit/post/post_cubit.dart';
import 'package:instagram_app/features/user/domain/entities/user_entity.dart';
import 'package:instagram_app/features/user/presentation/cubit/auth/auth_cubit.dart';
import 'package:instagram_app/features/user/presentation/cubit/get_single_user/get_single_user_cubit.dart';

class SingleUserProfileMainWidget extends StatefulWidget {
  final String otherUserId;

  const SingleUserProfileMainWidget({
    super.key,
    required this.otherUserId,
  });

  @override
  State<SingleUserProfileMainWidget> createState() =>
      _SingleUserProfileMainWidgetState();
}

class _SingleUserProfileMainWidgetState
    extends State<SingleUserProfileMainWidget> {
  @override
  void initState() {
    BlocProvider.of<GetSingleUserCubit>(context)
        .getSingleUser(uid: widget.otherUserId);

    BlocProvider.of<PostCubit>(context).getPosts(post: const PostEntity());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
      builder: (context, userState) {
        if (userState is GetSingleUserLoaded) {
          final singleUser = userState.user;
          return Scaffold(
            backgroundColor: tBackGroundColor,
            appBar: AppBar(
              backgroundColor: tBackGroundColor,
              title: Text(
                '${singleUser.username}',
                style: const TextStyle(color: tPrimaryColor),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    _openBottomModalSheet(
                      context: context,
                      currentUser: singleUser,
                    );
                  },
                  icon: const Icon(Boxicons.bx_menu, color: tPrimaryColor),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: profileWidget(
                              imageUrl: singleUser.profileUrl,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  '${singleUser.totalPosts}',
                                  style: const TextStyle(
                                      color: tPrimaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                sizeVer(8),
                                const Text(
                                  'Posts',
                                  style: TextStyle(color: tPrimaryColor),
                                ),
                              ],
                            ),
                            sizeHor(25),
                            Column(
                              children: [
                                Text(
                                  '${singleUser.totalFollowers}',
                                  style: const TextStyle(
                                      color: tPrimaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                sizeVer(8),
                                const Text(
                                  'Followers',
                                  style: TextStyle(color: tPrimaryColor),
                                ),
                              ],
                            ),
                            sizeHor(25),
                            Column(
                              children: [
                                Text(
                                  '${singleUser.totalFollowing}',
                                  style: const TextStyle(
                                      color: tPrimaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                sizeVer(8),
                                const Text(
                                  'Following',
                                  style: TextStyle(color: tPrimaryColor),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                    sizeVer(10),
                    Text(
                      '${singleUser.name == tEmptyString ? singleUser.username : singleUser.name}',
                      style: const TextStyle(
                          color: tPrimaryColor, fontWeight: FontWeight.bold),
                    ),
                    sizeVer(5),
                    Text(
                      '${singleUser.bio}',
                      style: const TextStyle(color: tPrimaryColor),
                    ),
                    sizeVer(10),
                    BlocBuilder<PostCubit, PostState>(
                      builder: (context, postState) {
                        if (postState is PostLoaded) {
                          final posts = postState.posts
                              .where(
                                (post) => post.creatorUid == widget.otherUserId,
                              )
                              .toList();

                          return GridView.builder(
                            itemCount: posts.length,
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                            ),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  pushNamedToPage(
                                      context, PageConst.postDetailPage,
                                      arguments: posts[index].postId);
                                },
                                child: SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: profileWidget(
                                      imageUrl: posts[index].postImageUrl),
                                ),
                              );
                            },
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  _openBottomModalSheet(
      {required BuildContext context, required UserEntity currentUser}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: tDarkBlackColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: tDarkBlackColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.only(
            top: 16,
            bottom: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: tDarkGreyColor,
                  ),
                ),
              ),
              sizeVer(10),
              Column(
                children: [
                  ListTile(
                    minVerticalPadding: 1,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 24),
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Boxicons.bx_grid_alt,
                            color: tPrimaryColor, size: 20),
                        sizeHor(10),
                        const Text(
                          'More options',
                          style: TextStyle(color: tPrimaryColor, fontSize: 16),
                        ),
                      ],
                    ),
                    onTap: () {
                      popBack(context);
                    },
                  ),
                  ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 24),
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Boxicons.bx_edit,
                            color: tPrimaryColor, size: 20),
                        sizeHor(10),
                        const Text(
                          'Edit profile',
                          style: TextStyle(color: tPrimaryColor, fontSize: 16),
                        ),
                      ],
                    ),
                    onTap: () {
                      popBack(context);
                      pushNamedToPage(
                        context,
                        PageConst.editProfilePage,
                        arguments: widget.otherUserId,
                      );
                    },
                  ),
                  ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 24),
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Boxicons.bx_log_out,
                            color: tPrimaryColor, size: 20),
                        sizeHor(10),
                        const Text(
                          'Log out',
                          style: TextStyle(color: tPrimaryColor, fontSize: 16),
                        ),
                      ],
                    ),
                    onTap: () {
                      BlocProvider.of<AuthCubit>(context).loggedOut();
                      popBack(context);
                      pushNamedAndRemoveUntilToPage(
                          context, PageConst.signInPage);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
