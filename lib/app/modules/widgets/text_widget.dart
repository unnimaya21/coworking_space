import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextWidget extends StatefulWidget {
  const TextWidget({
    super.key,
    required this.text,
    this.color = Colors.black,
    required this.fontSize,
    this.minFontSize = 8,
    required this.fontWeight,
    this.maxlines,
    this.lineHeight,
    this.isUnderlined = false,
    this.isStriked = false,
  });
  final String text;
  final Color color;
  final double fontSize;
  final double minFontSize;
  final double? lineHeight;
  final int? maxlines;
  final FontWeight fontWeight;
  final bool isUnderlined;
  final bool isStriked;

  @override
  State<TextWidget> createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
  late Locale local;
  @override
  void initState() {
    local = Get.locale ?? const Locale("ar");
    log(local.languageCode);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,

      maxLines: widget.maxlines ?? 2,

      // minFontSize: widget.minFontSize,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: widget.color,

        fontSize: widget.fontSize,
        fontWeight:
            local == const Locale('ar') ? FontWeight.w700 : widget.fontWeight,
        overflow: TextOverflow.ellipsis,
        height: widget.lineHeight,
        decoration:
            widget.isUnderlined
                ? TextDecoration.underline
                : widget.isStriked
                ? TextDecoration.lineThrough
                : TextDecoration.none,
        fontFamily: 'Hellix',
      ),
    );
  }
}
