import 'package:amanu/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

Future<dynamic> showInfoDialog(
    BuildContext context,
    String title,
    Widget childWidget,
    Widget? bottomWidget,
    VoidCallback? onClose,
    RxBool isVisible) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: pureWhite,
                    borderRadius: BorderRadius.circular(30.0)),
                margin: EdgeInsets.only(right: 12, top: 12),
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      constraints: BoxConstraints(minHeight: 70),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                          color: primaryOrangeDark,
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(30.0))),
                      child: Text(
                        title,
                        style: GoogleFonts.robotoSlab(
                            fontSize: 24,
                            color: pureWhite,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: childWidget,
                      ),
                    ),
                    bottomWidget != null ? bottomWidget : Container()
                  ],
                ),
              ),
              Positioned(
                right: 0.0,
                child: Obx(
                  () => Visibility(
                    visible: isVisible.value,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        if (onClose != null) {
                          onClose;
                        }
                      },
                      child: Align(
                        alignment: Alignment.topRight,
                        child: CircleAvatar(
                          radius: 18.0,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.close, color: primaryOrangeDark),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      });
}
