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
  static Future<String> addComment(String topicId, String comment, String author) async {
    try {
      DocumentReference topicRef =
          FirebaseFirestore.instance.collection('topics').doc(topicId);


      // create a hashmap which has comment, author and timestamp and add it to the array
      Map<String, dynamic> commentMap = {
        'comment': comment,
        'author': author,
        'timestamp': DateTime.now()
      };
    
          

      await topicRef.update({
        'comments': FieldValue.arrayUnion([commentMap])
      });
      return 'success';
    } catch (error) {
      return error.toString();
    }
  }
}
