import 'dart:typed_data';

class UserImageFile {
  final String name;
  final Uint8List bytes;

  const UserImageFile({
    required this.name,
    required this.bytes,
  });
}