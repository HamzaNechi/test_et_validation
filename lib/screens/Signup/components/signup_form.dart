import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psychoday/screens/Signup/components/verification_diplome.dart';
import 'package:psychoday/utils/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../utils/constants.dart';
import '../../Login/login_screen.dart';
import 'package:http/http.dart' as http;

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    Key? key,
    
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignUpForm> {
  late String _fullname;
  late String _nickname;
  late String isDoctor;
  late String _email;
  late String _password;
  late String phone;
  String role='user';
  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  //variable for verification diploma
  String isDocVerif = '';
  String spec="";
  bool switchValue=false;
  String path="";
  
  //actions
  void signupAction() async{
    if(switchValue){
      setState(() {
        role='doctor';
      });
    }

    if(isDocVerif == 'oui'){
      /***Multipartform */
      var request = http.MultipartRequest(
        'POST', Uri.parse("$BASE_URL/user/signup"));
        request.fields['fullName'] = _fullname;
        request.fields['nickName'] = _nickname;
        request.fields['email'] = _email;
        request.fields['password'] = _password;
        request.fields['phone'] = 'test';
        request.fields['speciality'] = spec;
        request.fields['address'] = 'test';
        request.fields['role'] = role;
        request.files.add(await http.MultipartFile.fromPath(
        'certificate', path));

        var response = await request.send();
        print(response.statusCode);
        if(response.statusCode == 201){
           Navigator.push(context,
              MaterialPageRoute(
                builder: (context) {
                  return LoginScreen();
                },
              ),
            );
        }else if (response.statusCode == 401) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Information"),
              content: const Text("Username et/ou mot de passe incorrect!"),
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
      /***End multipartform */
    }else{

      /****** add user sans image diplome */

      // //url
    Uri addUri = Uri.parse("$BASE_URL/user/signup");
    print("url = ${addUri.toString()}");
    //data to send
    Map<String, dynamic> userObject = {
      "fullName": _fullname,
      "nickName": _nickname,
      "email": _email,
      "password": _password,
      "phone":"test",
      "speciality":spec,
      "address":"test",
      "role":role,
    };

    //data to send
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };
    http
        .post(addUri, headers: headers, body: json.encode(userObject))
        .then((response) {
      if (response.statusCode == 201) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return LoginScreen();
            },
          ),
        );
      } else if (response.statusCode == 401) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Information"),
              content: const Text("Username et/ou mot de passe incorrect!"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Dismiss"))
              ],
            );
          },
        );
      } else {
        print(response.body);
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

      /******* add user */

    }
  }

  //get variable from verification diplom
  String validateDoctorError='please validate your diploma';
  bool errorDiploma=false;
  String nameDoctor=''; //test with jean martin

  void updateisDocVerif(String isdoc) {
    setState(() {
      isDocVerif = isdoc;
      print('sign up form is doctor : $isDocVerif');
    });
  }


  void pathDiplome(String p) {
    setState(() {
      path = p;
      print('path image diplome : $path');
    });
  }


  void updateSpecialite(String s) {
    setState(() {
      spec = s;
    });
  }
  //end

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _keyForm,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              onSaved: (String? value) {
                _fullname = value!;
              },
              onChanged: (value) {
                setState(() {
                  nameDoctor=value;
                });
                
              },
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Le username ne doit pas etre vide";
                } else if (value.length < 5) {
                  return "Le username doit avoir au moins 5 caractères";
                } else {
                  return null;
                }
              },
              decoration: const InputDecoration(
                hintText: "Your fullname",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.person),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              onSaved: (String? value) {
                _email = value!;
              },
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "L'email' ne doit pas etre vide";
                } else {
                  return null;
                }
              },
              decoration: const InputDecoration(
                hintText: "Your email",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.mail),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              onSaved: (String? value) {
                _nickname = value!;
              },
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Le nickname' ne doit pas etre vide";
                } else if (value.length < 5) {
                  return "Le nickname doit avoir au moins 5 caractères";
                } else {
                  return null;
                }
              },
              decoration: const InputDecoration(
                hintText: "Your nickName",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.person),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.phone,
              cursorColor: kPrimaryColor,
              onSaved: (String? value) {
                _nickname = value!;
              },
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Le numero' ne doit pas etre vide";
                } else {
                  return null;
                }
              },
              decoration: const InputDecoration(
                hintText: "Your phone",
                prefixIcon: Padding(
                  padding:EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.phone),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              cursorColor: kPrimaryColor,
              onSaved: (String? value) {
                _password = value!;
              },
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Le mot de passe ne doit pas etre vide";
                } else if (value.length < 5) {
                  return "Le mot de passe doit avoir au moins 5 caractères";
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
          
          //doctor verification
          

          Column(
            children: [
              Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("sign up as a doctor ?",
                      style: TextStyle(color: Style.primaryLight,fontFamily: 'Mark-Light',fontSize: 18),
                    ),
                    Transform.scale(
                      scale: 0.8,
                      child: CupertinoSwitch(
                          // This bool value toggles the switch.
                          value: switchValue,
                          activeColor: Style.primaryLight,
                          onChanged: (bool? value) {
                            
                            // This is called when the user toggles the switch.
                            setState(() {
                              switchValue = value ?? false;
                            });
                          },
                        ),
                    ),
              
              
                      
                  ],
                ),
              ),


              Visibility(
                        visible: switchValue,
                        child:Diplome(updateisDocVerif,updateSpecialite,pathDiplome,nameDoctor),
                      ),

              Visibility(
                visible: errorDiploma,
                child:Text(validateDoctorError,style: const TextStyle(color: Colors.red),)),
            ],
          ),


          const SizedBox(height: defaultPadding / 2),
          //end doctor verification
          ElevatedButton(
            onPressed: () {
              if(switchValue){

                if (_keyForm.currentState!.validate() && isDocVerif=="oui") {
                  _keyForm.currentState!.save();
                  signupAction();
                }else{
                  setState(() {
                    errorDiploma=true;
                  });
                  print('error doctor');
                }

              }else{
                if(_keyForm.currentState!.validate()){
                  _keyForm.currentState!.save();
                  signupAction();
                }else{
                  print('form not validate');
                }
              }
              
            },
            child: Text(
              "Sign Up".toUpperCase(),
              style: const TextStyle(
                  fontFamily: 'Mark-Light',
                  fontWeight: FontWeight.bold,
                  fontSize: 17),
            ),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
