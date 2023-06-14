import 'package:flutter/material.dart';
import 'package:tech_app/Tab%20Pages/earning_tab.dart';
import 'package:tech_app/Tab%20Pages/home_tab.dart';
import 'package:tech_app/Tab%20Pages/profile_tab.dart';
import 'package:tech_app/Tab%20Pages/ratings_page.dart';

class MyMainScreen extends StatefulWidget {
  const MyMainScreen({super.key});

  @override
  State<MyMainScreen> createState() {
    return _MyMainScreenState();
  }
}

class _MyMainScreenState extends State<MyMainScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  int selectedIndex = 0;

  onItemClicked(int index) {
    setState(() {
      selectedIndex = index;
      tabController!.index = selectedIndex;
    });
  }

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(context) {
    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [
          MyHomeTab(),
          MyEarningTab(),
          RatingTabPages(),
          ProfileTabPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: "Earnings",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: "Ratings",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Accounts",
          ),
        ],
        unselectedItemColor: Colors.grey,
        selectedItemColor: const Color.fromARGB(255, 72, 147, 137),
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontSize: 14),
        showUnselectedLabels: true,
        currentIndex: selectedIndex,
        onTap: onItemClicked,
      ),
    );
  }
}
