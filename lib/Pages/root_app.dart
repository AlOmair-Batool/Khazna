import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:sim/Pages/daily_page.dart';
import 'package:sim/Pages/plan_page.dart';
import 'package:sim/Pages/profile_page.dart';
import 'package:sim/Pages/stats_page.dart';
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
        PlanPage(),
        StatsPage(),
        DailyPage(),
        ProfilePage(),
      ],
    );
  }

  Widget getFooter() {
    List<IconData> iconItems = [
      Icons.receipt_long_rounded,
      Icons.bar_chart_rounded,
      Icons.compare_arrows_rounded,
      Icons.person_outline,
    ];
    return AnimatedBottomNavigationBar(
      activeColor: primary,
      splashColor: secondary,
      inactiveColor: Colors.black.withOpacity(0.3),
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