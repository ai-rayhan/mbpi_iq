import 'package:firebase_storage/firebase_storage.dart';

class FiledeleteUtils {
  static Future<void> deleteImageFromFirebaseStorage(String url) async {
    // Create a Firebase Storage instance
    FirebaseStorage storage = FirebaseStorage.instance;

    // Get the reference to the image using its URL
    Reference ref = storage.refFromURL(url);

    try {
      // Delete the file from Firebase Storage
      await ref.delete();
    } catch (e) {
      print('Error deleting image: $e');
      // Handle any errors that occur during deletion
    }
  }
}
