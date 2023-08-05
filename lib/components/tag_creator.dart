import 'package:amanu/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';

class TagCreator extends StatelessWidget {
  const TagCreator({
    super.key,
    required this.label,
    this.color = pureWhite,
    this.textColor = cardText,
    this.padding = const EdgeInsets.fromLTRB(6, 3, 6, 3),
    this.height = 22,
    this.fontSize = 12,
    this.isBadge = false,
    this.isExpert = false,
    this.iconSize = 13,
    this.isLink = false,
  });

  final String label;
  final Color? color;
  final Color? textColor;
  final EdgeInsets? padding;
  final double? height;
  final double? fontSize;
  final bool? isBadge;
  final bool? isExpert;
  final bool? isLink;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(2.5, 0, 2.5, 5.0),
      height: height,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(20), color: color),
      padding: padding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          isBadge ?? false
              ? Container(
                  padding: EdgeInsets.only(right: 5),
                  child: Icon(
                    isExpert ?? false
                        ? Icons.verified_rounded
                        : isLink ?? false
                            ? Icons.search_rounded
                            : Icons.person_add_rounded,
                    size: iconSize,
                    color: textColor,
                  ),
                )
              : Container(),
          Text(label,
              style: TextStyle(
                  fontSize: fontSize,
                  color: textColor,
                  fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }
}
