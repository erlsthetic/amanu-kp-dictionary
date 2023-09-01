import 'package:amanu/components/request_card.dart';
import 'package:amanu/screens/home_screen/controllers/drawerx_controller.dart';
import 'package:amanu/screens/requests_screen/controllers/requests_controller.dart';
import 'package:amanu/utils/constants/app_colors.dart';
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
  final controller = Get.put(RequestsController());

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    final size = MediaQuery.of(context).size;
    final screenPadding = MediaQuery.of(context).padding;
    return Scaffold(
        body: Stack(
      children: [
        Positioned(
          top: screenPadding.top + 50,
          left: 0,
          right: 0,
          child: FutureBuilder(
            future: controller.getAllRequests(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState != ConnectionState.done)
                return Container(
                  height: size.height - 110,
                  width: size.width,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              else
                return Container(
                  height: size.height - 110,
                  width: size.width,
                  child: controller.requests.length != 0
                      ? ListView.builder(
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.only(top: 30, bottom: 100),
                          itemCount: controller.requests.length,
                          itemBuilder: (context, index) {
                            return RequestCard(
                              timestamp: controller.requests[index].timestamp,
                              requestType:
                                  controller.requests[index].requestType,
                              word: controller.requests[index].word,
                              userName: controller.requests[index].userName,
                              notes: controller.requests[index].requestNotes,
                              onTap: () async {
                                await controller.requestSelect(
                                    controller.requests[index].requestId,
                                    controller.requests[index].requestType);
                              },
                            );
                          },
                        )
                      : Center(
                          child: Text(
                            "No requests at the moment.",
                            style: TextStyle(fontSize: 16, color: disabledGrey),
                          ),
                        ),
                );
            },
          ),
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
