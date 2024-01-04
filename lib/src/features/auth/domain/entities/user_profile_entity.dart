import 'package:equatable/equatable.dart';

class UserProfileEntity extends Equatable {
  final String uid;
  final String phoneNumber;
  final String? displayName;
  final String? photoURL;
  final String? bio;

  const UserProfileEntity({
    required this.uid,
    required this.phoneNumber,
    this.displayName,
    this.photoURL,
    this.bio,
  });

  @override
  List<Object?> get props => [
        uid,
        phoneNumber,
        displayName,
        photoURL,
        bio,
      ];
}
