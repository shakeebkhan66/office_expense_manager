import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:office_expense_manager/Pages/widgets/confirm_dialog.dart';
import '../Constants/colors.dart';
import '../Controllers/db_helper.dart';
import '../Controllers/shared_preference_class.dart';
import 'home_page.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  // TODO Instance of DBHelper
  DbHelper dbHelper = DbHelper();

  TextEditingController nameController = TextEditingController();

  // TODO Getting value from SharedPreference Class
  var myName =  SharedPreferenceClass.preferences?.getString('name');


  @override
  void initState() {
    nameController.text = myName.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants().backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (ctx) => const HomePage()));
          },
          icon: Icon(CupertinoIcons.back, color: Constants().backgroundColor,),
        ),
        title: Text(
          "Settings",
          style: TextStyle(color: Constants().backgroundColor),
        ),
        backgroundColor: Constants().deepTealColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(
          12.0,
        ),
        children: [
          ListTile(
            onTap: () async {
              bool answer = await showConfirmDialog(context, "Warning",
                  "This is irreversible. Your entire data will be Lost");
              if (answer) {
                await dbHelper.cleanData();
                Navigator.of(context).pop();
              }
            },
            tileColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 20.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                8.0,
              ),
            ),
            title: Text(
              "Clean Data",
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w800,
                  color: Constants().deepTealColor
              ),
            ),
            subtitle: Text(
              "This is irreversible",
              style: TextStyle(
                color: Constants().deepTealColor,
              ),
            ),
            trailing: const Icon(
              Icons.delete_forever,
              size: 32.0,
              color: Colors.redAccent,
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          ListTile(
            onTap: () async {
              String nameEditing = "";
              String? name = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Constants().backgroundColor,
                  content: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        12.0,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    child: TextFormField(
                      controller: nameController,
                      cursorColor: Constants().deepTealColor,
                      decoration: InputDecoration(
                        hintText: "enter your name",
                        labelText: "Your Name",
                        labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Constants().deepTealColor),
                        hintStyle: TextStyle(color: Constants().deepTealColor),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        fontSize: 20.0,
                      ),
                      maxLength: 12,
                      onChanged: (val) {
                        nameEditing = val;
                      },
                    ),
                  ),
                  actions: [
                    MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop(nameEditing);
                      },
                      color: Constants().deepTealColor,
                      child: Text(
                        "OK",
                        style: TextStyle(color: Constants().backgroundColor),
                      ),
                    ),
                  ],
                ),
              );
              if (name != null && name.isNotEmpty) {
                DbHelper dbHelper = DbHelper();
                await dbHelper.addName(name);
              }
            },
            tileColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 20.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                8.0,
              ),
            ),
            title: Text(
              "Change Name",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w800,
                color: Constants().deepTealColor,
              ),
            ),
            subtitle: Text(
              "Welcome {newname}",
              style: TextStyle(
                color: Constants().deepTealColor,
              ),
            ),
            trailing: const Icon(
              Icons.change_circle,
              size: 32.0,
              color: Colors.green,
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          FutureBuilder<bool>(
            future: dbHelper.getLocalAuth(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SwitchListTile(
                  onChanged: (val) {
                    DbHelper dbHelper = DbHelper();
                    dbHelper.setLocalAuth(val);
                    setState(() {});
                  },
                  value: snapshot.data == null ? false : snapshot.data!,
                  tileColor: Colors.white,
                  activeColor: Constants().deepTealColor,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 20.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      8.0,
                    ),
                  ),
                  title: Text(
                    "Local Bio Auth",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w800,
                      color: Constants().deepTealColor,
                    ),
                  ),
                  subtitle: Text(
                    "Secure This app, Use Fingerprint to unlock the app.",
                    style: TextStyle(
                      color: Constants().deepTealColor,
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}
