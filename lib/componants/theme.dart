import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData.dark();
  // ThemeData(
  //     useMaterial3: true,
  //     // scaffoldBackgroundColor: Color.fromARGB(255, 223, 223, 223),
  //     textTheme: const TextTheme(
  //       titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
  //       titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  //       bodySmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
  //       bodyLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
  //     ),
  //     inputDecorationTheme: InputDecorationTheme(
  //       border: OutlineInputBorder(
  //         borderRadius:
  //             BorderRadius.circular(16.0), // Adjust the radius as needed
  //       ),
  //     ),
  //     cardTheme: const CardTheme(elevation: 4,
  //     // color: AppColor.bigobjectcolor
  //     ),
  //     dividerTheme: const DividerThemeData(
  //       space: 2,
  //       color: Colors.grey,
  //     ),
  //     listTileTheme: const ListTileThemeData(
  //       // tileColor: AppColor.mediumobjectcolor,
  //       contentPadding: EdgeInsets.all(4),
       
  //     ));
}

class AppColor {
  static Color bigobjectcolor = const Color.fromARGB(255, 187, 208, 238);
  static Color mediumobjectcolor = const Color.fromARGB(255, 158, 192, 240);
}
