import 'package:flutter/material.dart';
import 'package:office_expense_manager/Pages/add_name.dart';
import '../Constants/colors.dart';
import '../Controllers/db_helper.dart';
import 'auth.dart';
import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  // TODO Instance of DB Helper
  DbHelper dbHelper = DbHelper();

  @override
  void initState() {
    getName();
    super.initState();

  }

  Future getName() async {
    String? name = await dbHelper.getName();
    if (name != null) {
      bool? auth = await dbHelper.getLocalAuth();
      if (auth != null && auth) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => FingerPrintAuth(),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => AddName(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
        backgroundColor: Constants().backgroundColor,
      ),
      backgroundColor: Constants().backgroundColor,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(
              12.0,
            ),
          ),
          padding: const EdgeInsets.all(
            16.0,
          ),
          child: Image.network(
            "https://cdn-icons-png.flaticon.com/512/1570/1570998.png",
            width: 64.0,
            height: 64.0,
          ),
        ),
      ),
    );
  }
}
