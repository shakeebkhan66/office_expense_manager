import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:office_expense_manager/Constants/colors.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Constants().backgroundColor,
      child: Center(
        child: SpinKitWave(
          color: Constants().deepTealColor,
          size: 40.0,
        ),
      ),
    );
  }
}