import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

import '../UI/menu_buttons.dart';
import '../Utils/ai_service.dart';
import '../UI/app_theme.dart';
import './food_detail_page.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _controller;
  bool _isCameraOn = false;
  bool _isScanning = false;
  Future<bool> _showConfirmationDialog(String name) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundColor.value,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Is this $name?",
          textAlign: TextAlign.center,
          style: TextStyle(color: AppTheme.accentColor.value),
        ),
        content: const Text(
          "Confirming ensures the safety tips are accurate for your food.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          // No / Rescan Button
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("NO, RESCAN", style: TextStyle(color: Colors.redAccent[100])),
          ),
          // Yes Button
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentColor.value,
              foregroundColor: AppTheme.backgroundColor.value,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("YES, THAT'S IT"),
          ),
        ],
      ),
    ) ?? false; // Default to false if they tap outside the dialog
  }

  @override
  void initState() {
    super.initState();
    // No need to initialize _model here anymore, AIService handles it!
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

  Future<void> _processImage(Uint8List imageBytes) async {
    setState(() => _isScanning = true);
    try {
      final Map<String, dynamic> result = await AIService.identifyFood(imageBytes);
      final String foodName = result['name'] ?? "Unknown";

      if (!mounted) return;

      // 1. Ask for confirmation
      bool confirmed = await _showConfirmationDialog(foodName);

      // 2. If yes, go to the Detail Scene
      if (confirmed && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoodDetailPage(
              foodData: result,
              imageBytes: imageBytes,
            ),
          ),
        );
      }
      // If no, we do nothing and the user is back at the camera to rescan
    } catch (e) {
      debugPrint("Processing error: $e");
    } finally {
      setState(() => _isScanning = false);
    }
  }

  Future<void> _scanImage() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    try {
      final XFile photo = await _controller!.takePicture();
      final Uint8List imageBytes = await photo.readAsBytes();
      await _processImage(imageBytes);
    } catch (e) {
      debugPrint("Scan error: $e");
    }
  }

  Future<void> _handleImageUpload() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (image != null) {
      final Uint8List imageBytes = await image.readAsBytes();
      await _processImage(imageBytes);
    }
  }

  void _showResult(Map<String, dynamic> data, Uint8List imageBytes) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.backgroundColor.value,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (c) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, scrollController) => Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            controller: scrollController,
            children: [
              Center(child: Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(10)))),
              const SizedBox(height: 20),
              Text(
                (data['name'] ?? "Unknown Food").toString().toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppTheme.accentColor.value),
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.memory(imageBytes, height: 200, fit: BoxFit.cover),
              ),
              const SizedBox(height: 25),
              _buildSectionTitle("Cutting Safety Tips"),
              ...(data['cutting_safety_tips'] as List? ?? ["No tips available"]).map((tip) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text("• $tip", style: TextStyle(color: AppTheme.accentColor.value, fontSize: 15)),
              )),
              const Divider(height: 40),
              _buildSectionTitle("Nutrition (per 100g)"),
              _buildNutritionRow("Calories", data['nutritional_facts_per_100g']?['calories']),
              _buildNutritionRow("Protein", data['nutritional_facts_per_100g']?['protein']),
              _buildNutritionRow("Fat", data['nutritional_facts_per_100g']?['fat']),
              _buildNutritionRow("Carbs", data['nutritional_facts_per_100g']?['carbs']),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.accentColor.value)),
    );
  }

  Widget _buildNutritionRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: AppTheme.accentColor.value.withOpacity(0.8))),
          Text(value?.toString() ?? "N/A", style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.accentColor.value)),
        ],
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
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text('CutSmart', style: TextStyle(fontFamily: 'Georgia', fontSize: 24, fontStyle: FontStyle.italic, fontWeight: FontWeight.w700, color: AppTheme.accentColor.value)),
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
                              ? ClipRRect(borderRadius: BorderRadius.circular(28), child: CameraPreview(_controller!))
                              : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.photo_camera_outlined, color: AppTheme.accentColor.value.withOpacity(0.5), size: 74),
                              const SizedBox(height: 10),
                              Text('Camera is off', style: TextStyle(color: AppTheme.accentColor.value.withOpacity(0.5), fontSize: 13)),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 15,
                          right: 15,
                          child: GestureDetector(
                            onTap: _handleImageUpload,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: AppTheme.accentColor.value, borderRadius: BorderRadius.circular(10)),
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
                    ),
                    child: _isScanning
                        ? SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: bgColor))
                        : Text(_isCameraOn ? 'SCAN PRODUCT' : 'TURN ON CAMERA', style: const TextStyle(fontWeight: FontWeight.bold)),
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
