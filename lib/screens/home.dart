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
  var ds;
  var comments;

  Future<void> _fetchData() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('topics')
        .orderBy('trendScore', descending: true)
        .get();

    // List<dynamic> newData = snapshot.docs.map((DocumentSnapshot docSnapshot) {
    //   return docSnapshot.data();
    // }).toList();

    // setState(() {
    //   items = newData;
    // });

    // return newData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.15,
        title: const Text('Topics'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/newTopic');
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('topics')
            .orderBy('trendScore', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: PageView.builder(
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
                      appBar: AppBar(
                        title: Text(ds['topic']),
                        elevation: 0.0,
                        centerTitle: true,
                      ),
                      body: RefreshIndicator(
                        onRefresh: () async {
                          QuerySnapshot snapshot = await FirebaseFirestore
                              .instance
                              .collection('topics')
                              .orderBy('trendScore', descending: true)
                              .get();

                          ds = snapshot.docs[index];
                          comments = ds['comments'];
                        },
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                title:
                                    Text(comments[index]['comment'].toString()),
                                subtitle:
                                    Text(comments[index]['author'].toString()),
                              ),
                            );
                          },
                        ),
                      ),
                      floatingActionButton: FloatingActionButton(
                        onPressed: () {
                          // TextEditingController commentController =
                          //     TextEditingController();
                          // showDialog(
                          //     context: context,
                          //     builder: (context) => AlertDialog(
                          //           title: const Text("Add Comment"),
                          //           content: TextField(
                          //             controller: commentController,
                          //           ),
                          //           actions: [
                          //             TextButton(
                          //               onPressed: () {
                          //                 Navigator.pop(context);
                          //               },
                          //               child: const Text('Cancel'),
                          //             ),
                          //             TextButton(
                          //               onPressed: () async {
                          //                 showAddCommentDialog(context, ds.id);
                          //               },
                          //               child: const Text('Add'),
                          //             ),
                          //           ],
                          //         ));

                          showAddCommentDialog(context, ds.id);
                        },
                        child: const Icon(Icons.add),
                      ));
                },
              ),
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
                      FirebaseAuth.instance.currentUser!.displayName!);
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
