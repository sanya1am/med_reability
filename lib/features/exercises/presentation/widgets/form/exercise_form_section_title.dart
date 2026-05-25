import 'package:flutter/material.dart';

class ExerciseFormSectionTitle extends StatelessWidget {
  final String text;

  const ExerciseFormSectionTitle({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontSize: 18,
      ),
    );
  }
}