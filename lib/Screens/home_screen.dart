import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_login/Screens/logout_screen.dart';
import 'package:my_login/Screens/explore_screen.dart';
import 'package:my_login/Screens/timeline_screen.dart';

import '../Component/trip_preview.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/homescreen';
  const HomeScreen({Key? key}) : super(key: key);

  final String title = 'Wanderer';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //podemos checkear el codigo original para ver como se editava el estado

  int selectedIndex = 0;
  static const List<Widget> fourNavigationScreens = <Widget>[
    TimelineScreen(),
    ExploreScreen(),
    Text(
      'Index 2: School',
    ),
    LogoutScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called
    return Scaffold(
      /*appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),*/
      body: Center(
        child: fourNavigationScreens.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,  //probar shifting? no se que es
        backgroundColor: Colors.cyan,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.cyanAccent,
        items: const [BottomNavigationBarItem(icon: Icon(Icons.home), label: "Timeline",),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Explore"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Create trip"),
          BottomNavigationBarItem(icon: Icon(Icons.account_box_rounded), label: "Profile",)],
        currentIndex: selectedIndex,
        onTap: _onItemTapped,
      ),
      //he quitado el center
      /*body: Column( //TODO usar
        //comments borrados
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: ListView(
                //itemExtent: 50,
                children: trips,
                //shrinkWrap: true,

              )
          )
        ],
      ),*/// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}