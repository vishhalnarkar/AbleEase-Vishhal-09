import 'package:ableeasefinale/pages/UI/homePage.dart';
import 'package:ableeasefinale/pages/UI/meditationPage.dart';
import 'package:ableeasefinale/pages/UI/navigationBar.dart';
import 'package:ableeasefinale/pages/UI/profilePage.dart';
import 'package:ableeasefinale/pages/disability_page.dart';
import 'package:ableeasefinale/pages/doctorPages/doctorHomePage.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';

class doctorParentPage extends StatefulWidget {
  const doctorParentPage({super.key});

  @override
  State<doctorParentPage> createState() => DoctorParentPageState();
}

class DoctorParentPageState extends State<doctorParentPage> {
  int _selectedIndex = 0;
  Widget getChild({required int index}) {
    Widget ch;
    switch (index) {
      case 0:
        ch = const doctorHomePage();
        break;
      case 1:
        ch = const DisabilityPage();
        break;
      case 2:
        ch = const MedPage();
        break;
      case 3:
        ch = const ProfilePage();
        break;
      default:
        ch = const DisabilityPage();
    }
    return ch;
  }

  void navigateToPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        buttonBackgroundColor: Theme.of(context).colorScheme.secondary,
        color: Theme.of(context).colorScheme.primary,
        items: const [
          CurvedNavigationBarItem(
            child: Icon(
              Icons.home_outlined,
              size: 35,
            ),
          ),
          CurvedNavigationBarItem(
            child: Icon(CommunityMaterialIcons.gamepad_variant, size: 35),
          ),
          CurvedNavigationBarItem(
            child: Icon(CommunityMaterialIcons.meditation, size: 35),
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.person, size: 35),
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: Container(child: getChild(index: _selectedIndex)),
    );
  }
}
