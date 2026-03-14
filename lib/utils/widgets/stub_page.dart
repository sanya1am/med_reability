import 'package:flutter/material.dart';

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
      appBar: AppBar(title: Text(title), actions: actions),
      body: Center(child: body ?? Text('Заглушка: $title')),
    );
  }
}