
import 'package:my_login/dataclasses/spot_data.dart';
import 'package:my_login/dataclasses/trip_data.dart';

class SpotTripPair {
  late SpotData spot;
  late TripData trip;

  SpotTripPair(this.spot, this.trip);
}