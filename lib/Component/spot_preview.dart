
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_login/dataclasses/spot_data.dart';

class SpotPreview extends StatelessWidget {
  final SpotData spotData;

  const SpotPreview(this.spotData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: InkWell(
          onTap: () {
            //Navigator
          },
          child: Ink(
            child: Text(spotData.name),
          ),
        )
    );
  }
}