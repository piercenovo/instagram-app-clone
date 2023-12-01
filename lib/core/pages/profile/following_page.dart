import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:instagram_app/core/helpers/navigator.dart';
import 'package:instagram_app/core/helpers/profile_widget.dart';
import 'package:instagram_app/core/utils/constants/colors.dart';
import 'package:instagram_app/core/utils/constants/pages.dart';
import 'package:instagram_app/core/utils/constants/sizes.dart';
import 'package:instagram_app/features/user/domain/entities/user_entity.dart';
import 'package:instagram_app/core/injection/injection_container.dart' as di;
import 'package:instagram_app/features/user/domain/usecases/user/get_single_user_usecase.dart';

class FollowingPage extends StatelessWidget {
  final UserEntity user;

  const FollowingPage({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tBackGroundColor,
      appBar: AppBar(
        backgroundColor: tBackGroundColor,
        title: const Text(
          'Following',
          style: TextStyle(color: tPrimaryColor),
        ),
        leading: IconButton(
          onPressed: () {
            popBack(context);
          },
          icon: const Icon(Boxicons.bx_arrow_back, color: tPrimaryColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Column(
          children: [
            Expanded(
              child: user.following!.isEmpty
                  ? _noFollowingYetWidget()
                  : ListView.builder(
                      itemCount: user.following!.length,
                      itemBuilder: (context, index) {
                        return StreamBuilder<List<UserEntity>>(
                            stream: di
                                .sl<GetSingleUserUseCase>()
                                .call(user.following![index]),
                            builder: (context, snapshot) {
                              if (snapshot.hasData == false) {
                                return Container(
                                  width: double.infinity,
                                  height: 500,
                                  alignment: Alignment.center,
                                  child: const CircularProgressIndicator(),
                                );
                              }
                              if (snapshot.data!.isEmpty) {
                                return Container();
                              }

                              final singleUserData = snapshot.data!.first;

                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  pushNamedToPage(
                                    context,
                                    PageConst.singleUserProfilePage,
                                    arguments: singleUserData.uid,
                                  );
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      width: 40,
                                      height: 40,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: profileWidget(
                                          imageUrl: singleUserData.profileUrl,
                                        ),
                                      ),
                                    ),
                                    sizeHor(10),
                                    Text(
                                      '${singleUserData.username}',
                                      style: const TextStyle(
                                        color: tPrimaryColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }

  _noFollowingYetWidget() {
    return const Center(
      child: Text(
        'No Following Yet',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
      ),
    );
  }
}
