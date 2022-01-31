import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:my_login/Component/picture_loading_indicator.dart';
import 'package:my_login/Screens/trip_detail.dart';
import 'package:my_login/dataclasses/trip_data.dart';

import '../user_secure_storage.dart';


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
    late bool didFollow;
    late String follow;
    String? loggedUsername;
    String? loggedUserEmail;
    Map<String, dynamic>? userMapUid;
    late Color button_color;

    @override
    void initState() {
      super.initState();
      getLoggedUsernameAndEmail();

    }
    @override
    void didChangeDependencies() {
      super.didChangeDependencies();
      args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      getUsersPastTripsStreamSnapshots();

    }

    Future<void> getLoggedUsernameAndEmail () async {
      loggedUsername = await UserSecureStorage.getUsername();
      loggedUserEmail = await UserSecureStorage.getUserEmail();
      uidFromEmail(loggedUserEmail!);
      print("persistent username = " +loggedUsername!+", persistent email = "+loggedUserEmail!);
    }

    searchResultsList() {
      var showResults = [];

      if(args['username'] != "") {
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
      var isPortrait = MediaQuery.of(context).orientation;
      doesFollow(args['list_followers']);
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
                  padding: const EdgeInsets.only(left: 20, right: 10, top: 70),
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
                                size: Size.fromRadius(isPortrait == Orientation.portrait ? size.height/18 : size.width/15), // Image radius
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
                                    return Image.network(snapshot.data as String, fit:BoxFit.fill);
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
                ),

            Container(
                    padding: const EdgeInsets.only(left: 20, right: 10, top: 0),
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
                              const Padding(padding: EdgeInsets.fromLTRB(0, 10, 00, 0),),
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
                        child: customButton(size),
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
                                  child:_resultsList[index].previewPic != null?
                                FutureBuilder(
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
                                },): SizedBox(),),
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
        onTap: () {
          print(didFollow.toString() +' 1');
          doesFollow(args['list_followers']);
          print(didFollow.toString() +' 2');
          if(didFollow){
            var list = [loggedUserEmail];
            FirebaseFirestore.instance.collection('users').doc(args['uid']).update({"list_followers": FieldValue.arrayRemove(list)});
            FirebaseFirestore.instance.collection('users').doc(args['uid']).update({"followers": FieldValue.increment(-1) });
            print(args['list_followers'] );
            args['list_followers'].remove(loggedUserEmail);
            print(args['list_followers']);
            var list2=[args['email']];
            print(userMapUid!['uid'] + ' 1');
            FirebaseFirestore.instance.collection('users').doc(userMapUid!['uid']).update({"list_following": FieldValue.arrayRemove(list2)});
            FirebaseFirestore.instance.collection('users').doc(userMapUid!['uid']).update({"following": FieldValue.increment(-1) });
            args['followers']=args['followers']-1;
            /*setState(() {
              follow="Follow";
              didFollow=false;
            });*/
          }
          else{
            var list = [loggedUserEmail];
            FirebaseFirestore.instance.collection('users').doc(args['uid']).update({"list_followers": FieldValue.arrayUnion(list)});
            FirebaseFirestore.instance.collection('users').doc(args['uid']).update({"followers": FieldValue.increment(1) });

            args['list_followers'].add(loggedUserEmail);
            var list2=[args['email']];


            FirebaseFirestore.instance.collection('users').doc(userMapUid!['uid']).update({"list_following": FieldValue.arrayUnion(list2)});
            FirebaseFirestore.instance.collection('users').doc(userMapUid!['uid']).update({"following": FieldValue.increment(1) });
            args['followers']=args['followers']+1;

            /*setState(() {
              follow="Unfollow";
              didFollow=true;
            });*/
          }
          print(didFollow.toString() +' 3');
          doesFollow(args['list_followers']);
          print(didFollow.toString() +' 4');

        },
        child: Container(
        height: 40,
        decoration: BoxDecoration(color: button_color, border: Border.all(color: Colors.blue), borderRadius: BorderRadius.circular(5)),
      padding: const EdgeInsets.all(8),
      child:  Center(
      child:  Text(follow, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
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
    }

    doesFollow(List followers)  {
      print(followers);
      if(followers.isEmpty){
        setState(() {
          follow="Follow";
          didFollow=false;
          button_color=Colors.cyan;
        });
      }
      for (var follower in followers){
        if(follower==loggedUserEmail){
          setState(() {
            follow="Unfollow";
            didFollow=true;
            button_color=Colors.cyan.shade900;
          });
      }else{
          setState(() {
            follow="Follow";
            didFollow=false;
            button_color=Colors.cyan;
          });

        }
      }
    }

  }