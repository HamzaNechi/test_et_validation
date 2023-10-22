
import 'package:flutter/material.dart';
import 'package:psychoday/screens/meeting_therapy/join_meeting.dart';
import 'package:psychoday/screens/therapy/detail.dart';
import 'package:psychoday/screens/therapy/therapy_argument.dart';
import 'package:psychoday/utils/style.dart';

import 'therapy_model.dart';

class MenuItemCard extends StatelessWidget {
  final Therapy index;

   const MenuItemCard(this.index, {Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    print("cell normale");
    List<String> dateTime=index.date.split('T');

    return Container(
      margin: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 10),
      child: AspectRatio(
        aspectRatio: 3 / 1,
        child: Container(
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreen(title: "Réservation", therapy: index)));
                },
                child: Row(
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 1 / 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          index.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    AspectRatio(
                      aspectRatio: 4 / 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            index.titre,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),

                          Text(
                            dateTime[0],
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),

                          Text(
                            dateTime[1].split('.')[0],
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            index.address,
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w300),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Np. " + index.capacity.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  //if date meeting = date.now show button join meeting
                  Visibility(
                    visible: index.type == "Remotely" ? true : false,
                    child: IconButton(
                      onPressed: () {
                        // go to screen join meeting (send roomName)
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeCall(roomName: index.roomName )))    ;                
                      },
                      icon: Icon(
                        Icons.join_inner,
                        color: Style.primaryLight,
                        size: 36,
                      ),
                    ),
                  ),

              
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

verifDate(String dateString) {
  DateTime date = DateTime.parse(dateString);
  DateTime toDay = DateTime.now();
  int result = date.compareTo(toDay);

  if (result < 0) {
    print("date reservation ass4ar m date date.hour");
    // wa9it therapy mazel
    return false;
  } else if (result > 0) {
    // wa9it therapy mazel date therapy > date lyoum
    print(date.hour);
    if((date.month == toDay.month) && (date.year == toDay.year) && (date.day == toDay.day) && (date.hour-toDay.hour <= 2)){
      return true;
    }else{
      return false;
    }
    
  } else {
    print(date.hour);
    return false;
  }
}