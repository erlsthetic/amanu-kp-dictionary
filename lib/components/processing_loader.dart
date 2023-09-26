import 'package:amanu/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';

class IsProcessingLoader extends StatelessWidget {
  const IsProcessingLoader({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      bottom: 0,
      right: 0,
      child: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(color: disabledGrey.withOpacity(0.25)),
        child: Center(
          child: SizedBox(
            height: 50.0,
            width: 50.0,
            child: CircularProgressIndicator(
              color: primaryOrangeDark,
              strokeWidth: 6.0,
            ),
          ),
        ),
      ),
    );
  }
}
