import 'package:amanu/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';

Future<dynamic> showLoaderDialog(BuildContext context) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            return Future.value(false);
          },
          child: Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Center(
              child: Container(
                height: 70,
                width: 70,
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), color: pureWhite),
                child: CircularProgressIndicator(
                  color: primaryOrangeDark,
                  strokeWidth: 6.0,
                ),
              ),
            ),
          ),
        );
      });
}
