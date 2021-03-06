import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stylist/pages/show_image.dart';

class BookDetailPage extends StatefulWidget {
  final service;
  final String personId;
  BookDetailPage(this.service, this.personId);

  @override
  _BookDetailPageState createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  Future _updateBookTile(BuildContext context, String label) async {
    CollectionReference bookList =
        FirebaseFirestore.instance.collection('booklist');
    List removeItem = [];
    removeItem.add(widget.service);
    await bookList
        .doc(widget.personId)
        .update({'bookedList': FieldValue.arrayRemove(removeItem)})
        .then((value) => label == 'confirmed'
            ? _reCreateService(context, label)
            : _addToHistoryList(label))
        .catchError((error) {
          print("Failed to remove service: $error");
        });
  }

  Future _reCreateService(BuildContext context, String label) async {
    CollectionReference bookList =
        FirebaseFirestore.instance.collection('booklist');
    List createBook = [];
    createBook.add(toMap(widget.service, label));
    await bookList.doc(widget.personId).update(
        {'bookedList': FieldValue.arrayUnion(createBook)}).then((value) {
      setState(() {
        widget.service['status'] = label;
      });
      Navigator.pop(context);
    }).catchError((error) {
      print("Failed to book: $error");
    });
  }

  Future<void> _addToHistoryList(String label) async {
    CollectionReference historyList =
        FirebaseFirestore.instance.collection('history');
    List bookItem = [];
    bookItem.add(toMap(widget.service, label));
    List<String> ids = [];
    // await FirebaseFirestore.instance
    //     .collection('history')
    await historyList.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        ids.add(doc.id);
      });
    });
    if (ids.contains(widget.personId)) {
      await historyList.doc(widget.personId).update(
          {'historyList': FieldValue.arrayUnion(bookItem)}).then((value) {
            setState(() {
        widget.service['status'] = label;
      });
        Navigator.pop(context);
      }).catchError((error) {
        print("Failed to book: $error");
      });
    } else {
      await historyList
          .doc(widget.personId)
          .set({'historyList': FieldValue.arrayUnion(bookItem)}).then((value) {
            setState(() {
        widget.service['status'] = label;
      });
        Navigator.pop(context);
      }).catchError((error) {
        print("Failed to book: $error");
      });
    }
  }

  Map<String, dynamic> toMap(dynamic data, String label) {
    return {
      'date': data['date'],
      'hostelName': data['hostelName'],
      'price': data['price'],
      'status': label,
      'imgUrl' : data['imgUrl'],
      'stylistName': data['stylistName'],
      'tel': data['tel'],
      'tid': data['tid'],
      'time': data['time'],
      'title': data['title'],
      'cusName': data['cusName']
    };
  }

  void _confirmBook(BuildContext context, String label) async {
    await _updateBookTile(context, label);
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
                        widget.service['imgUrl'].contains('http')
                            ? Center(
                                child: GestureDetector(
                                  child: CircleAvatar(
                                    radius: 60,
                                    child:
                                        Image.network(widget.service['imgUrl']),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ShowImage(
                                                  imgUrl:
                                                      widget.service['imgUrl'],
                                                )));
                                  },
                                ),
                              )
                            : Center(),
                        SizedBox(
                          height: 1,
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

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            widget.service['status'] == 'pending'
                                ? MaterialButton(
                                    onPressed: () {
                                      _showDialogAndAcceptAppointment(
                                          'confirmed');
                                    },
                                    color: Color(0xffFF8573),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      widget.service['status'],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                : widget.service['status'] == 'confirmed'
                                    ? MaterialButton(
                                        onPressed: () {
                                          _showDialogAndAcceptAppointment(
                                              'Done');
                                        },
                                        color: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          'Done',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    : Center(),
                            // Color(0xffFF8573)
                            widget.service['status'] == 'reschedule'
                                ? Center()
                                : MaterialButton(
                                    onPressed: () {
                                      _showDialogAndAcceptAppointment(
                                          'reschedule');
                                    },
                                    color: Colors.brown,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'reschedule',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                          ],
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

  Future _showDialogAndAcceptAppointment(String label) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: label == 'confirmed'
              ? Text(
                  "Confirm Alert!!",
                  style: TextStyle(
                    fontFamily: 'NimbusSanL',
                    fontWeight: FontWeight.w700,
                    color: Colors.red,
                    fontSize: 20,
                  ),
                )
              : label == 'Done'
                  ? Text('Appointment Done Alert!!',
                      style: TextStyle(
                        fontFamily: 'NimbusSanL',
                        fontWeight: FontWeight.w700,
                        color: Colors.blue,
                        fontSize: 20,
                      ))
                  : Text('Reschedule Alert!!',
                      style: TextStyle(
                        fontFamily: 'NimbusSanL',
                        fontWeight: FontWeight.w700,
                        color: Colors.brown,
                        fontSize: 20,
                      )),
          content: Center(
            child: label == 'confirmed'
                ? Text(
                    "Confirmed Appointment can not be reversed.\Are you sure you want to accept this Appointment?")
                : label == 'Done'
                    ? Text('Are you sure you are done with this appointment?')
                    : Text('Click on OK to reschedule this appointment'),
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
                _confirmBook(context, label);
              },
            ),
          ],
        );
      },
    );
  }
}
