import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rider/dataprovider/app_data.dart';
import 'package:rider/global_variable.dart';
import 'package:rider/helpers/requesthelper.dart';
import 'package:rider/model/address.dart';
import 'package:rider/model/direction_details.dart';

class HelperMethod {
  /// function take position {long,lat} & return address string
  static Future<String> findCoordinateAddress(context,
      {required Position position}) async {
    String placeAddress = '';
    // check connectivity
    ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      return placeAddress;
    }
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
    var response = await RequestHelper.getRequest(url: url);
    if (response != "failed") {
      placeAddress = response['results'][0]['formatted_address'];
      Address pickUpAddress = Address();
      pickUpAddress.latitude = position.latitude;
      pickUpAddress.longitude = position.longitude;
      pickUpAddress.placeName = placeAddress;
      Provider.of<AppData>(context, listen: false)
          .updatePickUpAddress(pickUpAddress);
    }
    return placeAddress;
  }

  static Future<DirectionDetails> getDirectionDetails(
      LatLng startPosition, LatLng endPosition) async {
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?destination=${endPosition.latitude},${endPosition.longitude}&origin=${startPosition.latitude},${startPosition.longitude}&mode=driving&key=$mapKey";
    var response = await RequestHelper.getRequest(url: url);
    if (response == "failed") {
      return DirectionDetails();
    }
    DirectionDetails directionDetails = DirectionDetails();

    directionDetails.durationText =
        response["routes"][0]["legs"][0]["duration"]["text"];
    directionDetails.durationValue =
        response["routes"][0]["legs"][0]["duration"]["value"];

    directionDetails.distanceText =
        response["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.distanceValue =
        response["routes"][0]["legs"][0]["distance"]["value"];

    directionDetails.encodedPoints =
        response["routes"][0]["overview_polyline"]["points"];
    return directionDetails;
  }

  static int estimateFares(DirectionDetails details) {
    double baseFare = 3;
    double distanceFare = (details.distanceValue! / 100) * 0.3;
    double timeFare = (details.durationValue! / 60) * 0.2;

    double totalFare = baseFare + distanceFare + timeFare;
    return timeFare.truncate();
  }
}
