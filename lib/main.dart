import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تشخیص حشرات قرنطینه',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const InsectDetectorScreen(),
    );
  }
}

class InsectDetectorScreen extends StatefulWidget {
  const InsectDetectorScreen({super.key});
  @override
  State<InsectDetectorScreen> createState() => _InsectDetectorScreenState();
}

class _InsectDetectorScreenState extends State<InsectDetectorScreen> {
  Interpreter? _interpreter;
  List<String> _labels = [];
  File? _imageFile;
  String _resultText = "لطفاً یک تصویر انتخاب کنید.";
  bool _isProcessing = false;

  final int _inputSize = 224;
  final int _numClasses = 40;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/best_float32.tflite');
      String labelsData = await DefaultAssetBundle.of(context)
          .loadString('assets/labels.txt');
      _labels = labelsData
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      setState(() {});
    } catch (e) {
      setState(() {
        _resultText = "خطا در بارگذاری مدل: $e";
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 85);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _resultText = "در حال پردازش...";
        _isProcessing = true;
      });
      await _runModelOnImage(_imageFile!);
    }
  }

  Future<void> _runModelOnImage(File imageFile) async {
    if (_interpreter == null) {
      setState(() {
        _resultText = "مدل هنوز بارگذاری نشده است.";
        _isProcessing = false;
      });
      return;
    }

    try {
      img.Image? image = img.decodeImage(imageFile.readAsBytesSync());
      if (image == null) {
        setState(() {
          _resultText = "خطا در خواندن تصویر.";
          _isProcessing = false;
        });
        return;
      }

      img.Image resizedImage = img.copyResize(image, width: _inputSize, height: _inputSize);

      var input = List.filled(1 * _inputSize * _inputSize * 3, 0.0)
          .reshape([1, _inputSize, _inputSize, 3]);
      for (int y = 0; y < _inputSize; y++) {
        for (int x = 0; x < _inputSize; x++) {
          var pixel = resizedImage.getPixel(x, y);
          input[0][y][x][0] = pixel.r / 255.0;
          input[0][y][x][1] = pixel.g / 255.0;
          input[0][y][x][2] = pixel.b / 255.0;
        }
      }

      var output = List.filled(1 * _numClasses, 0.0).reshape([1, _numClasses]);
      _interpreter!.run(input, output);

      double maxProb = 0.0;
      int predictedIndex = 0;
      for (int i = 0; i < _numClasses; i++) {
        if (output[0][i] > maxProb) {
          maxProb = output[0][i];
          predictedIndex = i;
        }
      }

      setState(() {
        String className = (predictedIndex < _labels.length)
            ? _labels[predictedIndex]
            : "نامشخص";
        _resultText =
            "✅ حشره تشخیص داده شده:\n$className\n\n📊 میزان اطمینان: ${(maxProb * 100).toStringAsFixed(1)}%";
        _isProcessing = false;
      });
    } catch (e) {
      setState(() {
        _resultText = "خطا در پردازش: $e";
        _isProcessing = false;
      });
    }
  }

  @override
  void dispose() {
    _interpreter?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تشخیص حشرات قرنطینه‌ای'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_imageFile != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.file(_imageFile!, height: 250, fit: BoxFit.cover),
                )
              else
                const Icon(Icons.bug_report, size: 120, color: Colors.grey),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _isProcessing ? null : () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('دوربین'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton.icon(
                    onPressed: _isProcessing ? null : () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('گالری'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              if (_isProcessing)
                const CircularProgressIndicator(color: Colors.green)
              else
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.green.shade300, width: 2),
                  ),
                  child: Text(
                    _resultText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
