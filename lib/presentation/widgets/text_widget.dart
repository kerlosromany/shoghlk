import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shoghlak/consts.dart';

class TextWidget extends StatelessWidget {
  final String? txt;
  final Color? color;
  final double? fontsize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;

  const TextWidget({super.key, this.color, this.fontsize, this.txt , this.fontWeight , this.textAlign,});

  @override
  Widget build(BuildContext context) {
    return Text(
      txt!,
      style: TextStyle(
        color: color ?? primaryColor,
        fontSize: fontsize ?? 16,
        fontWeight: fontWeight ?? FontWeight.normal,
        
      ),
      textAlign: textAlign,
      
    );
  }
}
