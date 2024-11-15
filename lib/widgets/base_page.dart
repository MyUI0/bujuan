import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BasePage extends ConsumerStatefulWidget {
  final Widget body;

  const BasePage({required this.body, super.key});

  @override
  ConsumerState<BasePage> createState() => _BasePageState();
}

class _BasePageState extends ConsumerState<BasePage> {
  final isLand = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.body,
    );
  }
}
