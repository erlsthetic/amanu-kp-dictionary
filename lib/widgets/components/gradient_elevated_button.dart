import 'package:flutter/material.dart';
import 'package:amanu/utils/constants/app_colors.dart';

class GradientElevatedButton extends StatelessWidget {
  final BorderRadius? borderRadius;
  final double? width;
  final double height;
  final EdgeInsets? padding;
  final Gradient gradient;
  final VoidCallback? onPressed;
  final Widget child;

  const GradientElevatedButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.borderRadius,
    this.width,
    this.height = 45.0,
    this.gradient = orangeGradient,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderRad = this.borderRadius ?? BorderRadius.circular(0);
    return InkWell(
      onTap: onPressed,
      borderRadius: borderRad,
      splashColor: primaryOrangeLight.withOpacity(0.5),
      highlightColor: primaryOrangeLight.withOpacity(0.5),
      child: Ink(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: borderRad,
            boxShadow: [
              BoxShadow(
                  color: Colors.black45, blurRadius: 2, offset: Offset(0, 1))
            ]),
        child: Center(child: child),
      ),
    );
  }
}
