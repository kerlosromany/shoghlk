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
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

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
            padding: EdgeInsets.all(0.02 * screenWidth),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TextWidget(
                      txt: "Description", fontWeight: FontWeight.bold),
                  sizeVer(0.01 * screenHeight),
                  ContainerWidget(
                    width: double.infinity,
                    padding: EdgeInsets.all(0.02 * screenWidth),
                    borderWidth: 2,
                    borderColor: backGroundColor,
                    widget: SelectableText("${post.description}",
                        style: const TextStyle(color: primaryColor)),
                  ),
                  sizeVer(20),
                  const TextWidget(txt: "Details", fontWeight: FontWeight.bold),
                  sizeVer(0.01 * screenHeight),
                  ContainerWidget(
                    width: double.infinity,
                    padding: EdgeInsets.all(0.02 * screenWidth),
                    borderWidth: 2,
                    borderColor: backGroundColor,
                    widget: SelectableText("${post.details}",
                        style: const TextStyle(color: primaryColor)),
                  ),
                  sizeVer(0.02 * screenHeight),
                  const TextWidget(
                      txt: "Phone number", fontWeight: FontWeight.bold),
                  sizeVer(0.01 * screenHeight),
                  ContainerWidget(
                    width: double.infinity,
                    padding: EdgeInsets.all(0.02 * screenWidth),
                    borderWidth: 2,
                    borderColor: backGroundColor,
                    widget: SelectableText("${post.phoneNo1}",
                        style: const TextStyle(color: primaryColor)),
                  ),
                  sizeVer(0.02 * screenHeight),
                  const TextWidget(
                      txt: "Phone number", fontWeight: FontWeight.bold),
                  sizeVer(0.01 * screenHeight),
                  ContainerWidget(
                    width: double.infinity,
                    padding: EdgeInsets.all(0.02 * screenWidth),
                    borderWidth: 2,
                    borderColor: backGroundColor,
                    widget: SelectableText("${post.phoneNo2}",
                        style: const TextStyle(color: primaryColor)),
                  ),
                  sizeVer(0.02 * screenHeight),
                  const TextWidget(
                      txt: "Communication Link", fontWeight: FontWeight.bold),
                  sizeVer(0.01 * screenHeight),
                  ContainerWidget(
                    width: double.infinity,
                    padding: EdgeInsets.all(0.02 * screenWidth),
                    borderWidth: 2,
                    borderColor: backGroundColor,
                    widget: SelectableText("${post.communicationLink}",
                        style: const TextStyle(color: primaryColor)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
