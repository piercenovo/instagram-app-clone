import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_app/core/utils/constants/firebase.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_app/features/user/data/data_sources/remote_data_source/user_remote_data_source.dart';
import 'package:instagram_app/features/user/data/models/user_model.dart';
import 'package:instagram_app/features/user/domain/entities/user_entity.dart';
import 'package:uuid/uuid.dart';

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirebaseFirestore fireStore;
  final FirebaseStorage storage;
  final FirebaseAuth auth;

  UserRemoteDataSourceImpl({
    required this.storage,
    required this.fireStore,
    required this.auth,
  });

  @override
  Future<void> createUser(UserEntity user, String profileUrl) async {
    final userCollection = fireStore.collection(FirebaseConst.users);

    final uid = await getCurrentUid();

    userCollection.doc(uid).get().then((userDoc) {
      final newUser = UserModel(
        uid: uid,
        username: user.username,
        name: user.name,
        bio: user.bio,
        website: user.website,
        email: user.email,
        profileUrl: profileUrl,
        followers: user.followers,
        following: user.following,
        totalFollowers: user.totalFollowers,
        totalFollowing: user.totalFollowing,
        totalPosts: user.totalPosts,
      ).toJson();

      if (!userDoc.exists) {
        userCollection.doc(uid).set(newUser);
      } else {
        userCollection.doc(uid).update(newUser);
      }
    }).catchError((error) {
      toast('Some error occurred');
    });
  }

  @override
  Future<String> getCurrentUid() async => auth.currentUser!.uid;

  @override
  Stream<List<UserEntity>> getSingleUser(String uid) {
    final userCollection = fireStore
        .collection(FirebaseConst.users)
        .where('uid', isEqualTo: uid)
        .limit(1);
    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  @override
  Stream<List<UserEntity>> getUsers(UserEntity user) {
    final userCollection = fireStore.collection(FirebaseConst.users);
    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  @override
  Future<bool> isSignIn() async => auth.currentUser?.uid != null;

  @override
  Future<void> sigInUser(UserEntity user) async {
    try {
      if (user.email!.isNotEmpty || user.password!.isNotEmpty) {
        await auth.signInWithEmailAndPassword(
            email: user.email!, password: user.password!);
      } else {
        toast('Fields cannot be empty');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        toast('User not found');
      } else if (e.code == 'wrong-password') {
        {
          toast('Invalid email or password');
        }
      }
    }
  }

  @override
  Future<void> signUpUser(UserEntity user) async {
    try {
      await auth
          .createUserWithEmailAndPassword(
              email: user.email!, password: user.password!)
          .then((currentUser) async {
        if (currentUser.user?.uid != null) {
          if (user.imageFile != null) {
            uploadImageToStorage(user.imageFile, false, 'profileImages')
                .then((profileUrl) {
              createUser(user, profileUrl);
            });
          } else {
            createUser(user, '');
          }
        }
      });
      return;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        toast('Email is already token');
      } else {
        toast('Something went wrong');
      }
    }
  }

  @override
  Future<void> signOut() async {
    await auth.signOut();
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    final userCollection = fireStore.collection(FirebaseConst.users);

    Map<String, dynamic> userInfo = {};

    if (user.username != '' && user.username != null) {
      userInfo['username'] = user.username;
    }

    if (user.name != '' && user.name != null) {
      userInfo['name'] = user.name;
    }

    if (user.bio != '' && user.bio != null) {
      userInfo['bio'] = user.bio;
    }

    if (user.website != '' && user.website != null) {
      userInfo['website'] = user.website;
    }

    if (user.profileUrl != '' && user.profileUrl != null) {
      userInfo['profileUrl'] = user.profileUrl;
    }

    if (user.totalFollowers != null) {
      userInfo['totalFollowers'] = user.totalFollowers;
    }

    if (user.totalFollowing != null) {
      userInfo['totalFollowing'] = user.totalFollowing;
    }

    if (user.totalPosts != null) {
      userInfo['totalPosts'] = user.totalPosts;
    }

    userCollection.doc(user.uid).update(userInfo);
  }

  @override
  Future<String> uploadImageToStorage(
      File? file, bool isPost, String childName) async {
    Reference ref = storage.ref().child(childName).child(auth.currentUser!.uid);

    if (isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }

    final uploadTask = ref.putFile(file!);

    final imageUrl =
        (await uploadTask.whenComplete(() => {})).ref.getDownloadURL();

    return await imageUrl;
  }

  @override
  Future<void> followUnFollowUser(UserEntity user) async {
    final userCollection = fireStore.collection(FirebaseConst.users);

    final myDocRef = await userCollection.doc(user.uid).get();
    final otherUserDocRef = await userCollection.doc(user.otherUid).get();

    if (myDocRef.exists && otherUserDocRef.exists) {
      List myFollowingList = myDocRef.get('following');
      List otherFollowersList = otherUserDocRef.get('followers');

      // My Following List
      if (myFollowingList.contains(user.otherUid)) {
        userCollection.doc(user.uid).update({
          'following': FieldValue.arrayRemove([user.otherUid])
        }).then((value) {
          final userCollection =
              fireStore.collection(FirebaseConst.users).doc(user.uid);

          userCollection.get().then((value) {
            if (value.exists) {
              final totalFollowing = value.get('totalFollowing');
              userCollection.update({'totalFollowing': totalFollowing - 1});
              return;
            }
          });
        });
      } else {
        userCollection.doc(user.uid).update({
          'following': FieldValue.arrayUnion([user.otherUid])
        }).then((value) {
          final userCollection =
              fireStore.collection(FirebaseConst.users).doc(user.uid);

          userCollection.get().then((value) {
            if (value.exists) {
              final totalFollowing = value.get('totalFollowing');
              userCollection.update({'totalFollowing': totalFollowing + 1});
              return;
            }
          });
        });
      }

      // Other User Following List
      if (otherFollowersList.contains(user.uid)) {
        userCollection.doc(user.otherUid).update({
          'followers': FieldValue.arrayRemove([user.uid])
        }).then((value) {
          final userCollection =
              fireStore.collection(FirebaseConst.users).doc(user.otherUid);

          userCollection.get().then((value) {
            if (value.exists) {
              final totalFollowers = value.get('totalFollowers');
              userCollection.update({'totalFollowers': totalFollowers - 1});
              return;
            }
          });
        });
      } else {
        userCollection.doc(user.otherUid).update({
          'followers': FieldValue.arrayUnion([user.uid])
        }).then((value) {
          final userCollection =
              fireStore.collection(FirebaseConst.users).doc(user.otherUid);

          userCollection.get().then((value) {
            if (value.exists) {
              final totalFollowers = value.get('totalFollowers');
              userCollection.update({'totalFollowers': totalFollowers + 1});
              return;
            }
          });
        });
      }
    }
  }

  @override
  Stream<List<UserEntity>> getSingleOtherUser(String otherUid) {
    final userCollection = fireStore
        .collection(FirebaseConst.users)
        .where('uid', isEqualTo: otherUid)
        .limit(1);
    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }
}
