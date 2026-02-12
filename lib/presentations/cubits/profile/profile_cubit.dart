import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:epharmacy/constants/helpers.dart';
import 'package:epharmacy/data/models/user_model.dart';
import 'package:epharmacy/data/remote_datasource/auth/auth_remote_datasource.dart';
import 'package:epharmacy/data/remote_datasource/profile/profile_remote_datasource.dart';
import 'package:equatable/equatable.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final AuthRemoteDatasource _authRemoteDatasource = AuthRemoteDatasource();
  final ProfileRemoteDatasource _profileRemoteDatasource =
      ProfileRemoteDatasource();
  ProfileCubit() : super(const ProfileState()) {
    getUserProfile();
  }

  Future<void> getUserProfile() async {
    emit(state.copyWith(status: ProfileStatus.loading));

    try {
      final user = await _authRemoteDatasource.getCurrentUserData();
      if (user != null) {
        emit(state.copyWith(status: ProfileStatus.success, user: user));
      } else {
        emit(
          state.copyWith(
            status: ProfileStatus.error,
            errorMessage: "User not found",
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(status: ProfileStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> updateProfile({
    required UserModel user,
    required String newFirstName,
    required String newLastName,
    File? newImageFile,
  }) async {
    emit(state.copyWith(status: ProfileStatus.loading));

    try {
      String? finalImageString = user.profileImage;

      if (newImageFile != null) {
        final converted = await Helpers.compressAndConvertToBase64(
          newImageFile,
        );
        if (converted != null) {
          finalImageString = converted;
        }
      }

      final userPayLoad = user.copyWith(
        firstName: newFirstName,
        lastName: newLastName,
        profileImage: finalImageString,
      );

      final updateUserResult = await _profileRemoteDatasource.updateUserProfile(
        user: userPayLoad,
      );

      emit(
        state.copyWith(status: ProfileStatus.success, user: updateUserResult),
      );
    } catch (e) {
      emit(
        state.copyWith(status: ProfileStatus.error, errorMessage: e.toString()),
      );
    }
  }
}
