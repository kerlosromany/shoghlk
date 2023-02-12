import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoghlak/presentation/cubits/post/post_cubit.dart';
import 'package:shoghlak/presentation/pages/main_screens/search/widgets/search_main_widget.dart';
import 'package:shoghlak/injection_container.dart' as di;

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostCubit>(
      create: (context) => di.sl<PostCubit>(),
      child: const SearchMainWidget(),
    );
  }
}
