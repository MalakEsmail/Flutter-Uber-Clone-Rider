import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rider/brand_colors.dart';
import 'package:rider/global_variable.dart';
import 'package:rider/helpers/requesthelper.dart';
import 'package:rider/widgets/brand_divider.dart';
import 'package:rider/widgets/prediction_tile.dart';

import '../dataprovider/app_data.dart';
import '../model/prediction.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final pickupController = TextEditingController();
  final destinationController = TextEditingController();
  final focusDestination = FocusNode();
  bool focused = false;
  void setFocused() {
    if (!focused) {
      FocusScope.of(context).requestFocus(focusDestination);
      focused = true;
    }
  }

  List<Prediction> destinationPredictionList = [];
  searchPlace(String placeName) async {
    if (placeName.length > 1) {
      String url =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json ?input=$placeName &key=$mapKey &components=country:eg";
      var response = await RequestHelper.getRequest(url: url);
      if (response == "failed") {
        print("api search response : $response");
        return;
      }
      if (response["status"] == "OK") {
        var predictionJson = response["predictions"];
        var thisList = (predictionJson as List)
            .map((e) => Prediction.fromJson(e))
            .toList();
        setState(() {
          destinationPredictionList = thisList;
        });

        print("api search response : $response");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String address = Provider.of<AppData>(context).pickUpAddress == null
        ? "nasr city"
        : Provider.of<AppData>(context).pickUpAddress!.placeName!;
    pickupController.text = address;
    setFocused();
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          Container(
            height: 220,
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5.0,
                spreadRadius: 0.5,
                offset: Offset(0.7, 0.7),
              ),
            ]),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, top: 30, right: 24, bottom: 20),
              child: Column(
                children: [
                  Stack(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back)),
                      Center(
                        child: Text(
                          "Set Destination ",
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        "images/pickicon.png",
                        height: 16,
                        width: 16,
                      ),
                      SizedBox(
                        width: 18,
                      ),
                      Expanded(
                        child: Container(
                          child: TextField(
                            controller: pickupController,
                            decoration: InputDecoration(
                                hintText: "Pickup Location",
                                fillColor: BrandColors.colorLightGrayFair,
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(
                                  left: 10,
                                  top: 8,
                                  bottom: 8,
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        "images/desticon.png",
                        height: 16,
                        width: 16,
                      ),
                      SizedBox(
                        width: 18,
                      ),
                      Expanded(
                        child: Container(
                          child: TextField(
                            onChanged: (val) {
                              searchPlace(val);
                            },
                            focusNode: focusDestination,
                            decoration: InputDecoration(
                                hintText: "Where to ? ",
                                fillColor: BrandColors.colorLightGrayFair,
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(
                                  left: 10,
                                  top: 8,
                                  bottom: 8,
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          destinationPredictionList.length > 0
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListView.separated(
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return PredictionTile(
                            prediction: destinationPredictionList[index]);
                      },
                      separatorBuilder: (context, index) {
                        return BrandDivider();
                      },
                      itemCount: destinationPredictionList.length),
                )
              : SizedBox()
        ],
      ),
    ));
  }
}
