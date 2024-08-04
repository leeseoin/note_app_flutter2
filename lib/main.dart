import 'package:flutter/material.dart';
import 'package:note_app_flutter2/models/note_database.dart';
import 'package:note_app_flutter2/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'pages/notes_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // NoteDatabase 인스턴스 생성
  final noteDatabase = NoteDatabase();

  // 마이그레이션 실행
  await noteDatabase.migrateNotesToJson();

  runApp(
    MultiProvider(
      providers: [
        // Note Provider
        ChangeNotifierProvider.value(value: noteDatabase),

        // Theme Provider
        ChangeNotifierProvider(create: (context) => ThemeProvider())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const NotesPage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
