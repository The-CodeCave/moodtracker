import 'package:flutter/material.dart';

class LoadingIcon extends StatelessWidget {
  final Widget? icon;
  final double _strokeWidth = 2.0;

  final Color color;
  final double size;

  const LoadingIcon({
    required this.size,
    required this.color,
    this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return icon ??
        Center(
          child: SizedBox.square(
            dimension: size,
            child: CircularProgressIndicator(
              color: color,
              strokeWidth: _strokeWidth,
            ),
          ),
        );
  }
}
