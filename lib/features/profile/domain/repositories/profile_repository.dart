import 'dart:typed_data';
import 'package:med_reability/features/auth/domain/entities/user_me.dart';


abstract class ProfileRepository {
  Future<UserMe> updateMyProfile({
    required String email,
    required String firstName,
    required String patronymic,
    required String lastName,
    required String phoneNumber,
    Uint8List? imageBytes,
    String? imageFileName,
  });

  Future<void> changeMyPassword({
    required String currentPassword,
    required String newPassword,
  });
}