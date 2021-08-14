import 'package:stylist/auth/stylist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stylist/widgets/book_tile.dart';

// ignore: must_be_immutable
class BookList extends StatelessWidget {
  // Display booked list for you
  Future<Widget> _displayBook(BuildContext context) async {
    final stylistClass = Provider.of<Stylist>(context, listen: false);
    String tid = stylistClass.tid;
    List<Widget> list = [
      SizedBox(height: 0.0),
    ];
    await FirebaseFirestore.instance
        .collection('booklist')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        List<dynamic> data = doc['bookedList'];
        for (var i = 0; i < data.length; i++) {
          if (data[i]['tid'] == tid) {
            String personId = doc.id;
            list.add(BookedTile(data[i], personId));
          }
        }
      });
    });

    return list.length > 1
        ? Column(
            children: list,
          )
        : Center(
            child: Text('Your book list is empty'),
          );
  }

  // Widget display(BuildContext context) {
  //   Widget take = _displayBook(context) as Widget;
  //   return take;
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
                        'Booked List and Its Status',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'NimbusSanL',
                          color: Colors.black54,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      FutureBuilder<Widget>(
                          future: _displayBook(context),
                          builder: (BuildContext context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasData) {
                                return snapshot.data as Widget;
                              }
                            }
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }),
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
}
