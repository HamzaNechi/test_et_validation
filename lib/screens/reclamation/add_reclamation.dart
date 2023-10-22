import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:psychoday/screens/Login/login_screen.dart';
import 'package:psychoday/utils/constants.dart';
import 'package:psychoday/utils/style.dart';
import 'package:http/http.dart' as http;


class AddReclamation extends StatefulWidget {
  const AddReclamation({super.key});

  @override
  State<AddReclamation> createState() => _AddReclamationState();
}

class _AddReclamationState extends State<AddReclamation> {

  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  late String _email;
  late String _message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Send email"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("Assets/images/login.jpg", width: 300, height: 300),
              Form(
                key: _keyForm,
                child:Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      cursorColor: Style.primary,
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
                      decoration: const InputDecoration(
                        hintText: "Your email",
                      ),
                    ),
                
                
                
                    SizedBox(height: 20,),
                
                
                    TextFormField(
                      textInputAction: TextInputAction.done,
                      maxLines: 10,
                      cursorColor: Style.primary,
                      onSaved: (String? value) {
                        _message = value!;
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Message can't be empty";
                        }
                      },
                      decoration: const InputDecoration(
                        hintText: "Your message",
                      ),
                    ),
        
        
                    SizedBox(height: 20,),
        
                    ElevatedButton(
                    onPressed: () {
                      if (_keyForm.currentState!.validate()) {
                        _keyForm.currentState!.save();
                        sendReclamation();
                      }
                    },
                    child: const Text(
                      "Send",
                      style: TextStyle(
                          color: Style.whiteColor,
                          fontFamily: 'Mark-Light',
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
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
  
  void sendReclamation() {
    //url
    Uri addUri = Uri.parse("$BASE_URL/reclamation");

    //data to send
    Map<String, dynamic> userObject = {"email": _email, "message": _message};

    //data to send
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };


    http.post(addUri,headers:headers,body: json.encode(userObject)).then((response)async {
      if(response.statusCode == 201){
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Success"),
              content: const Text("Reclamation sended"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> const LoginScreen())),
                    child: const Text("Dismiss"))
              ],
            );
          },
        );
      }else{
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text("Error status ${response.statusCode}"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Dismiss"))
              ],
            );
          },
        );
      }
    },);
  }
}