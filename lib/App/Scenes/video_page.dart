import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../UI/app_theme.dart';

class VideoDetailPage extends StatefulWidget {
  final String searchQuery;
  const VideoDetailPage({super.key, required this.searchQuery});

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  YoutubePlayerController? _controller;
  bool _isLoading = true;
  String? _foundVideoId;

  @override
  void initState() {
    super.initState();
    _findVideo();
  }

  Future<void> _findVideo() async {
    final yt = YoutubeExplode();
    try {
      // Searches YouTube for the query and takes the first result
      final videoSearch = await yt.search.search(widget.searchQuery);
      if (videoSearch.isNotEmpty) {
        setState(() {
          _foundVideoId = videoSearch.first.id.value;
          _controller = YoutubePlayerController(
            initialVideoId: _foundVideoId!,
            flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
          );
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Video search error: $e");
    } finally {
      yt.close();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor.value,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Tutorial: ${widget.searchQuery}"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: YoutubePlayer(
              controller: _controller!,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.redAccent,
            ),
          ),
        ),
      ),
    );
  }
}
