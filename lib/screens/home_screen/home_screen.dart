import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/widgets/components/floating_button.dart';
import 'widgets/browse_screen_page.dart';
import 'package:amanu/widgets/components/bottom_nav_bar.dart';
import 'package:coast/coast.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'widgets/home_screen_page.dart';
import 'controllers/home_page_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key, this.pageIndex});

  final bool isLoggedIn = true;
  final bool isExpert = true;
  final int? pageIndex;

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    final _topPadding = MediaQuery.of(context).padding.top;
    final _pController = HomePageController();
    _pController.currentIdx.value = pageIndex ?? 0;
    return Scaffold(
      body: Stack(
        children: [
          Coast(
            beaches: [
              Beach(
                  builder: (context) =>
                      HomeScreenPage(size: _size, topPadding: _topPadding)),
              Beach(
                  builder: (context) => BrowseScreenPage(
                        size: _size,
                        topPadding: _topPadding,
                      )),
            ],
            controller: _pController.coastController,
            onPageChanged: (page) {
              _pController.currentIdx.value = page;
            },
            observers: [CrabController()],
          ),
          BottomNavBar(size: _size, pController: _pController),
          CustomFloatingPanel(
            onPressed: (index) {
              print("Clicked $index");
            },
            positionBottom: _size.height * 0.1,
            positionLeft: _size.width - 85,
            size: 70,
            iconSize: 30,
            panelIcon: Icons.person,
            dockType: DockType.inside,
            dockOffset: 15,
            backgroundColor: pureWhite,
            contentColor: pureWhite,
            panelShape: PanelShape.rounded,
            borderRadius: BorderRadius.circular(40),
            borderColor: primaryOrangeDark,
            buttons: [
              Icons.add,
              Icons.edit,
              Icons.delete,
            ],
            iconBGColors: [primaryOrangeDark, primaryOrangeLight, orangeCard],
            iconBGSize: 60,
            mainIconColor: primaryOrangeDark,
            shadowColor: primaryOrangeDark,
          )
        ],
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final grey = const Color(0xFFF2F2F7);
  final double paddingFactor;

  SearchBar({Key? key, required this.paddingFactor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
          20 + (15 * paddingFactor), 0, 20 + (20 * paddingFactor), 0),
      child: TextFormField(
        style: GoogleFonts.poppins(
          fontSize: 16.0,
          fontWeight: FontWeight.normal,
          color: primaryOrangeDark,
          letterSpacing: 1.0,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          focusColor: primaryOrangeLight,
          focusedBorder: _border(grey),
          border: _border(grey),
          enabledBorder: _border(grey),
          hintText: 'Search',
          hintStyle: TextStyle(color: primaryOrangeDark),
          contentPadding: EdgeInsets.symmetric(
              vertical: 15 - (5 * paddingFactor), horizontal: 20),
          suffixIcon: const Icon(
            Icons.search,
            color: primaryOrangeDark,
          ),
        ),
        onFieldSubmitted: (value) {},
      ),
    );
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderSide: BorderSide(width: 0.5, color: color),
        borderRadius: BorderRadius.circular(20),
      );
}
