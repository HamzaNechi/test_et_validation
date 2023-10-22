import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:psychoday/models/user.dart';
import 'package:psychoday/screens/ChooseRole/role_screen.dart';
import 'package:psychoday/screens/DoctorDetails/doctor_detail_screen.dart';
import 'package:psychoday/screens/Signup/components/verification_email.dart';
import 'package:psychoday/screens/dashboard/dashboard.dart';
import 'package:psychoday/screens/testUser.dart';
import 'package:psychoday/utils/style.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../components/already_have_an_account_acheck.dart';
import '../../../utils/constants.dart';
import '../../Signup/components/or_divider.dart';
import '../../Signup/signup_screen.dart';
import 'google_sign_in_api.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  //var
  late final GoogleSignInAccount user;
  late String _email;
  late String _password;
  late String _nickname;
  late String _fullname;
  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  //actions
  void signinAction() {
    print("sign in action start");
    //url
    Uri addUri = Uri.parse("$BASE_URL/user/login");

    //data to send
    Map<String, dynamic> userObject = {"email": _email, "password": _password};

    //data to send
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    //request
    http
        .post(addUri, headers: headers, body: json.encode(userObject))
        .then((response) async {
      if (response.statusCode == 200) {
        var jsonResponse = response.body;
        print('response json = $jsonResponse');
        Map<String, dynamic> jsonMap = json.decode(jsonResponse);
        User user=User.fromJson(jsonMap);
        printInShared(user);
        // Navigator.of(context).pushReplacement(
        //       MaterialPageRoute(builder: (context) => Dashboard(role: user.role!)));
        if(user.role! == 'doctor'){
          print("user address ${user.address!}");
          if(user.address! == " "){
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => DoctorDetailsScreen()));
          }else{
            Navigator.of(context).pushReplacement(
               MaterialPageRoute(builder: (context) => Dashboard(role: user.role!)));
          }
          
        }else{
          Navigator.of(context).pushReplacement(
               MaterialPageRoute(builder: (context) => Dashboard(role: user.role!)));
        }
        
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

  Future signInGoogle() async {
    final user = await GoogleSignInApi.login();
    if (user == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Sign in Failed')));
    } else {
      //url
      Uri addUriGoogle = Uri.parse("$BASE_URL/user/loginGoogle");

      //data to send
      Map<String, dynamic> userObjectGoogle = {
        "email": user.email,
        "role": "",
        "nickName": "",
        "fullName": user.displayName
      };

      //data to send
      Map<String, String> headersGoogle = {
        "Content-Type": "application/json",
      };

      //request
      await http
          .post(addUriGoogle,
              headers: headersGoogle, body: json.encode(userObjectGoogle))
          .then((response) async {
        if (response.statusCode == 200) {
          var jsonResponseGoogle =jsonEncode(response.body) ;
           print(jsonResponseGoogle);

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const Dashboard(role: 'user')));

         /* Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => RoleScreen(user: user)));*/
          //Navigator.pushReplacementNamed(context, BottomNavScreen.routeName);
        } else if (response.statusCode == 403) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _keyForm,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (String? value) {
              _email = value!;
            },
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return "Email can't be empty";
              } else if (!(EmailValidator.validate(value))) {
                return "Unvalid Email !";
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              hintText: "Your email",
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, defaultPadding, 0, 5),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              onSaved: (String? value) {
                _password = value!;
              },
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Password cant be empty!";
                } else if (value.length < 5) {
                  return "Password must have at least 5 caracteres!";
                } else {
                  return null;
                }
              },
              decoration: const InputDecoration(
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          //const SizedBox(height: 2,),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                     Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Reset();
                  },
                ),
              );
                  },
                  child: const Text("Forget password ?", style: TextStyle(color: Style.primary,fontWeight: FontWeight.w700),),
                )
              ],
            ),
          ),
          const SizedBox(height: 30),
          Hero(
            tag: "login_btn",
            child: ElevatedButton(
              onPressed: () {
                print("login button");
                if (_keyForm.currentState!.validate()) {
                  _keyForm.currentState!.save();
                  signinAction();
                }
              },
              child: const Text(
                "Login",
                style: TextStyle(
                    color: Style.whiteColor,
                    fontFamily: 'Mark-Light',
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SignUpScreen();
                  },
                ),
              );
            },
          ),
          const SizedBox(height: defaultPadding),
          // const OrDivider(),
          // FloatingActionButton.extended(
          //   onPressed: signInGoogle,
          //   icon: Image.asset(
          //     'Assets/google_logo.png',
          //     height: 30,
          //     width: 30,
          //   ),
          //   label: Text('Sign in with Google'),
          //   backgroundColor: Colors.white,
          //   foregroundColor: Colors.black,
          // ),
        ],
      ),
    );
  }
  
  void printInShared(user) async {
    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('_id', user.id);
    await prefs.setString('email', user.email);
    await prefs.setString('role', user.role);
    await prefs.setString('fullname', user.fullName);    
  }
}
