import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoghlak/domin/entities/user/user_entity.dart';
import 'package:shoghlak/presentation/cubits/auth/auth_cubit.dart';
import 'package:shoghlak/presentation/cubits/auth/auth_states.dart';
import 'package:shoghlak/presentation/cubits/credential/credential_cubit.dart';
import 'package:shoghlak/presentation/cubits/credential/credential_states.dart';
import 'package:shoghlak/presentation/pages/credentials/sign_in_page.dart';
import 'package:shoghlak/presentation/pages/main_screens/main_screen.dart';
import 'package:shoghlak/presentation/pages/main_screens/profile/widgets/profile_widget.dart';
import 'package:shoghlak/presentation/widgets/container_widget.dart';
import 'package:shoghlak/presentation/widgets/icon_widget.dart';
import 'package:shoghlak/presentation/widgets/text_widget.dart';

import '../../../consts.dart';
import '../../../data/data_sources/local_data_source/cache_helper.dart';
import '../../../on_generate_route.dart';
import '../../widgets/button_container_widget.dart';
import '../../widgets/circular_progress_indicator.dart';
import '../../widgets/form_container_widget.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isSigningUp = false;

  File? _image;
  Future selectImage() async {
    try {
      final pickedImage =
          await ImagePicker.platform.getImage(source: ImageSource.gallery);
      setState(() {
        if (pickedImage != null) {
          _image = File(pickedImage.path);
        } else {
          toast("no image selected");
        }
      });
    } catch (_) {
      toast("some errors occured , try again");
    }
  }

  @override
  void dispose() {
    _bioController.dispose();
    _userNameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
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
                  CacheHelper.saveData(key: "token", value: authState.uid);
                  return MainScreen(uid: authState.uid);
                } else {
                  return _buildBody(
                      screenHeight: screenHeight, screenWidth: screenWidth);
                }
              },
            );
          }
          return _buildBody(
              screenHeight: screenHeight, screenWidth: screenWidth);
        },
      ),
    );
  }

  void _signUpUser() {
    setState(() {
      _isSigningUp = true;
    });
    BlocProvider.of<CredentialCubit>(context)
        .signUpUser(
          user: UserEntity(
            email: _emailController.text,
            bio: _bioController.text,
            password: _passwordController.text,
            confirmPassword: _confirmPasswordController.text,
            username: _userNameController.text,
            followers: const [],
            following: const [],
            name: "",
            profileUrl: "",
            totalFollowers: 0,
            totalFollowing: 0,
            totalPosts: 0,
            website: "",
            imageFile: _image,
          ),
        )
        .then((value) => _clear());
  }

  _clear() {
    setState(() {
      // _bioController.clear();
      // _confirmPasswordController.clear();
      // _emailController.clear();
      // _passwordController.clear();
      // _userNameController.clear();
      _isSigningUp = false;
    });
  }

  _buildBody({required double screenHeight, required double screenWidth}) {
    return SafeArea(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            padding: EdgeInsets.only(top: 0.038 * screenWidth),
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
              height: 0.72 * screenHeight,
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
                      ContainerWidget(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(left: 0.089 * screenWidth),
                        widget: const TextWidget(
                          txt: "Sign up",
                          fontsize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      sizeVer(0.036 * screenHeight),
                      Center(
                        child: Stack(
                          children: [
                            ContainerWidget(
                              width: 0.178 * screenWidth,
                              height: 0.0848 * screenHeight,
                              borderRadius: BorderRadius.circular(30),
                              widget: ClipRRect(
                                  borderRadius: BorderRadius.circular(40),
                                  child: ProfileWidget(imageFile: _image)),
                            ),
                            Positioned(
                              right: -10,
                              bottom: -15,
                              child: IconButton(
                                onPressed: selectImage,
                                icon: const IconWidget(
                                  icon: Icons.add_a_photo,
                                  color: blueColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      sizeVer(0.036 * screenHeight),
                      FormContainerWidget(
                        controller: _userNameController,
                        hintText: "User name",
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "User name field must not be empty";
                          }
                          return null;
                        },
                      ),
                      sizeVer(0.018 * screenHeight),
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
                      sizeVer(0.036 * screenHeight),
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
                      sizeVer(0.036 * screenHeight),
                      FormContainerWidget(
                        controller: _confirmPasswordController,
                        hintText: "Confirm Password",
                        isPasswordField: true,
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return "Confirm Password doesn\'t match password";
                          }
                          return null;
                        },
                      ),
                      sizeVer(0.036 * screenHeight),
                      FormContainerWidget(
                        controller: _bioController,
                        hintText: "Bio",
                      ),
                      sizeVer(0.036 * screenHeight),
                      const ContainerWidget(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 35),
                        widget: TextWidget(
                          txt: "(Optional)",
                          fontsize: 10,
                          color: secondaryColor,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      sizeVer(0.036 * screenHeight),
                      ButtonContainerWidget(
                        color: blueColor,
                        text: "Sign Up",
                        onTapListener: () {
                          if (_formKey.currentState!.validate()) {
                            _signUpUser();
                          }
                        },
                      ),
                      sizeVer(0.036 * screenHeight),
                      _isSigningUp == true
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const TextWidget(txt: "Please wait"),
                                sizeHor(10),
                                const CircularProgressIndicatorWidget(),
                              ],
                            )
                          : const ContainerWidget(width: 0, height: 0),
                      sizeVer(0.036 * screenHeight),
                      const Divider(color: secondaryColor),
                      FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const TextWidget(
                              txt: "Already have an account? ",
                              color: darkGreyColor,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamedAndRemoveUntil(context,
                                    ScreenName.signInScreen, (route) => false);
                              },
                              child: const TextWidget(
                                txt: "Sign In",
                                fontsize: 20,
                                fontWeight: FontWeight.bold,
                                color: tealColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      sizeVer(0.018 * screenHeight),
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
