import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:litmedia/pages/model/multimedia.dart';
import 'package:litmedia/static/colors.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

// Dummy AppColors (replace with your actual colors)

class VideoPlayerPage extends StatefulWidget {
  final Multimedia mediaItem;

  const VideoPlayerPage({Key? key, required this.mediaItem}) : super(key: key);

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _controller;
  bool isLiked = false;
  bool isFavorited = false;
  bool _showPlayButton = true;
  Duration _videoDuration = Duration.zero;
  Duration _currentPosition = Duration.zero;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.mediaItem.mediaUrl)
      ..initialize().then((_) {
        setState(() {
          _videoDuration = _controller.value.duration;
          _showPlayButton = true;
        });
      });

    _controller.addListener(() {
      setState(() {
        _currentPosition = _controller.value.position;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleLike() => setState(() => isLiked = !isLiked);
  void toggleFavorite() => setState(() => isFavorited = !isFavorited);
  void shareMedia() {
    Share.share(
        'Check out this audiobook: ${widget.mediaItem.booktitle} by ${widget.mediaItem.bookauthor}. Listen here: ${widget.mediaItem.mediaUrl}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_controller.value.isPlaying) {
                          _controller.pause();
                          _showPlayButton = true;
                        } else {
                          _controller.play();
                          _showPlayButton = false;
                        }
                      });
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        _controller.value.isInitialized
                            ? VideoPlayer(_controller)
                            : const Center(child: CircularProgressIndicator()),
                        if (_showPlayButton && _controller.value.isInitialized)
                          IconButton(
                            iconSize: 80,
                            icon: Icon(
                              Icons.play_circle_filled,
                              color: AppColors.electricPurple,
                            ),
                            onPressed: () {
                              setState(() {
                                _controller.play();
                                _showPlayButton = false;
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                ProgressBar(
                  progress: _currentPosition,
                  total: _videoDuration,
                  onSeek: (duration) {
                    _controller.seekTo(duration);
                  },
                  timeLabelTextStyle: const TextStyle(color: Colors.white),
                  thumbColor: Colors.white,
                  baseBarColor: Colors.grey,
                  progressBarColor: AppColors.electricPurple,
                  bufferedBarColor: Colors.white24,
                ),
                const SizedBox(height: 16),

                const SizedBox(height: 16),
                // Buttons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: toggleLike,
                      icon: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : AppColors.offWhite,
                      ),
                    ),
                    IconButton(
                      onPressed: toggleFavorite,
                      icon: Icon(
                        isFavorited ? Icons.bookmark : Icons.bookmark_border,
                        color: isFavorited
                            ? AppColors.electricPurple
                            : AppColors.offWhite,
                      ),
                    ),
                    IconButton(
                      onPressed: shareMedia,
                      icon: const Icon(
                        Icons.share,
                        color: AppColors.offWhite,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Description Container
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.lightPurple,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "video Description",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.offWhite,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.mediaItem.desc?.isNotEmpty == true
                            ? widget.mediaItem.desc!
                            : "No description available.",
                        style: const TextStyle(
                          color: AppColors.grayPurple,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        widget.mediaItem.createdBy?.isNotEmpty == true
                            ? "Created by: ${widget.mediaItem.createdBy!}"
                            : "Created by: Unknown",
                        style: const TextStyle(
                          color: AppColors.offWhite,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Recommended Videos Title

                const SizedBox(height: 12),
                SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Linked book",
                          style: TextStyle(
                            color: AppColors.offWhite,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "${widget.mediaItem.booktitle?.trim().isNotEmpty == true ? widget.mediaItem.booktitle : 'Unknown Title'}"
                        " by "
                        "${widget.mediaItem.bookauthor?.trim().isNotEmpty == true ? widget.mediaItem.bookauthor : 'Unknown Author'}",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.035,
                          fontWeight: FontWeight.bold,
                          color: AppColors.offWhite,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height *
                            0.02, // smaller height for balance
                      ),
                      Text(
                        "This book is about:\n${widget.mediaItem.desc?.trim().isNotEmpty == true ? widget.mediaItem.desc : 'No description available.'}",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.035,
                          fontWeight: FontWeight.normal,
                          color: AppColors.offWhite,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Horizontal Recommended Video List
                /*  SizedBox(
                  height: MediaQuery.of(context).size.width * 9 / 12,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                "Video ${index + 1}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ), */
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Dummy MediaItem class for this example
class MediaItem {
  final String videoUrl;
  final String? desc;
  final String? createdBy;

  MediaItem({
    required this.videoUrl,
    this.desc,
    this.createdBy,
  });
}
