import 'package:flutter/material.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import 'package:med_reability/utils/widgets/app_top_actions_bar.dart';

class DayWellBeingViewPage extends StatelessWidget {
  final int? wellBeingRating;
  final int? workoutDifficultyRating;
  final bool? hadPain;
  final int? painIntensityRating;

  const DayWellBeingViewPage({
    super.key,
    required this.wellBeingRating,
    required this.workoutDifficultyRating,
    required this.hadPain,
    required this.painIntensityRating,
  });

  bool get _hasProgress {
    return wellBeingRating != null &&
        wellBeingRating! > 0 &&
        workoutDifficultyRating != null &&
        workoutDifficultyRating! > 0 &&
        hadPain != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: !_hasProgress
            ? const _EmptyWellBeingView()
            : ListView(
          padding: const EdgeInsets.fromLTRB(28, 12, 28, 24),
          children: [
            AppTopActionsBar(
              onBack: () => Navigator.pop(context),
              onNotify: () {},
            ),
            const SizedBox(height: 18),

            _WellBeingRatingCard(
              number: 1,
              title: 'Как вы себя чувствуете после тренировки?',
              value: wellBeingRating!,
            ),

            const SizedBox(height: 16),

            _WellBeingRatingCard(
              number: 2,
              title: 'Насколько сложной была тренировка?',
              value: workoutDifficultyRating!,
            ),

            const SizedBox(height: 16),

            _WellBeingAnswerCard(
              number: 3,
              title: 'Была ли боль или дискомфорт?',
              answer: hadPain == true ? 'Да' : 'Нет',
            ),

            if (hadPain == true) ...[
              const SizedBox(height: 16),
              _WellBeingRatingCard(
                number: 4,
                title: 'Насколько сильная?',
                value: painIntensityRating ?? 1,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _EmptyWellBeingView extends StatelessWidget {
  const _EmptyWellBeingView();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final primary = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 12, 28, 24),
      child: Column(
        children: [
          AppTopActionsBar(
            onBack: () => Navigator.pop(context),
            onNotify: () {},
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 52,
                    color: primary,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Пациент ещё не оценил свое\nсамочувствие.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WellBeingRatingCard extends StatelessWidget {
  final int number;
  final String title;
  final int value;

  const _WellBeingRatingCard({
    required this.number,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final primary = Theme.of(context).colorScheme.primary;

    final progress = (value.clamp(1, 10)) / 10.0;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _QuestionNumber(number: number),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 6,
                          backgroundColor: colors.border,
                          valueColor: AlwaysStoppedAnimation(primary),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '$value/10',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WellBeingAnswerCard extends StatelessWidget {
  final int number;
  final String title;
  final String answer;

  const _WellBeingAnswerCard({
    required this.number,
    required this.title,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _QuestionNumber(number: number),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 14),
                Text(
                  'Ответ: $answer',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionNumber extends StatelessWidget {
  final int number;

  const _QuestionNumber({
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 14,
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Text(
        number.toString(),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}