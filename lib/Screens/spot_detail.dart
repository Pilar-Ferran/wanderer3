
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:my_login/Component/picture_loading_indicator.dart';
import 'package:my_login/dataclasses/spot_data.dart';
import 'package:my_login/dataclasses/spot_trip_pair.dart';
import 'package:my_login/dataclasses/trip_data.dart';
//import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:html/parser.dart' as htmlparser;
import 'package:html/dom.dart' as dom;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart' as thing;

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

  String? soundtrackHtmlData;
  //late dom.Document document;

  @override
  /*Future<*/void/*>*/ initState() /*async*/ {
    super.initState();
    //await SpotifySdk.connectToSpotifyRemote(clientId: "ad0826945176451cab98b38cbd2011ad", redirectUrl: "");
    //var authenticationToken = await SpotifySdk.getAuthenticationToken(clientId: "ad0826945176451cab98b38cbd2011ad", redirectUrl: "", scope: "app-remote-control,user-modify-playback-state,playlist-read-private");
    //String fullMoon = "56kaK6tAfATdNjavJwthsN";
    //String bigCityNights ="7BF627yIxHuxETi7HaEdnT";
    //document = htmlparser.parse(htmlData);
    //iniSpotify();
  }

  /*Future<void> iniSpotify() /*async*/ async {
    await SpotifySdk.connectToSpotifyRemote(clientId: "ad0826945176451cab98b38cbd2011ad", redirectUrl: "");
    var authenticationToken = await SpotifySdk.getAuthenticationToken(clientId: "ad0826945176451cab98b38cbd2011ad", redirectUrl: "", scope: "app-remote-control,user-modify-playback-state,playlist-read-private");
  }*/

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context)!.settings.arguments as SpotTripPair;
    spotData = args.spot;
    tripData = args.trip;
    if (spotData.soundtrack != null && spotData.soundtrack != "") {
      soundtrackHtmlData =
          '<iframe src="https://open.spotify.com/embed/track/' +
              spotData.soundtrack! +
              '?utm_source=generator" width="100%" height="80" frameBorder="0" allowfullscreen="" allow="autoplay; clipboard-write; encrypted-media; fullscreen; picture-in-picture"></iframe>';
    }
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
                    Center(child: //kinda ugly. maybe the trip texts should be smaller, maybe remove the center. idk.
                      Text(spotData.name, style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
                    ),

                    const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),),
                    //soundtrack:
                    buildSoundtrackSection(),

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
                              return Column(children: addPaddingAndCenterImages(snapshot.data as List<Image>),);
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

  //builds the sountrack section of the screen only if the spot has a sountrack
  Widget buildSoundtrackSection() {
    if (soundtrackHtmlData != null) {
      return Column(children: [
        Row(children: const [
          Padding(padding: EdgeInsets.fromLTRB(7, 0, 0, 0),),
          Text("Soundtrack", style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal)),
        ],),

        //spotify:
        Html(data: soundtrackHtmlData,
              customRender: {
              "iframe": (RenderContext context, Widget child) {
                final attrs = context.tree.element?.attributes;
                if (attrs != null) {
                  double? width = double.tryParse(attrs['width'] ?? "");
                  double? height = double.tryParse(attrs['height'] ?? "");
                  return Container(
                    width: width/* ?? (height ?? 150) * 2*/,
                    height: height/* ?? (width ?? 300) / 2*/,
                    /*decoration: BoxDecoration(  //doesnt work
                      borderRadius: BorderRadius.circular(20),
                    ),*/
                      child: WebView(
                      initialUrl: attrs['src'] ?? "about:blank",
                      javascriptMode: JavascriptMode.unrestricted,

                      //evitamos q navegue. osea los links q contienen ya no hacen nada. pq no funcionaban
                      navigationDelegate: (thing.NavigationRequest request) async {
                        return thing.NavigationDecision.prevent;
                      },
                    ),
                  );
                } else {
                  return Container(height: 0);
                }
              }
            }
          /*style:{
                        "html": Style(height: 100),
                        }*/
        ),
      ],
      );
    }
    else {
      return const Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 0));
    }
  }

  Future<List<Image>> awaitSpotPictures(List<Future<String>> picturesFutures) async {
    List<Image> picturesListOfImages =[];
    for (var fut in picturesFutures) {
      picturesListOfImages.add(Image.network(await fut));
    }
    return picturesListOfImages;
  }

  List<Widget> addPaddingAndCenterImages(List<Image> imageList) {
    List<Widget> widgets = [];
    for (var image in imageList) {
      widgets.add(
        Center(child:
          image,
        ));
      widgets.add(const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),));
    }
    return widgets;
  }

}