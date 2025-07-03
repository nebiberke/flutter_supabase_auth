import 'package:equatable/equatable.dart';

abstract class UserProfileEvent extends Equatable {
  const UserProfileEvent();

  @override
  List<Object?> get props => [];
}

class GetProfileWithIdEvent extends UserProfileEvent {
  const GetProfileWithIdEvent({required this.userId});

  final String userId;

  @override
  List<Object> get props => [userId];
}
