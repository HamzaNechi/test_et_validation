import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:psychoday/utils/style.dart';

class MoodCard extends StatelessWidget {
  final ValueChanged<double> onSliderChange;
  final String title;
  final double sliderValue;

  MoodCard({
    required this.title,
    required this.sliderValue,
    required this.onSliderChange,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 320,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(50),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Style.marron),
                  ),
                
                SizedBox(height: 16),
                Column(
                  children: [
                    Text("Current Slider Value: ${sliderValue.toInt()}"),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 8,
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 14),
                        overlayShape:
                            RoundSliderOverlayShape(overlayRadius: 28),
                        activeTrackColor: Style.second,
                        inactiveTrackColor:Style.marron,
                        thumbColor: Colors.white,
                        overlayColor: Style.second,
                      ),
                      child: Slider(
                        value: sliderValue,
                        min: 0,
                        max: 5,
                        onChanged: onSliderChange,
                        label: 'Slider',
                        divisions: 5,
                        semanticFormatterCallback: (double value) =>
                            '${value.round()}',
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
