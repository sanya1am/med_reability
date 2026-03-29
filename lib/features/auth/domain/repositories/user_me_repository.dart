import '../entities/user_me.dart';

abstract class UserMeRepository {
  Future<UserMe> getMe();
}