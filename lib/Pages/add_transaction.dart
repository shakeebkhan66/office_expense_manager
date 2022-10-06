import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import '../Constants/colors.dart';
import '../Controllers/db_helper.dart';

class AddExpenseNoGradient extends StatefulWidget {
  const AddExpenseNoGradient({Key? key}) : super(key: key);

  @override
  _AddExpenseNoGradientState createState() => _AddExpenseNoGradientState();
}

class _AddExpenseNoGradientState extends State<AddExpenseNoGradient> {
  DateTime selectedDate = DateTime.now();
  int? amount;
  String? note;
  String type = "Income";
  final DateTime _future = DateTime.now().add(const Duration(days: 365));



  List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  // TODO Select Date From Calender Function With the Desired Color Too
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Constants().deepTealColor,
                onPrimary: Constants().backgroundColor,
                onSurface: Constants().deepTealColor,
              ),
            ),
            child: child!,
          );
        });
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
        backgroundColor: Constants().deepTealColor,
      ),
      backgroundColor: Constants().backgroundColor,
      body: ListView(
        padding: const EdgeInsets.all(
          40.0,
        ),
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Shimmer.fromColors(
              baseColor: Constants().deepTealColor.withOpacity(0.6),
              highlightColor: Constants().deepTealColor,
              child: Text(
                "\nADD TRANSACTION",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                  color: Constants().deepTealColor,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 40.0,
          ),
          Row(
            children: [
              const SizedBox(
                width: 12.0,
              ),
              Expanded(
                child: TextField(
                  cursorColor: Constants().deepTealColor,
                  decoration: InputDecoration(
                      suffixIcon: Icon(
                        Icons.attach_money_rounded,
                        color: Constants().deepTealColor,
                      ),
                      hintText: "0",
                      labelText: "Enter your amount",
                      labelStyle: TextStyle(
                          color: Constants().deepTealColor,
                          fontWeight: FontWeight.bold),
                      hintStyle: TextStyle(
                        color: Constants().deepTealColor,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide:
                              BorderSide(color: Constants().deepTealColor)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide:
                              BorderSide(color: Constants().deepTealColor)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide:
                              BorderSide(color: Constants().deepTealColor))),
                  style: TextStyle(
                    fontSize: 17.0,
                    color: Constants().deepTealColor,
                  ),
                  onChanged: (val) {
                    try {
                      amount = int.parse(val);
                    } catch (e) {
                      // show Error
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          duration: const Duration(
                            seconds: 2,
                          ),
                          content: Row(
                            children: const [
                              Icon(
                                Icons.info_outline,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 6.0,
                              ),
                              Text(
                                "Enter only Numbers",
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.number,
                  // textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          Row(
            children: [
              const SizedBox(
                width: 12.0,
              ),
              Expanded(
                child: TextField(
                  style: TextStyle(
                    fontSize: 17.0,
                    color: Constants().deepTealColor,
                  ),
                  onChanged: (val) {
                    note = val;
                  },
                  decoration: InputDecoration(
                      suffixIcon: Icon(
                        Icons.description_outlined,
                        color: Constants().deepTealColor,
                      ),
                      hintText: "Enter transaction note",
                      labelText: "Transaction Note",
                      labelStyle: TextStyle(
                          color: Constants().deepTealColor,
                          fontWeight: FontWeight.bold),
                      hintStyle: TextStyle(
                        color: Constants().deepTealColor,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide:
                              BorderSide(color: Constants().deepTealColor)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide:
                              BorderSide(color: Constants().deepTealColor)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide:
                              BorderSide(color: Constants().deepTealColor))),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 40.0,
          ),
          Container(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              "C H O O S E  O N E",
              style: TextStyle(
                  color: Constants().deepTealColor,
                  fontSize: 21,
                  fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 29),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ChoiceChip(
                label: Text(
                  "Income",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: type == "Income"
                        ? Constants().backgroundColor
                        : Constants().deepTealColor,
                  ),
                ),
                selectedColor: Constants().deepTealColor,
                onSelected: (val) {
                  if (val) {
                    setState(() {
                      type = "Income";
                      if (note!.isEmpty || note == "Expense") {
                        note = 'Income';
                      }
                    });
                  }
                },
                selected: type == "Income" ? true : false,
              ),
              const SizedBox(
                width: 8.0,
              ),
              ChoiceChip(
                label: Text(
                  "Expense",
                  style: TextStyle(
                      fontSize: 18.0,
                      color: type == "Expense"
                          ? Constants().backgroundColor
                          : Constants().deepTealColor),
                ),
                selectedColor: Constants().deepTealColor,
                onSelected: (val) {
                  if (val) {
                    setState(() {
                      type = "Expense";

                      if (note!.isEmpty || note == "Income") {
                        note = 'Expense';
                      }
                    });
                  }
                },
                selected: type == "Expense" ? true : false,
              ),
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          SizedBox(
            height: 50.0,
            child: TextButton(
              onPressed: () {
                _selectDate(context);
                FocusScope.of(context).unfocus();
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  EdgeInsets.zero,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 14.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      Container(
                        child: Text(
                          "Select Date",
                          style: TextStyle(
                              color: Constants().deepTealColor,
                              fontSize: 19,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(width: 100),
                      Text(
                        "${selectedDate.day} ${months[selectedDate.month - 1]}",
                        style: TextStyle(
                            fontSize: 20.0, color: Constants().deepTealColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 40.0,
          ),
          SizedBox(
            height: 40.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35.0),
              child: MaterialButton(
                color: Constants().deepTealColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                onPressed: () {
                  if (amount != null && note != null && selectedDate.year != _future.year) {
                    DbHelper dbHelper = DbHelper();
                    dbHelper.addData(amount!, selectedDate, type, note!);
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      amount == null ? SnackBar(
                        backgroundColor: Colors.red[700],
                        content: const Text(
                          "Please enter a valid Amount && Select the current year not next year!",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ) : note == null ? SnackBar(
                        backgroundColor: Colors.red[700],
                        content: const Text(
                          "Please enter the transaction note !",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ) : SnackBar(
                        backgroundColor: Colors.red[700],
                        content: const Text(
                          "Please select the current year not next year !",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }
                },
                child: Text(
                  "A D D",
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w900,
                      color: Constants().backgroundColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
