import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/providers.dart';
import '../../../../core/errors/unauthorized_exception.dart';
import '../../domain/entities/user_me.dart';
import 'auth_view_model.dart';


class UserMeViewModel extends AsyncNotifier<UserMe?> {
  late final getMe = ref.read(getUserMeUseCaseProvider);

  @override
  Future<UserMe?> build() async {
    final authed = ref.watch(authViewModelProvider.select((s) => s.isAuthed));
    if (!authed) return null;

    try {
      return await getMe();
    } on UnauthorizedException {
      await ref.read(authViewModelProvider.notifier).logout();
      return null;
    }
  }

  Future<void> refresh() async {
    final authed = ref.read(authViewModelProvider).isAuthed;
    if (!authed) {
      state = const AsyncData(null);
      return;
    }

    state = const AsyncLoading();
    final next = await AsyncValue.guard(() => getMe());

    if (next.hasError && next.error is UnauthorizedException) {
      await ref.read(authViewModelProvider.notifier).logout();
      state = const AsyncData(null);
      return;
    }

    state = next;
  }
}

final userMeViewModelProvider =
AsyncNotifierProvider<UserMeViewModel, UserMe?>(UserMeViewModel.new);