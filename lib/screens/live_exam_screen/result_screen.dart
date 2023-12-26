import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ResultScreen extends StatefulWidget {
  final String mcqLink;
  final String examId;

  const ResultScreen({Key? key, required this.mcqLink, required this.examId})
      : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  List<Map<String, dynamic>> questions = [];

  Map<int, bool> answerResults = {};


  @override
  void dispose() {
    super.dispose();
  }

  fetchData() async {
    try {
      http.Response response = await http.get(Uri.parse(widget.mcqLink));

      if (response.statusCode == 200) {
       String responseBody =
            utf8.decode(response.bodyBytes); // Decode using UTF-8

        List<dynamic> parsedList = jsonDecode(responseBody); List<Map<String, dynamic>> formattedList =
            parsedList.map((item) => item as Map<String, dynamic>).toList();

        setState(() {
          questions = formattedList;
        });
         print('Failed to load data: $questions');
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception while fetching data: $e');
    }
  }

  @override
  void initState() {
    loadMapFromPrefs();
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
      ),
      body: SingleChildScrollView(
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text("Your Answer Status:",style: TextStyle(
                              color: Colors.brown,
                        
                              fontWeight: FontWeight.bold)),
                            answerResults[index] == true
                                ? const Icon(Icons.check_circle_outline,color: Colors.green)
                                : const Icon(Icons.cancel,color: Colors.red)
                          ],
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
    String correctAnswer = questions[index]['correctAnswer'] as String;
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
              padding: const EdgeInsets.all(8.0),
              child: Row(
                
                children: [
                  CircleAvatar(radius: 14, child: Text((options.indexOf(option)+1).toString(),style: const TextStyle(
                              color: Colors.brown,
                              fontSize: 15,
                              fontWeight: FontWeight.bold))),
                  const SizedBox(width: 10,),
                  Text(option,style: const TextStyle(
                            
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                  
                  const Spacer(),
                  option == correctAnswer
                          ? const Icon(Icons.check_circle_outlined,color: Colors.green,)
                          : Container()
                ],
              ),
            ),
          ),const SizedBox(height: 6,)
        ],
      );
    }).toList();
  }

  Future<void> loadMapFromPrefs() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs = await SharedPreferences.getInstance();

    String? data = _prefs.getString('${widget.examId}answerresult');

    if (data != null) {
      // Convert the saved JSON string to Map<int, bool>
      Map<String, dynamic> decodedMap = json.decode(data);
      answerResults = decodedMap
          .map((key, value) => MapEntry(int.parse(key), value as bool));
      print(answerResults);
       debugPrint('answerresult loaded prefs');
    } else {
      answerResults = {};
    }

    setState(() {});
  }
}
