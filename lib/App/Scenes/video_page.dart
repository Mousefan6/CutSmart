import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoDetailPage extends StatefulWidget {
  final List<String> videoIds;
  const VideoDetailPage({super.key, required this.videoIds});

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3D8CD),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('CutSmart', style: TextStyle(color: Color(0xFF7D5334), fontStyle: FontStyle.italic)),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // THE SWIPABLE VIDEO PLAYER SECTION
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: widget.videoIds.length,
                  onPageChanged: (int page) => setState(() => _currentPage = page),
                  itemBuilder: (context, index) {
                    return AnimatedBuilder(
                      animation: _pageController,
                      builder: (context, child) {
                        return _buildVideoCard(widget.videoIds[index]);
                      },
                    );
                  },
                ),
                // LEFT ARROW
                Positioned(left: 10, child: Icon(Icons.arrow_back_ios, color: Colors.black54, size: 30)),
                // RIGHT ARROW
                Positioned(right: 10, child: Icon(Icons.arrow_forward_ios, color: Colors.black54, size: 30)),
              ],
            ),
          ),

          // PAGE INDICATOR (The Dots)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.videoIds.length, (index) => _buildDot(index)),
          ),

          const SizedBox(height: 20),

          // MOCK BOTTOM NAV BAR (Matches your image)
          _buildBottomNav(),
        ],
      ),
    );
  }

  Widget _buildVideoCard(String youtubeId) {
    YoutubePlayerController _ytController = YoutubePlayerController(
      initialVideoId: youtubeId,
      flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: YoutubePlayer(
          controller: _ytController,
          showVideoProgressIndicator: true,
          progressIndicatorColor: const Color(0xFFB08968),
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return Container(
      height: 8,
      width: 8,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index ? Colors.black : Colors.black26,
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      color: const Color(0xFFB08968), // Brownish bottom nav
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.history, "History"),
          _navItem(Icons.bookmark_border, "Saved"),
          _navItem(Icons.crop_free, "Scanner", isBig: true),
          _navItem(Icons.person_outline, "Profile"),
          _navItem(Icons.settings_outlined, "Settings"),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, {bool isBig = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: isBig ? 40 : 28),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 10)),
      ],
    );
  }
}
