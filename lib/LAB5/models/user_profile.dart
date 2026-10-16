import 'package:flutter/material.dart';

enum UserRole {
  student('Student', Icons.school_rounded),
  teacher('Teacher', Icons.work_rounded),
  developer('Developer', Icons.code_rounded);

  const UserRole(this.label, this.icon);

  final String label;
  final IconData icon;
}

/// Данные пользователя после регистрации (LAB 6).
class UserProfile {
  final String fullName;
  final String email;
  final UserRole role;
  final bool subscribedToNews;

  const UserProfile({
    required this.fullName,
    required this.email,
    required this.role,
    required this.subscribedToNews,
  });

  String get firstName => fullName.trim().split(RegExp(r'\s+')).first;

  /// «Aruzhan Serikova» → «AS»
  String get initials {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    return parts.take(2).map((p) => p[0].toUpperCase()).join();
  }
}
