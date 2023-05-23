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
    appBarTheme: AppBarTheme(),
    floatingActionButtonTheme: FloatingActionButtonThemeData(),
      indicatorColor: AppColor.mycolor,
    tabBarTheme: TabBarTheme(
      labelColor: Colors.black,
      labelStyle: TextStyle(color: Colors.black),

    ),

    elevatedButtonTheme: ElevatedButtonThemeData(style:ElevatedButton.styleFrom())
  );
  static ThemeData darkTheme = ThemeData(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: AppColor.mycolor,).copyWith(secondary: Colors.red, brightness: Brightness.dark),

      textTheme: TextTheme(
      ).apply(
        bodyColor: Colors.yellow,
        displayColor:  Colors.yellow,

      ),
      appBarTheme: AppBarTheme(),
      indicatorColor: AppColor.mycolor,
      floatingActionButtonTheme: FloatingActionButtonThemeData(),

      elevatedButtonTheme: ElevatedButtonThemeData(style:ElevatedButton.styleFrom())
  );

}

class AppColor {
  static const MaterialColor mycolor = const MaterialColor(
    0xffffea00,
    const <int, Color>{
      50: const Color(0xffffec1a ),//10%
      100: const Color(0xffffee33),//20%
      200: const Color(0xfffff04d),//30%
      300: const Color(0xfffff266),//40%
      400: const Color(0xfffff580	),//50%
      500: const Color(0xfffff799),//60%
      600: const Color(0xfffff9b3),//70%
      700: const Color(0xfffffbcc),//80%
      800: const Color(0xfffffde6),//90%
      900: const Color(0xffffffff),//100%
    },
  );
}