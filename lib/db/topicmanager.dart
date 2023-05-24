import 'package:cloud_firestore/cloud_firestore.dart';

class TopicManager {
  static Future<String> createNewTopic(String topic) async {
    try {
      DocumentReference topicRef =
          FirebaseFirestore.instance.collection('topics').doc();

      await topicRef
          .set({'topic': topic, 'createdAt': DateTime.now(), 'trendScore': 0});
      return 'success';
    } catch (error) {
      return error.toString();
    }
  }

  // method to add coment in the topic
  static Future<String> addComment(String topicId, String comment) async {
    try {
      DocumentReference topicRef =
          FirebaseFirestore.instance.collection('topics').doc(topicId);

      await topicRef.update({
        'comments': FieldValue.arrayUnion([comment])
      });
      return 'success';
    } catch (error) {
      return error.toString();
    }
  }
}
