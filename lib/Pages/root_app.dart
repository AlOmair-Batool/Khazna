import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:sim/Pages/daily_page.dart';
import 'package:sim/Pages/profile_page.dart';
import 'package:sim/theme/colors.dart';

class RootApp extends StatefulWidget {
  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: getBody(),
      bottomNavigationBar: getFooter(),
    );
  }
  Widget getBody() {
    return IndexedStack(
      index: pageIndex,
      children:[
        DailyPage(),
        Center(
            child: Text("States Page"),
        ),
        Center(
            child: Text("Plan Page"),
        ),
        ProfilePage(),
      ],
    );
  }

  Widget getFooter() {
    List<IconData> iconItems = [
      Ionicons.md_swap,
      Ionicons.md_stats,
      Ionicons.md_calculator,
      Ionicons.md_person,
    ];
    return AnimatedBottomNavigationBar(
      activeColor: primary,
      splashColor: secondary,
      inactiveColor: Colors.black.withOpacity(0.5),
      icons: iconItems,
      activeIndex: pageIndex,
      gapLocation: GapLocation.none,
      notchSmoothness: NotchSmoothness.softEdge,
      leftCornerRadius: 10,
      iconSize: 25,
      rightCornerRadius: 10,
      onTap: (index) {
        selectedTab(index);
      },
      //other params
    );
  }
  selectedTab(index) {
    setState(() {
      pageIndex = index;
    });
  }
  }