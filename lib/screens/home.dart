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
  List<dynamic> items = [];

  Future<List<dynamic>> _fetchData() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('topics')
        .orderBy('trendScore', descending: true)
        .get();

    List<dynamic> newData = snapshot.docs.map((DocumentSnapshot docSnapshot) {
      return docSnapshot.data();
    }).toList();

    setState(() {
      items = newData;
    });

    return newData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Topics')),
      body: RefreshIndicator(
        onRefresh: () => _fetchData(),
        child: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection('topics')
              .orderBy('trendScore', descending: true)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              return PageView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  if (snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('No comments'),
                    );
                  }

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
                                        onPressed: () async {
                                          showAddCommentDialog(context, ds.id);
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
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Center(
                child: Column(
                  children: [
                    const Text('No topics found'),
                    // textbutton to go to new topic screen
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/newTopic');
                      },
                      child: const Text('Add Topic'),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

void showAddCommentDialog(BuildContext context, String topicId) {
  TextEditingController commentController = TextEditingController();
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
                onPressed: () async {
                  String result = await TopicManager.addComment(
                      topicId,
                      commentController.text,
                      FirebaseAuth.instance.currentUser!.uid);
                  if (result == 'success') {
                    Navigator.pop(context);
                  } else {
                    log(result);
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ));
}
