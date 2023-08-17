import 'package:amanu/screens/home_screen/controllers/drawerx_controller.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:amanu/components/three_part_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RequestsScreen extends StatelessWidget {
  RequestsScreen({
    super.key,
    this.fromDrawer = true,
  });

  final bool fromDrawer;

  final drawerController = Get.find<DrawerXController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenPadding = MediaQuery.of(context).padding;
    return Scaffold(
        body: Stack(
      children: [
        Positioned(
          top: screenPadding.top + 50,
          left: 0,
          right: 0,
          child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              height: size.height - screenPadding.top - 50,
              width: size.width,
              child: Column(
                children: [
                  SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                      child: Column(
                        children: [],
                      ),
                    ),
                  ),
                ],
              )),
        ),
        ThreePartHeader(
          size: size,
          screenPadding: screenPadding,
          title: tRequests,
          firstIcon: fromDrawer
              ? Icons.menu_rounded
              : Icons.arrow_back_ios_new_rounded,
          firstOnPressed: () {
            fromDrawer ? drawerController.drawerToggle(context) : Get.back();
          },
        ),
      ],
    ));
  }
}
