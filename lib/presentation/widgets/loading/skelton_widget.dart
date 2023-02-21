import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shoghlak/presentation/widgets/container_widget.dart';

class SkeltonWidget extends StatelessWidget {
  final double? heigth;
  final double? width;
  final double? borderRadius;
  const SkeltonWidget({super.key, required this.heigth, required this.width, required this.borderRadius,});

  @override
  Widget build(BuildContext context) {
    return ContainerWidget(
      width: width,
      height: heigth,
      padding: const EdgeInsets.all(8.0),
      color: Colors.grey.withOpacity(0.4),
      borderRadius: BorderRadius.circular(borderRadius!),
    );
  }
}
