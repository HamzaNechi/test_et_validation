import 'package:flutter/material.dart';
import 'package:psychoday/utils/constants.dart';
import 'package:psychoday/utils/style.dart';

class Continue extends StatelessWidget {
  final bool login;
  final Function? press;
  const Continue({
    Key? key,
    this.login = true,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? "continue  " : "continue ? ",
          style: const TextStyle(color: Style.primaryLight,fontFamily: 'Mark-Light'),
        ),
        GestureDetector(
          onTap: press as void Function()?,
          child: Text(
            login ? "update psd" : "update",
            style: const TextStyle(color: Style.primary,fontFamily: 'Mark-Light', fontWeight: FontWeight.bold ),
          ),
        )
      ],
    );
  }
}