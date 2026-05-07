import 'package:flutter_riverpod/flutter_riverpod.dart';

final sessionEpochProvider = StateProvider<int>((ref) => 0);

void bumpSessionEpoch(Ref ref) {
  ref.read(sessionEpochProvider.notifier).state++;
}