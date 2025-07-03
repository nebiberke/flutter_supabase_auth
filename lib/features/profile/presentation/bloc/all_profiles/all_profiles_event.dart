import 'package:equatable/equatable.dart';

abstract class AllProfilesEvent extends Equatable {
  const AllProfilesEvent();

  @override
  List<Object?> get props => [];
}

class GetAllProfilesEvent extends AllProfilesEvent {
  const GetAllProfilesEvent();

  @override
  List<Object> get props => [];
}
