
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

    TopicManager.createNewTopic(topic);
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
      ),
      // show list of all topics in the database
      body: Column(children: [
        // text field to input new topic name
        TextField(
          controller: _topicController,
          decoration: const InputDecoration(
            hintText: 'Enter a new topic',
          ),
        ),
      ]),
      // body: FutureBuilder<List<String>>(
      //   future: TopicManager.fetchAllTopics(),
      //   builder: (context, snapshot) {
      //     if (snapshot.hasData && snapshot.data!.isNotEmpty) {
      //       return ListView.builder(
      //         itemCount: snapshot.data!.length,
      //         itemBuilder: (context, index) => ListTile(
      //           title: Text(snapshot.data![index]),
      //         ),
      //       );
      //     } else {
      //       return const Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }
      //   },
      // ),
      
    );
  }
}
