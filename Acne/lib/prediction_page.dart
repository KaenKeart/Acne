import 'package:flutter/material.dart';
import 'dart:io';
import 'AcneLevelsPage.dart'; // Import the AcneLevelsPage

class PredictionPage extends StatefulWidget {
  final File image;

  const PredictionPage({super.key, required this.image});

  @override
  _PredictionPageState createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  String? _predictionResult;
  bool _isAnalyzing = false;

  void _analyzeImage() {
    setState(() {
      _isAnalyzing = true;
      _predictionResult = null;
    });

    // Simulate image analysis (adding delay to simulate process)
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isAnalyzing = false;
        _predictionResult = 'Mild Acne'; // Simulated analysis result
      });
    });
  }

  void _showAcneLevelsPage() {
    if (_predictionResult != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AcneLevelsPage(acneLevel: _predictionResult!),
        ),
      );
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
          decoration: BoxDecoration(
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
        decoration: BoxDecoration(
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
                constraints: BoxConstraints(maxWidth: 360),
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
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
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
                        onPressed: _analyzeImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Color.fromRGBO(33, 150, 243, 1),
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                                color: Color.fromRGBO(33, 150, 243, 1)),
                          ),
                          elevation: 6,
                        ).copyWith(
                          shadowColor: MaterialStateProperty.all(
                            Color.fromRGBO(33, 150, 243, 0.4),
                          ),
                        ),
                        child: const Text(
                          'Analyze Image',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    const SizedBox(height: 20),
                    if (!_isAnalyzing && _predictionResult != null)
                      Column(
                        children: [
                          Text(
                            'Prediction Result: $_predictionResult',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: _showAcneLevelsPage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.green,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: Colors.green),
                              ),
                              elevation: 6,
                            ).copyWith(
                              shadowColor: MaterialStateProperty.all(
                                Colors.green.withOpacity(0.4),
                              ),
                            ),
                            child: const Text(
                              'View Detailed Analysis',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
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
