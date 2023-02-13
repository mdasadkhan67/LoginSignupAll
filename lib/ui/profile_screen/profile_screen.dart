// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fb_task/const/const.dart';
import 'package:google_fb_task/ui/chathomescreen/chaht_home_screen.dart';
import 'package:google_fb_task/utils/shared_pref_services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fb_task/model/user_signup_model.dart';
import 'package:google_fb_task/widget/button_gradiant.dart';
import 'package:google_fb_task/widget/background_decoration.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel? userModel;
  final User? firebaseuser;
  const ProfileScreen({
    this.userModel,
    this.firebaseuser,
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  File? imageFile;
  TextEditingController fullNameTEC = TextEditingController();
  void selectImage(ImageSource source) async {
    ImagePicker imgPickObj = ImagePicker();
    XFile? pickFile = await imgPickObj.pickImage(source: source);
    if (pickFile != null) {
      cropImage(pickFile);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  void cropImage(XFile file) async {
    ImageCropper imgCropObj = ImageCropper();
    CroppedFile? croppedImage = await imgCropObj.cropImage(
        sourcePath: file.path,
        aspectRatio: const CropAspectRatio(
          ratioX: 1,
          ratioY: 1,
        ),
        compressQuality: 20);

    setState(() {
      imageFile = File(croppedImage!.path);
    });
  }

  void showPhotoOption() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Uplaod Profile Picture'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.gallery);
                  },
                  leading: const Icon(Icons.photo_album),
                  title: const Text('Select From Gallery'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.camera);
                  },
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Take a Photo'),
                )
              ],
            ),
          );
        });
  }

  void uploadData() async {
    UploadTask uploadTask = FirebaseStorage.instance
        .ref('ProfilePicture')
        .child(widget.userModel!.uid.toString())
        .putFile(imageFile!);
    TaskSnapshot snapshot = await uploadTask;
    String imageUrl = await snapshot.ref.getDownloadURL();
    String name = fullNameTEC.text.trim();
    widget.userModel!.imageurl = imageUrl;
    widget.userModel!.name = name;
    await Prefs.setString('imageurl', imageUrl);
    await Prefs.setString('name', name);
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(widget.userModel!.toMap())
        .whenComplete(() => ConstantItems.navigatorPushReplacement(
            context, const ChatHomePage()))
        .onError((error, stackTrace) =>
            ConstantItems.toastMessage(error.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BackgroundWidget(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 60,
            ),
            Container(
              width: 325,
              height: 400,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      "Profile",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        showPhotoOption();
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: imageFile != null && imageFile!.path.isNotEmpty
                            ? Image.file(
                                imageFile!,
                                height: 120,
                                width: 120,
                              )
                            : const Icon(
                                Icons.person,
                                size: 60,
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 260,
                      height: 60,
                      child: TextFormField(
                        keyboardType: TextInputType.name,
                        controller: fullNameTEC,
                        validator: (value) {
                          if (value == null ||
                              value.isNotEmpty == null ||
                              imageFile == null) {
                            return 'Please enter some text';
                          }
                        },
                        decoration: const InputDecoration(
                          suffix: Icon(
                            FontAwesomeIcons.envelope,
                            color: Colors.red,
                          ),
                          labelText: "Your Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    InkWell(
                        onTap: (() {
                          if (_formKey.currentState!.validate()) {
                            uploadData();
                          }
                        }),
                        child: RadientButton(
                          btnName: "Submit",
                        )),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
