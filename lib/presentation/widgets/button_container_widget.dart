import 'package:flutter/material.dart';
import 'package:shoghlak/presentation/widgets/text_widget.dart';
import '../../../consts.dart';

class ButtonContainerWidget extends StatelessWidget {
  final Color? color;
  final Color? color2;
  final String? text;
  final VoidCallback? onTapListener;
  final double? width;
  final double? height;
  const ButtonContainerWidget({
    Key? key,
    this.color,
    this.text,
    this.onTapListener,
    this.color2,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: onTapListener,
      child: Container(
        width: width ?? 0.76 * screenWidth,
        height: height ?? 0.06 * screenHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color ?? Colors.blueAccent.withOpacity(0.4),
              color2 ?? Colors.pinkAccent.withOpacity(0.4),
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: FittedBox(
            child: TextWidget(
              txt: "$text",
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
