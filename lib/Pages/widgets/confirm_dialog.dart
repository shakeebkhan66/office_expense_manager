import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../Constants/colors.dart';

showConfirmDialog(BuildContext context, String title, String content) async {
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: MaterialButton(
            color: Colors.redAccent,
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text(
              "YES",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: 40,),
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: MaterialButton(
            color: Constants().deepTealColor,
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(
              "No",
              style: TextStyle(color: Constants().backgroundColor, fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
      ],
    ),
  );
}