import 'package:flutter/material.dart';
import 'package:psychoday/screens/listPatient/PatientModel.dart';
import 'package:psychoday/screens/suivi/listRapport.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/constants.dart';
import '../../../utils/style.dart';
import './listRapport2.dart';


class CellP extends StatefulWidget {
  final PatientModel mGame;

  const CellP(this.mGame, {Key? key}) : super(key: key);

  @override
  State<CellP> createState() => _CellState();
}

class _CellState extends State<CellP> {
  

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("tts");
        print(widget.mGame.id);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ListRapport2(id_patient: widget.mGame.id,)));
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                //widget.mGame.certificate
                children: [
                  CircleAvatar(
                    radius: 30.0,
                    
                    backgroundImage: NetworkImage('https://images.unsplash.com/5/unsplash-kitsune-4.jpg?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&ixid=eyJhcHBfaWQiOjEyMDd9&s=50827fd8476bfdffe6e04bc9ae0b8c02'),
                    backgroundColor: Colors.transparent,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.mGame.fullName}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                          color: Style.blackColor,
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        widget.mGame.email,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Icon(Icons.arrow_forward_ios)
            ],
          ),
        ),
      ),
    );
  }
}
