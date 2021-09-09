import 'package:stylist/auth/stylist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class HistoryScreen extends StatelessWidget {
  // Display booked list for you
  Future<Widget> _displayHistory(BuildContext context) async {
    final stylistClass = Provider.of<Stylist>(context, listen: false);
    String tid = stylistClass.tid;
    List<Widget> list = [
      SizedBox(height: 0.0),
    ];
    await FirebaseFirestore.instance
        .collection('history')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        List<dynamic> data = doc['historyList'];
        for (var i = 0; i < data.length; i++) {
          if (data[i]['tid'] == tid) {
            // String personId = doc.id;
            list.add(HistoryTile(data[i]));
          }
        }
      });
    });

    return list.length > 1
        ? Column(
            children: list,
          )
        : Center(
            child: Text('Your history list is empty'),
          );
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
                        'Appointment History List',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'NimbusSanL',
                          color: Colors.green,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      FutureBuilder<Widget>(
                          future: _displayHistory(context),
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

class HistoryTile extends StatelessWidget {
  final service;
  HistoryTile(this.service);

  @override
  Widget build(BuildContext context) {
    final serviceRef = Provider.of<Service>(context, listen: false);
    Map<String, dynamic> serviceInfo = serviceRef.serviceRef;
    return Container(
      margin: EdgeInsets.only(bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          service['imgUrl'].contains('http')
              ? CircleAvatar(
                  radius: 30,
                  child: Image.network(service['imgUrl']),
                )
              : CircleAvatar(radius: 30),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width / 2 - 40,
                child: Text(
                  service['cusName'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                serviceInfo['title'],
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'date: ' + service['date'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              // Text(
              //   'time: ' + service['time'],
              //   style: TextStyle(
              //     fontWeight: FontWeight.bold,
              //     color: Colors.grey,
              //   ),
              // )
            ],
          ),
          // Text(
          //   '\Ghc${serviceInfo['price']}',
          //   style: TextStyle(
          //     fontWeight: FontWeight.bold,
          //     fontSize: 18,
          //   ),
          // ),
          MaterialButton(
            onPressed: () {},
            color:
                service['status'] == 'reschedule' ? Colors.brown : Colors.cyan,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              service['status'],
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
