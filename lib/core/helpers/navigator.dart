import 'package:flutter/material.dart';

void pushToPage(BuildContext context, Widget route) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => route));
}

void pushNamedToPage(BuildContext context, String routeName) {
  Navigator.pushNamed(context, routeName);
}

void popBack(BuildContext context) {
  Navigator.pop(context);
}

void pushAndRemoveUntilToPage(BuildContext context, Widget route) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => route),
    (route) => false,
  );
}

void pushNamedAndRemoveUntilToPage(BuildContext context, String routeName) {
  Navigator.pushNamedAndRemoveUntil(
    context,
    routeName,
    (route) => false,
  );
}
