import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TTextTheme {
  static TextTheme lightTextTheme = TextTheme(
    displayMedium:GoogleFonts.robotoSerif(
      color: Colors.black87,
    ),
    titleSmall: GoogleFonts.robotoSerif(
      color: Colors.black54,
      fontSize: 24,

    ),


  );
  static TextTheme darkTextTheme = const TextTheme(
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




