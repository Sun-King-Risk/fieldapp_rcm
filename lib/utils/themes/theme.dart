import 'package:flutter/material.dart';

class AppTheme{
  static ThemeData lightTheme = ThemeData(
    fontFamily: 'Roboto',
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: AppColor.appColor,).copyWith(secondary: Colors.orange, brightness: Brightness.light),
    appBarTheme: const AppBarTheme(),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(),
      indicatorColor: AppColor.appColor,
    tabBarTheme: const TabBarTheme(
      labelColor: Colors.black,
      labelStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),

    ),

    elevatedButtonTheme: ElevatedButtonThemeData(style:ElevatedButton.styleFrom())
  );
  static ThemeData darkTheme = ThemeData(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: AppColor.appColor,).copyWith(secondary: Colors.red, brightness: Brightness.dark),

      textTheme: const TextTheme(
      ).apply(
        bodyColor: Colors.yellow,
        displayColor:  Colors.yellow,

      ),
      appBarTheme: const AppBarTheme(),
      indicatorColor: AppColor.appColor,
      backgroundColor: Colors.blue ,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(),

      elevatedButtonTheme: ElevatedButtonThemeData(style:ElevatedButton.styleFrom())
  );

}

class AppColor {
  static const MaterialColor backgroundColor = MaterialColor(
    0xffffea00,
    <int, Color>{
      50: Color(0xffffec1a ),//10%
      100: Color(0xffffee33),//20%
      200: Color(0xfffff04d),//30%
      300: Color(0xfffff266),//40%
      400: Color(0xfffff580	),//50%
      500: Color(0xfffff799),//60%
      600: Color(0xfffff9b3),//70%
      700: Color(0xfffffbcc),//80%
      800: Color(0xfffffde6),//90%
      900: Color(0xffffffff),//100%
    },
  );

  static const MaterialColor appColor = MaterialColor(
    0xffffea00,
    <int, Color>{
      50: Color(0xffffec1a ),//10%
      100: Color(0xffffee33),//20%
      200: Color(0xfffff04d),//30%
      300: Color(0xfffff266),//40%
      400: Color(0xfffff580	),//50%
      500: Color(0xfffff799),//60%
      600: Color(0xfffff9b3),//70%
      700: Color(0xfffffbcc),//80%
      800: Color(0xfffffde6),//90%
      900: Color(0xffffffff),//100%
    },
  );
}