import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class MessageModel {
  String? messageId;
  String? sender;
  String? text;
  bool? seen;
  DateTime? createdob;
  MessageModel({
    this.messageId,
    this.sender,
    this.text,
    this.seen,
    this.createdob,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'messageId': messageId,
      'sender': sender,
      'text': text,
      'seen': seen,
      'createdob': createdob,
    };
  }

  MessageModel.fromMap(Map<String, dynamic> map) {
    messageId = map['messageId'];
    sender = map['sender'];
    text = map['text'];
    seen = map['seen'];
    createdob = map['createdob'].toDate();
  }
}
