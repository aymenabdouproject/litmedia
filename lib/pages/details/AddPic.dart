import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FileUploadForm extends StatefulWidget {
  const FileUploadForm({super.key});

  @override
  _FileUploadFormState createState() => _FileUploadFormState();
}

class _FileUploadFormState extends State<FileUploadForm> {
  String? _filePath;

  Future<void> _pickFile() async {
    // Use FilePicker to pick a file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'txt'], // Specify allowed file types
    );

    if (result != null) {
      setState(() {
        _filePath = result.files.single.path; // Get the file path
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickFile,
      child: Container(
        width: 150,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: const Color.fromARGB(255, 248, 247, 255),
            width: 2,
          ),
        ),
        child: _filePath == null
            ? Center(
                child: Text(
                  'Upload your book in PDF or TXT format',
                  style: TextStyle(color: Colors.black54),
                ),
              )
            : Center(
                child: Text(
                  'File: ${_filePath!.split('/').last}', // Display the file name
                  style: TextStyle(color: Colors.black),
                ),
              ),
      ),
    );
  }
}
