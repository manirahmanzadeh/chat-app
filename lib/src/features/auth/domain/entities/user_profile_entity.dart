import 'package:equatable/equatable.dart';

class UserProfileEntity extends Equatable {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoURL;
  final String? bio;

  const UserProfileEntity({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoURL,
    this.bio,
  });

  @override
  List<Object?> get props => [
        uid,
        email,
        displayName,
        photoURL,
        bio,
      ];
}
