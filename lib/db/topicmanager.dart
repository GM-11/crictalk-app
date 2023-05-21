import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class TopicManager {
  static Future<void> createNewTopic(String topic) async {
    try {
      DocumentReference topicRef =
          FirebaseFirestore.instance.collection('topics').doc();

      await topicRef.set({'topic': topic, 'createdAt': DateTime.now()});
    } catch (error) {
      log('Error creating topic: $error');
    }
  }
}
