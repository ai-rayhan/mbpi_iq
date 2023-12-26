import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mbpi_iq/models/user.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizScreen extends StatefulWidget {
  final String mcqLink;
  final String examId;
  final String duration;

  const QuizScreen(
      {Key? key,
      required this.mcqLink,
      required this.examId,
      required this.duration})
      : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Map<String, dynamic>> questions = [];
  Map<int, String?> selectedAnswers = {};
  Map<int, bool> answerResults = {};
  late Timer _timer;
  bool isLoading = true;
  int _secondsRemaining = 0;
  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer.cancel();
          Navigator.pop(context);
          Navigator.pop(context);
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer to prevent memory leaks
    super.dispose();
  }

  fetchData() async {
    try {
      http.Response response = await http.get(Uri.parse(widget.mcqLink));

      if (response.statusCode == 200) {
        String responseBody =
            utf8.decode(response.bodyBytes); // Decode using UTF-8

        List<dynamic> parsedList = jsonDecode(responseBody);
        List<Map<String, dynamic>> formattedList =
            parsedList.map((item) => item as Map<String, dynamic>).toList();

        setState(() {
          questions = formattedList;
        });
        print(' data: $questions');
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception while fetching data: $e');
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    fetchData();
    _secondsRemaining = int.parse(widget.duration) * 60;
    startTimer();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String timerText =
        '${_secondsRemaining ~/ 60}:${(_secondsRemaining % 60).toString().padLeft(2, '0')}';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Time Left: $timerText',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 1,
                        margin: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Q-${index + 1}: ${questions[index]['question']}',
                                style: const TextStyle(
                                    color: Colors.brown,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _buildOptions(index),
                              ),
                              const SizedBox(height: 8.0),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FilledButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Submit Answers ?"),
                              content: const Text(
                                'Are submit answers.it will saved and when result published you can see this',
                              ),
                              actions: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    FilledButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _checkAnswers();
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Submit '),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text("Submit")),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
    );
  }

  List<Widget> _buildOptions(int index) {
    List<String> options = (questions[index]['options'] as String)
        .split(',')
        .map((e) => e.trim())
        .toList();

    return options.map((option) {
      return Column(
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(221, 226, 226, 226),
                  width: 2,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Row(
                children: [
                  Radio<String?>(
                    value: option,
                    groupValue: selectedAnswers[index],
                    onChanged: (value) {
                      setState(() {
                        selectedAnswers[index] = value;
                      });
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(option),
                  // ListTile(
                  //   contentPadding:EdgeInsets.zero,
                  //   title: Text(option),
                  //   leading:
                  // ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          )
        ],
      );
    }).toList();
  }

  void _checkAnswers() {
    for (int i = 0; i < questions.length; i++) {
      String correctAnswer = questions[i]['correctAnswer'] as String;
      String? userAnswer = selectedAnswers[i];

      if (correctAnswer == userAnswer) {
        answerResults[i] = true; // Mark the answer as correct
      } else {
        answerResults[i] = false; // Mark the answer as wrong
      }
    }
    saveMapToPrefs();
    _addSubCollectionDocument(context);
    // Navigate to ResultScreen and pass the result data
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => ResultScreen(
    //       mcqLink: widget.mcqLink,
    //       // totalQuestions: questions.length,
    //       // correctAnswersCount:
    //       //     answerResults.values.where((result) => result).length,
    //       // answerResults: answerResults,
    //       // selectedAnswers: selectedAnswers,
    //       // questions: questions,
    //     ),
    //   ),
    // );
  }

  int countTrueValues(Map<int, bool> map) {
    int count = 0;
    map.forEach((key, value) {
      if (value == true) {
        count++;
      }
    });
    return count;
  }

  Future<void> saveMapToPrefs() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> data =
        answerResults.map((key, value) => MapEntry(key.toString(), value));

    // Encode the map to JSON and save it as a string
    String jsonData = json.encode(data);
    await _prefs.setString('${widget.examId}answerresult', jsonData);
    debugPrint('answerresult saved prefs');
  }

  void _addSubCollectionDocument(BuildContext context) async {
    var user = context.read<UserDataProvider>();
    
    await FirebaseFirestore.instance
        .collection('allexam')
        .doc(widget.examId)
        .collection('ledearboard')
        .add({
      'name': user.userData?.name??'',
      'roll': user.userData?.roll??'',
      'semester': user.userData?.semester??'',
      'shift': user.userData?.shift??'',
      'mark': countTrueValues(answerResults),
  

      // Add other fields as needed
    }).then((value) {
      debugPrint('saved leader');
      // Navigator.pop(context); // Close the current screen
    }).catchError((error) {
      // Error adding document
      // Handle error according to your app's requirements
    });
  }
}
