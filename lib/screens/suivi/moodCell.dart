import 'package:flutter/material.dart';
import 'package:psychoday/utils/style.dart';

import 'Report.dart';

class MoodItemCard extends StatelessWidget {
  final Report index;

  const MoodItemCard(this.index, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      margin: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 40),
      child: AspectRatio(
        aspectRatio: 3 / 1,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: Style.whiteColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Style.primary,
                blurRadius: 4,
                spreadRadius: 2,
              ),
            ],
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Expanded(
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Container(
                            height: 80,
                            child: AspectRatio(
                              aspectRatio: 4 / 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: [
                                      Text(
                                        index.mood!,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 50,
                                      ),
                                      Text(
                                        index.date!,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[500],
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "DepressedMood " +
                                              index.depressedMood.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: Style.marron),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 7,
                                      ),
                                      Expanded(
                                        child: Text(
                                          "ElevatedMood " +
                                              index.depressedMood.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: Style.marron),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "IrritabilityMood " +
                                          index.depressedMood.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Style.marron),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
