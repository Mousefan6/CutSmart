import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../UI/app_theme.dart';
import '../UI/menu_buttons.dart'; // Import your global menu bar

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
  void dispose() {
    _pageController.dispose();
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
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: AppTheme.accentColor.value),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'CutSmart',
              style: TextStyle(
                color: AppTheme.accentColor.value,
                fontStyle: FontStyle.italic,
                fontFamily: 'Georgia',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: Column(
            children: [
              const SizedBox(height: 20),
              // SWIPEABLE VIDEO PLAYER SECTION
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      itemCount: widget.videoIds.length,
                      onPageChanged: (int page) => setState(() => _currentPage = page),
                      itemBuilder: (context, index) {
                        return _buildVideoCard(widget.videoIds[index]);
                      },
                    ),
                    // LEFT ARROW
                    Positioned(
                      left: 10,
                      child: Icon(Icons.arrow_back_ios,
                          color: AppTheme.accentColor.value.withOpacity(0.5),
                          size: 30),
                    ),
                    // RIGHT ARROW
                    Positioned(
                      right: 10,
                      child: Icon(Icons.arrow_forward_ios,
                          color: AppTheme.accentColor.value.withOpacity(0.5),
                          size: 30),
                    ),
                  ],
                ),
              ),

              // PAGE INDICATOR (The Dots)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.videoIds.length, (index) => _buildDot(index)),
              ),

              const SizedBox(height: 20),

              // REAL BOTTOM MENU BAR (Replaces the mock version)
              const BottomMenuBar(),
            ],
          ),
        );
      },
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
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5)
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: YoutubePlayer(
          controller: _ytController,
          showVideoProgressIndicator: true,
          // Progress bar matches the accent color of the theme
          progressIndicatorColor: AppTheme.accentColor.value,
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
        color: _currentPage == index
            ? AppTheme.accentColor.value
            : AppTheme.accentColor.value.withOpacity(0.3),
      ),
    );
  }
}
