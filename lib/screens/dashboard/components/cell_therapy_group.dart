import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:psychoday/models/therapy_groups.dart';
import 'package:psychoday/screens/therapy/therapy_model.dart';
import 'package:psychoday/utils/style.dart';

class CellTherapyGroup extends StatefulWidget {
  final Therapy t_group;
  const CellTherapyGroup({required this.t_group,super.key});

  @override
  State<CellTherapyGroup> createState() => _CellTherapyGroupState();
}

class _CellTherapyGroupState extends State<CellTherapyGroup> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
        child:Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(widget.t_group.image),//AssetImage(widget.t_group.image),
              fit: BoxFit.cover
              ),
            borderRadius: BorderRadius.circular(16)
            ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Container(
                    height: 60,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(colors: [
                        Colors.black,
                        Colors.transparent,
                        
                        
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter
                      )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10,bottom: 3),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Style.titleText(widget.t_group.type, Style.whiteColor, 14),
                          Style.sousTitleText(widget.t_group.date, Style.whiteColor, 12)
                        ],
                      ),
                    ),
                  )
                
              ],
            ),
          )
      );
  }
}