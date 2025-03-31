import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole {
  admin("ADMIN"),
  user("USER"),
  ;

  final String roleValue;

  const UserRole(this.roleValue);
}

abstract class UserEntity {
  final UserRole role;
  final String? userId;
  final String? email;
  final String? fullName;
  final Timestamp? dob;

  const UserEntity({
    required this.role,
    this.userId,
    this.email,
    this.fullName,
    this.dob,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    switch (json["role"].toString().toUpperCase()) {
      case "ADMIN":
        return AdminUser(
          userId: json["username"],
          email: json["email"],
          fullName: json["name"],
          dob: json["dob"],
        );
      case "USER":
      default:
        return AppUser(
          userId: json["username"],
          email: json["email"],
          fullName: json["name"],
          dob: json["dob"],
        );
    }
  }

  Map<String, dynamic> toJson() => {
        "role": role.roleValue,
        "username": userId,
        "email": email,
        "name": fullName,
        "dob": dob,
      };

  DateTime? get dobDt => dob?.toDate();
}

final class AppUser extends UserEntity {
  AppUser({
    required super.userId,
    required super.email,
    required super.fullName,
    required super.dob,
  }) : super(
          role: UserRole.user,
        );
}

final class AdminUser extends UserEntity {
  AdminUser({
    required super.userId,
    required super.email,
    required super.fullName,
    required super.dob,
  }) : super(
          role: UserRole.admin,
        );
}
