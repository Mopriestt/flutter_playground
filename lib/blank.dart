import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Blank extends StatefulWidget {
  const Blank({super.key});

  @override
  State<StatefulWidget> createState() => _BlankState();
}

class _BlankState extends State<Blank> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blank'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
    );
  }
}
