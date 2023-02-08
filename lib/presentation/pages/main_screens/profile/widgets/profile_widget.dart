import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shoghlak/presentation/widgets/circular_progress_indicator.dart';

class ProfileWidget extends StatelessWidget {
  final String? imageUrl;
  final File? imageFile;
  const ProfileWidget({super.key, this.imageFile, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (imageFile == null) {
      if (imageUrl == "" || imageUrl == null) {
        return Image.asset('assets/default_profile.png', fit: BoxFit.cover);
      } else {
        return CachedNetworkImage(
          imageUrl: "$imageUrl",
          fit: BoxFit.cover,
          progressIndicatorBuilder: (context, url, progress) {
            return const CircularProgressIndicatorWidget();
          },
        );
      }
    } else {
      return Image.file(imageFile!, fit: BoxFit.cover);
    }
  }
}
