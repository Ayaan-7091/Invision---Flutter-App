import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:invision/home.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ShapeDetector(),
  ));
}

class ShapeDetector2 extends StatefulWidget {
  const ShapeDetector2({Key? key}) : super(key: key);

  @override
  State<ShapeDetector2> createState() => _ShapeDetectorState();
}

class _ShapeDetectorState extends State<ShapeDetector2> {
  File? _selectedImage;
  File? _processedImage;
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
        _processedImage = null;
      });
    }
  }

  Future<void> _sendToServer() async {
    if (_selectedImage == null) return;

    setState(() => _isLoading = true);

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.0.134:5000/detect-shapes')

    );

    request.files.add(await http.MultipartFile.fromPath(
      'image',
      _selectedImage!.path,
    ));

    final response = await request.send();

    if (response.statusCode == 200) {
      final dir = await getTemporaryDirectory();
      final filePath = join(dir.path, 'processed.jpg');
      final file = File(filePath);
      await file.writeAsBytes(await response.stream.toBytes());
      setState(() {
        _processedImage = file;
      });
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Failed to process image')),
      // );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shape Detector')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (_selectedImage != null) ...[
              Image.file(_selectedImage!, height: 200),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _sendToServer,
                child: const Text('Detect Shapes'),
              ),
            ],
            if (_isLoading) const CircularProgressIndicator(),
            if (_processedImage != null) ...[
              const SizedBox(height: 20),
              const Text("Detected Shapes:"),
              Image.file(_processedImage!, height: 400),
            ],
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.image),
                  label: const Text('Gallery'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
