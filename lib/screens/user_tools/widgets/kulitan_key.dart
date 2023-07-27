import 'package:amanu/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';

class KulitanKey extends StatefulWidget {
  KulitanKey({
    super.key,
  });

  @override
  State<KulitanKey> createState() => _KulitanKeyState();
}

class _KulitanKeyState extends State<KulitanKey> {
  String buttonString = "k";
  String buttonLabel = "ka";
  String upperString = "ki";
  String upperLabel = "ki";
  String lowerString = "ku";
  String lowerLabel = "ku";
  bool buttonOnHold = false;
  bool buttonTapped = false;
  bool upperButtonSelected = false;
  bool lowerButtonSelected = false;
  double dragStartLocation = 0.0;
  double dragSensitivity = 10.0;

  void buttonHoldToggle() {
    buttonTapped = false;
    buttonOnHold = !buttonOnHold;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => setState(() {
        print("ka");
        buttonTapped = true;
      }),
      onTapUp: (details) => setState(() {
        buttonTapped = false;
      }),
      onTapCancel: () => setState(() {
        buttonTapped = false;
      }),
      onVerticalDragStart: (event) {
        setState(() {
          dragStartLocation = event.globalPosition.dy;
          buttonHoldToggle();
        });
      },
      onVerticalDragUpdate: (event) {
        if (event.globalPosition.dy > dragStartLocation + dragSensitivity) {
          setState(() {
            upperButtonSelected = false;
            lowerButtonSelected = true;
          });
        } else if (event.globalPosition.dy <
            dragStartLocation - dragSensitivity) {
          setState(() {
            upperButtonSelected = true;
            lowerButtonSelected = false;
          });
        }
      },
      onVerticalDragEnd: (event) {
        setState(() {
          if (upperButtonSelected) {
            print("ki");
          }
          if (lowerButtonSelected) {
            print("ku");
          }
          buttonOnHold = false;
          upperButtonSelected = false;
          lowerButtonSelected = false;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        constraints: BoxConstraints(minWidth: 60),
        clipBehavior: Clip.antiAlias,
        height: 60,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  offset: Offset(1, 5),
                  color: primaryOrangeDark.withOpacity(0.25),
                  blurRadius: 15),
            ],
            color: buttonTapped ? Color(0xFFffb87f) : pureWhite,
            borderRadius: BorderRadius.circular(20)),
        child: Stack(
          children: [
            AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: buttonOnHold
                  ? Container(
                      height: double.infinity,
                      width: double.infinity,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              color: upperButtonSelected
                                  ? primaryOrangeDark.withOpacity(0.5)
                                  : muteBlack.withOpacity(0.12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 30,
                                  ),
                                  Container(
                                    width: 20,
                                    alignment: Alignment.center,
                                    child: Text(
                                      upperLabel,
                                      style: TextStyle(
                                          fontSize:
                                              upperButtonSelected ? 12 : 10,
                                          color: upperButtonSelected
                                              ? primaryOrangeDark
                                              : disabledGrey),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              color: lowerButtonSelected
                                  ? primaryOrangeDark.withOpacity(0.5)
                                  : muteBlack.withOpacity(0.12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 30,
                                  ),
                                  Container(
                                    width: 20,
                                    alignment: Alignment.center,
                                    child: Text(
                                      lowerLabel,
                                      style: TextStyle(
                                          fontSize:
                                              lowerButtonSelected ? 12 : 10,
                                          color: lowerButtonSelected
                                              ? primaryOrangeDark
                                              : disabledGrey),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
            ),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 100),
              child: upperButtonSelected
                  ? Container(
                      height: double.infinity,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 50,
                            width: 30,
                            alignment: Alignment.center,
                            child: Text(
                              upperString,
                              style: TextStyle(
                                  fontFamily: 'KulitanKeith',
                                  fontSize: 35,
                                  color: primaryOrangeDark),
                            ),
                          ),
                          Container(
                            height: 50,
                            width: 20,
                          ),
                        ],
                      ),
                    )
                  : lowerButtonSelected
                      ? Container(
                          height: double.infinity,
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 50,
                                width: 30,
                                alignment: Alignment.center,
                                child: Text(
                                  lowerString,
                                  style: TextStyle(
                                      fontFamily: 'KulitanKeith',
                                      fontSize: 35,
                                      color: primaryOrangeDark),
                                ),
                              ),
                              Container(
                                height: 50,
                                width: 20,
                              ),
                            ],
                          ),
                        )
                      : Container(),
            ),
            Container(
              height: double.infinity,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    width: 30,
                    alignment: Alignment.center,
                    child: Text(
                      buttonString,
                      style: TextStyle(
                          fontFamily: 'KulitanKeith',
                          fontSize: 35,
                          color: primaryOrangeDark),
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 20,
                    alignment: Alignment.center,
                    child: Text(
                      buttonLabel,
                      style: TextStyle(
                          fontSize: 12,
                          color: (upperButtonSelected || lowerButtonSelected)
                              ? disabledGrey
                              : primaryOrangeDark),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
