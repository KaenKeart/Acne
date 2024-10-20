import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';

class PredictionPage extends StatefulWidget {
  final File image;

  const PredictionPage({super.key, required this.image});

  @override
  _PredictionPageState createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  String? _predictionResult;
  bool _isAnalyzing = false;
  List<dynamic>? _predictionDetails;

  Dio dio = Dio();

  Future<void> _analyzeImage(File imageFile) async {
    setState(() {
      _isAnalyzing = true;
      _predictionResult = null;
    });

    try {
      String url = 'http://localhost:3000/upload';
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: basename(imageFile.path),
        ),
      });

      Response response = await dio.post(url, data: formData);

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        setState(() {
          _isAnalyzing = false;
          _predictionDetails = response.data['predictions'];
          _predictionResult = 'การวิเคราะห์เสร็จสิ้น';
        });
      } else {
        setState(() {
          _isAnalyzing = false;
          _predictionResult = 'เกิดข้อผิดพลาด: ${response.data['message']}';
        });
      }
    } catch (e) {
      setState(() {
        _isAnalyzing = false;
        _predictionResult = 'เกิดข้อผิดพลาด: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Prediction',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(33, 150, 243, 0.8),
                Color.fromRGBO(33, 150, 243, 1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(33, 150, 243, 0.1),
              Color.fromRGBO(33, 150, 243, 0.2),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 360),
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 4,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(
                              widget.image,
                              width: 320,
                              height: 320,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        if (_isAnalyzing)
                          Container(
                            width: 320,
                            height: 320,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Analyzing...',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (!_isAnalyzing && _predictionResult == null)
                      ElevatedButton(
                        onPressed: () => _analyzeImage(widget.image),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor:
                              const Color.fromRGBO(33, 150, 243, 1),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(
                                color: Color.fromRGBO(33, 150, 243, 1)),
                          ),
                          elevation: 6,
                        ).copyWith(
                          shadowColor: MaterialStateProperty.all(
                            const Color.fromRGBO(33, 150, 243, 0.4),
                          ),
                        ),
                        child: const Text(
                          'Analyze Image',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    const SizedBox(height: 20),
                    if (_predictionResult != null)
                      Column(
                        children: [
                          Text(
                            _predictionResult ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (_predictionDetails != null)
                            ..._predictionDetails!.map((result) => Text(
                                  '${result['class']}: ${result['probability']}%',
                                  style: const TextStyle(fontSize: 16),
                                )),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
