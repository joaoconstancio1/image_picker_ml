import 'package:flutter/material.dart';
import 'package:image_picker_ml/image_picker_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Modular Clean Login',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ImagePickerPage(),
    );
  }
}
