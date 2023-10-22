import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class CircleButton extends StatelessWidget {
  final IconData icon;
  final Color bgcolor;
  final Color iconColor;
  final VoidCallback onPressed;
  const CircleButton({super.key,required this.icon,required this.bgcolor,required this.iconColor,required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bgcolor,
      ),
      child: Icon(
        icon,
        color: iconColor,
      ),
    );
  }
}