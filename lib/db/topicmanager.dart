import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class TopicManager {
  static Future<void> createNewTopic(String topic) async {
    try {
      // Create a new document for the topic
      DocumentReference topicRef =
          FirebaseFirestore.instance.collection('topics').doc();

      // Set the topic data in Firestore
      await topicRef.set({
        'title': topic,
      });
    } catch (error) {
      // Handle error
      log('Error creating topic: $error');
    }
  }
}
