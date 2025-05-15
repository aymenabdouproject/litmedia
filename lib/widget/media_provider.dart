import 'package:flutter/material.dart';
import 'package:litmedia/pages/model/multimedia.dart'; // Import your Multimedia class

class MediaProvider extends ChangeNotifier {
  List<Multimedia> galleryItems = [];
  List<Multimedia> audioItems = [];

  // Add media to the list
  void addMedia(Multimedia media) {
    if (media.mediaType == 'image') {
      galleryItems.add(media);
    } else if (media.mediaType == 'audio') {
      audioItems.add(media);
    }
    notifyListeners(); // Notify listeners to update the UI
  }

  // You can also add methods to remove or fetch media items if needed
}
