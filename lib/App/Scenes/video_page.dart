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
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _findVideo();
  }

  Future<void> _findVideo() async {
    final yt = YoutubeExplode();
    try {
      final videoSearch = await yt.search.search(widget.searchQuery);

      if (videoSearch.isNotEmpty && mounted) {
        setState(() {
          _controller = YoutubePlayerController(
            initialVideoId: videoSearch.first.id.value,
            flags: const YoutubePlayerFlags(
              autoPlay: true,
              mute: false,
            ),
          );
          _isLoading = false;
        });
      } else {
        if (mounted) setState(() => _hasError = true);
      }
    } catch (e) {
      if (mounted) setState(() => _hasError = true);
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
    final Color themeAccent = AppTheme.accentColor.value;

    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller ?? YoutubePlayerController(initialVideoId: ""),
        showVideoProgressIndicator: true,
        progressIndicatorColor: themeAccent,
      ),
      builder: (context, player) {
        return Scaffold(
          backgroundColor: AppTheme.backgroundColor.value,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: themeAccent),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              "Tutorial",
              style: TextStyle(
                  fontFamily: 'Georgia',
                  color: themeAccent,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _hasError
              ? Center(child: Text("Video unavailable", style: TextStyle(color: themeAccent)))
              : ListView( // Using ListView to handle all orientations/sizes safely
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              const SizedBox(height: 20),

              // CLEAR FOOD NAME
              Text(
                _formatTitle(widget.searchQuery),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: themeAccent,
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                  letterSpacing: 1.5,
                  fontFamily: 'Georgia',
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "CUTTING TECHNIQUE",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: themeAccent.withOpacity(0.6),
                  fontSize: 12,
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: 30),

              // THE PLAYER
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: themeAccent.withOpacity(0.1)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: player,
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  // Helper to make the title look good
  String _formatTitle(String query) {
    return query
        .toLowerCase()
    // Aggressively remove all common filler words
        .replaceAll('how to cut', '')
        .replaceAll('tutorial', '')
        .replaceAll('youtube', '')
        .replaceAll('video', '')
        .replaceAll('an ', ' ') // Removes "an " if it's "an onion"
        .replaceAll('a ', ' ')  // Removes "a " if it's "a potato"
        .trim()
        .toUpperCase();
  }
}
