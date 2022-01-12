
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_login/Component/picture_loading_indicator.dart';
import 'package:my_login/dataclasses/spot_data.dart';
import 'package:my_login/dataclasses/spot_trip_pair.dart';
import 'package:my_login/dataclasses/trip_data.dart';
//import 'package:spotify_sdk/spotify_sdk.dart';

class SpotDetail extends StatefulWidget {
  static const routeName = '/spot_detail';

  const SpotDetail({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SpotDetailState();
}

class _SpotDetailState extends State<SpotDetail> {

  late final SpotTripPair args;
  late final SpotData spotData;
  late final TripData tripData;


  @override
  /*Future<*/void/*>*/ initState() /*async*/ {
    super.initState();
    //await SpotifySdk.connectToSpotifyRemote(clientId: "ad0826945176451cab98b38cbd2011ad", redirectUrl: "");
    //var authenticationToken = await SpotifySdk.getAuthenticationToken(clientId: "ad0826945176451cab98b38cbd2011ad", redirectUrl: "", scope: "app-remote-control,user-modify-playback-state,playlist-read-private");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context)!.settings.arguments as SpotTripPair;
    spotData = args.spot;
    tripData = args.trip;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(spotData.name+" - "+tripData.title),),
        body: Container(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: ListView(  //main
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),),
              Text(tripData.authorUser, textAlign: TextAlign.left, style: const TextStyle(fontSize: 18),),
              const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),),

              Column(   //trip title, place, spot name
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    Text(tripData.title, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.normal),),
                    Row(children:[  //place, with padding
                      const Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0),),
                      Text(tripData.place, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)]
                    ),
                    const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),),
                    Text(spotData.name, style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
                    const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),),
                    const Text("Soundtrack", style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal)),
                    Text(spotData.description, style: const TextStyle(fontSize: 15),),
                    const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),),

                    //las fotos:
                    FutureBuilder(
                        future: awaitSpotPictures(spotData.picturesFutures),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            if (snapshot.hasError) {
                              //TODO
                              print("error in snapshot: "+snapshot.error.toString());
                              return const Text("error");
                            }
                            else {
                              //return ListView(children: snapshot.data as List<Image>,);
                              return Column(children: addPaddingBetweenImages(snapshot.data as List<Image>),);
                            }
                          }
                          else { //show loading
                            return const PictureLoadingIndicator();
                          }
                        },
                    ),
                  ],
              ),
              //const Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10),),
            ],
          ),
        ),
    );
  }

  Future<List<Image>> awaitSpotPictures(List<Future<String>> picturesFutures) async {
    List<Image> picturesListOfImages =[];
    for (var fut in picturesFutures) {
      picturesListOfImages.add(Image.network(await fut));
    }
    return picturesListOfImages;
  }

  List<Widget> addPaddingBetweenImages(List<Image> imageList) {
    List<Widget> widgets = [];
    for (var image in imageList) {
      widgets.add(image);
      widgets.add(const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),));
    }
    return widgets;
  }

}