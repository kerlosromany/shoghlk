import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shoghlak/consts.dart';
import 'package:shoghlak/presentation/widgets/container_widget.dart';
import 'package:shoghlak/presentation/widgets/text_widget.dart';

import '../../../../domin/entities/post/post_entity.dart';

class PostDetailsScreen extends StatelessWidget {
  final PostEntity post;
  const PostDetailsScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/back_ground.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TextWidget(
                    txt: "Description", fontWeight: FontWeight.bold),
                sizeVer(10),
                ContainerWidget(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10.0),
                  borderWidth: 2,
                  borderColor: backGroundColor,
                  widget: SelectableText("${post.description}"),
                ),
                sizeVer(20),
                const TextWidget(txt: "Details", fontWeight: FontWeight.bold),
                sizeVer(10),
                ContainerWidget(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10.0),
                  borderWidth: 2,
                  borderColor: backGroundColor,
                  widget: SelectableText("${post.details}"),
                ),
                sizeVer(20),
                const TextWidget(
                    txt: "Phone number", fontWeight: FontWeight.bold),
                sizeVer(10),
                ContainerWidget(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10.0),
                  borderWidth: 2,
                  borderColor: backGroundColor,
                  widget: SelectableText("${post.phoneNo1}"),
                ),
                sizeVer(20),
                const TextWidget(
                    txt: "Phone number", fontWeight: FontWeight.bold),
                sizeVer(10),
                ContainerWidget(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10.0),
                  borderWidth: 2,
                  borderColor: backGroundColor,
                  widget: SelectableText("${post.phoneNo2}"),
                ),
                sizeVer(20),
                const TextWidget(
                    txt: "Communication Link", fontWeight: FontWeight.bold),
                sizeVer(10),
                ContainerWidget(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10.0),
                  borderWidth: 2,
                  borderColor: backGroundColor,
                  widget: SelectableText("${post.communicationLink}"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
