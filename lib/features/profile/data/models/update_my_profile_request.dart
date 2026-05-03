import 'dart:typed_data';
import 'package:dio/dio.dart';


class UpdateMyProfileRequest {
  final String email;
  final String firstName;
  final String patronymic;
  final String lastName;
  final String phoneNumber;
  final Uint8List? imageBytes;
  final String? imageFileName;

  const UpdateMyProfileRequest({
    required this.email,
    required this.firstName,
    required this.patronymic,
    required this.lastName,
    required this.phoneNumber,
    this.imageBytes,
    this.imageFileName,
  });

  FormData toFormData() {
    final map = <String, dynamic>{
      'Email': email,
      'FirstName': firstName,
      'Patronymic': patronymic,
      'LastName': lastName,
      'PhoneNumber': phoneNumber,
    };

    if (imageBytes != null) {
      map['Image'] = MultipartFile.fromBytes(
        imageBytes!,
        filename: imageFileName ?? 'profile_image.jpg',
      );
    }

    return FormData.fromMap(map);
  }
}