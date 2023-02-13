// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  String? uid;
  String? name;
  String? email;
  String? phone;
  String? imageurl;

  UserModel({
    this.uid,
    this.name,
    this.email,
    this.phone,
    this.imageurl,
  });

  UserModel.fromMap(Map<String, dynamic> map) {
    uid = map['uid'];
    name = map['name'];
    email = map['email'];
    phone = map['phone'];
    imageurl = map['imageurl'];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'imageurl': imageurl,
    };
  }
}
