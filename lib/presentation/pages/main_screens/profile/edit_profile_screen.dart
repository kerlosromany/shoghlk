import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoghlak/domin/use_cases/storage/upload_image_to_storage_usecase.dart';
import 'package:shoghlak/presentation/cubits/user/user_cubit.dart';
import 'package:shoghlak/presentation/pages/main_screens/profile/widgets/profile_form_widget.dart';
import 'package:shoghlak/presentation/pages/main_screens/profile/widgets/profile_widget.dart';
import 'package:shoghlak/presentation/widgets/circular_progress_indicator.dart';
import 'package:shoghlak/presentation/widgets/container_widget.dart';
import 'package:shoghlak/presentation/widgets/icon_widget.dart';
import 'package:shoghlak/presentation/widgets/text_widget.dart';

import '../../../../consts.dart';
import '../../../../domin/entities/user/user_entity.dart';

import 'package:shoghlak/injection_container.dart' as di;

class EditProfileScreen extends StatefulWidget {
  final UserEntity currentUser;
  const EditProfileScreen({Key? key, required this.currentUser})
      : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController? _nameController;
  TextEditingController? _userNameController;
  TextEditingController? _websiteController;
  TextEditingController? _bioController;

  bool _isUpdating = false;

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
  void initState() {
    _nameController = TextEditingController(text: widget.currentUser.name);
    _userNameController =
        TextEditingController(text: widget.currentUser.username);
    _websiteController =
        TextEditingController(text: widget.currentUser.website);
    _bioController = TextEditingController(text: widget.currentUser.bio);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backGroundColor,
        appBar: AppBar(
          backgroundColor: backGroundColor.withOpacity(0.2),
          title: const Text("Edit Profile"),
          leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const IconWidget(
                icon: Icons.close,
                size: 32,
              )),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: _isUpdating
                  ? const CircularProgressIndicatorWidget()
                  : InkWell(
                      onTap: _updateUserProfileData,
                      child: const IconWidget(
                        icon: Icons.done,
                        color: tealColor,
                        size: 32,
                      ),
                    ),
            )
          ],
        ),
        body: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/back_ground.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: ContainerWidget(
                      width: 120,
                      height: 120,
                      widget: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: ProfileWidget(
                          imageUrl: widget.currentUser.profileUrl,
                          imageFile: _image,
                        ),
                      ),
                    ),
                  ),
                  sizeVer(15),
                  Center(
                    child: InkWell(
                      onTap: selectImage,
                      child: const TextWidget(
                        txt: "Change profile photo",
                        color: tealColor,
                        fontsize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  sizeVer(15),
                  ProfileFormWidget(title: "Name", controller: _nameController),
                  sizeVer(15),
                  ProfileFormWidget(
                      title: "Username", controller: _userNameController),
                  sizeVer(15),
                  ProfileFormWidget(
                      title: "Website", controller: _websiteController),
                  sizeVer(15),
                  ProfileFormWidget(title: "Bio", controller: _bioController),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _updateUserProfileData() {
    if (_image == null) {
      _updateUserProfile("");
    } else {
      di
          .sl<UploadImageToStorageUseCase>()
          .call(_image!, false, FirebaseStorageConsts.profileImages)
          .then((profileUrl) {
        _updateUserProfile(profileUrl);
      });
    }
  }

  _updateUserProfile(String profileUrl) {
    setState(() {
      _isUpdating = true;
    });
    BlocProvider.of<UserCubit>(context)
        .updateUser(
            user: UserEntity(
          bio: _bioController!.text,
          name: _nameController!.text,
          username: _userNameController!.text,
          website: _websiteController!.text,
          uid: widget.currentUser.uid,
          profileUrl: profileUrl,
        ))
        .then((value) => _clear());
  }

  _clear() {
    setState(() {
      _isUpdating = false;
      _nameController!.clear();
      _userNameController!.clear();
      _bioController!.clear();
      _websiteController!.clear();
    });
    Navigator.pop(context);
  }
}
