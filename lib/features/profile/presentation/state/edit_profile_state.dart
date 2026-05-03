import 'dart:typed_data';
import 'package:med_reability/features/auth/domain/entities/user_me.dart';


class EditProfileState {
  final UserMe user;
  final Uint8List? pickedImageBytes;
  final String? pickedImageFileName;
  final bool isSubmitting;
  final String? errorMessage;

  const EditProfileState({
    required this.user,
    required this.pickedImageBytes,
    required this.pickedImageFileName,
    required this.isSubmitting,
    required this.errorMessage,
  });

  factory EditProfileState.initial(UserMe user) {
    return EditProfileState(
      user: user,
      pickedImageBytes: null,
      pickedImageFileName: null,
      isSubmitting: false,
      errorMessage: null,
    );
  }

  EditProfileState copyWith({
    UserMe? user,
    Uint8List? pickedImageBytes,
    String? pickedImageFileName,
    bool? isSubmitting,
    String? errorMessage,
    bool clearPickedImage = false,
    bool clearErrorMessage = false,
  }) {
    return EditProfileState(
      user: user ?? this.user,
      pickedImageBytes: clearPickedImage ? null : (pickedImageBytes ?? this.pickedImageBytes),
      pickedImageFileName: clearPickedImage
          ? null
          : (pickedImageFileName ?? this.pickedImageFileName),
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}