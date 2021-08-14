import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BookDetailPage extends StatefulWidget {
  final service;
  final String personId;
  BookDetailPage(this.service, this.personId);

  @override
  _BookDetailPageState createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  Future _updateBookTile(BuildContext context) async {
    CollectionReference bookList =
        FirebaseFirestore.instance.collection('booklist');
    List removeItem = [];
    removeItem.add(widget.service);
    await bookList
        .doc(widget.personId)
        .update({'bookedList': FieldValue.arrayRemove(removeItem)})
        .then((value) => _reCreateService(context))
        .catchError((error) {
          print("Failed to remove service: $error");
        });
  }

  Future _reCreateService(BuildContext context) async {
    CollectionReference bookList =
        FirebaseFirestore.instance.collection('booklist');
    List createBook = [];
    createBook.add(toMap(widget.service));
    await bookList.doc(widget.personId).update(
        {'bookedList': FieldValue.arrayUnion(createBook)}).then((value) {
      setState(() {
        widget.service['status'] = 'confirmed';
      });
      Navigator.pop(context);
    }).catchError((error) {
      print("Failed to book: $error");
    });
  }

  Map<String, dynamic> toMap(dynamic data) {
    return {
      'date': data['date'],
      'hostelName': data['hostelName'],
      'price': data['price'],
      'status': 'confirmed',
      'stylistName': data['stylistName'],
      'tel': data['tel'],
      'tid': data['tid'],
      'time': data['time'],
      'title': data['title'],
      'cusName': data['cusName']
    };
  }

  void _confirmBook(BuildContext context) async {
    await _updateBookTile(context);
  }

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
                  ],
                ),
              ),
              SizedBox(
                height: 10,
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
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 120,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Confirm Detail',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            fontSize: 30,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            // service title
                            Column(
                              children: <Widget>[
                                Text(
                                  'Service Title',
                                  style: TextStyle(
                                    fontFamily: 'NimbusSanL',
                                    fontStyle: FontStyle.italic,
                                    color: Color.fromRGBO(237, 139, 0, 1),
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "${widget.service['title']}",
                                  style: TextStyle(
                                    fontFamily: 'NimbusSanL',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 30,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            // customer name column
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'customer Name',
                                  style: TextStyle(
                                    fontFamily: 'NimbusSanL',
                                    fontStyle: FontStyle.italic,
                                    color: Colors.blue,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  widget.service['cusName'],
                                  style: TextStyle(
                                    fontFamily: 'NimbusSanL',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),

                            // customer phone number
                            Column(
                              children: <Widget>[
                                Text(
                                  'customer tel',
                                  style: TextStyle(
                                    fontFamily: 'NimbusSanL',
                                    fontStyle: FontStyle.italic,
                                    color: Color.fromRGBO(164, 52, 68, 1),
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "${widget.service['tel']}",
                                  style: TextStyle(
                                    fontFamily: 'NimbusSanL',
                                    fontWeight: FontWeight.w100,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Row 2
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            // hostel
                            Column(
                              children: <Widget>[
                                Text(
                                  'customer Hostel',
                                  style: TextStyle(
                                    fontFamily: 'NimbusSanL',
                                    fontStyle: FontStyle.italic,
                                    fontSize: 16,
                                    color: Color.fromRGBO(255, 127, 127, 1),
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "${widget.service['hostelName']}",
                                  style: TextStyle(
                                    fontFamily: 'NimbusSanL',
                                    fontWeight: FontWeight.w300,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),

                            // price
                            Column(
                              children: <Widget>[
                                Text(
                                  'Service Price',
                                  style: TextStyle(
                                    fontFamily: 'NimbusSanL',
                                    fontStyle: FontStyle.italic,
                                    color: Color.fromRGBO(60, 214, 152, 1),
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "\Ghc${widget.service['price']}",
                                  style: TextStyle(
                                    fontFamily: 'NimbusSanL',
                                    fontWeight: FontWeight.w300,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // row 3
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            // date and time
                            Column(
                              children: <Widget>[
                                Text(
                                  'Appointment Date',
                                  style: TextStyle(
                                    fontFamily: 'NimbusSanL',
                                    fontStyle: FontStyle.italic,
                                    fontSize: 16,
                                    color: Color.fromRGBO(138, 21, 56, 1),
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "${widget.service['date']}",
                                  style: TextStyle(
                                    fontFamily: 'NimbusSanL',
                                    fontWeight: FontWeight.w200,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),

                            // customer phone number
                            Column(
                              children: <Widget>[
                                Text(
                                  'Appointment Time',
                                  style: TextStyle(
                                    fontFamily: 'NimbusSanL',
                                    fontStyle: FontStyle.italic,
                                    color: Color.fromRGBO(164, 52, 68, 1),
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "${widget.service['time']}",
                                  style: TextStyle(
                                    fontFamily: 'NimbusSanL',
                                    fontWeight: FontWeight.w300,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        MaterialButton(
                          onPressed: widget.service['status'] == 'pending'
                              ? _showDialogAndAcceptAppointment
                              : null,
                          color: widget.service['status'] == 'pending'
                              ? Color(0xffFF8573)
                              : Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            widget.service['status'],
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _showDialogAndAcceptAppointment() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Confirm Alert!!",
            style: TextStyle(
              fontFamily: 'NimbusSanL',
              fontWeight: FontWeight.w700,
              color: Colors.red,
              fontSize: 20,
            ),
          ),
          content: Center(
            child: Text(
                "Confirmed Appointment can not be reversed.\Are you sure you want to accept this Appointment?"),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "No",
                style: TextStyle(
                  fontFamily: 'NimbusSanL',
                  fontWeight: FontWeight.w700,
                  color: Colors.black54,
                  fontSize: 20,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                "Yes",
                style: TextStyle(
                  fontFamily: 'NimbusSanL',
                  fontWeight: FontWeight.w700,
                  color: Colors.blue,
                  fontSize: 20,
                ),
              ),
              onPressed: () {
                _confirmBook(context);
              },
            ),
          ],
        );
      },
    );
  }
}
