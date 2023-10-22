import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../utils/constants.dart';
import '../../../utils/style.dart';
import '../../Login/login_screen.dart';

class ResetPasswordPage extends StatefulWidget {
  ResetPasswordPage({Key? key}) : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
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
      final response = await http.put(
        Uri.parse("$BASE_URL/user/edit_password"),
        body: <String, String>{
          'email': _emailController.text,
          'resetCode': _resetCodeController.text,
          'password': _passwordController.text,
        },
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        setState(() {
          _message = 'Password reset successfully.';
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return LoginScreen();
            },
          ),
        );
      } else {
        setState(() {
          _message = 'Failed to reset password. Please try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
        backgroundColor:  Style.primaryLight,
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
                        child: Image.asset("Assets/images/forget.png"),
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
                  TextFormField(
                    controller: _resetCodeController,
                    decoration: InputDecoration(labelText: 'Reset Code'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the reset code you received in your email.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'New Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a new password.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your new password.';
                      } else if (value != _passwordController.text) {
                        return 'Passwords do not match.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _resetPassword,
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : Text('Reset Password'),
                  ),
                  SizedBox(height: 20),
                  Text(
                    _message,
                    style: TextStyle(
                        // color: response.statusCode == 200 ? Colors.green : Colors.red,
                        ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}