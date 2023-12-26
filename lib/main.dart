import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mbpi_iq/firebase_options.dart';
import 'package:mbpi_iq/models/user.dart';
import 'package:mbpi_iq/screens/login_screen/auth_wrapper.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
         ChangeNotifierProvider(
          create: (context) => UserDataProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'IQ Profiler MBPI',
        theme: ThemeData(
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
                color: Color.fromARGB(255, 195, 190, 250),
                titleTextStyle:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
            elevatedButtonTheme: const ElevatedButtonThemeData(
                style: ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll(Color.fromARGB(255, 195, 190, 250)),
              // iconColor: MaterialStatePropertyAll(
              //     Color.fromARGB(255, 101, 97, 133))
            )),
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 148, 192, 250)),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            )),
        home: const IQProfiler(),
      ),
    );
  }
}

class IQProfiler extends StatelessWidget {
  const IQProfiler({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthChecker();
  }
}
