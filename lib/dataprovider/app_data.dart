import 'package:flutter/cupertino.dart';
import 'package:rider/model/address.dart';

class AppData extends ChangeNotifier {
  Address? pickUpAddress;
  void updatePickUpAddress(Address pickUpAdd) {
    pickUpAddress = pickUpAdd;
    notifyListeners();
  }
}
