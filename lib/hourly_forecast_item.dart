import 'dart:ui';
import 'package:flutter/material.dart';

class HourlyForecastItem extends StatelessWidget {
  final String time;
  final String temperature;
  final IconData icon;

  const HourlyForecastItem({
    super.key,
    required this.time,
    required this.temperature,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            width: 100,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2), // translucent white
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // ensure readability
                  ),
                ),
                const SizedBox(height: 8),
                Icon(
                  icon,
                  size: 32,
                  color: Colors.black,
                ),
                const SizedBox(height: 8),
                Text(
                  "$temperature°C",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
