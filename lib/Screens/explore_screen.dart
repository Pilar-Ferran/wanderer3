import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_login/Component/picture_loading_indicator.dart';
import 'package:my_login/dataclasses/trip_data.dart';
import '../Component/trip_preview.dart';
import '../icons_app.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  Map<String, dynamic>? userMap;
  bool loading = false;
  bool loading2= false;
  final TextEditingController _search = TextEditingController();
  final TextEditingController _searchtrip = TextEditingController();
  late Future resultsLoaded;
  List _allResults = [];
  List _resultsList = [];



  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getUsersPastTripsStreamSnapshots();
  }



  searchResultsList() {
    var showResults = [];

    if(_searchtrip.text != "") {
      for(var tripSnapshot in _allResults){
        var title = TripData.fromSnapshot(tripSnapshot).place;
        if(title.contains(_searchtrip.text)) {
          TripData aux= TripData.fromSnapshot(tripSnapshot);

          showResults.add(aux);
        }
      }

    } else {

      showResults = List.from(_allResults);
    }
    setState(() {
      _resultsList = showResults;
    });
  }

  getUsersPastTripsStreamSnapshots() async {
    var data = await FirebaseFirestore.instance.collection('trips').where("location", isEqualTo: _searchtrip.text).get();
    setState(() {
      _allResults = data.docs;
    });
    searchResultsList();
    print(_allResults);
  }
  @override

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
            Container(
              constraints: const BoxConstraints.expand(),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/cyan.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,

                    children: [
                      SizedBox(
                        height: size.height / 20,
                      ),
                      Container(
                        height: size.height / 14,
                        width: size.width,
                        alignment: Alignment.center,
                        child: Container(
                          height: size.height / 14,
                          width: size.width / 1.15,
                          child: TextField(
                            controller: _searchtrip,
                            decoration: InputDecoration(
                              filled:true,
                              fillColor: Colors.white,
                              hintText: "Search Trip",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height / 50,
                      ),
                      ElevatedButton(
                        onPressed: getUsersPastTripsStreamSnapshots,
                        child: const Text("Search", style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),),
                      ),
                      SizedBox(
                        height: size.height / 30,
                      ),
                      Expanded(
                              child: ListView.builder(
                              itemCount: _resultsList.length,
                              itemBuilder: (BuildContext context, int index) =>
                              TripPreview(_resultsList[index]),
                              )

                      ),
    ],
                  ),


            ),
        Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/cyan.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child:Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,

                children: [
                  loading
                    ? Column(
                    children: [
                      SizedBox(
                        height: size.height / 3,
                      ),
                      const Center(
                  child: CircularProgressIndicator(),
                ),],)
                    :   Column(
                  children: [
                SizedBox(
                height: size.height / 20,
                ),
              Container(
                height: size.height / 14,
                width: size.width,
                alignment: Alignment.center,
                child: Container(
                  height: size.height / 14,
                  width: size.width / 1.15,
                  child: TextField(
                    controller: _search,
                    decoration: InputDecoration(
                      filled:true,
                      fillColor: Colors.white,
                      hintText: "Search User",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height / 50,
              ),
              ElevatedButton(
                onPressed: onSearch,
                child: const Text("Search", style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),),
              ),
              SizedBox(
                height: size.height / 30,
              ),
                    userMap!=null ?
                        Container(
                          color: Colors.white,
                          child:
                        ListTile(
                          onTap:() {},
                          leading: FutureBuilder(
                            future: getImage(userMap!['profile_picture']),
                            builder: (context, snapshot){
                              if (snapshot.connectionState == ConnectionState.done) {
                                if (snapshot.hasError) {
                                  print("error in snapshot: "+snapshot.error.toString());
                                  return const Text("error");
                                }
                                else {
                                  return Image.network(snapshot.data as String);
                                }
                              }
                              else { //show loading
                                return const PictureLoadingIndicator();
                              }
                            },),
                          selectedTileColor: Colors.white,
                          title: Text(
                            userMap!['username'],
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(userMap!['biography']),
                          trailing: Icon(Icons.chat, color: Colors.black),
                        ),)
                        : Container(),
    ],
      ),
          ],
        ),
                    ),
        ],
      ),
    ),
    );


  }


  void onSearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    setState(() {
      loading = true;
    });

    await _firestore
        .collection('users')
        .where("username", isEqualTo: _search.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        loading = false;
      });
      print(userMap);
    }).onError((error, stackTrace) {
      setState(() {
      loading = false;
      userMap=null;
    });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('No user found', style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),),
          backgroundColor: Colors.red,
          action: SnackBarAction(label: 'Try again', textColor: Colors.white ,onPressed: ScaffoldMessenger.of(context).hideCurrentSnackBar),
        ),
      );
    });


  }

  Future<String> getImage(String imagePath) async {
    final ref = FirebaseStorage.instance.ref().child(imagePath);
    var url = await ref.getDownloadURL();
    return url;
  }




}

