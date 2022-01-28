import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:my_login/Component/picture_loading_indicator.dart';
import 'package:my_login/Screens/trip_detail.dart';
import 'package:my_login/dataclasses/trip_data.dart';


class UserDetail extends StatefulWidget {
  static const routeName = '/user_detail';
  const UserDetail({Key? key}) : super(key: key);


  @override
  _UserDetailState createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
    late final Map<String, dynamic> args;
    List _allResults = [];
    List _resultsList = [];

    @override
    void didChangeDependencies() {
      super.didChangeDependencies();
      args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      getUsersPastTripsStreamSnapshots();
    }





    searchResultsList() {
      var showResults = [];

      if(args['author_username'] != "") {
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
        print(_resultsList);

      });

    }
    getUsersPastTripsStreamSnapshots() async {

      var data = await FirebaseFirestore.instance.collection('trips').where("author_username", isEqualTo: args['username']).get();
      setState(() {
        _allResults = data.docs;
      });
      searchResultsList();

    }

    @override
    Widget build(BuildContext context) {
      final size = MediaQuery.of(context).size;
      final Map<String,dynamic> userCharact=args;
      return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
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
                  margin: const EdgeInsets.only(left: 20, right: 10, top: 30),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height:size.height/5,
                              width:size.width/5,
                        child:
                            FutureBuilder(
                              future: getImage(userCharact['profile_picture']),
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
                                Text(userCharact['followers'].toString(), style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
                                const SizedBox(height: 5),
                                const Text('Followers', style: TextStyle(color: Colors.black, fontSize: 14),),
                              ],
                            ),
                            Column(
                              children: [
                                Text(userCharact['following'].toString(), style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
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

            Container(
                    margin: const EdgeInsets.only(left: 20, right: 10, top: 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(userCharact['username'], style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
                              SizedBox(
                                height: size.height/60,
                              ),
                              Text(userCharact['biography'], style: const TextStyle(color: Colors.black, fontSize: 15),),

                            ],
                          ),
                          flex: 9,
                        )
                      ],
                    ),),

                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 30, bottom: 25),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 8,
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(color: Colors.cyan, border: Border.all(color: Colors.blue), borderRadius: BorderRadius.circular(5)),
                          padding: const EdgeInsets.all(8),
                          child: const Center(
                            child:  Text('Follow', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
            const Divider(
                    color: Colors.cyan
                ),


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


  }