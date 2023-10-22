import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psychoday/screens/meeting_therapy/join_meeting.dart';
import 'package:psychoday/screens/therapy/ajout_therapy.dart';
import 'package:psychoday/screens/therapy/detail.dart';
import 'package:psychoday/screens/therapy/therapy_argument.dart';
import 'package:psychoday/screens/therapy/therapy_model.dart';
import 'package:psychoday/screens/therapy/updateTherapy.dart';
import 'package:psychoday/utils/style.dart';

class CellDoctor extends StatelessWidget {
  final Therapy index;

  const CellDoctor(this.index, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("cell doctor");
    return Container(
      margin: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 40),
      child: AspectRatio(
        aspectRatio: 3 / 1,
        child: Container(
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {},
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return UpdateTherapy(id: index.id,therapy: index,);
                        },
                      ),
                    );
                  },
                  icon: Icon(
                    CupertinoIcons.pencil_circle,
                    color: Style.primaryLight,
                    size: 30,
                  ),
                ),

                Visibility(
                  visible: index.type == "Remotely" ? true : false,
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeCall(roomName: index.roomName )))    ; 
                    },
                    icon: const Icon(
                      Icons.join_inner_sharp,
                      color: Style.primaryLight,
                      size: 30,
                    ),
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
