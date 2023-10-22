import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:psychoday/utils/constants.dart';

import '../../../utils/style.dart';

class DoctorScreenTopImage extends StatelessWidget {
  const DoctorScreenTopImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 8,
              child: Image.asset("Assets/images/doctordetail.png",
                  width: 250, height: 250),
            ),
          ],
        ),
         Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // to center the texts vertically
          children: [
             Text(
              "Welcome Doctor",
             style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Style.primaryLight,
                  fontFamily: 'Red Ring',
                  fontSize: 25),
            ),
              SizedBox(height: defaultPadding),
             Text(
              'PLEASE ENTER YOUR DETAILS IN THE GIVEN FORM',
              style: TextStyle(
                fontSize: 13,
                fontFamily: "Mark-Light",
                ),
            ),
          ],
        ),
      ],
    );
  }
}
