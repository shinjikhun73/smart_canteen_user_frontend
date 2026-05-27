import 'package:flutter/material.dart';

void main() {
  runApp(const ScmsApp());
}

class ScmsApp extends StatelessWidget {
  const ScmsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Canteen Management System',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SCMS'),
        ),
        body: const Center(
          child: Text('Smart Canteen Management System'),
        ),
      ),
    );
  }
}
