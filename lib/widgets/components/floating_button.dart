import 'package:amanu/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';

enum PanelShape { rectangle, rounded }

enum DockType { inside, outside }

enum PanelState { open, closed }

class CustomFloatingPanel extends StatefulWidget {
  final double? positionBottom;
  final double? positionLeft;
  final Color? borderColor;
  final double? borderWidth;
  final double? size;
  final double? iconSize;
  final IconData? panelIcon;
  final IconData? panelIconClose;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? contentColor;
  final Color? mainIconColor;
  final PanelShape? panelShape;
  final PanelState? panelState;
  final double? panelOpenOffset;
  final int? panelAnimDuration;
  final Curve? panelAnimCurve;
  final DockType? dockType;
  final double? dockOffset;
  final int? dockAnimDuration;
  final Curve? dockAnimCurve;
  final List<IconData>? buttons;
  final List<Color>? iconBGColors;
  final double? iconBGRadius;
  final double? iconBGSize;
  final Function(int) onPressed;
  final Color? shadowColor;

  CustomFloatingPanel({
    this.buttons,
    this.positionBottom,
    this.positionLeft,
    this.borderColor,
    this.borderWidth,
    this.iconSize,
    this.panelIcon,
    this.size,
    this.borderRadius,
    this.panelState,
    this.panelOpenOffset,
    this.panelAnimDuration,
    this.panelAnimCurve,
    this.backgroundColor,
    this.contentColor,
    this.panelShape,
    this.dockType,
    this.dockOffset,
    this.dockAnimCurve,
    this.dockAnimDuration,
    required this.onPressed,
    this.iconBGColors,
    this.iconBGRadius,
    this.iconBGSize,
    this.mainIconColor,
    this.panelIconClose,
    this.shadowColor,
    //this.isOpen,
  });

  @override
  _FloatBoxState createState() => _FloatBoxState();
}

class _FloatBoxState extends State<CustomFloatingPanel> {
  // Required to set the default state to closed when the widget gets initialized;
  PanelState _panelState = PanelState.closed;

  // Default positions for the panel;
  double _positionBottom = 0.0;
  double _positionLeft = 0.0;

  // ** PanOffset ** is used to calculate the distance from the edge of the panel
  // to the cursor, to calculate the position when being dragged;
  double _panOffsetTop = 0.0;
  double _panOffsetLeft = 0.0;

  // This is the animation duration for the panel movement, it's required to
  // dynamically change the speed depending on what the panel is being used for.
  // e.g: When panel opened or closed, the position should change in a different
  // speed than when the panel is being dragged;
  int _movementSpeed = 0;

