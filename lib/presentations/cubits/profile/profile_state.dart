// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'profile_cubit.dart';

enum ProfileStatus { initial, loading, success, error }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final UserModel? user;
  final String errorMessage;
  const ProfileState({
    this.status = ProfileStatus.initial,
    this.user,
    this.errorMessage = '',
  });

  @override
  List<Object?> get props => [status, user, errorMessage];

  ProfileState copyWith({
    ProfileStatus? status,
    UserModel? user,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
