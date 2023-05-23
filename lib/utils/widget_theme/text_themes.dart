import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TTextTheme {
  static TextTheme lightTextTheme = TextTheme(
    headline2:GoogleFonts.robotoSerif(
      color: Colors.black87,
    ),
    subtitle2: GoogleFonts.robotoSerif(
      color: Colors.black54,
      fontSize: 24,

    ),


  );
  static TextTheme darkTextTheme = TextTheme(
  );

}
class DashCard extends StatelessWidget{
  const DashCard({
    required this.value,
    required this.label,
    required this.color,
    Key?key}):super(key: key);

  final int value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Container(

          decoration: BoxDecoration(color: color.withOpacity(25)),
        )
      ],
    );
  }
}