  @override
  void initState() {
    _positionBottom = widget.positionBottom ?? 0;
    _positionLeft = widget.positionLeft ?? 0;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Width and height of page is required for the dragging the panel;
    double _pageWidth = MediaQuery.of(context).size.width;
    double _pageHeight = MediaQuery.of(context).size.height;

    // All Buttons;
    List<IconData> _buttons = widget.buttons!;

    List<Color> _buttonColors = widget.iconBGColors!;

    // Dock offset creates the boundary for the page depending on the DockType;
    double _dockOffset = widget.dockOffset ?? 20.0;

    // Widget size if the width of the panel;
    double _widgetSize = widget.size ?? 70.0;

    // **** METHODS ****

    // Dock boundary is calculated according to the dock offset and dock type.
    double _dockBoundary() {
      if (widget.dockType != null && widget.dockType == DockType.inside) {
        // If it's an 'inside' type dock, dock offset will remain the same;
        return _dockOffset;
      } else {
        // If it's an 'outside' type dock, dock offset will be inverted, hence
        // negative value;
        return -_dockOffset;
      }
    }

    // If panel shape is set to rectangle, the border radius will be set to custom
    // border radius property of the WIDGET, else it will be set to the size of
    // widget to make all corners rounded.
    BorderRadius _borderRadius() {
      if (widget.panelShape != null &&
          widget.panelShape == PanelShape.rectangle) {
        // If panel shape is 'rectangle', border radius can be set to custom or 0;
        return widget.borderRadius ?? BorderRadius.circular(0);
      } else {
        // If panel shape is 'rounded', border radius will be the size of widget
        // to make it rounded;
        return BorderRadius.circular(_widgetSize);
      }
    }

    // Total buttons are required to calculate the height of the panel;
    double _totalButtons() {
      if (widget.buttons == null) {
        return 0;
      } else {
        return widget.buttons!.length.toDouble();
      }
    }

    // Height of the panel according to the panel state;
    double _panelHeight() {
      if (_panelState == PanelState.open) {
        // Panel height will be in multiple of total buttons, I have added "1"
        // digit height for each button to fix the overflow issue. Don't know
        // what's causing this, but adding "1" fixed the problem for now.
        return (_widgetSize + (_widgetSize + 1) * _totalButtons()) +
            (widget.borderWidth ?? 0);
      } else {
        return _widgetSize + (widget.borderWidth ?? 0) * 2;
      }
    }

    // Panel top needs to be recalculated while opening the panel, to make sure
    // the height doesn't exceed the bottom of the page;
    /*void _calcPanelTop() {
      if (_positionTop + _panelHeight() > _pageHeight + _dockBoundary()) {
        _positionTop = _pageHeight - _panelHeight() + _dockBoundary();
      }
    }*/
    void _calcPanelTop() {
      if (_positionBottom + _panelHeight() > _pageHeight - _dockBoundary()) {
        _positionBottom = _pageHeight - _panelHeight() - _dockBoundary();
      }
    }

    // Dock Left position when open;
    double _openDockLeft() {
      if (_positionLeft < (_pageWidth / 2)) {
        // If panel is docked to the left;
        return widget.panelOpenOffset ?? 30.0;
      } else {
        // If panel is docked to the right;
        return ((_pageWidth - _widgetSize)) - (widget.panelOpenOffset ?? 30.0);
      }
    }

    // Panel border is only enabled if the border width is greater than 0;
    Border? _panelBorder() {
      if (widget.borderWidth != null && widget.borderWidth! > 0) {
        return Border.all(
          color: widget.borderColor ?? Color(0xFF333333),
          width: widget.borderWidth ?? 0.0,
        );
      } else {
        return null;
      }
    }

    // Force dock will dock the panel to it's nearest edge of the screen;
    void _forceDock() {
      // Calculate the center of the panel;
      double center = _positionLeft + (_widgetSize / 2);

      // Set movement speed to the custom duration property or '300' default;
      _movementSpeed = widget.dockAnimDuration ?? 300;

      // Check if the position of center of the panel is less than half of the
      // page;
      if (center < _pageWidth / 2) {
        // Dock to the left edge;
        _positionLeft = 0.0 + _dockBoundary();
      } else {
        // Dock to the right edge;
        _positionLeft = (_pageWidth - _widgetSize) - _dockBoundary();
      }
    }

    // TODO implement close panel from screen without touch panel

    // Animated positioned widget can be moved to any part of the screen with
    // animation;
    return AnimatedPositioned(
      duration: Duration(
        milliseconds: _movementSpeed,
      ),
      bottom: _positionBottom,
      left: _positionLeft,
      curve: widget.dockAnimCurve ?? Curves.fastLinearToSlowEaseIn,

      // Animated Container is used for easier animation of container height;
      child: AnimatedContainer(
        duration: Duration(milliseconds: widget.panelAnimDuration ?? 600),
        width: _widgetSize,
        height: _panelHeight(),
        decoration: BoxDecoration(
            color: widget.backgroundColor ?? Color(0xff00b0cb),
            borderRadius: _borderRadius(),
            border: _panelBorder(),
            boxShadow: [
              BoxShadow(
                  color: widget.shadowColor ?? Colors.black,
                  blurRadius: 15,
                  spreadRadius: -4,
                  offset: Offset(1, 1))
            ]),
        curve: widget.panelAnimCurve ?? Curves.fastLinearToSlowEaseIn,
        child: Wrap(
          verticalDirection: VerticalDirection.up,
          direction: Axis.horizontal,
          children: [
            // Gesture detector is required to detect the tap and drag on the panel;
            GestureDetector(
              onPanEnd: (event) {
                setState(
                  () {
                    _forceDock();
                  },
                );
              },
              onTapCancel: () {
                print('TAP_CANCEL');
              },
              onPanStart: (event) {
                // Detect the offset between the top and left side of the panel and
                // x and y position of the touch(click) event;
                _panOffsetTop = -event.globalPosition.dy - _positionBottom;
                _panOffsetLeft = event.globalPosition.dx - _positionLeft;
              },
              onPanUpdate: (event) {
                setState(
                  () {
                    // Close Panel if opened;
                    _panelState = PanelState.closed;

                    // Reset Movement Speed;
                    _movementSpeed = 0;

                    // Calculate the top position of the panel according to pan;
                    _positionBottom = -event.globalPosition.dy - _panOffsetTop;

                    // Check if the top position is exceeding the dock boundaries;
                    if (_positionBottom < 0 + _dockBoundary()) {
                      _positionBottom = 0 + _dockBoundary();
                    }
                    if (_positionBottom >
                        (_pageHeight - _panelHeight()) - _dockBoundary()) {
                      _positionBottom =
                          (_pageHeight - _panelHeight()) - _dockBoundary();
                    }

                    // Calculate the Left position of the panel according to pan;
                    _positionLeft = event.globalPosition.dx - _panOffsetLeft;

                    // Check if the left position is exceeding the dock boundaries;
                    if (_positionLeft < 0 + _dockBoundary()) {
                      _positionLeft = 0 + _dockBoundary();
                    }
                    if (_positionLeft >
                        (_pageWidth - _widgetSize) - _dockBoundary()) {
                      _positionLeft =
                          (_pageWidth - _widgetSize) - _dockBoundary();
                    }
                  },
                );
              },
              onTap: () {
                setState(
                  () {
                    // Set the animation speed to custom duration;
                    _movementSpeed = widget.panelAnimDuration ?? 200;

                    if (_panelState == PanelState.open) {
                      // If panel state is "open", set it to "closed";
                      _panelState = PanelState.closed;

                      // Reset panel position, dock it to nearest edge;
                      _forceDock();
                      //widget.isOpen(false);
                      //print("Float panel closed.");
                    } else {
                      // If panel state is "closed", set it to "open";
                      _panelState = PanelState.open;

                      // Set the left side position;
                      _positionLeft = _openDockLeft();
                      //widget.isOpen(true);

                      _calcPanelTop();
                    }
                  },
                );
              },
              child: _FloatButton(
                size: widget.size ?? 70.0,
                icon: (_panelState == PanelState.closed
                        ? widget.panelIcon
                        : widget.panelIconClose) ??
                    (_panelState == PanelState.closed
                        ? Icons.settings
                        : Icons.close),
                color: widget.mainIconColor ?? Colors.white,
                iconSize: widget.iconSize ?? 36.0,
              ),
            ),
            AnimatedOpacity(
              opacity: _panelState == PanelState.open ? 1.0 : 0.0,
              duration: _panelState == PanelState.open
                  ? Duration(milliseconds: 250)
                  : Duration(milliseconds: 10),
              child: Container(
                child: Column(
                  children: List.generate(
                    _buttons.length,
                    (index) {
                      return GestureDetector(
                        onTap: () {
                          widget.onPressed(index);
                          setState(() {
                            _movementSpeed = widget.panelAnimDuration ?? 200;

                            if (_panelState == PanelState.open) {
                              // If panel state is "open", set it to "closed";
                              _panelState = PanelState.closed;

                              // Reset panel position, dock it to nearest edge;
                              _forceDock();
                              //widget.isOpen(false);
                              ////print("Float panel closed.");
                            } else {
                              // If panel state is "closed", set it to "open";
                              _panelState = PanelState.open;

                              // Set the left side position;
                              _positionLeft = _openDockLeft();
                              // widget.isOpen(true);

                              _calcPanelTop();
                            }
                          });
                        },
                        child: _FloatButton(
                          size: widget.size ?? 70.0,
                          icon: _buttons[index],
                          color: widget.contentColor ?? Colors.white,
                          iconSize: widget.iconSize ?? 24.0,
                          iconBGColor: _buttonColors[index],
                          iconBGRadius: widget.iconBGRadius ?? 70.0,
                          iconBGSize:
                              widget.iconBGSize ?? (widget.size ?? 70.0),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FloatButton extends StatelessWidget {
  final double? size;
  final Color? color;
  final IconData? icon;
  final double? iconSize;
  final Color? iconBGColor;
  final double? iconBGRadius;
  final double? iconBGSize;

  _FloatButton(
      {this.size,
      this.color,
      this.icon,
      this.iconSize,
      this.iconBGColor,
      this.iconBGRadius,
      this.iconBGSize});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size ?? 70.0,
      height: size ?? 70.0,
      child: Center(
        child: Container(
          width: iconBGSize ?? 70.0,
          height: iconBGSize ?? 70.0,
          decoration: BoxDecoration(
              color: iconBGColor ?? Colors.white.withOpacity(0.0),
              borderRadius:
                  BorderRadius.all(Radius.circular(iconBGRadius ?? 70))),
          child: Center(
            child: Icon(
              icon ?? Icons.settings,
              color: color ?? Colors.white,
              size: iconSize ?? 24.0,
            ),
          ),
        ),
      ),
    );
  }
}
