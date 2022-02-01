import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_login/Component/picture_loading_indicator.dart';
import 'package:my_login/Screens/home_screen.dart';
import 'package:my_login/Screens/logout_screen.dart';
import 'package:my_login/Screens/search_yourself_screen.dart';
import 'package:my_login/Screens/trip_detail.dart';
import 'package:my_login/Screens/user_detail.dart';
import 'package:my_login/dataclasses/trip_data.dart';
import '../icons_app.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../user_secure_storage.dart';


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
  List _allResults = [];
  List _resultsList = [];
  String? loggedUsername;
  String? loggedUserEmail;


  @override
  void initState() {
    super.initState();
    getLoggedUsernameAndEmail();

  }

  Future<void> getLoggedUsernameAndEmail () async {
    loggedUsername = await UserSecureStorage.getUsername();
    loggedUserEmail = await UserSecureStorage.getUserEmail();
    print("persistent username = " +loggedUsername!+", persistent email = "+loggedUserEmail!);
  }
  searchResultsList() {
    var showResults = [];

    if(_searchtrip.text != "") {
      for(var doc in _allResults){

        var docData = doc.data() as Map<String, dynamic>;
        TripData trip = TripData.fromJson(docData);


        trip.firestorePath = doc.reference.path;
        //trip.firestoreId = doc.reference.id;

        //we add the preview image, which is stored in a different Firebase service.
        trip.previewPicFuture = getImage(trip.previewPic);

        //var title = TripData.fromSnapshot(tripSnapshot).place;
        //if(title.contains(_searchtrip.text)) {
          //TripData aux= TripData.fromSnapshot(tripSnapshot);

          showResults.add(trip);
        }
      } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      _resultsList = showResults;
      loading2=false;
      print(_resultsList);

    });
    if(_resultsList.length==0){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('No trips found', style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),),
          backgroundColor: Colors.red,
          action: SnackBarAction(label: 'Try again', textColor: Colors.white ,onPressed: ScaffoldMessenger.of(context).hideCurrentSnackBar),
        ),
      );
    }
  }

  getUsersPastTripsStreamSnapshots() async {
    setState(() {
      loading2 = true;
    });
    var data = await FirebaseFirestore.instance.collection('trips').where("location", isEqualTo: _searchtrip.text).get();
    setState(() {
      _allResults = data.docs;
    });
    searchResultsList();

  }
  @override

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var isPortrait = MediaQuery.of(context).orientation;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset : false,
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
            loading2
                ? Column(
              children: [
                SizedBox(
                  height: size.height / 3,
                ),
                const Center(
                  child: CircularProgressIndicator(),
                ),],)
                :
              Container(
              constraints: const BoxConstraints.expand(),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/cyan.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,

                    children: [
                    Expanded(
                      child:ListView.builder(
                          shrinkWrap: true,
                          itemCount: 1,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
    SizedBox(
    height: size.height / 20,
    ),
    Container(
    height: (isPortrait==Orientation.portrait) ? size.height / 14 : size.height/5,
    width: size.width / 1.15,
    alignment: Alignment.center,
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
    //),
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
                     ListView.builder(
                        itemCount: _resultsList.length,
                         physics: ClampingScrollPhysics(),
                         shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: Container(
                              color: Colors.white,
                              child: ListTile(
                                onTap:() {Navigator.pushNamed(context, TripDetail.routeName, arguments: _resultsList[index]);},
                                leading: FutureBuilder(
                                  future: getImage(_resultsList[index].previewPic),
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
                                  _resultsList[index].title,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: Text(_resultsList[index].authorUser),
                                trailing: Icon(Icons.account_balance, color: Colors.black),
                              ),),);}
                ),],);},),),],),

    //],
                  //),


            ),
                loading
                    ? Column(
                  children: [
                    SizedBox(
                      height: size.height / 3,
                    ),
                    const Center(
                      child: CircularProgressIndicator(),
                    ),],)
                    :

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
                    Expanded(
                  child: ListView.builder(
                  shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: size.height / 20,
                        ),

                        Container(
                          alignment: Alignment.center,
                          height: (isPortrait == Orientation.portrait) ? size
                              .height / 14 : size.height / 5,
                          width: size.width / 1.15,
                          child: TextField(
                            controller: _search,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "Search User",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
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
                        userMap != null ?
                        Container(
                          color: Colors.white,
                          child:
                          ListTile(
                            onTap: () {
                              (userMap!['email'] == loggedUserEmail)
                                  ? Navigator.pushNamed(
                                  context, SearchYourselfScreen.routeName)
                                  : Navigator.pushNamed(
                                  context, UserDetail.routeName,
                                  arguments: userMap);
                            },
                            leading: ClipOval(
                              child: SizedBox.fromSize(
                                size: Size.fromRadius(size.height / 25),
                                // Image radius
                                child: FutureBuilder(
                                  future: getImage(userMap!['profile_picture']),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      if (snapshot.hasError) {
                                        print("error in snapshot: " +
                                            snapshot.error.toString());
                                        return const Text("error");
                                      }
                                      else {
                                        return Image.network(
                                            snapshot.data as String,
                                            fit: BoxFit.fill);
                                      }
                                    }
                                    else { //show loading
                                      return const PictureLoadingIndicator();
                                    }
                                  },),),),
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
                    );
                  }
    ), ),
    ],),


    ),
    ],
    ),
      ),);


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

  Future<String?> getImage(String? imagePath) async {
    if (imagePath == null) {
      return null;
    }
    final ref = FirebaseStorage.instance.ref().child(imagePath);
    var url = await ref.getDownloadURL();
    return url;
  }



}

