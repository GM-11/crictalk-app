import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crictalk/db/topicmanager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('topic')
          .orderBy('trendScore', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // make a page view instead of a list view
          return PageView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data!.docs[index];
              List<dynamic> comments = ds['comments'];
              return Scaffold(
                  appBar: AppBar(title: Text(ds['topic'])),
                  body: ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(comments[index]['comment']),
                          subtitle: Text(comments[index]['author']),
                        ),
                      );
                    },
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      // show a dialog box
                      TextEditingController commentController =
                          TextEditingController();
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text("Add Comment"),
                                content: TextField(
                                  controller: commentController,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // add the comment to the db
                                      TopicManager.addComment(
                                          ds.id,
                                          commentController.text.trim(),
                                          FirebaseAuth.instance.currentUser!
                                              .displayName!);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Add'),
                                  ),
                                ],
                              ));
                    },
                    child: const Icon(Icons.add),
                  ));
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    ));
  }
}
