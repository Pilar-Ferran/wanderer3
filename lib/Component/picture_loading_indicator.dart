import 'package:flutter/material.dart';

//a circular progress indicator. so as to not repeat code
class PictureLoadingIndicator extends StatelessWidget {
  const PictureLoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column( children: const [
      Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),),
      CircularProgressIndicator()],
    );
  }
}