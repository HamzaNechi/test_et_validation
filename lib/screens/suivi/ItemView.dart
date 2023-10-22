import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemMood {
  final String id;
  final String title;
  final Image image;
  final Color imgColor;

  ItemMood({required this.id, required this.title, required this.image, required this.imgColor});
}

class ItemView extends StatelessWidget {
  final ItemMood item;

  const ItemView({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final fontSize = constraints.maxWidth * 0.2;
        final imageWidth = constraints.maxWidth * 0.6;

        return Container(
          height: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            item.image,
              SizedBox(height: 5),
              Text(
                item.title,
                style: TextStyle(
                  fontSize: fontSize > 28 ? 28 : fontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.9),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
