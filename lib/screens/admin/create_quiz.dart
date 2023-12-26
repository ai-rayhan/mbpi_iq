import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mbpi_iq/componants/dialogs/custom_alert.dart';



class QuizInputPage extends StatefulWidget {
  @override
  _QuizInputPageState createState() => _QuizInputPageState();
}

class _QuizInputPageState extends State<QuizInputPage> {
  TextEditingController questionController = TextEditingController();
  TextEditingController option1Controller = TextEditingController();
  TextEditingController option2Controller = TextEditingController();
  TextEditingController option3Controller = TextEditingController();
  TextEditingController option4Controller = TextEditingController();
  TextEditingController correctAnswerController = TextEditingController();

  List<Map<String, String>> questions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Questions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              // saveQuestionsToFirebaseStorage();
              showCustomDialog(
                context,
                title: 'Confirmation',
                content: 'Are you sure you want to perform this action?',
                onOkPressed: () {
                  saveQuestionsToFirebaseStorage(context);
                  print('OK button pressed! Execute specific action.');
                  // Call any function or perform any task you want here
                },
              );
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) =>
              //         QuizScreen(questions: questions,)
              //   ),
              // );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(questions[index]['question']!),
            subtitle:
                Text('Correct Answer: ${questions[index]['correctAnswer']}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddQuestionDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddQuestionDialog(BuildContext context) {
    TextEditingController correctOptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Question'),
          content: SingleChildScrollView(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                TextField(
                  controller: questionController,
                  decoration: InputDecoration(
                    labelText: 'Enter the question',
                  ),
                ),
                SizedBox(height: 12.0),
                TextField(
                  controller: option1Controller,
                  decoration: InputDecoration(
                    labelText: 'Enter  option 1',
                  ),
                ),
                SizedBox(height: 12.0),
                TextField(
                  controller: option2Controller,
                  decoration: InputDecoration(
                    labelText: 'Enter  option 2',
                  ),
                ),
                SizedBox(height: 12.0),
                TextField(
                  controller: option3Controller,
                  decoration: InputDecoration(
                    labelText: 'Enter  option 3',
                  ),
                ),
                SizedBox(height: 12.0),
                TextField(
                  controller: option4Controller,
                  decoration: InputDecoration(
                    labelText: 'Enter  option 3',
                  ),
                ),
                SizedBox(height: 12.0),
                TextField(
                  controller: correctOptionController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Enter correct option number',
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    saveQuestion(correctOptionController.text);
                    Navigator.pop(context); // Close the dialog after saving
                  },
                  child: Text('Add Question'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void saveQuestion(String correctOption) {
    String question = questionController.text;

    int correctOptionIndex = int.tryParse(correctOption) ?? 0;
    if (correctOptionIndex <= 0 || correctOptionIndex > 4) {
      // Handle invalid option number input
      // For example, show a snackbar or dialog indicating the invalid input
      return;
    }

    List<String> options = [
      option1Controller.text,
      option2Controller.text,
      option3Controller.text,
      option4Controller.text
    ];

    String correctAnswer = options[correctOptionIndex - 1];

    Map<String, String> newQuestion = {
      'question': question,
      'options': options.join(', '),
      'correctAnswer': correctAnswer,
    };

    setState(() {
      questions.add(newQuestion);
    });

    // Clear the text fields after saving
    questionController.clear();
    option1Controller.clear();
    option2Controller.clear();
    option3Controller.clear();
    option4Controller.clear();
    correctAnswerController.clear();
  }

  ///

  String convertQuestionsToJson() {
    return jsonEncode(questions);
  }

void saveQuestionsToFirebaseStorage(BuildContext context) async {
  String jsonData = convertQuestionsToJson();
  Uint8List data = Uint8List.fromList(utf8.encode(jsonData)); // Convert to Uint8List

  Reference ref = FirebaseStorage.instance.ref().child('${DateTime.now().toString()}.json');
  UploadTask uploadTask = ref.putData(
    data,
    SettableMetadata(contentType: 'application/json'),
  );

  try {
    TaskSnapshot snapshot = await uploadTask;
    if (snapshot.state == TaskState.success) {
      // If upload is successful, get the download URL
      String downloadURL = await snapshot.ref.getDownloadURL();

      // Print the download URL
      print('Download URL: $downloadURL');

      // Perform action to pop the screen, for example, using Navigator.pop
      Navigator.pop(context,downloadURL); // This pops the current screen

      // You can navigate to a new screen or perform any other action as needed here
      // For navigating to a new screen, you might use:
      // Navigator.push(context, MaterialPageRoute(builder: (context) => NextScreen()));
    }
  } catch (e) {
    print('Error uploading file: $e');
    // Handle errors here
  }
}
}
