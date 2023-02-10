import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class MessageModel {
  String? sender;
  String? text;
  bool? seen;
  DateTime? createdob;
  MessageModel({
    this.sender,
    this.text,
    this.seen,
    this.createdob,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sender': sender,
      'text': text,
      'seen': seen,
      'createdob': createdob,
    };
  }

  MessageModel.fromMap(Map<String, dynamic> map) {
    sender = map['sender'];
    text = map['text'];
    seen = map['seen'];
    createdob = map['createdob'].toDate();
  }
}
