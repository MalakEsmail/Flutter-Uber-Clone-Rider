import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rider/global_variable.dart';
import 'package:rider/helpers/requesthelper.dart';

class HelperMethod {
  /// function take position {long,lat} & return address string
  static Future<String> findCoordinateAddress(
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
    }
    return placeAddress;
  }
}
