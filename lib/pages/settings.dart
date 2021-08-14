import 'package:stylist/auth/auth.dart';
import 'package:stylist/auth/stylist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stylist/widgets/rounded-button.dart';

class BookingScreen extends StatefulWidget {
  BookingScreen({Key? key}) : super(key: key);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  CollectionReference users = FirebaseFirestore.instance.collection('booklist');

  late DateTime bookDate;
  
  List<String> _workingDays = [
    'Mon - Friday',
    'Mon - Saturday',
    'Mon - Sunday'
  ];
  String _dayChosen = 'Mon - Sunday';

  static String toDate(DateTime dateTime) {
    final date = DateFormat.yMMMEd().format(dateTime);
    return '$date';
  }

  static String toTime(DateTime dateTime) {
    final time = DateFormat.Hm().format(dateTime);
    return '$time';
  }

  @override
  void initState() {
    super.initState();
    bookDate = DateTime.now();
  }

  // Future<void> addToBookedList() async {
  //   final authClass = Provider.of<AuthClass>(context, listen: false);
  //   final stylist = Provider.of<Stylist>(context, listen: false);
  //   final userId = authClass.auth.currentUser!.uid;
  //   stylistId = stylist.tid;
  //   stylistName = stylist.stylistName;
  //   List bookItem = [];
  //   bookItem.add(toMap());
  //   List<String> ids = [];
  //   await FirebaseFirestore.instance
  //       .collection('booklist')
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //     querySnapshot.docs.forEach((doc) {
  //       ids.add(doc.id);
  //     });
  //   });
  //   if (ids.contains(userId)) {
  //     await users
  //         .doc(userId)
  //         .update({'bookedList': FieldValue.arrayUnion(bookItem)})
  //         .then((value) => Navigator.pushNamed(context, 'BookList'))
  //         .catchError((error) {
  //           print("Failed to book: $error");
  //         });
  //   } else {
  //     await users
  //         .doc(userId)
  //         .set({'bookedList': FieldValue.arrayUnion(bookItem)})
  //         .then((value) => Navigator.pushNamed(context, 'BookList'))
  //         .catchError((error) {
  //           print("Failed to book: $error");
  //         });
  //   }
  // }

  // Map<String, dynamic> toMap() {
  //   return {
  //     'hostelName': hostelName,
  //     'tid': stylistId,
  //     'stylistName': stylistName,
  //     'tel': tel,
  //     'time': toTime(bookDate),
  //     'date': toDate(bookDate),
  //     'status': 'pending'
  //   };
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context)),
                    IconButton(
                      icon: Icon(
                        Icons.save,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(50),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        'Setups',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.all(10),
                        child: Text('Working days'),
                      ),
                      Container(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10)),
                            child: DropdownButton(
                              value: _dayChosen,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _dayChosen = newValue!;
                                });
                              },
                              items: _workingDays.map((workingDay) {
                                return DropdownMenuItem(
                                  value: workingDay,
                                  child: Text(workingDay),
                                );
                              }).toList(),
                              hint: Text('Choose working days'),
                              dropdownColor: Colors.white,
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 36,
                              isExpanded: true,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ),
                      ),
                      RoundedButton(buttonName: 'Save Changes'),
                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     Expanded(
                      //       flex: 2,
                      //       child: Text(
                      //         'Time Available',
                      //         style: TextStyle(
                      //           fontWeight: FontWeight.bold,
                      //           fontSize: 24,
                      //         ),
                      //       ),
                      //     ),
                      //     Expanded(
                      //       flex: 1,
                      //       child: MaterialButton(
                      //         onPressed: () {},
                      //         color: Colors.black54,
                      //         shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(20),
                      //         ),
                      //         child: Text(
                      //           'Add Time',
                      //           style: TextStyle(
                      //             fontWeight: FontWeight.bold,
                      //             fontSize: 24,
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       flex: 2,
                      //       child: buildDropDown(
                      //           text: toDate(bookDate),
                      //           onClicked: () => pickBookDate(pickDate: true)),
                      //     ),
                      //     Expanded(
                      //       child: buildDropDown(
                      //           text: toTime(bookDate),
                      //           onClicked: () => pickBookDate(pickDate: false)),
                      //     )
                      //   ],
                      // ),

                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDropDown({
    required String text,
    required VoidCallback onClicked,
  }) =>
      ListTile(
        title: Text(text),
        trailing: Icon(Icons.arrow_drop_down),
        onTap: onClicked,
      );

  Future pickBookDate({required bool pickDate}) async {
    final date = await pickDateTime(
      bookDate,
      pickDate: pickDate,
      firstDate: pickDate ? bookDate : null,
    );
    if (date == null) return;

    setState(() {
      bookDate = date;
    });
  }

  // method showing calendar to be picking the date and time from by using the switches

  Future<DateTime?> pickDateTime(
    DateTime initialDate, {
    required bool pickDate,
    DateTime? firstDate,
  }) async {
    if (pickDate) {
      final date = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate ?? DateTime(2020),
        lastDate: DateTime(2101),
      );
      if (date == null) return null;

      final time =
          Duration(hours: initialDate.hour, minutes: initialDate.minute);
      return date.add(time);
    } else {
      final timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );
      if (timeOfDay == null) return null;

      final date =
          DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);
      // added time to time list String
      // _availableTime.add(time.toString());
      return date.add(time);
    }
  }
}
