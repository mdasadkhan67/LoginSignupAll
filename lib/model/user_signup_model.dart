import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserSignUpModel {
  String name;
  String email;
  String phone;
  String imageurl;

  UserSignUpModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.imageurl,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'phone': phone,
      'imageurl': imageurl,
    };
  }

  factory UserSignUpModel.fromMap(Map<String, dynamic> map) {
    return UserSignUpModel(
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      imageurl: map['imageurl'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserSignUpModel.fromJson(String source) =>
      UserSignUpModel.fromMap(json.decode(source) as Map<String, dynamic>);

  UserSignUpModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? imageurl,
  }) {
    return UserSignUpModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      imageurl: imageurl ?? this.imageurl,
    );
  }

  @override
  String toString() {
    return 'UserSignUpModel(name: $name, email: $email, phone: $phone, imageurl: $imageurl)';
  }

  @override
  bool operator ==(covariant UserSignUpModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.imageurl == imageurl;
  }

  @override
  int get hashCode {
    return name.hashCode ^ email.hashCode ^ phone.hashCode ^ imageurl.hashCode;
  }
}
