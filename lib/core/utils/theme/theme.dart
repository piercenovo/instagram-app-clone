import 'package:flutter/material.dart';

ThemeData theme() {
  return ThemeData(
    useMaterial3: true,
    listTileTheme: const ListTileThemeData(
      dense: true,
      visualDensity: VisualDensity(vertical: -2),
    ),
  );
}
