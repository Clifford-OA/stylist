import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:stylist/auth/stylist.dart';

class ServiceTile extends StatelessWidget {
  final service;
  ServiceTile(this.service);

// menu list of actions 
  final List<MenuItem> menuItems = [
    MenuItem('delete', FontAwesomeIcons.removeFormat),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width / 2 - 40,
                child: Text(
                  service['title'],
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
                  "${service['duration']} \Min",
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w100,
                    fontSize: 15,
                  ),
                ),
            ],
          ),
          Text(
            "\Ghc${service['price']}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(
            child: PopupMenuButton(
              icon: Icon(Icons.more_vert),
              itemBuilder: (BuildContext context) {
                return menuItems.map((MenuItem menuItem) {
                  return PopupMenuItem(
                      value: menuItem.menuAction,
                      child: ListTile(
                        leading: Icon(
                          menuItem.iconData,
                          size: 20.0,
                          color: Colors.red,
                        ),
                        title: Text(
                          menuItem.menuAction,
                          style: TextStyle(color: Colors.red),
                        ),
                      ));
                }).toList();
              },
              onSelected: (String value) {
               return _valueActionHandler(value, context);
              },
            ),
          )
          // MaterialButton(
          //   onPressed: () {},
          //   color: service['status'] == 'pending'
          //       ? Color(0xffFF8573)
          //       : Colors.blue,
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(20),
          //   ),
          //   child: Text(
          //     service['status'],
          //     style: TextStyle(color: Colors.white),
          //   ),
          // ),
        ],
      ),
    );
  }

// string selected handler
  void _valueActionHandler(String action, BuildContext context) async {
    if (action == 'delete') {
      _deleteService(context);
    }
  }

// delete the service
  void _deleteService(BuildContext context) async {
    CollectionReference stylist =
        FirebaseFirestore.instance.collection('stylists');
    final stylistClass = Provider.of<Stylist>(context, listen: false);
    String tid = stylistClass.tid;
    List removeItem = [];
    removeItem.add(service);
    await stylist
        .doc(tid)
        .update({'serviceList': FieldValue.arrayRemove(removeItem)})
        .then((value) => _loadUserData(context, tid))
        .catchError((error) {
          print("Failed to book: $error");
        });
  }

// reload daata and set userData for provider to get access
  void _loadUserData(BuildContext context, String tid) async {
    CollectionReference stylist =
        FirebaseFirestore.instance.collection('stylists');
    final stylistClass = Provider.of<Stylist>(context, listen: false);
    await stylist.doc(tid).get().then((query) {
      Map<String, dynamic> data = query.data() as Map<String, dynamic>;
      stylistClass.stylistRef = data;
    });
  }
}

class MenuItem {
  String menuAction;
  IconData iconData;

  MenuItem(this.menuAction, this.iconData);
}
