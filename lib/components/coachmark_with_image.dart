import 'package:amanu/components/text_span_builder.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CoachmarkDescWithImage extends StatefulWidget {
  CoachmarkDescWithImage(
      {super.key,
      required this.title,
      required this.image,
      required this.text,
      this.skip = "Skip",
      this.next = "Next",
      this.onSkip,
      this.onNext,
      this.withSkip = true});

  final String title;
  final String image;
  final String text;
  final String skip;
  final String next;
  final void Function()? onSkip;
  final void Function()? onNext;
  final bool withSkip;

  @override
  State<CoachmarkDescWithImage> createState() => _CoachmarkDescWithImageState();
}

class _CoachmarkDescWithImageState extends State<CoachmarkDescWithImage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this,
        lowerBound: 0,
        upperBound: 10,
        duration: Duration(milliseconds: 1000))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, animationController.value),
          child: child,
        );
      },
      child: Container(
        decoration: BoxDecoration(
            color: pureWhite,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [BoxShadow(blurRadius: 20, spreadRadius: -7)]),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
              child: Center(
                child: Text(
                  widget.title,
                  style: GoogleFonts.robotoSlab(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: pureWhite),
                ),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                  color: primaryOrangeDark),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 15, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    widget.image,
                    width: size.width * 0.75,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text.rich(
                    TextSpan(children: [
                      buildTextSpan(
                          text: widget.text,
                          style: TextStyle(color: cardText, fontSize: 16),
                          boldWeight: FontWeight.w600)
                    ], style: TextStyle(color: cardText, fontSize: 16)),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: cardText, fontSize: 16),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      widget.withSkip
                          ? TextButton(
                              onPressed: widget.onSkip,
                              child: Text(
                                widget.skip,
                                style: TextStyle(
                                    color: darkerOrange.withOpacity(0.8),
                                    fontWeight: FontWeight.w500),
                              ))
                          : Container(),
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: widget.onNext,
                        child: Text(
                          widget.next,
                          style: TextStyle(
                              color: pureWhite, fontWeight: FontWeight.w700),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryOrangeDark,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
