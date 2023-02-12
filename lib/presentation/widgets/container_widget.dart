// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shoghlak/presentation/widgets/text_widget.dart';

class ContainerWidget extends StatelessWidget {
  final Alignment? alignment;
  final double? width;
  final double? height;
  final Color? color;
  final double? borderWidth;
  final Color? borderColor;
  final BorderRadiusGeometry? borderRadius;
  final Widget? widget;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BoxShape? boxShape;
  final VoidCallback? onTapListener;

  const ContainerWidget({
    Key? key,
    this.alignment,
    this.width,
    this.height,
    this.color,
    this.borderWidth,
    this.borderColor,
    this.borderRadius,
    this.widget,
    this.padding,
    this.boxShape,
    this.onTapListener,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapListener,
      child: Container(
        padding: padding,
        margin: margin,
        alignment: alignment,
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: borderColor ?? const Color(0xFF000000),
            width: borderWidth ?? 0.0,
          ),
          borderRadius: borderRadius,
          shape: boxShape ?? BoxShape.rectangle,
        ),
        child: widget ?? const TextWidget(txt: ""),
      ),
    );
  }
}
