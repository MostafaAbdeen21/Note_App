import 'package:flutter/material.dart';
import 'package:note_app/database.dart';

import 'notes.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.createDB();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    debugShowCheckedModeBanner: false,
      home: const Notes(),

    );
  }
}



