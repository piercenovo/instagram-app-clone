import 'package:flutter/material.dart';

void pushToPage(BuildContext context, Widget route) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => route));
}

void popBack(BuildContext context) {
  Navigator.pop(context);
}
