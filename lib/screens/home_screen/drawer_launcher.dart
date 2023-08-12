import 'package:amanu/screens/home_screen/widgets/app_drawer.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';

import 'controllers/drawerx_controller.dart';

// ignore: must_be_immutable
class DrawerLauncher extends StatelessWidget {
  DrawerLauncher({super.key});

  final controller = Get.put(DrawerXController());

  @override
  Widget build(BuildContext context) => Obx(
        () => ZoomDrawer(
            mainScreenTapClose: true,
            shadowLayer2Color: Color(0xFFFFDFC6),
            shadowLayer1Color: Color(0xFFFF933D),
            showShadow: true,
            slideWidth: MediaQuery.of(context).size.width * 0.8,
            menuScreenWidth: MediaQuery.of(context).size.width,
            style: DrawerStyle.defaultStyle,
            menuBackgroundColor: primaryOrangeDark,
            duration: const Duration(milliseconds: 500),
            reverseDuration: const Duration(milliseconds: 500),
            borderRadius: 50,
            menuScreen: Builder(
              builder: (context) => AppDrawer(
                  currentItem: controller.currentItem.value,
                  onSelectedItem: (item) {
                    controller.currentItem.value = item;
                    ZoomDrawer.of(context)!.toggle();
                  }),
            ),
            mainScreen: controller.getScreen()),
      );
}
