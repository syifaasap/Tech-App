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
          const MyHomeTab(),
          const MyEarningTab(),
          RatingTabPages(),
          const ProfileTabPage(),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.all(16),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
          child: Container(
            color: Colors.grey[300],
            child: TabBar(
              labelColor: const Color.fromARGB(255, 56, 120, 240),
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(fontSize: 14, fontFamily: "PTSans"),
              indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(color: Colors.black54, width: 0),
                insets: EdgeInsets.fromLTRB(50, 0, 50, 40),
              ),
              indicatorColor: Colors.red,
              tabs: const [
                Tab(
                  icon: Icon(Icons.home_rounded),
                  text: 'Home',
                ),
                Tab(
                  icon: Icon(Icons.credit_card_rounded),
                  text: 'Earnings',
                ),
                Tab(
                  icon: Icon(Icons.star_rounded),
                  text: 'Ratings',
                ),
                Tab(
                  icon: Icon(Icons.person_rounded),
                  text: 'Accounts',
                ),
              ],
              controller: tabController,
            ),
          ),
        ),

        // items: const [
        //   BottomNavigationBarItem(
        //     icon: Icon(Icons.home_rounded),
        //     label: "Home",
        //   ),
        //   BottomNavigationBarItem(
        //     icon: Icon(Icons.credit_card),
        //     label: "Earnings",
        //   ),
        //   BottomNavigationBarItem(
        //     icon: Icon(Icons.star),
        //     label: "Ratings",
        //   ),
        //   BottomNavigationBarItem(
        //     icon: Icon(Icons.person),
        //     label: "Accounts",
        //   ),
        // ],
        // unselectedItemColor: Colors.grey,
        // selectedItemColor: const Color.fromARGB(255, 72, 147, 137),
        // backgroundColor: Colors.white,
        // type: BottomNavigationBarType.fixed,
        // selectedLabelStyle: const TextStyle(fontSize: 14, fontFamily: "PTSans"),
        // showUnselectedLabels: true,
        // currentIndex: selectedIndex,
        // onTap: onItemClicked,
      ),
    );
  }
}
