import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:psychoday/screens/ChooseRole/components/role_form.dart';
import 'package:psychoday/screens/ChooseRole/components/role_screen_top_image.dart';
import 'package:psychoday/utils/responsive.dart';
import 'package:psychoday/utils/style.dart';

import '../../components/background.dart';

class RoleScreen extends StatelessWidget {
  //var
  final GoogleSignInAccount user;
  const RoleScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      bg: Style.whiteColor,
      child: SingleChildScrollView(
        child: Responsive(
          mobile: MobileLoginScreen(user: user),
          desktop: Row(
            children: [
              const Expanded(
                child: RoleScreenTopImage(),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 450,
                      child: RoleForm(user: user),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MobileLoginScreen extends StatelessWidget {
  //var
  final GoogleSignInAccount user;
  const MobileLoginScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const RoleScreenTopImage(),
        Row(
          children: [
            Spacer(),
            Expanded(
              flex: 8,
              child: RoleForm(user: user),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }
}
