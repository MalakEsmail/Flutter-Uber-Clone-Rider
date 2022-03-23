import 'package:flutter/material.dart';
import 'package:rider/brand_colors.dart';
import 'package:rider/model/prediction.dart';

class PredictionTile extends StatefulWidget {
  final Prediction prediction;
  const PredictionTile({Key? key, required this.prediction}) : super(key: key);

  @override
  _PredictionTileState createState() => _PredictionTileState();
}

class _PredictionTileState extends State<PredictionTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: BrandColors.colorDimText,
              ),
              SizedBox(
                width: 14,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.prediction.mainText!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      widget.prediction.secondaryText!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 12, color: BrandColors.colorDimText),
                    )
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }
}
