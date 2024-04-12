import 'package:flutter/material.dart';

import '../utils/themes/theme.dart';

class TitleView extends StatelessWidget {
  final String titleTxt;
  final String subTxt;


  const TitleView(
      {Key? key,
        this.titleTxt: "",
        this.subTxt: "",
        })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
   return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                titleTxt,
                textAlign: TextAlign.left,
                style: TextStyle(

                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  letterSpacing: 0.5,

                ),
              ),
            ),
            InkWell(
              highlightColor: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  children: <Widget>[
                    Text(
                      subTxt,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        letterSpacing: 0.5,

                      ),
                    ),
                    SizedBox(
                      height: 38,
                      width: 26,
                      child: Icon(
                        Icons.arrow_forward,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );

      }

  }
class KpiTittle extends StatelessWidget {
  final String label;
  final Color txtColor;
  const KpiTittle(
      {Key? key,
        required this.txtColor,
        required this.label})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.amber,
      color: AppColor.appColor,
      child: ListTile(
        title: Center(
            child:
            Text(label, style: TextStyle(fontSize: 20, color: txtColor))),
        dense: true,
      ),
    );
  }
}
