import 'package:amanu/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';

class _KeyHint extends StatefulWidget {
  const _KeyHint(
      {required this.hint, required this.visible, required this.child});

  final String hint;
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

    return OverlayEntry(
      builder: (context) {
        return Positioned(
          left: offset.dx + ((size.width - (1 * size.height)) / 2),
          top: offset.dy - size.height - 20,
          child: FadeTransition(
            opacity:
                Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: animation!,
              curve: Curves.fastLinearToSlowEaseIn,
            )),
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: _hintText == 'a' ||
                        _hintText == 'aa' ||
                        _hintText == 'ii' ||
                        _hintText == 'uu'
                    ? const EdgeInsets.all(5 + 10.0)
                    : const EdgeInsets.all(5),
                height: 1 * size.height,
                width: 1 * size.height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Color(0xFFffb87f),
                ),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    _hintText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'KulitanKeith',
                        fontSize: 35,
                        color: pureWhite),
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
