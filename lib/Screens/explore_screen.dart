import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Component/trip_preview.dart';
import '../icons_app.dart';

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
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: SafeArea(
            child: Column(
              children: [
               Expanded(child: Container()),
                const TabBar(
                  tabs: [
                    Tab(icon: Icon( IconsApp.globe_2,
                      size: 24,
                    )),
                    Tab(icon: Icon(Icons.person_search_sharp)),
                  ],
                  //indicatorColor: Colors.white,
                  indicatorWeight: 5,
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: const [Text("here you search places"),],
            ),
            Column(
              children: const [Text("here you search people"),],
            )
          ],
        ),
      ),
    );


  }
}