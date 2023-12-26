import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:mbpi_iq/componants/app_drawer.dart';
import 'package:mbpi_iq/componants/colors.dart';
import 'package:mbpi_iq/componants/date_fomat.dart';
import 'package:mbpi_iq/componants/snakbar.dart';
import 'package:mbpi_iq/models/user.dart';
import 'package:mbpi_iq/screens/live_exam_screen/leader_board_screen.dart';
import 'package:mbpi_iq/screens/live_exam_screen/result_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'exam_screen.dart';
import '../admin/live_exam_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> joinedExamList = [];
  late SharedPreferences _prefs;
  bool isLoading = true;

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _getListFromSharedPreferences();
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
    _initSharedPreferences();
  }

  loadUserData() async {
    await context.read<UserDataProvider>().fetchUserData();
    setState(() {
      isLoading = false;
    });
  }

 bool isoutdated(DateTime startdate, DateTime endDate) {
    
    if (DateTime.now().isAfter(startdate) &&
        DateTime.now().isBefore(endDate)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var userData = context.read<UserDataProvider>().userData;
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "MBPI EventIQ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            userData?.isAdmin ?? false
            // true
                ? IconButton(
                    onPressed: () {
                      Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              const AdminExamScreen(),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.admin_panel_settings,
                      color: AppColors.lightBrown,
                    ))
                : Container()
          ],
        ),
        drawer: const AppDrawer(),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Live Quizzes: ${snapshot.data!.docs.length}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var subDocument = snapshot.data!.docs[index];
                        String title = subDocument['title'] ?? '';
                        String duration = subDocument['duration'] ?? '';
                        String description = subDocument['description'] ?? '';
                        bool isresultpublished =
                            subDocument['isresultPublished'] ?? false;
                        String examId = snapshot.data!.docs[index].id;
                        DateTime startdate = DateTime.parse(subDocument['startDate']);
                        DateTime endDate = DateTime.parse(subDocument['deadlineDate']);
                

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 5),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push<void>(
                                context,
                                MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        LeaderboardScreen(
                                          groupName: 'jobprep',
                                          examId: examId,
                                        )),
                              );
                            },
                            child: Card(
                                elevation: 3,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        title,
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: AppColors.lightBrown,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        "Duration: $duration minute",
                                        style: TextStyle(
                                            color: AppColors.appyellow,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      // const SizedBox(
                                      //   height: 2,
                                      // ),
                                      // Text(subtitle),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        description,
                                        style: TextStyle(
                                          color: AppColors.lightBrown,
                                        ),
                                      ),
                                      Text('Start Time:${formatdate(startdate)}',style: TextStyle(
                                          color: AppColors.appyellow,fontSize: 12
                                        ),),
                                      
                                      Text('End Time:${formatdate(endDate)}',style: TextStyle(
                                          color: AppColors.appyellow,fontSize: 12
                                        )),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      joinedExamList.contains(examId)
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                ElevatedButton.icon(
                                                    onPressed: () {
                                                      if (isresultpublished) {
                                                        print(subDocument[
                                                            'quizLink']);
                                                        Navigator.push<void>(
                                                          context,
                                                          MaterialPageRoute<
                                                                  void>(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  ResultScreen(
                                                                    mcqLink:
                                                                        subDocument['quizLink'] ??
                                                                            '',
                                                                    examId:
                                                                        examId,
                                                                  )),
                                                        );
                                                      } else {
                                                        showSnackBar(
                                                            context: context,
                                                            message:
                                                                "Result Not Published Yet");
                                                      }
                                                    },
                                                    icon: const Icon(Icons
                                                        .sticky_note_2_rounded),
                                                    label: const Text(
                                                        'See Result',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold))),
                                                const SizedBox(
                                                  width: 7,
                                                ),
                                                ElevatedButton.icon(
                                                    onPressed: () {
                                                      if (isresultpublished) {
                                                        Navigator.push<void>(
                                                          context,
                                                          MaterialPageRoute<
                                                                  void>(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  LeaderboardScreen(
                                                                    examId:
                                                                        examId,
                                                                    groupName:
                                                                        'jobprep',
                                                                  )),
                                                        );
                                                      } else {
                                                        showSnackBar(
                                                            context: context,
                                                            message:
                                                                "Result Not Published Yet");
                                                      }
                                                    },
                                                    icon: const Icon(
                                                        Icons.leaderboard),
                                                    label: const Text(
                                                      'LeaderBoard',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                              ],
                                            )
                                          : ElevatedButton.icon(
                                              label: const Text("Start Quiz",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              icon: const Icon(Icons.timer),
                                              onPressed: () {
                                                isoutdated(startdate, endDate)? showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          "Start Exam ?"),
                                                      content: const Text(
                                                        'If you start quiz once it cannot be undone ',
                                                      ),
                                                      actions: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                  'Cancel'),
                                                            ),
                                                            const SizedBox(
                                                              width: 8,
                                                            ),
                                                            FilledButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                                Navigator.push<
                                                                    void>(
                                                                  context,
                                                                  MaterialPageRoute<
                                                                          void>(
                                                                      builder: (BuildContext
                                                                              context) =>
                                                                          QuizScreen(
                                                                            duration:
                                                                                duration,
                                                                            examId:
                                                                                examId,
                                                                            mcqLink:
                                                                                subDocument['quizLink'] ?? '',
                                                                          )),
                                                                );
                                                                _saveListToSharedPreferences(
                                                                    examId);
                                                              },
                                                              child: const Text(
                                                                  'Start Now '),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ):showSnackBar(message: "This Quiz is'nt Available this day",context: context);
                                              },
                                            ),
                                      const SizedBox(
                                        height: 20,
                                      )
                                    ],
                                  ),
                                )),
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

  Future<void> _saveListToSharedPreferences(questionid) async {
    joinedExamList.add(questionid);
    await _prefs.setStringList('jobprepmyJoinedExamList', joinedExamList);
  }

  Future _getListFromSharedPreferences() async {
    List<String>? storedList = _prefs.getStringList('jobprepmyJoinedExamList');

    setState(() {
      joinedExamList = storedList ?? [];
    });
    print(storedList);
  }
}
