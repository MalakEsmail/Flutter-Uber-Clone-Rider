import 'package:flutter/cupertino.dart';
import 'package:rider/model/address.dart';

class AppData extends ChangeNotifier {
  Address? pickUpAddress;

  Address? destinationAddress;
  void updatePickUpAddress(Address pickUpAdd) {
    pickUpAddress = pickUpAdd;
    notifyListeners();
  }

  void updateDestinationAddress(Address destinationAdd) {
    destinationAddress = destinationAdd;
    notifyListeners();
  }
}
