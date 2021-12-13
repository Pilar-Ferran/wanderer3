import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_login/Screens/logout_screen.dart';

import 'trip_preview.dart';

class TimelineScreen extends StatefulWidget {
  static const routeName = '/timeline';
  const TimelineScreen({Key? key}) : super(key: key);

  final String title = 'Timeline';

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  //podemos checkear el codigo original para ver como se editava el estado

  int selectedIndex = 0;
  static const List<Widget> fourNavigationScreens = <Widget>[
    Text('esto es el timeline'),
    Text(
      'Index 1: Business',
    ),
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
    List<TripPreview> trips = [TripPreview(), TripPreview(), TripPreview(), TripPreview(), TripPreview()];  //posts to show in the timeline
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
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