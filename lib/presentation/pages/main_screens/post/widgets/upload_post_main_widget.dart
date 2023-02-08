import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoghlak/domin/entities/post/post_entity.dart';
import 'package:shoghlak/domin/entities/user/user_entity.dart';
import 'package:shoghlak/domin/use_cases/storage/upload_image_to_storage_usecase.dart';
import 'package:shoghlak/presentation/cubits/post/post_cubit.dart';
import 'package:shoghlak/presentation/pages/main_screens/post/widgets/form_widget.dart';

import 'package:shoghlak/presentation/pages/main_screens/profile/widgets/profile_widget.dart';
import 'package:shoghlak/presentation/widgets/button_container_widget.dart';
import 'package:shoghlak/presentation/widgets/circular_progress_indicator.dart';
import 'package:shoghlak/presentation/widgets/container_widget.dart';
import 'package:shoghlak/presentation/widgets/icon_widget.dart';
import 'package:uuid/uuid.dart';
import 'package:shoghlak/injection_container.dart' as di;

import '../../../../../consts.dart';
import '../../../../widgets/text_widget.dart';

class UploadPostMainWidget extends StatefulWidget {
  final UserEntity currentUser;
  const UploadPostMainWidget({Key? key, required this.currentUser})
      : super(key: key);

  @override
  State<UploadPostMainWidget> createState() => _UploadPostMainWidgetState();
}
 
class _UploadPostMainWidgetState extends State<UploadPostMainWidget> {
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

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _phoneNo1Controller = TextEditingController();
  final TextEditingController _phoneNo2Controller = TextEditingController();
  final TextEditingController _communicationLinkController =
      TextEditingController();

  bool _uploading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    _descriptionController.dispose();
    _detailsController.dispose();
    _phoneNo1Controller.dispose();
    _phoneNo2Controller.dispose();
    _communicationLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/back_ground.png'),
              fit: BoxFit.cover,
              opacity: 0.5,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    ContainerWidget(
                      alignment: Alignment.center,
                      color: backGroundColor.withOpacity(0.1),
                      height: 70,
                      width: double.infinity,
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(20)),
                      widget: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const TextWidget(
                            txt: "Upload Post",
                            fontWeight: FontWeight.bold,
                          ),
                          _uploading == true
                              ? const CircularProgressIndicatorWidget()
                              : GestureDetector(
                                  onTap: () {
                                    if (_formKey.currentState!.validate()) {
                                      _submitPost();
                                    }
                                  },
                                  child: ButtonContainerWidget(
                                    text: "Upload",
                                    color2: Colors.pinkAccent.withOpacity(0.6),
                                    color: Colors.tealAccent.withOpacity(0.6),
                                    height: 60,
                                    width: 80,
                                  ),
                                ),
                        ],
                      ),
                    ),
                    sizeVer(20),
                    _image == null
                        ? InkWell(
                            onTap: selectImage,
                            child: ContainerWidget(
                              width: double.infinity,
                              height: 70,
                              alignment: Alignment.center,
                              borderRadius: BorderRadius.circular(10),
                              borderWidth: 2,
                              widget: const TextWidget(txt: "Add a photo"),
                            ),
                          )
                        : Stack(
                            children: [
                              ContainerWidget(
                                width: double.infinity,
                                height: 240,
                                widget: ProfileWidget(imageFile: _image),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _image = null;
                                  });
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 8.0, top: 8.0),
                                  child: ContainerWidget(
                                    alignment: Alignment.center,
                                    width: 40,
                                    height: 40,
                                    color: backGroundColor,
                                    boxShape: BoxShape.circle,
                                    widget: IconWidget(
                                        icon: Icons.close, color: primaryColor),
                                  ),
                                ),
                              ),
                            ],
                          ),
                    sizeVer(30),
                    FormWidget(
                      title: "Description",
                      maxLines: 12,
                      textInputType: TextInputType.text,
                      controller: _descriptionController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Description must be not empty";
                        }
                      },
                    ),
                    sizeVer(20),
                    FormWidget(
                      title: "Details",
                      maxLines: 15,
                      textInputType: TextInputType.text,
                      controller: _detailsController,
                    ),
                    sizeVer(20),
                    FormWidget(
                      title: "Phone number",
                      maxLines: 1,
                      textInputType: TextInputType.phone,
                      controller: _phoneNo1Controller,
                    ),
                    sizeVer(20),
                    FormWidget(
                      title: "Another Phone number",
                      maxLines: 1,
                      textInputType: TextInputType.phone,
                      controller: _phoneNo2Controller,
                    ),
                    sizeVer(20),
                    FormWidget(
                      title: "Communication Links",
                      maxLines: 5,
                      textInputType: TextInputType.text,
                      controller: _communicationLinkController,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _submitPost() {
    setState(() {
      _uploading = true;
    });
    if (_image == null) {
      _createSubmitPost(image: "");
    } else {
      di
          .sl<UploadImageToStorageUseCase>()
          .call(_image!, true, FirebaseStorageConsts.postImages)
          .then((postImageUrl) {
        _createSubmitPost(image: postImageUrl);
      });
    }
  }

  _createSubmitPost({required String image}) {
    BlocProvider.of<PostCubit>(context)
        .createPost(
          post: PostEntity(
            description: _descriptionController.text,
            details: _detailsController.text,
            phoneNo1: _phoneNo1Controller.text,
            phoneNo2: _phoneNo2Controller.text,
            communicationLink: _communicationLinkController.text,
            creatorUid: widget.currentUser.uid,
            postId: const Uuid().v1(),
            likes: const [],
            totalComments: 0,
            totalLikes: 0,
            postImageUrl: image,
            createAt: Timestamp.now(),
            userName: widget.currentUser.username,
            userProfileUrl: widget.currentUser.profileUrl,
          ),
        )
        .then((value) => _clear());
  }

  _clear() {
    setState(() {
      _uploading = false;
      _descriptionController.clear();
      _detailsController.clear();
      _phoneNo1Controller.clear();
      _phoneNo2Controller.clear();
      _communicationLinkController.clear();
      _image = null;
    });
  }
}
