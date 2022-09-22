import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:office_expense_manager/Pages/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Controllers/shared_preference_class.dart';
import 'hello.dart';


void main() async {
  await Hive.initFlutter();
  await Hive.openBox('money');
  SharedPreferenceClass.preferences = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expenses',
      home: SplashScreen(),
    );
  }
}
