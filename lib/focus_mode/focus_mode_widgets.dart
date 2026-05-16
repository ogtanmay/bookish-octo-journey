import 'package:flutter/material.dart';

class FocusStateBanner extends StatelessWidget {
  const FocusStateBanner({super.key, required this.enabled});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: enabled ? Colors.white.withOpacity(0.14) : Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Text(
        enabled
            ? 'Grind Mode ON • grayscale • minimal notifications • ambient audio'
            : 'Normal Mode • adaptive dashboard widgets',
        style: const TextStyle(color: Color(0xFFDCE3F4)),
      ),
    );
  }
}
