import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mbpi_iq/componants/snakbar.dart';

import '../../../componants/dialogs/deleting_dialog.dart';
import 'add_exam_screen.dart';

class AdminExamScreen extends StatelessWidget {
  const AdminExamScreen({super.key});

  
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Exams"),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddExamScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        body: FutureBuilder(
          future: FirebaseFirestore.instance.collection('allexam').get(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No data available'),
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var subDocument = snapshot.data!.docs[index];
                        var subDocumentId = snapshot.data!.docs[index].id;
                        return Card(
                          child: ListTile(
                            title: Text(subDocument['title']),
                            // subtitle: Text(subDocument['subtitle']),
                            trailing: popupbutton(
                                context, subDocumentId, subDocument),

                            onTap: () {
                              // Navigator.push<void>(
                              //   context,
                              //   MaterialPageRoute<void>(
                              //       builder: (BuildContext context) =>
                              //           AllE(
                              //             groupName: groupName,
                              //             subjectId: subDocumentId,
                              //             subjectName: subDocument['title']??'',
                              //           )),
                              // );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ));
  }

  PopupMenuButton<String> popupbutton(
    BuildContext context,
    documentId,
    documentData,
  ) {
    return PopupMenuButton<String>(
      onSelected: (String value) {
        if (value == 'Update') {
          updateresult(context, documentId, documentData);
          print('Update action');
        } else if (value == 'Delete') {
          _deleteTopic(documentId, context);
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'Update',
          child: Text('Publish result'),
        ),
        const PopupMenuItem<String>(
          value: 'Delete',
          child: Text('Delete'),
        ),
      ],
    );
  }

  Future<void> _deleteTopic(id, BuildContext context) async {
    // Show a loading indicator while deleting
    showLoadingDialog(context);

    try {
      await FirebaseFirestore.instance
          .collection('allexam')
          .doc(id)
          .delete();

      // If deletion is successful, show a success Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(' deleted successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (error) {
      // If there's an error, show an error Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete : $error'),
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      // Always pop the loading indicator
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}

void updateresult(
    BuildContext context, documentId, documentData,) async {
  await FirebaseFirestore.instance.collection('allexam')
      .doc(documentId)
      .update({
    'title': documentData['title'],
    'subtitle': documentData['subtitle'],
    'description': documentData['description'],
    'duration': documentData['duration'],
    'isresultPublished': true,
    'quizLink': documentData['quizLink'],
    // Add other fields as needed
  }).then((value) {
    showSnackBar(message: "Exam updated to result published", context: context);
  }).catchError((error) {
    // Handle error according to your app's requirements
  });
}
