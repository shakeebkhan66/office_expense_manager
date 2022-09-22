import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:office_expense_manager/Constants/loading.dart';
import '../Constants/colors.dart';
import 'home_page.dart';

class FingerPrintAuth extends StatefulWidget {
  const FingerPrintAuth({Key? key}) : super(key: key);

  @override
  _FingerPrintAuthState createState() => _FingerPrintAuthState();
}

class _FingerPrintAuthState extends State<FingerPrintAuth> {

  bool authenticated = false;
  bool isLoading = false;

  // TODO Authenticate User Function
  void authenticate() async {
    try {
      setState(() {
        isLoading = true;
      });
      var localAuth = LocalAuthentication();
      authenticated = await localAuth.authenticate(
        localizedReason: 'Please authenticate to move forward',
        options: const AuthenticationOptions(biometricOnly: true, useErrorDialogs: true),
      );
      if (authenticated) {
        setState(() {
          isLoading = false;
        });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (ctx) => new HomePage()));
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              "ERROR",
            ),
            content: const Text(
              "You need to setup Fingerprint Authentication to "
                  "be able to use this App !",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Ok",
                ),
              ),
            ],
          ),
        );
        // setState(() {});
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    authenticate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? Loading() : Scaffold(
      backgroundColor: Constants().backgroundColor,
      // appBar: AppBar(
      //   title: Text(
      //     "Authenticate User",
      //     style: TextStyle(color: Constants().backgroundColor),
      //   ),
      //   backgroundColor: Constants().deepTealColor,
      // ),
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Container(
      //         padding: const EdgeInsets.all(20.0),
      //         decoration: BoxDecoration(
      //           borderRadius: BorderRadius.circular(50.0),
      //           color: Colors.white54,
      //         ),
      //         child: Icon(
      //           Icons.lock_outline_rounded,
      //           color: Constants().deepTealColor,
      //           size: 150.0,
      //         ),
      //       ),
      //       const SizedBox(
      //         height: 15.0,
      //       ),
      //       if (!authenticated)
      //         Column(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           crossAxisAlignment: CrossAxisAlignment.center,
      //           children: [
      //             Text(
      //               "Oh Snap ! You Need to authenticate to move forward.",
      //               style: TextStyle(
      //                   fontSize: 28.0,
      //                   fontWeight: FontWeight.w800,
      //                   color: Constants().deepTealColor),
      //               textAlign: TextAlign.center,
      //             ),
      //             const SizedBox(
      //               height: 15.0,
      //             ),
      //             TextButton(
      //               onPressed: () {
      //                 authenticate();
      //               },
      //               child: Row(
      //                 mainAxisSize: MainAxisSize.min,
      //                 children: [
      //                   Text(
      //                     "Try Again",
      //                     style: TextStyle(
      //                       fontSize: 20.0,
      //                       color: Constants().deepTealColor,
      //                     ),
      //                   ),
      //                   const SizedBox(
      //                     width: 5.0,
      //                   ),
      //                   Icon(
      //                     Icons.replay_rounded,
      //                     color: Constants().deepTealColor,
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ],
      //         ),
      //     ],
      //   ),
      // ),
    );
  }
}
