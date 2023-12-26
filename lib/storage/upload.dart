import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FileUploadUtils {
  static Future<String?> uploadFile(BuildContext context, File? file) async {
    try {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Uploading')));

      if (file == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('File is null or empty')));
        return null;
      }

      String fileName = file.path.split('/').last; // Extract file name
      Reference storageReference = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask =
          storageReference.putFile(file, SettableMetadata(contentType: 'text/plain'));

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Upload Success')));
      print("File uploaded. Download URL: $downloadURL");
      return downloadURL;
    } catch (e) {
      print("Error uploading file: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred while uploading')));
      return null;
    }
  }

  // static Future<File?> pickFile() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles();
  //   if (result != null) {
  //     return File(result.files.single.path!);
  //   } else {
  //     print("No file selected");
  //     return null;
  //   }
  // }
}
