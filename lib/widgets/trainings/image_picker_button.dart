import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class ImagePickerButton extends StatefulWidget {
  final ValueChanged<File?> onFilePicked;

  const ImagePickerButton({Key? key, required this.onFilePicked}) : super(key: key);

  @override
  _ImagePickerButtonState createState() => _ImagePickerButtonState();
}

class _ImagePickerButtonState extends State<ImagePickerButton> {
  File? _selectedImage;

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        _selectedImage = file;
      });
      widget.onFilePicked(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _pickImage,
          child: Text('Seleccionar Imagen'),
        ),
        SizedBox(height: 8),
        Text(_selectedImage?.path ?? 'No image selected'),
      ],
    );
  }
}
