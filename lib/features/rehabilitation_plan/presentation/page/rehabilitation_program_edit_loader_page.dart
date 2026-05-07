import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_reability/core/di/providers.dart';
import 'package:med_reability/features/rehabilitation_plan/domain/entities/rehabilitation_program.dart';
import 'package:med_reability/features/rehabilitation_plan/presentation/page/rehabilitation_program_weeks_page.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import 'package:med_reability/utils/widgets/app_top_actions_bar.dart';

final rehabilitationProgramDetailsProvider =
FutureProvider.autoDispose.family<RehabilitationProgram, String>(
      (ref, programId) {
    return ref.read(getRehabilitationProgramUseCaseProvider).call(
      id: programId,
    );
  },
);

class RehabilitationProgramEditLoaderPage extends ConsumerWidget {
  final String programId;

  const RehabilitationProgramEditLoaderPage({
    super.key,
    required this.programId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(
      rehabilitationProgramDetailsProvider(programId),
    );

    final colors = context.appColors;

    return Scaffold(
      body: SafeArea(
        child: async.when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, _) => Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              children: [
                AppTopActionsBar(
                  onBack: () => Navigator.pop(context),
                  onNotify: () {},
                ),
                const SizedBox(height: 40),
                Text(
                  'Ошибка: $error',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          data: (program) {
            return RehabilitationProgramWeeksPage(
              patientId: program.patientId,
              initialProgram: program,
            );
          },
        ),
      ),
    );
  }
}