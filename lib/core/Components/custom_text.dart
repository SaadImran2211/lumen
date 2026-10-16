import 'package:flutter/material.dart';

class AppCustomText extends StatelessWidget {
  const AppCustomText({
    super.key,
    required this.fontSize,
    required this.fontWeight,
    required this.text,
    this.textColor = const Color(0xff313131),
    this.underLine,
    this.textAlign,
  });

  final String text;
  final Color textColor;
  final FontWeight fontWeight;
  final double fontSize;
  final bool? underLine;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        decoration: underLine == true
            ? TextDecoration.underline
            : TextDecoration.none,
        color: textColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
