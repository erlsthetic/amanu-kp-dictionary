import 'package:amanu/screens/home_screen/controllers/home_page_controller.dart';
import 'package:amanu/screens/home_screen/widgets/drawer_item.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DrawerItems {
  static const home = DrawerItem('Home', Icons.home);
  static const browse = DrawerItem('Browse', Icons.book);
  static const bookmarks = DrawerItem('Bookmarks', Icons.bookmark);
  static const kulitan = DrawerItem('Kulitan Reader', Icons.scanner);
  static const join = DrawerItem('Join Amanu', Icons.people);
  static const support = DrawerItem('Support', Icons.contact_support);
  //static const profile = DrawerItem('Profile', Icons.person);

  static const all = <DrawerItem>[
    home,
    browse,
    bookmarks,
    kulitan,
    join,
    support
  ];
}

class AppDrawer extends StatelessWidget {
  const AppDrawer(
      {super.key, required this.currentItem, required this.onSelectedItem});
  final DrawerItem currentItem;
  final ValueChanged<DrawerItem> onSelectedItem;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: primaryOrangeDark,
        body: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacer(),
            ...DrawerItems.all.map(buildDrawerItem).toList(),
            Spacer(),
          ],
        )),
      );

  Widget buildDrawerItem(DrawerItem item) {
    return ListTileTheme(
      selectedColor: primaryOrangeDark,
      iconColor: primaryOrangeDark,
      child: ListTile(
        textColor: pureWhite,
        selectedTileColor: pureWhite,
        selected: currentItem == item,
        minLeadingWidth: 30,
        iconColor: pureWhite,
        leading: Icon(
          item.icon,
          size: 30,
        ),
        title: Text(
          item.title,
          style:
              GoogleFonts.robotoSlab(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        onTap: () {
          onSelectedItem(item);
          if (Get.isRegistered<HomePageController>()) {
            final homeController = Get.find<HomePageController>();
            if (currentItem == DrawerItems.home ||
                currentItem == DrawerItems.browse) {
              homeController.coastController.animateTo(
                  beach: item == DrawerItems.home ? 0 : 1,
                  duration: Duration(milliseconds: 50));
            }
          }
        },
      ),
    );
  }
}
