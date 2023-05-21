import 'package:cloud_firestore/cloud_firestore.dart';

class TopicManager {
  static Future<String> createNewTopic(String topic) async {
    try {
      DocumentReference topicRef =
          FirebaseFirestore.instance.collection('topics').doc();

      await topicRef.set({'topic': topic, 'createdAt': DateTime.now()});
      return 'success';
    } catch (error) {
      return error.toString();
    }
  }
}
