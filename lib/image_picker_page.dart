import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerPage extends StatefulWidget {
  const ImagePickerPage({super.key});

  @override
  State<ImagePickerPage> createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  ImageLabelerOptions options = ImageLabelerOptions(confidenceThreshold: 0.6);

  late final ImageLabeler _labeler = ImageLabeler(options: options);
  final ImagePicker _picker = ImagePicker();
  File? image;
  List<ImageLabel> labels = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Picker ML')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Image section - smaller size
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: image == null
                  ? const Icon(Icons.image, size: 100, color: Colors.grey)
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        image!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
            const SizedBox(height: 16),
            // Button
            ElevatedButton(
              onPressed: () {
                showImagePickerBottomSheet();
              },
              child: const Text('Choose/Capture'),
            ),
            const SizedBox(height: 16),
            // Labels section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Detected Labels:',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: labels.isEmpty
                        ? const Center(
                            child: Text(
                              'No labels detected yet.\nSelect an image to see labels.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            itemCount: labels.length,
                            itemBuilder: (context, index) {
                              final label = labels[index];
                              return Card(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.blue,
                                    child: Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    label.label,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Confidence: ${(label.confidence * 100).toStringAsFixed(1)}%',
                                  ),
                                  trailing: Icon(
                                    Icons.verified,
                                    color: label.confidence > 0.8
                                        ? Colors.green
                                        : label.confidence > 0.6
                                        ? Colors.orange
                                        : Colors.red,
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  imageLabeling() async {
    if (image == null) {
      debugPrint('No image selected for labeling');
      return;
    }

    try {
      InputImage inputImage = InputImage.fromFile(image!);

      final List<ImageLabel> detectedLabels = await _labeler.processImage(
        inputImage,
      );

      setState(() {
        labels = detectedLabels;
      });

      for (ImageLabel label in detectedLabels) {
        final String text = label.label;
        final int index = label.index;
        final double confidence = label.confidence;
        debugPrint('Label: $text, Index: $index, Confidence: $confidence');
      }
    } catch (e) {
      debugPrint('Error during image labeling: $e');
      setState(() {
        labels = [];
      });
    }
  }

  chooseImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
      await imageLabeling();
    }
  }

  captureImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
      await imageLabeling();
    }
  }

  showImagePickerBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Escolher da Galeria'),
            onTap: () {
              Navigator.pop(context);
              chooseImage();
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Tirar Foto'),
            onTap: () {
              Navigator.pop(context);
              captureImage();
            },
          ),
        ],
      ),
    );
  }
}
