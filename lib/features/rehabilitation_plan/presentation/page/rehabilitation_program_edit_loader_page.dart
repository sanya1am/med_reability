import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_reability/core/di/providers.dart';
import 'package:med_reability/features/rehabilitation_plan/domain/entities/rehabilitation_program.dart';
import 'package:med_reability/features/rehabilitation_plan/presentation/page/rehabilitation_program_weeks_page.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import 'package:med_reability/utils/widgets/app_top_actions_bar.dart';

import '../widgets/rehabilitation_plan_page_layout.dart';

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

    return async.when(
      loading: () => const Scaffold(
        body: SafeArea(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      error: (error, _) => RehabilitationPlanPageLayout(
        breadcrumbs: rehabilitationPlanBreadcrumbs(
          context,
          const [
            'Редактирование плана',
          ],
        ),
        desktopHeaderSpacing: 40,
        mobileHeaderSpacing: 40,
        children: [
          Text(
            'Ошибка: $error',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colors.textPrimary,
            ),
          ),
        ],
      ),
      data: (program) {
        return RehabilitationProgramWeeksPage(
          patientId: program.patientId,
          initialProgram: program,
        );
      },
    );
  }
}