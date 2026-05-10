import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:typed_data';

import '../UI/menu_buttons.dart';
import '../Utils/ai_service.dart';

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
      model: 'gemini-1.5-flash',
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
          enableAudio: false, // Disabling audio speeds up initialization
        );

        await _controller!.initialize();
        if (mounted) setState(() => _isCameraOn = true);
      } catch (e) {
        debugPrint("Camera Error: $e");
      }
    }
  }

  // Logic to capture buffer and scan
  Future<void> _scanImage() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    setState(() => _isScanning = true);

    try {
      final XFile photo = await _controller!.takePicture();
      final Uint8List imageBytes = await photo.readAsBytes();

      final prompt = TextPart("Identify this food. Return only the name."); // PROMPT FOR GEMINI
      final imagePart = DataPart('image/jpeg', imageBytes);

      final response = await _model.generateContent([
        Content.multi([prompt, imagePart])
      ]);

      _showResult(response.text ?? "Not found", imageBytes);
    } finally {
      setState(() => _isScanning = false);
    }
  }

  Future<void> _handleImageUpload() async {
    final ImagePicker picker = ImagePicker();
    // This opens File Explorer on PC or Gallery on Mobile
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80, // Edit for Gemini processing speed, lower quality = faster processing
    );

    if (image != null) {
      setState(() => _isScanning = true);
      try {
        // Convert to bytes for Gemini
        final Uint8List imageBytes = await image.readAsBytes();
        // Send to gemini
        final String result = await AIService.identifyFood(imageBytes);
        _showResult(result, imageBytes);
      } catch (e) {
        debugPrint("Upload error: $e");
      } finally {
        setState(() => _isScanning = false);
      }
    }
  }

  // void _showResult(String name) { // NAME ONLY!!!
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (c) => Container(
  //       padding: const EdgeInsets.all(20),
  //       height: 150,
  //       width: double.infinity,
  //       child: Text("AI Detected: $name", style: const TextStyle(fontSize: 20)),
  //     ),
  //   );
  // }

  void _showResult(String name, Uint8List? imageBytes) { // Shows image too
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows sheet to expand
      builder: (c) => Container(
        padding: const EdgeInsets.all(20),
        height: 400, // Make it taller to fit the image
        width: double.infinity,
        child: Column(
          children: [
            Text("AI Detected: $name", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            if (imageBytes != null)
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.memory(imageBytes, fit: BoxFit.cover),
                ),
              ),
            const SizedBox(height: 10),
            const Text("Testing Preview", style: TextStyle(color: Colors.grey)),
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
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xFFE3D8CD),
          elevation: 0,
          title: const Text(
              'CutSmart',
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: 24,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w700,
              color: Color(0xFF7D5334),
            ),
          ),
      ),
      backgroundColor: const Color(0xFFE3D8CD),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.84,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Stack(
                  children: [
                    Center(
                      child:
                      _isCameraOn && _controller != null && _controller!.value.isInitialized
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: AspectRatio(
                          aspectRatio: _controller!.value.aspectRatio,
                          child: CameraPreview(_controller!),
                        ),
                      )
                          : const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.photo_camera_outlined, color: Colors.white54, size: 74),
                          SizedBox(height: 10),
                          Text('Camera is off', style: TextStyle(color: Colors.white54, fontSize: 13)),
                        ],
                      ),
                    ),

                    // Upload button
                    Positioned(
                      top: 15,
                      right: 15,
                      child: GestureDetector(
                        onTap: _handleImageUpload,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.file_upload_outlined, // This matches your image's icon style
                            color: Colors.white,
                            size: 24,
                          ),
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
                  backgroundColor: const Color(0xFF7F5539), // Rich brown
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4, // Added a little shadow to make it "float"
                ),
                child: _isScanning
                    ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
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
  }
}
