// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fb_task/model/chat_room_model.dart';
import 'package:google_fb_task/model/message_model.dart';
import 'package:google_fb_task/model/user_signup_model.dart';
import 'package:google_fb_task/utils/chat_screen_utils.dart';
import 'package:google_fb_task/widget/background_decoration.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

// ignore: must_be_immutable
class ChatRoomPage extends StatefulWidget {
  final UserModel? targetUser;
  ChatRoom? chatRoom;
  final UserModel userModel;
  ChatRoomPage({
    Key? key,
    this.targetUser,
    this.chatRoom,
    required this.userModel,
  }) : super(key: key);

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  TextEditingController messageController = TextEditingController();
  final uniqId = const Uuid().v1();
  File? imageFile;
  TextEditingController fullNameTEC = TextEditingController();

  void selectImage(ImageSource source) async {
    ImagePicker imgPickObj = ImagePicker();
    XFile? pickFile = await imgPickObj.pickImage(source: source);
    if (pickFile != null) {
      cropImage(pickFile);
    }
  }

  void cropImage(XFile file) async {
    ImageCropper imgCropObj = ImageCropper();
    CroppedFile? croppedImage =
        await imgCropObj.cropImage(sourcePath: file.path, compressQuality: 10);

    setState(() {
      imageFile = File(croppedImage!.path);
    });
    uploadData();
  }

  void uploadData() async {
    UploadTask uploadTask = FirebaseStorage.instance
        .ref('SendPicture')
        .child(uniqId)
        .putFile(imageFile!);
    TaskSnapshot snapshot = await uploadTask;
    String imageUrl = await snapshot.ref.getDownloadURL();
    if (imageUrl != '') {
      MessageModel newMessage = MessageModel(
          messageId: uniqId,
          sender: widget.userModel.uid,
          createdob: DateTime.now(),
          text: '',
          image: imageUrl,
          type: 'photo',
          seen: false);
      await FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(widget.chatRoom!.chatroomid)
          .collection('messages')
          .doc(newMessage.messageId)
          .set(newMessage.toMap());
      widget.chatRoom!.lastMessage = 'Photo';
      await FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(widget.chatRoom!.chatroomid)
          .set(widget.chatRoom!.toMap());
    }
  }

  void sendMessage() async {
    String msg = messageController.text.trim();
    if (msg != '') {
      MessageModel newMessage = MessageModel(
          messageId: const Uuid().v1(),
          sender: widget.userModel.uid,
          createdob: DateTime.now(),
          text: msg,
          image: '',
          type: 'message',
          seen: false);

      await FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(widget.chatRoom!.chatroomid)
          .collection('messages')
          .doc(newMessage.messageId)
          .set(newMessage.toMap());

      widget.chatRoom!.lastMessage = msg;

      await FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(widget.chatRoom!.chatroomid)
          .set(widget.chatRoom!.toMap());
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BackgroundWidget(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.logout_outlined),
              onPressed: ChatScreenUtils.logOutMethod(context),
            ),
          )
        ],
        title: Row(children: [
          CircleAvatar(
            backgroundImage:
                NetworkImage(widget.targetUser!.imageurl.toString()),
          ),
          const SizedBox(
            width: 20,
          ),
          Text(widget.targetUser!.name.toString())
        ]),
      ),
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Column(children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('chatrooms')
                .doc(widget.chatRoom!.chatroomid)
                .collection('messages')
                .orderBy('createdob', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;
                  return Expanded(
                    child: ListView.builder(
                      reverse: true,
                      itemCount: dataSnapshot.docs.length,
                      itemBuilder: (context, index) {
                        var currentMessage = MessageModel.fromMap(
                            dataSnapshot.docs[index].data()
                                as Map<String, dynamic>);
                        return Row(
                          mainAxisAlignment:
                              (currentMessage.sender == widget.userModel.uid)
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                          children: [
                            Container(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 2,
                                ),
                                decoration: BackgroundWidgetWithRadius(),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: (currentMessage.type.toString() ==
                                          'message')
                                      ? Text(
                                          currentMessage.text.toString(),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        )
                                      : Container(
                                          height: 100,
                                          width: 110,
                                          child: Image(
                                              image: NetworkImage(currentMessage
                                                  .image
                                                  .toString())),
                                        ),
                                )),
                          ],
                        );
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                      child: Text(
                          'Erroe! please check your internet connectivity'));
                } else {
                  return const Center(child: Text('Say Hi to your friend'));
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          Row(
            children: [
              Flexible(
                child: TextField(
                  maxLines: null,
                  controller: messageController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          showPhotoOption();
                        },
                        icon: Icon(Icons.photo)),
                    border: InputBorder.none,
                    hintText: 'Enter message',
                  ),
                ),
              ),
              const Divider(
                color: Colors.pinkAccent,
                thickness: 1.0,
                height: 2.0,
              ),
              IconButton(
                onPressed: () {
                  sendMessage();
                  messageController.clear();
                },
                icon: const Icon(Icons.send),
                color: Theme.of(context).colorScheme.secondary,
              )
            ],
          )
        ]),
      )),
    );
  }
}
