import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stylist/auth/stylist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stylist/widgets/rounded-button.dart';
import 'package:stylist/widgets/text-field-input.dart';

// ignore: must_be_immutable
class AddService extends StatefulWidget {
  // Display booked list for you
  @override
  _AddServiceState createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  String title = '';
  double price = 0.0;
  String duration = '';

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
                        'Add Service',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      TextInputField(
                        onChanged: (value) {
                          setState(() {
                            title = value;
                          });
                        },
                        icon: FontAwesomeIcons.heading,
                        hint: 'title',
                        inputType: TextInputType.emailAddress,
                        inputAction: TextInputAction.next,
                      ),
                      TextInputField(
                        onChanged: (value) {
                          setState(() {
                            price = double.parse(value);
                          });
                        },
                        icon: FontAwesomeIcons.envelope,
                        hint: 'price',
                        inputType: TextInputType.emailAddress,
                        inputAction: TextInputAction.next,
                      ),
                      TextInputField(
                        onChanged: (value) {
                          setState(() {
                            duration = value;
                          });
                        },
                        icon: FontAwesomeIcons.envelope,
                        hint: 'duration',
                        inputType: TextInputType.emailAddress,
                        inputAction: TextInputAction.next,
                      ),
                      RoundedButton(
                        buttonName: 'Create',
                        action: _validateAndCreateService,
                      )
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

  void _validateAndCreateService() {
    final errorResult = validateName();
    if (errorResult['status']) {
      _createService();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorResult['message'])));
    }
  }

  void _createService() async {
    CollectionReference stylist =
        FirebaseFirestore.instance.collection('stylists');
    final stylistClass = Provider.of<Stylist>(context, listen: false);
    String tid = stylistClass.tid;
    List service = [];
    service.add(toMap());
    await stylist
        .doc(tid)
        .update({'serviceList': FieldValue.arrayUnion(service)}).then((value) {
      _loadUserData();
      Navigator.pushNamed(context, 'HomeScreen');
      print('created successfully');
    }).catchError((error) {
      print("Failed to book: $error");
    });
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'duration': duration,
      'price': price,
    };
  }

  validateName() {
    Map errorHandler = {'status': false, 'message': ''};

    if (title.isEmpty || price.isNaN || duration.isEmpty) {
      errorHandler['message'] = 'None of the field should be empty';
      return errorHandler;
    } else if (title.length > 20 || title.length < 5) {
      errorHandler['message'] = 'title should be between 5 and 20 characters';
      return errorHandler;
    } else if (price.isNaN) {
      errorHandler['message'] = 'price should be a floating value';
    } else {
      errorHandler['status'] = true;
      return errorHandler;
    }
  }

  void _loadUserData() async {
    CollectionReference stylist =
        FirebaseFirestore.instance.collection('stylists');
    final stylistClass = Provider.of<Stylist>(context, listen: false);
    String tid = stylistClass.tid;

    await stylist.doc(tid).get().then((query) {
      Map<String, dynamic> data = query.data() as Map<String, dynamic>;
      stylistClass.stylistRef = data;
    });
  }
}
