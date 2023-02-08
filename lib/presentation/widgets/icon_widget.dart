import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shoghlak/consts.dart';

class IconWidget extends StatelessWidget {
  final Color? color;
  final IconData? icon;
  final double? size;
  const IconWidget({
    super.key,
    this.color,
    this.size,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: color ?? primaryColor,
      size: size,
    );
  }
}
