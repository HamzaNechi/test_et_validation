import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:psychoday/utils/style.dart';
import '../../../utils/constants.dart';

class RoleScreenTopImage extends StatelessWidget {
  const RoleScreenTopImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Choose your role",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Style.primaryLight,
              fontFamily: 'Red Ring',
              fontSize: 25),
        ),
        const SizedBox(height: defaultPadding * 2),
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 8,
              child: Image.asset("Assets/images/choose.png",
                  width: 300, height: 300),
            ),
            const Spacer(),
          ],
        ),
        SizedBox(height: defaultPadding * 2),
      ],
    );
  }
}
