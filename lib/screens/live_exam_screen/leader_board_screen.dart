import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key, required this.examId, required this.groupName});
  final String examId;
  final String groupName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('allexam')
            .doc(examId)
            .collection('ledearboard')
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No leaderboard data available'),
            );
          } else {
            List<DocumentSnapshot> documents = snapshot.data!.docs;
            documents.sort((a, b) {
              int markA = a['mark'] ?? 0;
              int markB = b['mark'] ?? 0;
              return markB.compareTo(markA);
            });

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  String? name = documents[index]['name'];
                  int mark = documents[index]['mark'];

                  return Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black12)),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            flex: 1,
                            child: CircleAvatar(
                              radius: 15,
                              child: Text(
                                (index + 1).toString(),
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                         
                          Expanded(
                            flex: 7,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                 name!,
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              mark.toString(),
                              style:
                                  TextStyle(fontSize: 12.0, color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
