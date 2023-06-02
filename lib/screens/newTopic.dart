import 'package:crictalk/db/topicmanager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewTopicScreen extends StatefulWidget {
  const NewTopicScreen({super.key});

  @override
  _NewTopicScreenState createState() => _NewTopicScreenState();
}

class _NewTopicScreenState extends State<NewTopicScreen> {
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  void _createTopic() async {
    String topic = _topicController.text.trim();

    // validate that the topic is not empty, show dialog if it is
    if (topic.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Topic cannot be empty'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final String topicid = await TopicManager.createNewTopic(topic);

    final result = await TopicManager.addComment(
      topicid,
      _commentController.text,
      FirebaseAuth.instance.currentUser!.displayName!,
    );

    if(result == 'success'){
      // show a snackbar
      



    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.15,
        title: const Text('Topics'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createTopic,
        child: const Icon(Icons.add),
      ),
      // show list of all topics in the database
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          // text field to input new topic name
          TextField(
            controller: _topicController,
            decoration: const InputDecoration(
              hintText: 'Enter a new topic',
            ),
          ),
          const SizedBox(height: 35.0),
          TextField(
            controller: _commentController,
            decoration: const InputDecoration(
              hintText: 'Initial comment',
            ),
          ),
        ]),
      ),
      // body: FutureBuilder<List<String>>(
    );
  }
}
