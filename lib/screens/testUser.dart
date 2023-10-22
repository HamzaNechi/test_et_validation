import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:psychoday/screens/Login/components/google_sign_in_api.dart';
import 'package:psychoday/screens/Signup/signup_screen.dart';

class testUser extends StatefulWidget {
  static const routeName = "/userTestPage";
  //var
  final GoogleSignInAccount user;

  const testUser({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<testUser> createState() => _testUserState();
}

class _testUserState extends State<testUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Page'),
        actions: [
          TextButton(
            child: const Text('Log out', style: TextStyle(color: Colors.white)),
            onPressed: () async {
              await GoogleSignInApi.logout();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => SignUpScreen(),
              ));
            },
          ),
        ],
      ),
      body: Center(child: Text("Email : ${widget.user.email}")),
    );
  }
}
