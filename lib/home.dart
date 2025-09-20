import 'dart:io';

import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Center(
        child: Column(
          children: [
            image == null
                ? const Icon(Icons.image, size: 150)
                : Image.file(image!),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Choose/Capture'),
            ),
          ],
        ),
      ),
    );
  }
}
