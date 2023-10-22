import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:psychoday/screens/DoctorDetails/components/doctor_detail_form.dart';
import 'package:psychoday/screens/DoctorDetails/components/doctor_detail_top_image.dart';

import '../../components/background.dart';
import '../../utils/responsive.dart';
import '../../utils/style.dart';
import '../Login/components/login_screen_top_image.dart';

class DoctorDetailsScreen extends StatelessWidget {

  const DoctorDetailsScreen({super.key});

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Responsive(
          mobile: const MobileLoginScreen(),
          desktop: Row(
            children: [
              const Expanded(
                child: DoctorScreenTopImage(),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(
                      width: 450,
                      child: DoctorDetailsForm(),
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
  const MobileLoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const DoctorScreenTopImage(),
        Row(
          children: const [
            Spacer(),
            Expanded(
              flex: 8,
              child: DoctorDetailsForm(),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }
}
