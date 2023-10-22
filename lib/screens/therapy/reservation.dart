import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psychoday/screens/therapy/reservation_model.dart';

class ReservationButton extends StatefulWidget {
  final Reservation reservation;

  ReservationButton({required this.reservation});

  @override
  _ReservationButtonState createState() => _ReservationButtonState();
}

class _ReservationButtonState extends State<ReservationButton> {
  late String _buttonText;

  @override
  void initState() {
    super.initState();
    _buttonText = (widget.reservation.status == "En attente") as String;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (widget.reservation.status == "accepter") {
          setState(() {
            widget.reservation.status = "En attente";
            _buttonText = 'Cancelled';
          });
        } else if (widget.reservation.status == "En attente") {
          // Handle case where user wants to rebook the reservation
          setState(() {
            widget.reservation.status = "accepter";
            _buttonText = 'Cancel Reservation';
          });
        }
      },
      child: Text(_buttonText),
    );
  }
}
