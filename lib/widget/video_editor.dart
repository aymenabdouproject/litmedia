/*import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_editor_sdk/video_editor_sdk.dart'; // Ensure you have the correct video editor package
 // Add ffmpeg_kit_flutter for export

class VideoEditorWidget extends StatefulWidget {
  final File videoFile;

  const VideoEditorWidget({super.key, required this.videoFile});

  @override
  _VideoEditorWidgetState createState() => _VideoEditorWidgetState();
}

class _VideoEditorWidgetState extends State<VideoEditorWidget> {
  late final VideoEditorController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoEditorController.file(
      widget.videoFile,
      minDuration: const Duration(seconds: 1),
      maxDuration: const Duration(seconds: 10),
    );
    _controller.initialize().then((_) => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Export the video as it is
  Future<void> exportVideo() async {
    final config = VideoFFmpegVideoEditorConfig(_controller);
    final FFmpegVideoEditorExecute execute = await config.getExecuteConfig();

    // Run your custom logic to handle video export
    FFmpegKit.executeAsync(execute.command, (session) {
      print("Video exported to: ${execute.outputPath}");
      Fluttertoast.showToast(
        msg: "Video exported successfully to ${execute.outputPath}",
        backgroundColor: Colors.green,
      );
    });
  }

  /// Export the video as a GIF
  Future<void> exportGif() async {
    final gifConfig = VideoFFmpegVideoEditorConfig(
      _controller,
      format: VideoExportFormat.gif,
    );
    final FFmpegVideoEditorExecute gifExecute =
        await gifConfig.getExecuteConfig();

    // Handle GIF export logic
    FFmpegKit.executeAsync(gifExecute.command, (session) {
      print("GIF exported to: ${gifExecute.outputPath}");
      Fluttertoast.showToast(
        msg: "GIF exported successfully to ${gifExecute.outputPath}",
        backgroundColor: Colors.green,
      );
    });
  }

  /// Export the video with a horizontal flip (mirrored)
  Future<void> exportMirroredVideo() async {
    final mirrorConfig = VideoFFmpegVideoEditorConfig(
      _controller,
      name: 'mirror-video',
      commandBuilder: (VideoFFmpegVideoEditorConfig config, String videoPath,
          String outputPath) {
        final List<String> filters = config.getExportFilters();
        filters.add('hflip'); // Add horizontal flip filter

        return '-i $videoPath ${config.filtersCmd(filters)} -preset ultrafast $outputPath';
      },
    );
    final FFmpegVideoEditorExecute mirrorExecute =
        await mirrorConfig.getExecuteConfig();

    // Run your custom logic to handle mirrored video export
    FFmpegKit.executeAsync(mirrorExecute.command, (session) {
      print("Mirrored video exported to: ${mirrorExecute.outputPath}");
      Fluttertoast.showToast(
        msg:
            "Mirrored video exported successfully to ${mirrorExecute.outputPath}",
        backgroundColor: Colors.green,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video Editor"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!_controller.initialized)
            const CircularProgressIndicator()
          else
            AspectRatio(
              aspectRatio: _controller.video.value.aspectRatio,
              child: VideoPlayer(_controller.video),
            ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton(
                onPressed: exportVideo,
                child: const Text("Export Video"),
              ),
              ElevatedButton(
                onPressed: exportGif,
                child: const Text("Export GIF"),
              ),
              ElevatedButton(
                onPressed: exportMirroredVideo,
                child: const Text("Export Mirrored Video"),
              ),
            ],
          ),
        ],
      ),
    );
  }
} */
