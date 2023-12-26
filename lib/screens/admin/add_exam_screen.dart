import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:mbpi_iq/componants/date_fomat.dart';
import 'package:mbpi_iq/componants/datepicker_dialog.dart';
import 'package:mbpi_iq/screens/admin/create_quiz.dart';
import 'package:mbpi_iq/storage/upload.dart';



class AddExamScreen extends StatefulWidget {


  const AddExamScreen({
    Key? key,
  
  }) : super(key: key);

  @override
  State<AddExamScreen> createState() => _AddExamScreenState();
}

class _AddExamScreenState extends State<AddExamScreen> {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController subtitleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final bool _isresultPublished = false;
  void _addSubCollectionDocument(BuildContext context) {
    FirebaseFirestore.instance
        .collection('allexam')
        .add({
      'title': titleController.text,
      'subtitle': subtitleController.text,
      'description': descriptionController.text,
      'timestamp': Timestamp.fromDate(DateTime.now()),
      'quizLink': quizfileLink,
      'duration': durationController.text,
      'startDate':publishDate!.toIso8601String(),
      'deadlineDate':deadlineDate!.toIso8601String(),
      'isresultPublished': _isresultPublished,

      // Add other fields as needed
    }).then((value) {
      // Document successfully added
      Navigator.pop(context); // Close the current screen
      Navigator.pop(context); // Close the current screen
      
    }).catchError((error) {
      // Error adding document
      // Handle error according to your app's requirements
    });
  }

  File? _file;
  String? imagelink;
  String? quizfileLink;
  DateTime? publishDate;
  DateTime? deadlineDate;
  Future<void> uploadFile() async {
    String? downloadURL = await FileUploadUtils.uploadFile(context, _file);
    if (downloadURL != null) {
      setState(() {
        imagelink = downloadURL;
      });
    }
  }

  // Future<void> pickFile() async {
  //   File? file = await FileUploadUtils.pickFile();
  //   if (file != null) {
  //     setState(() {
  //       _file = file;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add A Exam '),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _addSubCollectionDocument(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: subtitleController,
                decoration: const InputDecoration(labelText: 'Subtitle'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: durationController,
                decoration: const InputDecoration(labelText: 'Duration in minute'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                maxLines: 5,
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: () async {
                    await pickDate(context).then((date) {
                      if (date != null) {
                        setState(() {
                          publishDate = date;
                        });
                      }
                    });
                  },
                  child: TextFormField(
                    enabled: false,
                    decoration: InputDecoration(
                        labelText: publishDate == null
                            ? 'Pick Start Date'
                            : 'Start Date: ${formatdate(publishDate)}'),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: () async {
                    await pickDate(context).then((date) {
                      if (date != null) {
                        setState(() {
                          deadlineDate = date;
                        });
                      }
                    });
                  },
                  child: TextFormField(
                    enabled: false,
                    decoration: InputDecoration(
                        labelText: deadlineDate == null
                            ? 'Pick Deadline Date'
                            : 'Deadline Date: ${formatdate(deadlineDate)}'),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              GestureDetector(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QuizInputPage()),
                  );

                  if (result != null) {
                    setState(() {
                      quizfileLink = result;
                    });
                    debugPrint('Received data from Screen : $result');
                  }
                },
                child: TextFormField(
                  enabled: false,
                  decoration: InputDecoration(
                      labelText:
                          quizfileLink == null ? 'Add MCQ' : quizfileLink!),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
         

              // Add more TextFields for additional fields if needed
            ],
          ),
        ),
      ),
    );
  }
}
