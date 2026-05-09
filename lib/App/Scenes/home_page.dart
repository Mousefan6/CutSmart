import 'package:cutsmart/App/Scenes/video_page.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:typed_data';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CameraController? _controller;
  bool _isCameraOn = false;
  bool _isScanning = false;
  late GenerativeModel _model;

  @override
  void initState() {
    super.initState();
    // Setup Gemini
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: '',
    );
  }

  Future<void> _toggleCamera() async {
    if (_isCameraOn) {
      await _controller?.dispose();
      setState(() => _isCameraOn = false);
    } else {
      final cameras = await availableCameras();
      _controller = CameraController(cameras.first, ResolutionPreset.medium);
      await _controller!.initialize();
      setState(() => _isCameraOn = true);
    }
  }

  // Logic to capture buffer and scan
  Future<void> _scanImage() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    setState(() => _isScanning = true);

    try {
      // 1. Get the image buffer (bytes)
      final XFile photo = await _controller!.takePicture();
      final Uint8List imageBytes = await photo.readAsBytes();

      // 2. Prompt for gemini
      // Need to set to only detect lowercase
      final prompt = TextPart("Identify this food. Return only the name.");
      final imagePart = DataPart('image/jpeg', imageBytes);

      // 3. Send to AI
      final response = await _model.generateContent([
        Content.multi([prompt, imagePart])
      ]);

      _showResult(response.text ?? "Not found");
    } finally {
      setState(() => _isScanning = false);
    }
  }

  void _showResult(String name) {
    showModalBottomSheet(
      context: context,
      builder: (c) => Container(
        padding: const EdgeInsets.all(20),
        height: 150,
        width: double.infinity,
        child: Text("AI Detected: $name", style: const TextStyle(fontSize: 20)),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Widget _buildSmallActionBox({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.26,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFB08968).withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF7D5334)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
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
                child: _isCameraOn && _controller != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: CameraPreview(_controller!),
                )
                    : const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.photo_camera_outlined,
                        color: Colors.white54,
                        size: 74,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Camera is off',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 26 / 2,
                        ),
                      ),
                    ],
                  ),
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

          // 2. THE BACKGROUND BOX (Starts after the button)

        ],
      ),
    );
  }
}
