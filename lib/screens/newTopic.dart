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
        toolbarHeight: MediaQuery.of(context).size.height * 0.15,
        title: const Text('Topics'),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {  },),
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            
          ],
        ),
      ),
    );
  }
}
