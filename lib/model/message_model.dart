import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class MessageModel {
  String? messageId;
  String? sender;
  String? text;
  String? image;
  String? type;
  bool? seen;
  DateTime? createdob;
  MessageModel({
    this.messageId,
    this.sender,
    this.text,
    this.image,
    this.type,
    this.seen,
    this.createdob,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'messageId': messageId,
      'sender': sender,
      'text': text,
      'image': image,
      'type': type,
      'seen': seen,
      'createdob': createdob,
    };
  }

  MessageModel.fromMap(Map<String, dynamic> map) {
    messageId = map['messageId'];
    sender = map['sender'];
    text = map['text'];
    image = map['image'];
    type = map['type'];
    seen = map['seen'];
    createdob = map['createdob'].toDate();
  }
}
