import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoghlak/presentation/cubits/credential/credential_cubit.dart';
import 'package:shoghlak/presentation/pages/credentials/sign_in_page.dart';
import 'package:shoghlak/presentation/widgets/container_widget.dart';
import 'package:shoghlak/presentation/widgets/text_widget.dart';

import '../../../consts.dart';
import '../../../on_generate_route.dart';
import '../../cubits/auth/auth_cubit.dart';
import '../../cubits/auth/auth_states.dart';
import '../../cubits/credential/credential_states.dart';
import '../../widgets/button_container_widget.dart';
import '../../widgets/circular_progress_indicator.dart';
import '../../widgets/form_container_widget.dart';
import '../main_screens/main_screen.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isSigningIn = false;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<CredentialCubit, CredentialStates>(
        listener: (context, credentialState) {
          if (credentialState is CredentialSuccess) {
            BlocProvider.of<AuthCubit>(context).loggedIn();
          }
          if (credentialState is CredentialFailure) {
            toast("Invalid email or password , please try again");
          }
        },
        builder: (context, credentialState) {
          if (credentialState is CredentialSuccess) {
            return BlocBuilder<AuthCubit, AuthStates>(
              builder: (context, authState) {
                if (authState is Authenticated) {
                  return MainScreen(uid: authState.uid);
                } else {
                  return _buildBody();
                }
              },
            );
          }
          return _buildBody();
        },
      ),
    );
  }

  void _signInUser() {
    setState(() {
      _isSigningIn = true;
    });
    BlocProvider.of<CredentialCubit>(context)
        .signInUser(
            email: _emailController.text, password: _passwordController.text)
        .then((value) => _clear());
  }

  _clear() {
    setState(() {
      _emailController.clear();
      _passwordController.clear();
      _isSigningIn = false;
    });
  }

  _buildBody() {
    return SafeArea(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 15),
            alignment: Alignment.topCenter,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/back_ground.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: const TextWidget(
              txt: "Shoghlk",
              fontWeight: FontWeight.w800,
              fontsize: 40,
            ),
          ),
          SingleChildScrollView(
            child: ContainerWidget(
              alignment: Alignment.center,
              width: double.infinity,
              height: 600,
              color: backGroundColor.withOpacity(0.3),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
              widget: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const ContainerWidget(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(left: 35),
                        widget: TextWidget(
                          txt: "Sign in",
                          fontsize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      sizeVer(30),
                      FormContainerWidget(
                        controller: _emailController,
                        hintText: "Email",
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Email field must not be empty";
                          }
                          if (!value.contains('@')) {
                            return "email must be written in a right way (example@gmail.com)";
                          }
                          return null;
                        },
                      ),
                      sizeVer(15),
                      FormContainerWidget(
                        controller: _passwordController,
                        hintText: "Password",
                        isPasswordField: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Password field must not be empty";
                          }
                          if (value.length < 8) {
                            return "password must be equal to or more than 8 characters";
                          }
                          return null;
                        },
                      ),
                      sizeVer(15),
                      ButtonContainerWidget(
                        color: blueColor,
                        text: "Sign In",
                        onTapListener: () {
                          if (_formKey.currentState!.validate()) {
                            _signInUser();
                          }
                        },
                      ),
                      sizeVer(15),
                      _isSigningIn == true
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const TextWidget(txt: "Please wait"),
                                sizeHor(10),
                                const CircularProgressIndicatorWidget(),
                              ],
                            )
                          : const ContainerWidget(width: 0, height: 0),
                      sizeVer(15),
                      const Divider(color: secondaryColor),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const TextWidget(
                            txt: "Don'\t have an account? ",
                            color: darkGreyColor,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamedAndRemoveUntil(context,
                                  ScreenName.signUpScreen, (route) => false);
                            },
                            child: const TextWidget(
                              txt: "Sign Up",
                              fontsize: 20,
                              fontWeight: FontWeight.bold,
                              color: tealColor,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
