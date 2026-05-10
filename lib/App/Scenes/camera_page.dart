import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:typed_data';

import '../UI/menu_buttons.dart';
import '../Utils/ai_service.dart';
import '../UI/app_theme.dart'; // Import your theme system

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _controller;
  bool _isCameraOn = false;
  bool _isScanning = false;
  late GenerativeModel _model;

  @override
  void initState() {
    super.initState();
    final String apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    _model = GenerativeModel(
      model: 'gemini-2.5', // should/could make a vairable for this lol
      apiKey: apiKey,
    );
  }

  Future<void> _toggleCamera() async {
    if (_isCameraOn) {
      await _controller?.dispose();
      if (mounted) setState(() => _isCameraOn = false);
    } else {
      try {
        final cameras = await availableCameras();
        if (cameras.isEmpty) return;

        _controller = CameraController(
          cameras.first,
          ResolutionPreset.medium,
          enableAudio: false,
        );

        await _controller!.initialize();
        if (mounted) setState(() => _isCameraOn = true);
      } catch (e) {
        debugPrint("Camera Error: $e");
      }
    }
  }

  Future<void> _scanImage() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    setState(() => _isScanning = true);

    try {
      final XFile photo = await _controller!.takePicture();
      final Uint8List imageBytes = await photo.readAsBytes();

      final response = await _model.generateContent([
        Content.multi([
          TextPart("Identify this food and give brief nutritional info."),
          DataPart('image/jpeg', imageBytes)
        ])
      ]);

      _showResult(response.text ?? "Not found", imageBytes);
    } catch (e) {
      debugPrint("Scan error: $e");
    } finally {
      setState(() => _isScanning = false);
    }
  }

  Future<void> _handleImageUpload() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() => _isScanning = true);
      try {
        final Uint8List imageBytes = await image.readAsBytes();
        final String result = await AIService.identifyFood(imageBytes);
        _showResult(result, imageBytes);
      } catch (e) {
        debugPrint("Upload error: $e");
      } finally {
        setState(() => _isScanning = false);
      }
    }
  }

  void _showResult(String name, Uint8List? imageBytes) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.backgroundColor.value, // Themed bottom sheet
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (c) => Container(
        padding: const EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          children: [
            Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 15),
            Text("AI Results", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.accentColor.value)),
            const SizedBox(height: 15),
            if (imageBytes != null)
              Expanded(
                flex: 2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.memory(imageBytes, fit: BoxFit.cover),
                ),
              ),
            const SizedBox(height: 15),
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Text(name, style: TextStyle(fontSize: 16, color: AppTheme.accentColor.value)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AppTheme.backgroundColor,
      builder: (context, Color bgColor, child) {
        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'CutSmart',
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 24,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700,
                color: AppTheme.accentColor.value,
              ),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.84,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: AppTheme.accentColor.value.withOpacity(0.2), width: 2),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: _isCameraOn && _controller != null && _controller!.value.isInitialized
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: CameraPreview(_controller!),
                          )
                              : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.photo_camera_outlined, color: AppTheme.accentColor.value.withOpacity(0.5), size: 74),
                              const SizedBox(height: 10),
                              Text('Camera is off', style: TextStyle(color: AppTheme.accentColor.value.withOpacity(0.5), fontSize: 13)),
                            ],
                          ),
                        ),
                        // Upload button - themed background
                        Positioned(
                          top: 15,
                          right: 15,
                          child: GestureDetector(
                            onTap: _handleImageUpload,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.accentColor.value,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(Icons.file_upload_outlined, color: bgColor, size: 24),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isCameraOn ? (_isScanning ? null : _scanImage) : _toggleCamera,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentColor.value,
                      foregroundColor: bgColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                    ),
                    child: _isScanning
                        ? SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: bgColor))
                        : Text(
                      _isCameraOn ? 'SCAN PRODUCT' : 'TURN ON CAMERA',
                      style: const TextStyle(letterSpacing: 1.1, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const BottomMenuBar(),
            ],
          ),
        );
      },
    );
  }
}
