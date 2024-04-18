import 'package:flutter/material.dart';

/*ThemeData lightTheme() {


  TextTheme _customLightThemesTextTheme(TextTheme base) {
    return base.copyWith(
    );
  }

  final ThemeData lightTheme = ThemeData.light();
  return lightTheme.copyWith(
    textTheme: _customLightThemesTextTheme(lightTheme.textTheme),
    primaryColor: Color(0xfffff799),
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: AppColor.mycolor),
    indicatorColor: Color(0xFF807A6B),
    scaffoldBackgroundColor: Color(0xffffffff),
    primaryIconTheme: lightTheme.primaryIconTheme.copyWith(
      color: Colors.white,
      size: 20,
    ),
    iconTheme: lightTheme.iconTheme.copyWith(
      color: Colors.white,
    ),
    tabBarTheme: lightTheme.tabBarTheme.copyWith(
      labelColor: Color(0xfffff266),
      unselectedLabelColor: Colors.grey,
    ),
    buttonTheme: lightTheme.buttonTheme.copyWith(buttonColor: AppColor.mycolor),

  );
}


ThemeData darkTheme() {
  final ThemeData darkTheme = ThemeData.dark();
  return darkTheme.copyWith(
    primaryColor: Colors.black38,
    indicatorColor: Color(0xFF807A6B),
    primaryIconTheme: darkTheme.primaryIconTheme.copyWith(
      color: Colors.green,
      size: 20,
    ),
  );
}*/

class AppTheme{
  static ThemeData lightTheme = ThemeData(
    fontFamily: 'Roboto',
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: AppColor.mycolor,).copyWith(secondary: Colors.red, brightness: Brightness.light),
    appBarTheme: const AppBarTheme(),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(),
      indicatorColor: AppColor.mycolor,
    tabBarTheme: const TabBarTheme(
      labelColor: Colors.black,
      labelStyle: TextStyle(color: Colors.black),

    ),

    elevatedButtonTheme: ElevatedButtonThemeData(style:ElevatedButton.styleFrom())
  );
  static ThemeData darkTheme = ThemeData(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: AppColor.mycolor,).copyWith(secondary: Colors.red, brightness: Brightness.dark),

      textTheme: const TextTheme(
      ).apply(
        bodyColor: Colors.yellow,
        displayColor:  Colors.yellow,

      ),
      appBarTheme: const AppBarTheme(),
      indicatorColor: AppColor.mycolor,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(),

      elevatedButtonTheme: ElevatedButtonThemeData(style:ElevatedButton.styleFrom())
  );

}

class AppColor {
  static const MaterialColor mycolor = MaterialColor(
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