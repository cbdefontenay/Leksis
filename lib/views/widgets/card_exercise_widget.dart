import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardExerciseWidget extends StatelessWidget {
  final IconData icon;
  final String name;
  final Color iconColor;
  final Color color;
  final Color backgroundColor;
  final VoidCallback onTap;

  const CardExerciseWidget({
    super.key,
    required this.icon,
    required this.name,
    required this.iconColor,
    required this.backgroundColor,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
          child: Card(
            color: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(icon, size: 32, color: iconColor),
                  SizedBox(width: 12),
                  Text(
                    name,
                    style: GoogleFonts.firaSans(
                      fontSize: 19,
                      fontWeight: FontWeight.w500,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
