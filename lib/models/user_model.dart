// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  String? uid;
  String email;
  String password;
  DateTime createDate;
  DateTime? lastUpdate;
  String? role;
  UserModel({
    this.uid,
    required this.email,
    required this.password,
    required this.createDate,
    this.lastUpdate,
    this.role = '0',
  });

  UserModel copyWith({
    String? uid,
    String? email,
    String? password,
    DateTime? createDate,
    DateTime? lastUpdate,
    String? role,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      password: password ?? this.password,
      createDate: createDate ?? this.createDate,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'password': password,
      'createDate': createDate.toIso8601String(),
      'lastUpdate': lastUpdate?.toIso8601String(),
      'role': role,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] != null ? map['uid'] as String : null,
      email: map['email'] as String,
      password: map['password'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      lastUpdate: map['lastUpdate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastUpdate'] as int)
          : null,
      role: map['role'] != null ? map['role'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(uid: $uid, email: $email, password: $password, createDate: $createDate, lastUpdate: $lastUpdate, role: $role)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.email == email &&
        other.password == password &&
        other.createDate == createDate &&
        other.lastUpdate == lastUpdate &&
        other.role == role;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        email.hashCode ^
        password.hashCode ^
        createDate.hashCode ^
        lastUpdate.hashCode ^
        role.hashCode;
  }
}
