import 'package:amanu/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';

class TagCreator extends StatelessWidget {
  const TagCreator({
    super.key,
    required this.label,
    this.color = pureWhite,
    this.textColor = disabledGrey,
  });

  final String label;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(2.5, 0, 2.5, 5.0),
      height: 22,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(20), color: color),
      padding: EdgeInsets.fromLTRB(5, 3, 5, 3),
      child: Text(label,
          style: TextStyle(
              fontSize: 12, color: textColor, fontStyle: FontStyle.italic)),
    );
  }
}
