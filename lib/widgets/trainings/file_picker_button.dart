import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:open_filex/open_filex.dart';

class FilePickerButton extends StatefulWidget {
  final ValueChanged<String?> onFilePicked;

  const FilePickerButton({Key? key, required this.onFilePicked}) : super(key: key);

  @override
  _FilePickerButtonState createState() => _FilePickerButtonState();
}

class _FilePickerButtonState extends State<FilePickerButton> {
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      String? fileUrl = await uploadFile(file);
      if (fileUrl != null) {
        widget.onFilePicked(fileUrl);
        openFile(fileUrl);
      }
    }
  }

  Future<String?> uploadFile(File file) async {
    try {
      String fileName = 'pdfs/${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
      Reference storageReference = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = storageReference.putFile(file);
      await uploadTask.whenComplete(() {});
      return await storageReference.getDownloadURL();
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }

  Future<void> openFile(String fileUrl) async {
    final result = await OpenFilex.open(fileUrl);
    print('Open file result: ${result.message}');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _pickFile,
          child: const Text('Seleccionar PDF'),
        ),
      ],
    );
  }
}
