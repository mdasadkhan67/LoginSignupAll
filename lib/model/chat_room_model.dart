// ignore_for_file: public_member_api_docs, sort_constructors_first
class ChatRoom {
  String? chatroomid;
  Map<String, dynamic>? participants;
  String? lastMessage;

  ChatRoom({
    this.chatroomid,
    this.participants,
    this.lastMessage,
  });

  ChatRoom.fromMap(Map<String, dynamic> map) {
    chatroomid = map['chatroomid'];
    participants = map['participants'];
    chatroomid = map['lastMessage'];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chatroomid': chatroomid,
      'participants': participants,
      'lastMessage': lastMessage,
    };
  }
}
