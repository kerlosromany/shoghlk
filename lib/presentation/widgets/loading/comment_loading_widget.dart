import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shoghlak/consts.dart';
import 'package:shoghlak/presentation/widgets/loading/skelton_widget.dart';

class CommentLoadingWidget extends StatelessWidget {
  const CommentLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SkeltonWidget(heigth: 50, width: 50, borderRadius: 50),
        sizeHor(10),
        Column(
          children: [
            const SkeltonWidget(heigth: 15, width: 60, borderRadius: 1),
            sizeVer(10),
            const SkeltonWidget(
                heigth: 100, width: 200, borderRadius: 1),
            sizeVer(20),
          ],
        ),
      ],
    );
  }
}
