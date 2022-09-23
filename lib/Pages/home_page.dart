import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:office_expense_manager/Pages/setting.dart';
import 'package:office_expense_manager/Widgets/confirm_dialog.dart';
import 'package:office_expense_manager/Widgets/info_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Constants/colors.dart';
import '../Controllers/db_helper.dart';
import '../Models/transaction.dart';
import 'add_transaction.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late Box box;
  late SharedPreferences preferences;
  DbHelper dbHelper = DbHelper();
  Map? data;
  int totalBalance = 0;
  int totalIncome = 0;
  int totalExpense = 0;
  int newTotalBalance = 0;
  DateTime today = DateTime.now();
  DateTime now = DateTime.now();
  int index = 1;

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

  @override
  void initState() {
    super.initState();
    getPreference();
    box = Hive.box('money');
  }

  getPreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  // TODO Fetch Data From Database
  Future<List<TransactionModel>> fetch() async {
    if (box.values.isEmpty) {
      return Future.value([]);
    } else {
      // return Future.value(box.toMap());
      List<TransactionModel> items = [];
      box.toMap().values.forEach((element) {
        // print(element);
        items.add(
          TransactionModel(
            element['amount'] as int,
            element['note'],
            element['date'] as DateTime,
            element['type'],
          ),
        );
      });
      print("Hello" +items.toString());
      return items;
    }
  }

  // TODO Get Total Balance Function
  getTotalBalance(List<TransactionModel> entireData) {
    totalBalance = 0;
    totalIncome = 0;
    totalExpense = 0;
    newTotalBalance = 0;
    for (TransactionModel data in entireData) {
        if (data.date.month == today.month || data.date.month == today.month + 1) {
          if (data.type == "Income") {
              totalBalance += data.amount;
              totalIncome += data.amount;
          }else if(totalBalance > totalIncome){
            newTotalBalance = totalBalance;
            totalBalance += data.amount - newTotalBalance;
          }
          else {
            totalBalance -= data.amount;
            totalExpense += data.amount;
          }
        }
    }
  }




  // TODO Card Income Widget
  cardIncome(String value) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Constants().backgroundColor,
            borderRadius: BorderRadius.circular(
              20.0,
            ),
          ),
          padding: const EdgeInsets.all(
            6.0,
          ),
          child: Icon(
            CupertinoIcons.arrow_down_circle_fill,
            size: 28.0,
            color: Colors.green[700],
          ),
          margin: const EdgeInsets.only(
            right: 8.0,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Income",
              style: TextStyle(
                fontSize: 14.0,
                color: Constants().backgroundColor,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: Constants().backgroundColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // TODO Card Expense Widget
  cardExpense(String value) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Constants().backgroundColor,
            borderRadius: BorderRadius.circular(
              20.0,
            ),
          ),
          padding: const EdgeInsets.all(
            6.0,
          ),
          child: Icon(
            CupertinoIcons.arrow_up_circle_fill,
            size: 28.0,
            color: Colors.red[700],
          ),
          margin: const EdgeInsets.only(
            right: 8.0,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Expense",
              style: TextStyle(
                  fontSize: 14.0,
                  color: Constants().backgroundColor
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color:  Constants().backgroundColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // TODO Expansion Tile Widget
  expenseTile(int value, String note, DateTime date, int index) {
    return InkWell(
      splashColor: Constants().deepTealColor,
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          deleteInfoSnackBar,
        );
      },
      onLongPress: () async {
        bool? answer = await showConfirmDialog(
          context,
          "WARNING",
          "This will delete this record. This action is irreversible. Do you want to continue ?",
        );
        if (answer != null && answer) {
          await dbHelper.deleteData(index);
          setState(() {});
        }
      },
      child: Container(
        padding: const EdgeInsets.all(18.0),
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          gradient: RadialGradient(
              center: Alignment.centerRight,
              colors: [
                Constants().deepTealColor,
                Constants().deepTealColor.withOpacity(0.65),
              ]
          ),
          borderRadius: BorderRadius.circular(
            8.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 15,
                          backgroundColor: Constants().backgroundColor,
                          child: Icon(
                            CupertinoIcons.arrow_up_circle_fill,
                            size: 28.0,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(
                          width: 4.0,
                        ),
                        Text(
                          "Expense",
                          style: TextStyle(
                            fontSize: 20.0,
                            color:  Constants().backgroundColor,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        "${date.day} ${months[date.month - 1]} ",
                        style: TextStyle(
                          color:  Constants().backgroundColor,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "- $value",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w700,
                        color:  Constants().backgroundColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        note,
                        style: TextStyle(
                          color:  Constants().backgroundColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // TODO Income Tile Widget
  incomeTile(int value, String note, DateTime date, int index) {
    return InkWell(
      splashColor: Constants().deepTealColor,
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          deleteInfoSnackBar,
        );
      },
      onLongPress: () async {
        bool? answer = showConfirmDialog(
          context,
          "WARNING",
          "This will delete this record. This action is irreversible. Do you want to continue ?",
        );

        if (answer != null && answer) {
          await dbHelper.deleteData(index);
          setState(() {});
        }
      },
      child: Container(
        padding: const EdgeInsets.all(18.0),
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          gradient: RadialGradient(
              colors: [
                Constants().deepTealColor,
                Constants().deepTealColor.withOpacity(0.65),
              ]
          ),
          borderRadius: BorderRadius.circular(
            8.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: Constants().backgroundColor,
                      child: const Icon(
                        CupertinoIcons.arrow_down_circle_fill,
                        size: 28.0,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      "Credit",
                      style: TextStyle(
                          fontSize: 20.0,
                          color:  Constants().backgroundColor
                      ),
                    ),
                  ],
                ),
                //
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(
                    "${date.day} ${months[date.month - 1]} ",
                    style: TextStyle(
                      color: Constants().backgroundColor,
                    ),
                  ),
                ),
                //
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "+ $value",
                  style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                      color:  Constants().backgroundColor
                  ),
                ),
                //
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(
                    note,
                    style: TextStyle(
                        color: Constants().backgroundColor
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // TODO Select Month Widget
  selectMonth() {
    return Padding(
      padding: const EdgeInsets.all(
        8.0,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  index = 9;
                  today = DateTime(now.year, now.month - 8, today.day);
                });
              },
              child: Container(
                height: 40.0,
                width: MediaQuery.of(context).size.width * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    13.0,
                  ),
                  color: index == 9 ?  Constants().deepTealColor :  Colors.white,
                ),
                alignment: Alignment.center,
                child: Text(
                  months[now.month - 9],
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: index == 9 ?  Constants().backgroundColor :  Constants().deepTealColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6.0,),
            InkWell(
              onTap: () {
                setState(() {
                  index = 8;
                  today = DateTime(now.year, now.month - 7, today.day);
                });
              },
              child: Container(
                height: 40.0,
                width: MediaQuery.of(context).size.width * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    13.0,
                  ),
                  color: index == 8 ?  Constants().deepTealColor :  Colors.white,
                ),
                alignment: Alignment.center,
                child: Text(
                  months[now.month - 8],
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: index == 8 ?  Constants().backgroundColor :  Constants().deepTealColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6.0,),
            InkWell(
              onTap: () {
                setState(() {
                  index = 7;
                  today = DateTime(now.year, now.month - 6, today.day);
                });
              },
              child: Container(
                height: 40.0,
                width: MediaQuery.of(context).size.width * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    13.0,
                  ),
                  color: index == 7 ?  Constants().deepTealColor :  Colors.white,
                ),
                alignment: Alignment.center,
                child: Text(
                  months[now.month - 7],
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: index == 7 ?  Constants().backgroundColor :  Constants().deepTealColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6.0,),
            InkWell(
              onTap: () {
                setState(() {
                  index = 6;
                  today = DateTime(now.year, now.month - 5, today.day);
                });
              },
              child: Container(
                height: 40.0,
                width: MediaQuery.of(context).size.width * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    13.0,
                  ),
                  color: index == 6 ?  Constants().deepTealColor :  Colors.white,
                ),
                alignment: Alignment.center,
                child: Text(
                  months[now.month - 6],
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: index == 6 ?  Constants().backgroundColor :  Constants().deepTealColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6.0,),
            InkWell(
              onTap: () {
                setState(() {
                  index = 5;
                  today = DateTime(now.year, now.month - 4, today.day);
                });
              },
              child: Container(
                height: 40.0,
                width: MediaQuery.of(context).size.width * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    13.0,
                  ),
                  color: index == 5 ?  Constants().deepTealColor :  Colors.white,
                ),
                alignment: Alignment.center,
                child: Text(
                  months[now.month - 5],
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: index == 5 ?  Constants().backgroundColor :  Constants().deepTealColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6.0,),
            InkWell(
              onTap: () {
                setState(() {
                  index = 4;
                  today = DateTime(now.year, now.month - 3, today.day);
                });
              },
              child: Container(
                height: 40.0,
                width: MediaQuery.of(context).size.width * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    13.0,
                  ),
                  color: index == 4 ?  Constants().deepTealColor :  Colors.white,
                ),
                alignment: Alignment.center,
                child: Text(
                  months[now.month - 4],
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: index == 4 ?  Constants().backgroundColor :  Constants().deepTealColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6.0,),
            InkWell(
              onTap: () {
                setState(() {
                  index = 3;
                  today = DateTime(now.year, now.month - 2, today.day);
                });
              },
              child: Container(
                height: 40.0,
                width: MediaQuery.of(context).size.width * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    8.0,
                  ),
                  color: index == 3 ?  Constants().deepTealColor :  Colors.white,
                ),
                alignment: Alignment.center,
                child: Text(
                  months[now.month - 3],
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: index == 3 ?  Constants().backgroundColor :  Constants().deepTealColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6.0,),
            InkWell(
              onTap: () {
                setState(() {
                  index = 2;
                  today = DateTime(now.year, now.month - 1, today.day);
                });
              },
              child: Container(
                height: 40.0,
                width: MediaQuery.of(context).size.width * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    8.0,
                  ),
                  color: index == 2 ?  Constants().deepTealColor :  Colors.white,
                ),
                alignment: Alignment.center,
                child: Text(
                  months[now.month - 2],
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: index == 2 ?  Constants().backgroundColor :  Constants().deepTealColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6.0,),
            InkWell(
              onTap: () {
                setState(() {
                  index = 1;
                  today = DateTime.now();
                });
              },
              child: Container(
                height: 40.0,
                width: MediaQuery.of(context).size.width * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    8.0,
                  ),
                  color: index == 1 ?  Constants().deepTealColor :  Colors.white,
                ),
                alignment: Alignment.center,
                child: Text(
                  months[now.month - 1],
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: index == 1 ?  Constants().backgroundColor:  Constants().deepTealColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6.0,),
            InkWell(
              onTap: () {
                setState(() {
                  index = 10;
                  today = DateTime(now.year, now.month + 1, today.day);
                });
              },
              child: Container(
                height: 40.0,
                width: MediaQuery.of(context).size.width * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    13.0,
                  ),
                  color: index == 10 ?  Constants().deepTealColor :  Colors.white,
                ),
                alignment: Alignment.center,
                child: Text(
                  months[now.month],
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: index == 10 ?  Constants().backgroundColor :  Constants().deepTealColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6.0,),
            InkWell(
              onTap: () {
                setState(() {
                  index = 11;
                  today = DateTime(now.year, now.month + 2, today.day);
                });
              },
              child: Container(
                height: 40.0,
                width: MediaQuery.of(context).size.width * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    13.0,
                  ),
                  color: index == 11 ?  Constants().deepTealColor :  Colors.white,
                ),
                alignment: Alignment.center,
                child: Text(
                  months[now.month + 1],
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: index == 11 ?  Constants().backgroundColor :  Constants().deepTealColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6.0,),
            InkWell(
              onTap: () {
                setState(() {
                  index = 12;
                  today = DateTime(now.year, now.month + 3, today.day);
                });
              },
              child: Container(
                height: 40.0,
                width: MediaQuery.of(context).size.width * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    13.0,
                  ),
                  color: index == 12 ?  Constants().deepTealColor :  Colors.white,
                ),
                alignment: Alignment.center,
                child: Text(
                  months[now.month + 2],
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: index == 12 ?  Constants().backgroundColor :  Constants().deepTealColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
        backgroundColor: Constants().deepTealColor,
      ),
      backgroundColor: Constants().backgroundColor,
      body: FutureBuilder<List<TransactionModel>>(
        future: fetch(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Opss !!! There is some error !",
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
            );
          }
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  "You haven't added Any Data !",
                  style: TextStyle(
                    fontSize: 24.0,
                    color: Constants().deepTealColor,
                  ),
                ),
              );
            }

            // TODO Get Total Balance
            getTotalBalance(snapshot.data!);

            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(
                    12.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 8.0,
                          ),
                          SizedBox(
                            width: 200.0,
                            child: Text(
                              "Welcome ${preferences.getString('name')}",
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.w900,
                                color: Constants().deepTealColor,
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            40.0,
                          ),
                          color: Constants().deepTealColor,
                        ),
                        padding: const EdgeInsets.all(
                          12.0,
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .push(
                              MaterialPageRoute(
                                builder: (context) => const Settings(),
                              ),
                            )
                                .then((value) {
                              setState(() {});
                            });
                          },
                          child: Icon(
                            CupertinoIcons.settings,
                            size: 20.0,
                            color: Constants().backgroundColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // TODO Select Month
                selectMonth(),

                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: const EdgeInsets.all(
                    12.0,
                  ),
                  child: Ink(
                    decoration:  BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Constants().deepTealColor,
                          Constants().deepTealColor.withOpacity(0.7),
                        ],
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(
                          24.0,
                        ),
                      ),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            24.0,
                          ),
                        ),
                        // color: Static.PrimaryColor,
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                        vertical: 18.0,
                        horizontal: 8.0,
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Total Balance',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.0,
                              // fontWeight: FontWeight.w700,
                              color: Constants().backgroundColor,
                            ),
                          ),
                          const SizedBox(
                            height: 12.0,
                          ),
                          Text(
                            'Rs $totalBalance',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 36.0,
                              letterSpacing: 1.0,
                              fontWeight: FontWeight.w700,
                              color: Constants().backgroundColor,
                            ),
                          ),
                          const SizedBox(
                            height: 12.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                cardIncome(
                                  totalIncome.toString(),
                                ),
                                cardExpense(
                                  totalExpense.toString(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "Recent Transactions",
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Constants().deepTealColor,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.length + 1,
                  itemBuilder: (context, index) {
                    TransactionModel dataAtIndex;
                    try {
                      dataAtIndex = snapshot.data![index];
                    } catch (e) {
                      return Container();
                    }

                    if (dataAtIndex.date.month == today.month) {
                      if (dataAtIndex.type == "Income") {
                        return incomeTile(
                          dataAtIndex.amount,
                          dataAtIndex.note,
                          dataAtIndex.date,
                          index,
                        );
                      } else {
                        return expenseTile(
                          dataAtIndex.amount,
                          dataAtIndex.note,
                          dataAtIndex.date,
                          index,
                        );
                      }
                    } else {
                      return Container();
                    }
                  },
                ),
                //
                const SizedBox(
                  height: 60.0,
                ),
              ],
            );
          } else {
            return const Text(
              "Loading...",
            );
          }
        },
      ),

      // TODO FLOATING ACTION BUTTON
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
            CupertinoPageRoute(
              builder: (context) => const AddExpenseNoGradient(),
            ),
          )
              .then((value) {
            setState(() {});
          });
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            30.0,
          ),
        ),
        backgroundColor: Constants().deepTealColor,
        child: const Icon(
          CupertinoIcons.add,
          size: 32.0,
        ),
      ),
    );
  }
}
