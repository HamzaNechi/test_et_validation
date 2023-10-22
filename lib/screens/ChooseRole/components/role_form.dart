import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:psychoday/screens/Login/login_screen.dart';
import 'package:psychoday/screens/testUser.dart';
import 'package:psychoday/utils/style.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../components/already_have_an_account_acheck.dart';
import '../../../utils/constants.dart';
import '../../Signup/components/or_divider.dart';
import '../../Signup/signup_screen.dart';

class RoleForm extends StatefulWidget {
  final GoogleSignInAccount user;
  const RoleForm({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<RoleForm> createState() => _RoleFormState();
}

class _RoleFormState extends State<RoleForm> {
  //var
  bool _isChecked = false;
  bool _isChecked2 = false;
  //String idUserConnected = '';
  late final String email = widget.user.email;

  String? _nicknameGoogle = "";
  late String? _role;

  final GlobalKey<FormState> _keyFormGoogle = GlobalKey<FormState>();
  //actions

  void updateGoogleUser() {
    //url
    Uri addUriUpdate = Uri.parse("$BASE_URL/user/editLoginGoogleUser/$email");

    //data to send
    Map<String, dynamic> userObjectUpdate = {
      "role": _role,
      "nickName": _nicknameGoogle,
    };

    //data to send
    Map<String, String> headersUpdate = {
      "Content-Type": "application/json",
    };

    //request
    http
        .post(addUriUpdate,
            headers: headersUpdate, body: json.encode(userObjectUpdate))
        .then((response) async {
      if (response.statusCode == 200) {
        // print("Response status: ${response.statusCode}");
        var jsonResponseRole = response.body;
        //print(jsonResponseRole);

        SharedPreferences.getInstance().then((sp) {
          sp.setString("nickName", json.decode(jsonResponseRole)['nickName']);
          sp.setString("role", json.decode(jsonResponseRole)['role']);
        });
       /* print(
            idUserConnected); */
        //Navigator.pushReplacementNamed(context, BottomNavScreen.routeName);
      } else if (response.statusCode == 401) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Information"),
              content: const Text("Email or password are incorrect!"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Dismiss"))
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Information"),
              content: const Text("Server error! Try again later"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Dismiss"))
              ],
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
   /* setState(() {
      SharedPreferences.getInstance().then((sp) {
        idUserConnected = sp.getString("email").toString();
      });
    });*/

    return Container(
      child: Column(
        children: [
          CheckboxListTile(
            value: _isChecked, //false
            onChanged: (newValue) {
              setState(() {
                _isChecked = newValue!;
                _isChecked2 = false;
                _role = "Doctor";
              });
            },
            title: const Text('Doctor',
                style: TextStyle(fontFamily: 'Mark-Light')),
          ),
          if (_isChecked)
            Row(
              children: [
                SizedBox(width: 12),
                const Text('Upload your own diploma',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Mark-Light',
                        color: Style.primaryLight)),
                SizedBox(width: 31),
                OutlinedButton(
                  onPressed: () {
                    // Respond to button press
                  },
                  child: const Text(
                    "BROWSE",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Style.primaryLight,
                        fontFamily: 'Mark-Light'),
                  ),
                ),
              ],
            ),
          CheckboxListTile(
            value: _isChecked2,
            onChanged: (newValue) {
              setState(() {
                _isChecked2 = newValue!;
                _isChecked = false;
                _role = "User";
              });
            },
            title: Text('User', style: TextStyle(fontFamily: 'Mark-Light')),
          ),
          if (_isChecked2)
            Form(
              key: _keyFormGoogle,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Enter your nickname',
                  border: OutlineInputBorder(),
                ),
                onSaved: (String? value) {
                  _nicknameGoogle = value;
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Nickname can't be empty";
                  } else {
                    return null;
                  }
                },
              ),
            ),
          const SizedBox(height: defaultPadding),
          ElevatedButton(
            onPressed: () {
              if (_isChecked2) {
                if (_keyFormGoogle.currentState!.validate()) {
                  _keyFormGoogle.currentState!.save();
                  updateGoogleUser();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                }
              } else {
                updateGoogleUser();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              }
            },
            child: Text(
              "NEXT".toUpperCase(),
              style: TextStyle(
                  fontFamily: 'Mark-Light',
                  fontWeight: FontWeight.bold,
                  fontSize: 17),
            ),
          ),
        ],
      ),
    );
  }
}
