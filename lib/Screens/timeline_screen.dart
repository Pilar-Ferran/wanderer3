import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../trip_preview.dart';

class TimelineScreen extends StatefulWidget {
  static const routeName = '/timeline';
  const TimelineScreen({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title = 'Timeline';

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  //podemos checkear el codigo original para ver como se editava el estado

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    List<TripPreview> trips = [TripPreview(), TripPreview(), TripPreview(), TripPreview(), TripPreview()];  //posts to show in the timeline
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,  //probar shifting? no se que es
        backgroundColor: Colors.cyan,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.cyanAccent,
        items: const [BottomNavigationBarItem(icon: Icon(Icons.home), label: "Timeline", ), BottomNavigationBarItem(icon: Icon(Icons.search), label: "Explore"), BottomNavigationBarItem(icon: Icon(Icons.add), label: "Create trip"), BottomNavigationBarItem(icon: Icon(Icons.account_box_rounded), label: "Profile")],
      ),
      //he quitado el center
      body: Column(
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
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}