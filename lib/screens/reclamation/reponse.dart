import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:psychoday/screens/dashboard/dashboard.dart';
import 'package:psychoday/utils/style.dart';
import 'package:http/http.dart' as http;
import '../../utils/constants.dart';

class ReponseReclamation extends StatefulWidget {
  String email;
  ReponseReclamation({super.key, required this.email});

  @override
  State<ReponseReclamation> createState() => _ReponseReclamationState();
}

class _ReponseReclamationState extends State<ReponseReclamation> {
  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  late String _message;

  void sendResponse() {
    print("send response method message $_message");
    print("send response method email ${widget.email}");
    //url
    Uri addUri = Uri.parse("$BASE_URL/reclamation/reponse");

    //data to send
    Map<String, dynamic> obj = {"email": widget.email, "text": _message};

    //data to send
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };


    http.post(addUri,headers:headers,body: json.encode(obj)).then((response)async {
      if(response.statusCode == 200){
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Success"),
              content: const Text("Response sended"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> const Dashboard(role: "admin",))),
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

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Response"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("Assets/email.png", width: 300, height: 300),
              Form(
                key: _keyForm,
                child:Column(
                  children: [
                    TextFormField(
                      readOnly: true,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      cursorColor: Style.primary,
                      decoration: InputDecoration(
                        hintText: widget.email,
                      ),
                    ),
                
                
                
                    const SizedBox(height: 20,),
                
                
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
                        sendResponse();
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
    );;
  }
}