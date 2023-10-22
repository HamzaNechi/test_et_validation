import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../utils/constants.dart';

class UserCard extends StatefulWidget {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String nickname;
  final String specialty;
  final String address;
  final String assurance;

  const UserCard({
    Key? key,
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.nickname,
    required this.specialty,
    required this.address,
    required this.assurance,
  }) : super(key: key);

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  bool _expanded = false;
  Future<void> _deleteDoctor(String id) async {
    try {
      final response =
          await http.delete(Uri.parse('$BASE_URL/user/delete/$id'));

      if (response.statusCode == 200) {
      } else {
        throw Exception('Failed to delete doctor');
      }
    } catch (error) {
      print('Error deleting doctor: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: Colors.grey, width: 1),
        ),
        child: InkWell(
          onTap: () {
            setState(() {
              _expanded = !_expanded;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    widget.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 8),
                if (_expanded)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email: ${widget.email}'),
                      Text('Phone Number: ${widget.phoneNumber}'),
                      Text('certificate: ${widget.nickname}'),
                      Text('Specialty: ${widget.specialty}'),
                      Text('Address: ${widget.address}'),
                      Text('Assurance: ${widget.assurance}'),
                      SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(width: 1, color: Colors.white),
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            // handle delete user action
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.red,
                            side: BorderSide(width: 0.25, color: Colors.black),
                          ),
                          child: Text('Delete'),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
