import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as http_parser;
import 'package:litmedia/pages/menuPages/createContent.dart' as content;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:litmedia/widget/video_editor.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPreview extends StatefulWidget {
  final void Function(String url, String mediaType) onMediaUploaded;

  const VideoPlayerPreview({required this.onMediaUploaded, super.key});

  @override
  _video_uploadState createState() => _video_uploadState();
}

class _video_uploadState extends State<VideoPlayerPreview> {
  bool _isUploading = false;
  File? _videoFile;
  VideoPlayerController? _videoPlayerController;
  String? _uploadedMediaUrl;

  Future<void> _pickAndUploadVideo() async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.video);
      if (result == null || result.files.single.path == null) {
        Fluttertoast.showToast(msg: "No video selected");
        return;
      }

      final file = File(result.files.single.path!);
      setState(() {
        _isUploading = true;
      });

      final request = http.MultipartRequest('POST',
          Uri.parse("https://api.cloudinary.com/v1_1/didoedsrv/auto/upload"));

      request.fields['upload_preset'] = 'video-upload';
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
          contentType: http_parser.MediaType('video', 'mp4'), // Example for MP4
        ),
      );

      final response = await request.send();

      if (response.statusCode == 200) {
        final resStr = await response.stream.bytesToString();
        final json = jsonDecode(resStr);
        if (json['secure_url'] != null) {
          final url = json['secure_url'];

          setState(() {
            _videoFile = file;
            _uploadedMediaUrl = url;
            _isUploading = false;
          });

          widget.onMediaUploaded(_uploadedMediaUrl!, 'video');

          // Initialize Video Player
          _videoPlayerController = VideoPlayerController.file(file)
            ..initialize().then((_) {
              setState(() {}); // Refresh to show video player
              _videoPlayerController?.play();
            });
        } else {
          setState(() => _isUploading = false);
          Fluttertoast.showToast(msg: "Upload failed: Missing secure_url");
        }
      } else {
        setState(() => _isUploading = false);
        Fluttertoast.showToast(msg: "Upload failed : ${response.statusCode}");
      }
    } catch (e) {
      setState(() => _isUploading = false);
      Fluttertoast.showToast(msg: "Upload error: $e");
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: _isUploading ? null : _pickAndUploadVideo,
          child: Text(_isUploading ? "Uploading..." : "Pick & Upload Video"),
        ),
        if (_videoFile != null) ...[
          Text("Uploaded File: ${_videoFile!.path.split('/').last}"),
          if (_uploadedMediaUrl != null) Text("Video URL: $_uploadedMediaUrl"),
          if (_videoPlayerController != null &&
              _videoPlayerController!.value.isInitialized)
            AspectRatio(
              aspectRatio: _videoPlayerController!.value.aspectRatio,
              child: VideoPlayer(_videoPlayerController!),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _videoPlayerController != null &&
                        _videoPlayerController!.value.isInitialized
                    ? () {
                        setState(() {
                          _videoPlayerController?.play();
                        });
                      }
                    : null,
                icon: Icon(Icons.play_arrow),
                label: Text("Play"),
              ),
              SizedBox(width: 10), // Add spacing between buttons
              ElevatedButton.icon(
                onPressed: _videoPlayerController != null &&
                        _videoPlayerController!.value.isInitialized
                    ? () {
                        setState(() {
                          _videoPlayerController?.pause();
                        });
                      }
                    : null,
                icon: Icon(Icons.pause),
                label: Text("Pause"),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  /* VideoEditorWidget(
                    videoFile: File('url'),
                  ); */
                },
                child: Text('Edit the video'),
              ),
            ],
          ),
        ],
        if (_isUploading) CircularProgressIndicator(),
      ],
    );
  }
}
