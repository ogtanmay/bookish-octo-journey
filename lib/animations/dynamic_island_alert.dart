import 'package:flutter/material.dart';

class DynamicIslandAlert extends StatelessWidget {
  const DynamicIslandAlert({super.key, required this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    final visible = message != null && message!.isNotEmpty;
    return AnimatedSlide(
      duration: const Duration(milliseconds: 280),
      offset: visible ? Offset.zero : const Offset(0, -1.2),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 220),
        opacity: visible ? 1 : 0,
        child: Container(
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.75),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Text(message ?? '', style: const TextStyle(fontSize: 12)),
        ),
      ),
    );
  }
}
