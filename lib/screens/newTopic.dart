import 'package:crictalk/db/topicmanager.dart';
import 'package:flutter/material.dart';

class NewTopicScreen extends StatefulWidget {
  const NewTopicScreen({super.key});

  @override
  _NewTopicScreenState createState() => _NewTopicScreenState();
}

class _NewTopicScreenState extends State<NewTopicScreen> {
  final TextEditingController _topicController = TextEditingController();

  void _createTopic() {
    String topic = _topicController.text.trim();

    TopicManager.createNewTopic(topic);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Topic'),
      ),
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _topicController,
              decoration: const InputDecoration(labelText: 'Topic'),
            ),
          ],
        ),
      ),
    );
  }
}
