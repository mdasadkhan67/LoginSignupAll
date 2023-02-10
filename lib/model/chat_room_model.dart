// ignore_for_file: public_member_api_docs, sort_constructors_first
class ChatRoom {
  String? chatroomid;
  List<String>? participants;

  ChatRoom({
    this.chatroomid,
    this.participants,
  });

  ChatRoom.fromMap(Map<String, dynamic> map) {
    chatroomid = map['chatroomid'];
    participants = map['participants'];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chatroomid': chatroomid,
      'participants': participants,
    };
  }
}
