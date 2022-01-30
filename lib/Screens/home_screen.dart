import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_login/Screens/create_trip_screen.dart';
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

  String _barTitle = "Wanderer";

  //used rarely
  late int? indexSetByArgs;

  int selectedIndex = 0;
  static const List<Widget> fourNavigationScreens = <Widget>[
    TimelineScreen(),
    ExploreScreen(),
    CreateTripScreen(),
    LogoutScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;

      switch (index) {
        case 0: {
            _barTitle = "Wanderer";
          }
          break;
        case 1: {
          _barTitle = "Explore";
        }
        break;
        case 2: {
          _barTitle = "Create a trip";
        }
        break;
        case 3: {
          _barTitle = "My profile"; //TODO: change to logged user profile
        }
        break;
      }

    });
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    //if we come from a screen which specified what page to go to, we set it
    indexSetByArgs = ModalRoute.of(context)!.settings.arguments as int?;
    if (indexSetByArgs != null) {
      selectedIndex = indexSetByArgs!;
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(/*widget.title*/_barTitle),
      ),
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
      ),*/
    );
  }
}