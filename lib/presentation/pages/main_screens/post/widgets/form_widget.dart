import 'package:flutter/material.dart';
import 'package:shoghlak/presentation/widgets/container_widget.dart';
import 'package:shoghlak/presentation/widgets/text_widget.dart';
import '../../../../../consts.dart';

class FormWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String? title;
  final int? maxLines;
  final TextInputType? textInputType;
  final FormFieldValidator<String>? validator;
  const FormWidget({
    Key? key,
    this.title,
    this.controller,
    this.maxLines,
    this.textInputType,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(txt: "$title", fontsize: 16),
        sizeVer(0.0121 * screenHeight),
        TextFormField(
          controller: controller,
          validator: validator,
          style: const TextStyle(color: primaryColor),
          decoration: const InputDecoration(
            border: InputBorder.none,
            labelStyle: TextStyle(
              color: primaryColor,
            ),
          ),
          minLines: 1,
          maxLines: maxLines ?? 12,
          keyboardType: textInputType,
        ),
        const ContainerWidget(
          width: double.infinity,
          height: 1,
          color: secondaryColor,
        )
      ],
    );
  }
}
