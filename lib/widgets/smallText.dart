import 'package:flutter/cupertino.dart';

class SmallText extends StatelessWidget {
  final Color? color;
  final String text;
  final double size;
  final int maxLength;
  double height;


  SmallText({Key? key,
    this.color= const Color(0xFF999796),
    required this.text,
    this.size=12,
    this.height=1.2,
    this.maxLength=25}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (text.length < maxLength) {
      return Text(
          text,
          style: TextStyle(
              color: color,
              fontSize: size,
              fontWeight: FontWeight.w400,
              height: height
          )
      );
    }else{
      return Text(
          "${text.substring(0,maxLength)}...",
          style: TextStyle(
              color: color,
              fontSize: size,
              fontWeight: FontWeight.w400,
              height: height
          )
      );
    }
  }

}
