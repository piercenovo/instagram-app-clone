import 'package:fluttertoast/fluttertoast.dart';
import 'package:instagram_app/core/utils/constants/colors.dart';

class FirebaseConst {
  static const String users = 'users';
  static const String posts = 'posts';
  static const String comment = 'comment';
  static const String replay = 'replay';
}

void toast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: tBlueColor,
    textColor: tPrimaryColor,
    fontSize: 16.0,
  );
}
