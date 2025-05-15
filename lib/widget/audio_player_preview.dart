import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as http_parser;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerPreview extends StatefulWidget {
  final void Function(String url, String mediaType) onMediaUploaded;

  const AudioPlayerPreview({required this.onMediaUploaded, super.key});

  @override
  State<AudioPlayerPreview> createState() => _AudioPlayerPreviewState();
}

class _AudioPlayerPreviewState extends State<AudioPlayerPreview> {
  bool _isUploading = false;
  File? _audioFile;
  final _audioPlayer = AudioPlayer();
  String? _uploadedMediaUrl;

  Future<void> _pickAndUploadAudio() async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.audio);
      if (result == null || result.files.single.path == null) {
        Fluttertoast.showToast(msg: "No audio selected");
        return;
      }
      final file = File(result.files.single.path!);
      setState(() {
        _isUploading = true;
      });

      final request = http.MultipartRequest(
        'POST',
        Uri.parse("https://api.cloudinary.com/v1_1/didoedsrv/auto/upload"),
      );

      request.fields['upload_preset'] = 'audio-audio';
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
          contentType: http_parser.MediaType('audio', 'octet-stream'),
        ),
      );

      final response = await request.send();

      if (response.statusCode == 200) {
        final resStr = await response.stream.bytesToString();
        final json = jsonDecode(resStr);
        if (json['secure_url'] != null) {
          final url = json['secure_url'];

          setState(() {
            _audioFile = file;
            _uploadedMediaUrl = url;
            _isUploading = false;
          });

          widget.onMediaUploaded(_uploadedMediaUrl!, 'audio');

          try {
            await _audioPlayer.setFilePath(file.path);
          } catch (e) {
            Fluttertoast.showToast(msg: "Audio playback error: $e");
          }
        } else {
          setState(() => _isUploading = false);
          Fluttertoast.showToast(msg: "Upload failed: Missing secure_url");
        }
      } else {
        setState(() => _isUploading = false);
        Fluttertoast.showToast(msg: "Upload failed: ${response.statusCode}");
      }
    } catch (e) {
      setState(() => _isUploading = false);
      Fluttertoast.showToast(msg: "Upload error: $e");
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              onPressed: _isUploading ? null : _pickAndUploadAudio,
              icon: const Icon(Icons.upload_file),
              label: Text(
                _isUploading ? "Uploading..." : "Pick & Upload Audio",
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isUploading ? Colors.grey : Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_audioFile != null) ...[
              Text(
                "Uploaded File: ${_audioFile!.path.split('/').last}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        await _audioPlayer.play();
                      } catch (e) {
                        Fluttertoast.showToast(msg: "Error playing audio: $e");
                      }
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text("Play"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        await _audioPlayer.stop();
                      } catch (e) {
                        Fluttertoast.showToast(msg: "Error stopping audio: $e");
                      }
                    },
                    icon: const Icon(Icons.stop),
                    label: const Text("Stop"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
            if (_isUploading) ...[
              const SizedBox(height: 16),
              const CircularProgressIndicator(),
            ],
          ],
        ),
      ),
    );
  }
}
