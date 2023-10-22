import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:psychoday/utils/style.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon:const Icon(
          Icons.search,
          color: Style.secondLight,
          size: 26,
        ),

        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelText: "Search your report ?",
        labelStyle: const TextStyle(color: Style.secondLight),
        fillColor: Style.whiteColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40)
        ),
        isDense: true

      ),
    );
  }
}