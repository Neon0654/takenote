import 'package:flutter/material.dart';
import 'controllers/notes_controller.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();

  // 🔥 ANDROID 13+ – XIN QUYỀN NGAY KHI MỞ APP
  await NotificationService.requestPermission();

  runApp(const MyApp());
}




class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Quản lý ghi chú",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const NotesController(),
    );
  }
}
