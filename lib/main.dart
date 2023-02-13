import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoghlak/domin/entities/post/post_entity.dart';
import 'package:shoghlak/presentation/cubits/auth/auth_cubit.dart';
import 'package:shoghlak/presentation/cubits/auth/auth_states.dart';
import 'package:shoghlak/presentation/cubits/bloc_observer.dart';
import 'package:shoghlak/presentation/cubits/credential/credential_cubit.dart';
import 'package:shoghlak/presentation/cubits/post/post_cubit.dart';
import 'package:shoghlak/presentation/cubits/ui/ui_cubit.dart';
import 'package:shoghlak/presentation/cubits/user/get_single_user/get_single_user_cubit.dart';
import 'package:shoghlak/presentation/cubits/user/user_cubit.dart';
import 'package:shoghlak/presentation/pages/credentials/sign_in_page.dart';
import 'package:shoghlak/presentation/pages/credentials/sign_up_page.dart';
import 'package:shoghlak/presentation/pages/main_screens/main_screen.dart';

import 'on_generate_route.dart';
import 'injection_container.dart' as di;
import 'presentation/cubits/comment/comment_cubit.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await Firebase.initializeApp();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthCubit>()..appStarted(context)),
        BlocProvider(create: (_) => di.sl<CredentialCubit>()),
        BlocProvider(create: (_) => di.sl<UserCubit>()),
        BlocProvider(create: (_) => di.sl<GetSingleUserCubit>()),
        BlocProvider(create: (context) => di.sl<PostCubit>()..getPosts(post: PostEntity()),),
        
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Instagram Clone",
        darkTheme: ThemeData.dark(),
        onGenerateRoute: OnGenerateRoute.route,
        initialRoute: '/',
        routes: {
          '/': (context) {
            //return SignUpPage();
            return BlocBuilder<AuthCubit, AuthStates>(
              builder: (context, authState) {
                if (authState is Authenticated) {
                  return MainScreen(uid: authState.uid);
                } else {
                  return const SignInPage();
                }
              },
            );
          },
        },
      ),
    );
  }
}
