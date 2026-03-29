import 'package:flutter/material.dart';
import 'package:med_reability/utils/widgets/app_header.dart';

class StubPage extends StatelessWidget {
  final String title;
  final List<Widget> actions;
  final Widget? body;

  const StubPage({
    super.key,
    required this.title,
    this.actions = const [],
    this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: body ?? Text('Заглушка: $title')),
    );
  }
}