import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Component/trip_preview.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  Widget build(BuildContext context) {
    //TODO quizás la appBar debería estar en cada pantalla en lugar de en home_screen
    return DefaultTabController(
        length: 2,
        child: Column(
            children: const [
              TabBar(tabs: [
                Tab(icon: Icon(Icons.directions_car)),
                Tab(icon: Icon(Icons.directions_transit)),
              ],
              ),
              //TabBarView(children: [Text("here you search places"), Text("here you search people")])
            ]
        )
    );
  }
}