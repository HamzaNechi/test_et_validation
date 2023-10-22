import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:psychoday/components/continue.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../utils/constants.dart';
import '../../../utils/style.dart';

class SendEmail extends StatefulWidget {
  SendEmail({Key? key}) : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<SendEmail> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _resetCodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  String _message = '';

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final response = await http.post(
        Uri.parse("$BASE_URL/user/send"),
        body: {
          'email': _emailController.text,
        },
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        setState(() {
          _message = 'email sent successfully.';
        });
      } else {
        setState(() {
          _message = 'Failed to send email. Please try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send email'),
        backgroundColor: Style.primaryLight,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: defaultPadding * 2),
                  Row(
                    children: [
                      const Spacer(),
                      Expanded(
                        flex: 8,
                        child: Image.asset("Assets/images/email.png"),
                      ),
                      const Spacer(),
                    ],
                  ),
                  SizedBox(height: defaultPadding * 2),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _resetPassword,
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : Text('send your email'),
                  ),
                  SizedBox(height: 20),
                  Text(
                    _message,
                    style: TextStyle(
                        // color: response.statusCode == 200 ? Colors.green : Colors.red,
                        ),
                  ),
                  Continue(
                    login: false,
                    press: () {
                   
                    },
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
