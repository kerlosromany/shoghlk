import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoghlak/domin/entities/post/post_entity.dart';
import 'package:shoghlak/presentation/cubits/post/post_cubit.dart';
import 'package:shoghlak/presentation/pages/main_screens/post/widgets/form_widget.dart';

import 'package:shoghlak/injection_container.dart' as di;

import '../../../../../consts.dart';
import '../../../../../domin/use_cases/storage/upload_image_to_storage_usecase.dart';
import '../../../../widgets/button_container_widget.dart';
import '../../../../widgets/circular_progress_indicator.dart';
import '../../../../widgets/container_widget.dart';
import '../../../../widgets/icon_widget.dart';
import '../../../../widgets/text_widget.dart';
import '../../profile/widgets/profile_widget.dart';

class UpdatePostMainWidget extends StatefulWidget {
  final PostEntity post;
  const UpdatePostMainWidget({Key? key, required this.post}) : super(key: key);

  @override
  State<UpdatePostMainWidget> createState() => _UpdatePostMainWidgetState();
}

class _UpdatePostMainWidgetState extends State<UpdatePostMainWidget> {
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

  TextEditingController? _descriptionController;
  TextEditingController? _detailsController;
  TextEditingController? _phoneNo1Controller;
  TextEditingController? _phoneNo2Controller;
  TextEditingController? _communicationLinkController;

  bool _updating = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    _descriptionController =
        TextEditingController(text: widget.post.description);
    _detailsController = TextEditingController(text: widget.post.details);
    _phoneNo1Controller = TextEditingController(text: widget.post.phoneNo1);
    _phoneNo2Controller = TextEditingController(text: widget.post.phoneNo2);
    _communicationLinkController =
        TextEditingController(text: widget.post.communicationLink);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _descriptionController!.dispose();
    _detailsController!.dispose();
    _phoneNo1Controller!.dispose();
    _phoneNo2Controller!.dispose();
    _communicationLinkController!.dispose();
    super.dispose();
  }

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
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    ContainerWidget(
                      alignment: Alignment.center,
                      color: backGroundColor.withOpacity(0.1),
                      height: 0.08 * screenHeight,
                      width: double.infinity,
                      borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(0.05 * screenWidth)),
                      widget: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const TextWidget(
                            txt: "Update Post",
                            fontWeight: FontWeight.bold,
                          ),
                          _updating == true
                              ? const CircularProgressIndicatorWidget()
                              : GestureDetector(
                                  onTap: _updatePost,
                                  child: ButtonContainerWidget(
                                    text: "Update",
                                    color2: Colors.pinkAccent.withOpacity(0.6),
                                    color: Colors.tealAccent.withOpacity(0.6),
                                    height: 0.07 * screenHeight,
                                    width: 0.2 * screenWidth,
                                  ),
                                ),
                        ],
                      ),
                    ),
                    sizeVer(0.012 * screenHeight),
                    if (widget.post.postImageUrl != null &&
                        widget.post.postImageUrl != "")
                      Stack(
                        children: [
                          ContainerWidget(
                            width: double.infinity,
                            widget: ProfileWidget(
                              imageFile: _image,
                              imageUrl: widget.post.postImageUrl,
                            ),
                          ),
                          GestureDetector(
                            onTap: selectImage,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 0.02 * screenWidth,
                                  top: 0.02 * screenWidth),
                              child: ContainerWidget(
                                alignment: Alignment.center,
                                width: 0.1 * screenWidth,
                                height: 0.048 * screenHeight,
                                color: primaryColor,
                                boxShape: BoxShape.circle,
                                widget: const IconWidget(
                                    icon: Icons.edit, color: blueColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    sizeVer(0.02 * screenHeight),
                    FormWidget(
                      title: "Description",
                      maxLines: 12,
                      textInputType: TextInputType.text,
                      controller: _descriptionController,
                    ),
                    sizeVer(0.02 * screenHeight),
                    FormWidget(
                      title: "Details",
                      maxLines: 15,
                      textInputType: TextInputType.text,
                      controller: _detailsController,
                    ),
                    sizeVer(0.02 * screenHeight),
                    FormWidget(
                      title: "Phone number",
                      maxLines: 1,
                      textInputType: TextInputType.phone,
                      controller: _phoneNo1Controller,
                    ),
                    sizeVer(0.02 * screenHeight),
                    FormWidget(
                      title: "Another Phone number",
                      maxLines: 1,
                      textInputType: TextInputType.phone,
                      controller: _phoneNo2Controller,
                    ),
                    sizeVer(0.02 * screenHeight),
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
        ],
      ),
    );
  }

  _updatePost() {
    setState(() {
      _updating = true;
    });
    if (_image == null) {
      _submitUpdatePost(image: widget.post.postImageUrl!);
    } else {
      di
          .sl<UploadImageToStorageUseCase>()
          .call(_image!, true, FirebaseStorageConsts.postImages)
          .then((postImageUrl) {
        _submitUpdatePost(image: postImageUrl);
      });
    }
  }

  _submitUpdatePost({required String image}) {
    BlocProvider.of<PostCubit>(context)
        .updatePost(
          post: PostEntity(
            creatorUid: widget.post.creatorUid,
            postId: widget.post.postId,
            postImageUrl: image,
            description: _descriptionController!.text,
            communicationLink: _communicationLinkController!.text,
            details: _detailsController!.text,
            phoneNo1: _phoneNo1Controller!.text,
            phoneNo2: _phoneNo2Controller!.text,
          ),
        )
        .then((value) => _clear());
  }

  _clear() {
    setState(() {
      _updating = false;
      _image = null;
      _descriptionController!.clear();
      _detailsController!.clear();
      _communicationLinkController!.clear();
      _phoneNo1Controller!.clear();
      _phoneNo2Controller!.clear();
      Navigator.pop(context);
    });
  }
}
