import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/teamProvider.dart';
import 'screens/homeScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TeamProvider()..loadTeams()), // โหลดข้อมูลทีมตอนเริ่มแอป
      ],
      child: MaterialApp(
        title: 'Robot Tournament',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const HomeScreen(), // เปลี่ยนหน้าแรกเป็น HomeScreen
      ),
    );
  }
}
