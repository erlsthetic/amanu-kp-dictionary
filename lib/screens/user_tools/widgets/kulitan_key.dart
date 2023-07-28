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
  final VoidCallback onTap;
  final VoidCallback onUpperSelect;
  final VoidCallback onLowerSelect;

  @override
  State<KulitanKey> createState() => _KulitanKeyState();
}

class _KulitanKeyState extends State<KulitanKey>
    with SingleTickerProviderStateMixin {
  bool buttonOnHold = false;
  bool buttonTapped = false;
  bool buttonDown = false;
  bool upperButtonSelected = false;
  bool lowerButtonSelected = false;
  double dragStartLocation = 0.0;
  String hintText = '';
  String hintTextLabel = '';
  late RenderBox renderBox;
  late Size size;
  late Offset offset;

  @override
  void initState() {
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

  @override
  Widget build(BuildContext context) {
    String buttonString = widget.buttonString;
    String upperString = widget.upperString;
    String lowerString = widget.lowerString;
    double dragSensitivity = widget.dragSensitivity ?? 10.0;

    Widget keyButton = GestureDetector(
      onTapDown: (details) => setState(() {
        hintText = widget.buttonString;
        hintTextLabel = widget.buttonLabel;
        buttonTapped = true;
        buttonDown = true;
      }),
      onTapUp: (details) => setState(() {
        hintText = '';
        hintTextLabel = '';
        widget.onTap();
        buttonTapped = false;
        buttonDown = false;
      }),
      onTapCancel: () => setState(() {
        buttonTapped = false;
        buttonDown = false;
      }),
      onVerticalDragStart: (event) {
        setState(() {
          buttonDown = true;
          hintText = widget.buttonString;
          hintTextLabel = widget.buttonLabel;
          dragStartLocation = event.globalPosition.dy;
          buttonHoldToggle();
        });
      },
      onVerticalDragUpdate: (event) {
        if (event.globalPosition.dy > dragStartLocation + dragSensitivity) {
          setState(() {
            hintText = widget.lowerString;
            hintTextLabel = widget.lowerLabel;
            upperButtonSelected = false;
            lowerButtonSelected = true;
          });
        } else if (event.globalPosition.dy <
            dragStartLocation - dragSensitivity) {
          setState(() {
            hintText = widget.upperString;
            hintTextLabel = widget.upperLabel;
            upperButtonSelected = true;
            lowerButtonSelected = false;
          });
        }
      },
      onVerticalDragEnd: (event) {
        setState(() {
          if (upperButtonSelected) {
            widget.onUpperSelect();
          }
          if (lowerButtonSelected) {
            widget.onLowerSelect();
          }
          hintText = '';
          hintTextLabel = '';
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
                  offset: buttonDown ? Offset(1, 1) : Offset(1, 5),
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
              child: Container(
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
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              color: lowerButtonSelected
                                  ? primaryOrangeDark.withOpacity(0.5)
                                  : muteBlack.withOpacity(0.12),
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
                      child: Container(
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
                    )
                  : lowerButtonSelected
                      ? Container(
                          height: double.infinity,
                          width: double.infinity,
                          child: Container(
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
                        )
                      : Container(),
            ),
            Container(
              height: double.infinity,
              width: double.infinity,
              child: Container(
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
            ),
          ],
        ),
      ),
    );

    return _KeyHint(
      hint: hintText,
      hintLabel: hintTextLabel,
      visible: buttonDown,
      child: keyButton,
    );
  }
}

class _KeyHint extends StatefulWidget {
  const _KeyHint({
    required this.hint,
    required this.visible,
    required this.child,
    required this.hintLabel,
  });

  final String hint;
  final String hintLabel;
  final bool visible;
  final Widget child;

  @override
  _KeyHintState createState() => _KeyHintState();
}

class _KeyHintState extends State<_KeyHint>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _overlay;
  bool _shouldRemove = false;

  AnimationController? animationController;
  Animation<double>? animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this)
      ..addStatusListener(_handleStatusChanged);
    animation = CurveTween(curve: Curves.fastLinearToSlowEaseIn)
        .animate(animationController!);
  }

  void _handleStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) _removeEntry();
  }

  @override
  void deactivate() {
    animationController!.reverse();
    super.deactivate();
  }

  void _removeEntry() {
    if (_overlay != null) {
      _overlay!.remove();
      _overlay = null;
    }
  }

  @override
  void dispose() {
    super.dispose();
    animationController!.dispose();
  }

  void _refresh() {
    if (_overlay != null) _overlay!.remove();
    _overlay = this._createKeyHint();
    Overlay.of(context).insert(_overlay!);
  }

  void _removeOverlay() async {
    _shouldRemove = true;
    animationController!.reverse();
    await Future.delayed(const Duration(milliseconds: 300));
    if (_shouldRemove) _removeEntry();
  }

  @override
  void didUpdateWidget(_KeyHint oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.visible && oldWidget.visible)
      _removeOverlay();
    else if (widget.visible && !oldWidget.visible) {
      _shouldRemove = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_overlay == null) {
          _overlay = this._createKeyHint();
          Overlay.of(context).insert(_overlay!);
        }
        animationController!.forward();
      });
    }
    if (widget.hint != oldWidget.hint && widget.visible && oldWidget.visible)
      WidgetsBinding.instance.addPostFrameCallback((_) => _refresh());
  }

  OverlayEntry _createKeyHint() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    final String _hintText = widget.hint;
    final String _hintLabel = widget.hintLabel;

    return OverlayEntry(
      builder: (context) {
        return Positioned(
          left: offset.dx,
          top: offset.dy - 65,
          child: FadeTransition(
            opacity:
                Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: animation!,
              curve: Curves.fastLinearToSlowEaseIn,
            )),
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(5),
                height: size.height,
                width: size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Color(0xFFffb87f),
                ),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        _hintText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'KulitanKeith',
                            fontSize: 35,
                            color: pureWhite),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        _hintLabel,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: pureWhite),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
