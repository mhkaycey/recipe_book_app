import 'package:flutter/material.dart';

class SimpleBadge extends StatelessWidget {
  final Widget child;
  final String? value;
  final Color color;
  final Color textColor;
  final double size;
  final bool showBadge;

  const SimpleBadge({
    super.key,
    required this.child,
    this.value,
    this.color = Colors.red,
    this.textColor = Colors.white,
    this.size = 18.0,
    this.showBadge = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (showBadge && (value != null && value!.isNotEmpty))
          Positioned(
            right: -4,
            top: -4,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                // borderRadius: BorderRadius.circular(size / 2),
                border: Border.all(color: Colors.white, width: 1),
              ),
              constraints: BoxConstraints(minWidth: size, minHeight: size),
              child: Text(
                value!,
                style: TextStyle(
                  color: textColor,
                  fontSize: size * 0.6,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        // Simple dot badge (when value is null but showBadge is true)
        if (showBadge && (value == null || value!.isEmpty))
          Positioned(
            right: 2,
            top: 2,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1),
              ),
            ),
          ),
      ],
    );
  }
}
