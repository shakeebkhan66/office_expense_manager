import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Constants/colors.dart';
import '../Controllers/db_helper.dart';
import 'home_page.dart';

class AddName extends StatefulWidget {
  const AddName({Key? key}) : super(key: key);

  @override
  _AddNameState createState() => _AddNameState();
}

class _AddNameState extends State<AddName> {

  // TODO Instance of DBHelper
  DbHelper dbHelper = DbHelper();

  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
        backgroundColor: Constants().backgroundColor,
      ),
      backgroundColor: Constants().backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(
          12.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(
                  12.0,
                ),
              ),
              padding: const EdgeInsets.all(
                16.0,
              ),
              child: Image.asset(
                "assets/icons/appicon.png",
                width: 64.0,
                height: 64.0,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              "Please Enter Your Name ?",
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w500,
                color: Constants().deepTealColor,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    12.0,
                  ),
                  gradient: LinearGradient(
                      colors: [
                        Constants().deepTealColor,
                        Constants().deepTealColor.withOpacity(0.6),
                      ]
                  )
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Your Name",
                  hintStyle: TextStyle(color: Constants().backgroundColor,),
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  fontSize: 20.0,
                  color: Constants().backgroundColor,
                ),
                maxLength: 12,
                onChanged: (val) {
                  name = val;
                },
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            const SizedBox(height: 40,),
            SizedBox(
              height: 40.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 45.0),
                child: MaterialButton(
                  minWidth: 50,
                  color: Constants().deepTealColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onPressed: () async {
                    if (name.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          action: SnackBarAction(
                            label: "OK",
                            textColor: Colors.red,
                            onPressed: () {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            },
                          ),
                          backgroundColor: Colors.white,
                          content: Text(
                            "Please Enter a name",
                            style: TextStyle(
                              color: Constants().deepTealColor,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      );
                    } else {
                      DbHelper dbHelper = DbHelper();
                      await dbHelper.addName(name);
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Let's Start",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Constants().backgroundColor,
                        ),
                      ),
                      const SizedBox(
                        width: 30.0,
                      ),
                      Icon(
                        CupertinoIcons.arrow_right_circle_fill,
                        size: 24.0,
                        color: Constants().backgroundColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
