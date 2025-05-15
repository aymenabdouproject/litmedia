import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:litmedia/pages/model/multimedia.dart';
import 'package:litmedia/static/colors.dart';
import 'package:share_plus/share_plus.dart';

class AudioPlayerUrl extends StatefulWidget {
  final Multimedia mediaItem;

  const AudioPlayerUrl({super.key, required this.mediaItem});

  @override
  _AudioPlayerUrlState createState() => _AudioPlayerUrlState();
}

class _AudioPlayerUrlState extends State<AudioPlayerUrl> {
  AudioPlayer audioPlayer = AudioPlayer();
  PlayerState audioPlayerState = PlayerState.paused;
  String? bookCoverUrl;
  String? bookAuthor;

  int timeProgress = 0;
  int audioDuration = 0;

  bool isLoading = true;
  bool isLiked = false; // Tracks the like status
  bool isFavorited = false; // Tracks the favorite status

  Widget slider() {
    return Slider.adaptive(
      value: timeProgress.toDouble(),
      max: audioDuration.toDouble(),
      activeColor: AppColors.electricPurple,
      inactiveColor: AppColors.purpleclair,
      onChanged: (value) {
        seekToSec(value.toInt());
      },
    );
  }

  @override
  void initState() {
    super.initState();
    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        audioPlayerState = state;
      });
    });

    audioPlayer.setSourceUrl(widget.mediaItem.mediaUrl);
    audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        audioDuration = duration.inSeconds;
      });
    });
    audioPlayer.onPositionChanged.listen((Duration position) {
      setState(() {
        timeProgress = position.inSeconds;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.stop();
    audioPlayer.release();
    audioPlayer.dispose();
    super.dispose();
  }

  playMusic() async {
    await audioPlayer.play(UrlSource(widget.mediaItem.mediaUrl));
  }

  pauseMusic() async {
    await audioPlayer.pause();
  }

  void seekToSec(int sec) {
    Duration newPos = Duration(seconds: sec);
    audioPlayer.seek(newPos);
  }

  String getTimeString(int seconds) {
    String minuteString =
        '${(seconds / 60).floor() < 10 ? 0 : ''}${(seconds / 60).floor()}';
    String secondString = '${seconds % 60 < 10 ? 0 : ''}${seconds % 60}';
    return '$minuteString:$secondString';
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
    // Optionally, save like status to Firestore
    FirebaseFirestore.instance
        .collection('likes')
        .doc(widget.mediaItem.bookId)
        .set({
      'liked': isLiked,
      'mediaId': widget.mediaItem.bookId,
    });
  }

  void toggleFavorite() {
    setState(() {
      isFavorited = !isFavorited;
    });
    // Optionally, save favorite status to Firestore
    FirebaseFirestore.instance
        .collection('favorites')
        .doc(widget.mediaItem.bookId)
        .set({
      'favorited': isFavorited,
      'mediaId': widget.mediaItem.bookId,
    });
  }

  void shareMedia() {
    Share.share(
        'Check out this audiobook: ${widget.mediaItem.booktitle} by ${widget.mediaItem.bookauthor}. Listen here: ${widget.mediaItem.mediaUrl}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkPurple,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.mediumPurple,
                              AppColors.lightPurple
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.grayPurple.withOpacity(0.5),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.mediaItem.caption ?? "Now Playing",
                              style: const TextStyle(
                                color: AppColors.offWhite,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            IconButton(
                              iconSize: 80,
                              icon: Icon(
                                audioPlayerState == PlayerState.playing
                                    ? Icons.pause_circle_filled
                                    : Icons.play_circle_filled,
                                color: AppColors.electricPurple,
                              ),
                              onPressed: () {
                                audioPlayerState == PlayerState.playing
                                    ? pauseMusic()
                                    : playMusic();
                              },
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  getTimeString(timeProgress),
                                  style: const TextStyle(
                                    color: AppColors.offWhite,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(child: slider()),
                                const SizedBox(width: 10),
                                Text(
                                  getTimeString(audioDuration),
                                  style: const TextStyle(
                                    color: AppColors.offWhite,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: toggleLike,
                            icon: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: isLiked
                                  ? Colors.red
                                  : AppColors.offWhite, // Dynamic color
                            ),
                          ),
                          IconButton(
                            onPressed: toggleFavorite,
                            icon: Icon(
                              isFavorited
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
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
                              "Audio Description",
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
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                /* Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.15,
                                  height:
                                      MediaQuery.of(context).size.height * 0.12,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: (widget.mediaItem.bookCoverUrl !=
                                                  null &&
                                              widget.mediaItem.bookCoverUrl!
                                                  .startsWith('http'))
                                          ? NetworkImage(
                                              widget.mediaItem.bookCoverUrl!)
                                          : const AssetImage(
                                                  'assets/images/default_cover.png')
                                              as ImageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ), */

                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.02,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${widget.mediaItem.booktitle?.trim().isNotEmpty == true ? widget.mediaItem.booktitle : 'Unknown Title'}"
                                        " by "
                                        "${widget.mediaItem.bookauthor?.trim().isNotEmpty == true ? widget.mediaItem.bookauthor : 'Unknown Author'}",
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.035,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.offWhite,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                        height: MediaQuery.of(context)
                                                .size
                                                .height *
                                            0.02, // smaller height for balance
                                      ),
                                      Text(
                                        "This book is about:\n${widget.mediaItem.desc?.trim().isNotEmpty == true ? widget.mediaItem.desc : 'No description available.'}",
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.035,
                                          fontWeight: FontWeight.normal,
                                          color: AppColors.offWhite,
                                        ),
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isNetworkUrl(String url) {
    return url.startsWith("http");
  }
}
