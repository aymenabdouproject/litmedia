import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:litmedia/pages/menuPages/createContent.dart';

class ImagePreviewArea extends StatefulWidget {
  final void Function(String url, String mediaType) onMediaUploaded;

  const ImagePreviewArea({super.key, required this.onMediaUploaded});

  @override
  State<ImagePreviewArea> createState() => _ImagePreviewAreaState();
}

class _ImagePreviewAreaState extends State<ImagePreviewArea> {
  File? _imageFile;
  String? _uploadedMediaUrl;
  bool isUploading = false;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) {
      Fluttertoast.showToast(
        msg: "No image selected",
        backgroundColor: Colors.red,
      );
      return;
    }

    final imageFile = File(picked.path);

    // Validate file size (limit to 5MB)
    if (imageFile.lengthSync() > 5 * 1024 * 1024) {
      Fluttertoast.showToast(
        msg: "File size exceeds 5MB limit",
        backgroundColor: Colors.red,
      );
      return;
    }

    setState(() {
      _imageFile = imageFile;
      isUploading = true;
    });

    final url = await uploadToImageKit(imageFile, picked.name);

    if (url != null) {
      setState(() {
        _uploadedMediaUrl = url;
      });

      // Pass the URL to the parent widget
      widget.onMediaUploaded(_uploadedMediaUrl!, 'image');

      Fluttertoast.showToast(
        msg: "Image uploaded successfully.",
        backgroundColor: Colors.green,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Image upload failed.",
        backgroundColor: Colors.red,
      );
    }

    setState(() {
      isUploading = false;
    });
  }

  Future<String?> uploadToImageKit(File file, String fileName) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://upload.imagekit.io/api/v1/files/upload'),
    );

    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    request.fields['fileName'] = fileName;

    // Replace API key with a secure method of retrieval (e.g., environment variable)
    const privateApiKey = 'private_9MoH0BcI0CyoI+15FSakzzoFSqs=';
    final basicAuth = 'Basic ${base64Encode(utf8.encode('$privateApiKey:'))}';
    request.headers['Authorization'] = basicAuth;

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['url'] == null) {
          throw Exception("No URL returned in response");
        }
        return data['url'];
      } else {
        print("Upload failed with status code: ${response.statusCode}");
        print("Response: ${response.body}");
        Fluttertoast.showToast(
          msg: "Failed to upload image. Please try again.",
          backgroundColor: Colors.red,
        );
        return null;
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error: $e",
        backgroundColor: Colors.red,
      );
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: isUploading ? null : pickImage,
          child: isUploading
              ? const CircularProgressIndicator()
              : const Text("Upload Image"),
        ),
        if (_imageFile != null) ...[
          const SizedBox(height: 10),
          Image.file(_imageFile!, width: 200, height: 200),
        ],
        if (_uploadedMediaUrl != null) ...[
          const SizedBox(height: 10),
          Text("ImageKit URL: $_uploadedMediaUrl"),
        ]
      ],
    );
  }
}
