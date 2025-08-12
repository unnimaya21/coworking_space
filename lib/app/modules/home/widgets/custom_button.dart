// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:perfume_app/app/modules/widgets/text_widget.dart';

class CustomButton extends StatelessWidget {
  String text;
  Color backgroundColor;
  Color textColor;
  VoidCallback? onPressed;
  Color borderColor;
  CustomButton({
    super.key,
    required this.text,
    this.backgroundColor = Colors.transparent,
    this.textColor = Colors.white,
    this.onPressed,
    this.borderColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
          side: BorderSide(color: borderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: TextWidget(
          text: text,
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
