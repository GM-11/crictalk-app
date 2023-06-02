import 'package:cloud_firestore/cloud_firestore.dart';

class TopicManager {
  static Future<String> createNewTopic(String topic) async {
    try {
      DocumentReference topicRef =
          FirebaseFirestore.instance.collection('topics').doc();

      await topicRef.set({
        'topic': topic,
        'createdAt': DateTime.now(),
        'trendScore': 0,
        'likes': 0
      });
      return topicRef.id;
    } catch (error) {
      return error.toString();
    }
  }

  // method to like a topic
  static Future<String> likeTopic(String topicId) async {
    try {
      final DocumentReference documentRef =
          FirebaseFirestore.instance.collection('topics').doc(topicId);

      int value = 2;

      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(documentRef);

        // Check if the document exists
        if (snapshot.exists) {
          // Update the field value
          transaction.update(documentRef, {
            'likes': FieldValue.increment(value),
            'trendScore': FieldValue.increment(value)
          });
        }
      });

      return 'success';
    } catch (error) {
      return error.toString();
    }
  }

  // method to add coment in the topic
  static Future<String> addComment(
      String topicId, String comment, String author) async {
    try {
      final DocumentReference documentRef =
          FirebaseFirestore.instance.collection('topics').doc(topicId);

      // create a hashmap which has comment, author and timestamp and add it to the array
      Map<String, dynamic> commentMap = {
        'comment': comment,
        'author': author,
        'timestamp': DateTime.now()
      };

      int value = 1;

      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(documentRef);

        // Check if the document exists
        if (snapshot.exists) {
          // Update the field value
          transaction.update(documentRef, {
            'comments': FieldValue.arrayUnion([commentMap]),
            'trendScore': FieldValue.increment(value)
          });
        }
      });

      return 'success';
    } catch (error) {
      return error.toString();
    }
  }
}
