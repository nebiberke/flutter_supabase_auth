import 'package:equatable/equatable.dart';

abstract class UsersEvent extends Equatable {
  const UsersEvent();

  @override
  List<Object?> get props => [];
}

class GetAllProfilesEvent extends UsersEvent {
  const GetAllProfilesEvent({required this.currentUserId});

  final String currentUserId;

  @override
  List<Object?> get props => [currentUserId];
}

class GetProfileWithIdEvent extends UsersEvent {
  const GetProfileWithIdEvent({required this.userId});

  final String userId;

  @override
  List<Object?> get props => [userId];
}
