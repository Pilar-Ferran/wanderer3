import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_login/Component/create_spot_dialog.dart';
import 'package:my_login/Component/edit_profile_dialog.dart';
import 'package:my_login/Component/logout_dialog.dart';
import 'package:my_login/Component/picture_loading_indicator.dart';
import 'package:my_login/Screens/trip_detail.dart';
import 'package:my_login/dataclasses/trip_data.dart';
import '../user_secure_storage.dart';
import 'package:my_login/Screens/login_screen.dart';

class LogoutScreen extends StatefulWidget {
  static const routeName = '/logout';

  const LogoutScreen({Key? key}) : super(key: key);
  @override
  _LogoutScreenState createState() => _LogoutScreenState();
}


class _LogoutScreenState extends State<LogoutScreen> {
  List _allResults = [];
  List _resultsList = [];
  String? loggedUsername;
  String? loggedUserEmail;
  late Map<String, dynamic>? userMapUid;
  bool loading =true;

  @override
  void initState() {
    super.initState();
    getLoggedUsernameAndEmail();

  }


  Future<void> getLoggedUsernameAndEmail () async {
    loggedUsername = await UserSecureStorage.getUsername();
    loggedUserEmail = await UserSecureStorage.getUserEmail();
    uidFromEmail(loggedUserEmail!);
    print("persistent username = " +loggedUsername!+", persistent email = "+loggedUserEmail!);
  }

  searchResultsList() {
    var showResults = [];
    if(loggedUsername != "") {
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
      loading=false;

    });

  }
  getUsersPastTripsStreamSnapshots() async {
    var data = await FirebaseFirestore.instance.collection('trips').where("author_username", isEqualTo: loggedUsername).get();
    setState(() {
      _allResults = data.docs;
    });
    searchResultsList();

  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: loading ?
      Center(
        child: SizedBox(
          height: size.height / 20,
          width: size.height / 20,
          child: const CircularProgressIndicator(),
        ),
      ) : Container(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child:  Container(
            constraints: const BoxConstraints.expand(),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/cyan.jpg'),
                fit: BoxFit.cover,
              ),
            ), child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 20, top:10, right: 10),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/white.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SingleChildScrollView(
                  child:
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        ClipOval(
                        child: SizedBox.fromSize(
                        size: Size.fromRadius(size.height/18), // Image radius
                      child:
                              FutureBuilder(
                                future: getImage(userMapUid!['profile_picture']),
                                builder: (context, snapshot){
                                  if (snapshot.connectionState == ConnectionState.done) {
                                    if (snapshot.hasError) {
                                      print("error in snapshot: "+snapshot.error.toString());
                                      return const Text("error");
                                    }
                                    else {
                                      return Image.network(snapshot.data as String, fit: BoxFit.fill);
                                    }
                                  }
                                  else { //show loading
                                    return const PictureLoadingIndicator();
                                  }
                                },),),),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(_resultsList.length.toString(), style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
                                const SizedBox(height: 5),
                                const Text('Trips', style:  TextStyle(color: Colors.black, fontSize: 14),),
                              ],
                            ),
                            Column(
                              children: [
                                Text(userMapUid!['followers'].toString(), style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
                                const SizedBox(height: 5),
                                const Text('Followers', style: TextStyle(color: Colors.black, fontSize: 14),),
                              ],
                            ),
                            Column(
                              children: [
                                Text(userMapUid!['following'].toString(), style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
                                const SizedBox(height: 5),
                                const Text('Following', style: TextStyle(color: Colors.black, fontSize: 14),),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.only(left: 20, top:10, right: 10),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/white.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(userMapUid!['username'], style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
                            SizedBox(
                              height: size.height/60,
                            ),
                            Text(userMapUid!['biography'], style: const TextStyle(color: Colors.black, fontSize: 15),),

                          ],
                        ),
                        flex: 9,
                      )
                    ],
                  ),),),
              Container(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 30, bottom: 25),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/white.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 8,
                        child:
                        customButton(size),
                        ),
                      const Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0),),
                      Expanded(
                        flex: 1,
                        child:
                        customButton2(size),
                      ),

                    ],
                  ),
                ),
              ),

              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/white.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: const SingleChildScrollView(
                  child: Divider(
                      thickness: 15,
                      color: Colors.cyan
                  ),),),


              Expanded(
                child: ListView.builder(
                    itemCount: _resultsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: Container(
                          color: Colors.white,
                          child: ListTile(
                            onTap:() {Navigator.pushNamed(context, TripDetail.routeName, arguments: _resultsList[index]);},
                            leading: SizedBox(
                              height:size.height/5,
                              width:size.width/5,
                              child:FutureBuilder(
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
                                },),),
                            selectedTileColor: Colors.white,
                            title: Text(
                              _resultsList[index].title,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(_resultsList[index].place),
                            trailing: Icon(Icons.account_balance, color: Colors.black),
                          ),),);}
                ),
              ),
            ],),),),),);

  }

  Future<String?> getImage(String? imagePath) async {
    if (imagePath == null) {
      return null;
    }
    final ref = FirebaseStorage.instance.ref().child(imagePath);
    var url = await ref.getDownloadURL();
    return url;
  }

  Widget customButton(Size size) {
    return GestureDetector(
      onTap:() {
        showDialog(context: context, builder: (context)=>EditProfileDialog(userMapInit:userMapUid!, refreshParent: () {refresh();},));
      },
      child: Container(
        height: 40,
        decoration: BoxDecoration(color: Colors.cyan.shade800, border: Border.all(color: Colors.blue), borderRadius: BorderRadius.circular(5)),
        padding: const EdgeInsets.all(8),
        child:  Center(
          child:  Text('Edit profile', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
        ),),);
  }

  Widget customButton2(Size size) {
    return GestureDetector(
      onTap:() {
        showDialog(context: context, builder: (context)=>LogoutDialog());
      },
      child: Container(
        height: 40,
        decoration: BoxDecoration(color: Colors.blueGrey, border: Border.all(color: Colors.blue), borderRadius: BorderRadius.circular(5)),
        padding: const EdgeInsets.all(8),
        child:  Center(
          child:  Icon(Icons.settings),
        ),),);
  }

  uidFromEmail(String email) async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    print(email.toString() + ' especial');
    await _firestore
        .collection('users')
        .where("email", isEqualTo: email)
        .get()
        .then((value) {
      setState(() {
        userMapUid = value.docs[0].data();
        print(userMapUid);
      });
    }).onError((error, stackTrace) {
      setState(() {
        userMapUid = null;
      });
    });
    getUsersPastTripsStreamSnapshots();
  }

void refresh(){
  setState(() {});
  getLoggedUsernameAndEmail();
  setState(() {});

}


}