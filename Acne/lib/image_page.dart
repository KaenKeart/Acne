import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'prediction_page.dart'; // นำเข้าไฟล์ prediction_page.dart

class ImagePage extends StatefulWidget {
  const ImagePage({super.key});

  @override
  _ImagePageState createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isPickingImage = false;

  Future<void> _requestPermissions() async {
    if (await Permission.camera.isDenied) {
      await Permission.camera.request();
    }
    if (await Permission.photos.isDenied) {
      await Permission.photos.request();
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    setState(() {
      _isPickingImage = true;
    });

    try {
      final pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });

        // เปลี่ยนไปยังหน้าทำนายผล
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PredictionPage(image: _image!),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No image selected'),
          ),
        );
      }
    } catch (e) {
      print('Failed to pick image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to pick image'),
        ),
      );
    } finally {
      setState(() {
        _isPickingImage = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Upload Image',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (_isPickingImage)
                const CircularProgressIndicator()
              else if (_image != null)
                Image.file(
                  _image!,
                  width: 300,
                  height: 300,
                  fit: BoxFit.cover,
                )
              else
                const Text('No image selected'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await _pickImage(ImageSource.camera);
                },
                child: const Text('Take Photo'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await _pickImage(ImageSource.gallery);
                },
                child: const Text('Select from Gallery'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
