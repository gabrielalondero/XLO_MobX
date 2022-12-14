import 'package:flutter/material.dart';

class BarButton extends StatelessWidget {
  const BarButton({super.key, required this.decoration, required this.label, required this.onTap});

  final String label;
  final BoxDecoration decoration;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: decoration,
          alignment: Alignment.center,
          height: 52,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
