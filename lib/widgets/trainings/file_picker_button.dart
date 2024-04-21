import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FilePickerButton extends StatefulWidget {
  final ValueChanged<File?> onFilePicked;

  const FilePickerButton({Key? key, required this.onFilePicked}) : super(key: key);

  @override
  _FilePickerButtonState createState() => _FilePickerButtonState();
}

class _FilePickerButtonState extends State<FilePickerButton> {
  File? _selectedFile;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        _selectedFile = file;
      });
      widget.onFilePicked(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _pickFile,
          child: Text('Seleccionar PDF'),
        ),
        SizedBox(height: 8),
        Text(_selectedFile?.path ?? 'No PDF selected'),
      ],
    );
  }
}
