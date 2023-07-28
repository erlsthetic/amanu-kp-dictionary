import 'package:amanu/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';

class KulitanKey extends StatefulWidget {
  KulitanKey({
    super.key,
    required this.buttonString,
    required this.buttonLabel,
    required this.upperString,
    required this.upperLabel,
    required this.lowerString,
    required this.lowerLabel,
    required this.onTap,
    required this.onUpperSelect,
    required this.onLowerSelect,
    this.dragSensitivity,
  });
  final String buttonString;
  final String buttonLabel;
  final String upperString;
  final String upperLabel;
  final String lowerString;
  final String lowerLabel;
  final double? dragSensitivity;
  final void Function(Size, Offset) onTap;
  final void Function(Size, Offset) onUpperSelect;
  final void Function(Size, Offset) onLowerSelect;

  @override
  State<KulitanKey> createState() => _KulitanKeyState();
}

class _KulitanKeyState extends State<KulitanKey> {
  bool buttonOnHold = false;
  bool buttonTapped = false;
  bool buttonDown = false;
  bool upperButtonSelected = false;
  bool lowerButtonSelected = false;
  double dragStartLocation = 0.0;
  String hintText = '';
  late RenderBox renderBox;
  late Size size;
  late Offset offset;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getWidgetInfo(context));
  }

  void getWidgetInfo(context) {
    renderBox = context.findRenderObject() as RenderBox;
    size = renderBox.size;
    offset = renderBox.localToGlobal(Offset.zero);
  }

  void buttonHoldToggle() {
    buttonTapped = false;
    buttonOnHold = !buttonOnHold;
  }

  Widget hintWidget() {
    if (buttonDown) {
      return AnimatedContainer(
        alignment: Alignment.center,
        duration: Duration(milliseconds: 100),
        height: 50,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              offset: Offset(1, 5),
              color: primaryOrangeDark.withOpacity(0.25),
              blurRadius: 15),
        ], color: Color(0xFFffb87f), borderRadius: BorderRadius.circular(20)),
        child: Text(
          hintText,
          style: TextStyle(
              fontFamily: 'KulitanKeith', fontSize: 35, color: pureWhite),
        ),
      );
    } else {
      return Container(
        height: 50,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String buttonString = widget.buttonString;
    String buttonLabel = widget.buttonLabel;
    String upperString = widget.upperString;
    String upperLabel = widget.upperLabel;
    String lowerString = widget.lowerString;
    String lowerLabel = widget.lowerLabel;
    double dragSensitivity = widget.dragSensitivity ?? 10.0;

    return GestureDetector(
      onTapDown: (details) => setState(() {
        hintText = buttonString;
        buttonTapped = true;
        buttonDown = true;
        widget.onTap(size, offset);
      }),
      onTapUp: (details) => setState(() {
        hintText = '';
        buttonTapped = false;
        buttonDown = false;
      }),
      onTapCancel: () => setState(() {
        hintText = '';
        buttonTapped = false;
        buttonDown = false;
      }),
      onVerticalDragStart: (event) {
        setState(() {
          buttonDown = true;
          hintText = buttonString;
          dragStartLocation = event.globalPosition.dy;
          buttonHoldToggle();
        });
      },
      onVerticalDragUpdate: (event) {
        if (event.globalPosition.dy > dragStartLocation + dragSensitivity) {
          setState(() {
            hintText = lowerString;
            upperButtonSelected = false;
            lowerButtonSelected = true;
          });
        } else if (event.globalPosition.dy <
            dragStartLocation - dragSensitivity) {
          setState(() {
            hintText = upperString;
            upperButtonSelected = true;
            lowerButtonSelected = false;
          });
        }
      },
      onVerticalDragEnd: (event) {
        setState(() {
          if (upperButtonSelected) {
            widget.onUpperSelect(size, offset);
          }
          if (lowerButtonSelected) {
            widget.onLowerSelect(size, offset);
          }
          hintText = '';
          buttonDown = false;
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
                  offset: buttonTapped ? Offset(1, 1) : Offset(1, 5),
                  color: primaryOrangeDark.withOpacity(0.25),
                  blurRadius: buttonDown ? 6 : 15),
            ],
            color: buttonTapped ? Color(0xFFffb87f) : pureWhite,
            borderRadius: BorderRadius.circular(20)),
        child: Stack(
          children: [
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
                    child: Stack(
                      children: [
                        Text(
                          upperString,
                          style: TextStyle(
                              fontFamily: 'KulitanKeith',
                              fontSize: 35,
                              color: lightGrey.withOpacity(0.5)),
                        ),
                        Text(
                          lowerString,
                          style: TextStyle(
                              fontFamily: 'KulitanKeith',
                              fontSize: 35,
                              color: lightGrey.withOpacity(0.5)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 20,
                  ),
                ],
              ),
            ),
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
