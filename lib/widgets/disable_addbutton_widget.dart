import 'package:flutter/material.dart';

class DisabledCircleButton extends StatelessWidget {
  final IconData icon;
  final double radius;
  final double iconSize;

  const DisabledCircleButton({
    super.key,
    required this.icon,
    this.radius = 14,
    this.iconSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: null, // ✅ Completely disables tap
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey.shade400, // ✅ disabled look
        child: Icon(
          icon,
          size: iconSize,
          color: Colors.white70,
        ),
      ),
    );
  }
}
