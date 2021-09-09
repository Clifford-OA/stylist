import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:stylist/auth/stylist.dart';
import 'package:stylist/widgets/rounded-button.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();

  String imgUrl = '';

  String name = '';
  String salon = '';
  String _tel = '';
  bool _loadImage = false;

  Widget textfield({@required hintText, onChanged, formatters, TextInputType? inputType}) {
    return Material(
      elevation: 3,
      shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        inputFormatters: formatters,
        onChanged: onChanged,
        keyboardType: inputType,
            // hintText == 'tel' ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              letterSpacing: 2,
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
            fillColor: Colors.white30,
            filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stylistClass = Provider.of<Stylist>(context, listen: true);
    String stylistName = stylistClass.stylistName;
    String saloonName = stylistClass.saloonName;
    String email = stylistClass.email;
    String image = stylistClass.imgUrl;
    String tel = stylistClass.tel;
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
        elevation: 0.0,
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Profile",
                        style: TextStyle(
                          fontSize: 35,
                          letterSpacing: 1.5,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(5.0),
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.width / 2,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: _loadImage == false
                            ? FadeInImage.assetNetwork(
                                placeholder: 'assets/images/no_picture.jpg',
                                image: image,
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/no_picture.jpg',
                                  );
                                },
                                fit: BoxFit.cover,
                              )
                            : Center(
                                child: CircularProgressIndicator(),
                              ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 400,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      textfield(
                        inputType: TextInputType.text,
                        formatters: [
                               FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]'))
                            ],
                          hintText: stylistName,
                          onChanged: (value) {
                            setState(() {
                              name = value;
                            });
                          }),
                      textfield(
                        inputType: TextInputType.text,
                        formatters: [
                                FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]'))
                            ],
                          hintText: saloonName,
                          onChanged: (value) {
                            setState(() {
                              salon = value;
                            });
                          }),
                      textfield(
                        inputType: TextInputType.text,
                          hintText: email,
                          onChanged: (value) {
                            setState(() {
                              name = value;
                            });
                          }),
                      textfield(
                        inputType: TextInputType.number,
                        formatters: [
                               FilteringTextInputFormatter.digitsOnly
                            ],
                          hintText: tel,
                          onChanged: (value) {
                            setState(() {
                              tel = value;
                            });
                          }),
                      RoundedButton(
                        buttonName: 'Update',
                        action: _validateAndCreateService,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 270, left: 184),
              child: CircleAvatar(
                backgroundColor: Colors.black54,
                child: IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  onPressed: _getImage,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future _getImage() async {
    final stylistClass = Provider.of<Stylist>(context, listen: false);
    late File image;
    String tid = stylistClass.tid;
    final XFile? img = await _picker.pickImage(source: ImageSource.gallery);
    _loadImage = true;
    File file = File(img!.path);
    setState(() {
      image = file;
    });
    var storeImage = FirebaseStorage.instance.ref().child(image.path);
    var task = await storeImage.putFile(image);
    imgUrl = await storeImage.getDownloadURL();
    print('downloadurl ' + imgUrl);
    await FirebaseFirestore.instance
        .collection('stylists')
        .doc(tid)
        .update({'imgUrl': imgUrl}).then((value) {
      stylistClass.imageUrl = imgUrl;
      _loadImage = false;
    });
  }

// validate and update stylist info
  void _validateAndCreateService() async {
    CollectionReference stylist =
        FirebaseFirestore.instance.collection('stylists');
    final stylistClass = Provider.of<Stylist>(context, listen: false);
    String tid = stylistClass.tid;
    final errorResult = validateName();
    if (errorResult['status']) {
      await stylist.doc(tid).update(
          {'stylistName': name, 'saloonName': salon, 'tel': _tel}).then((value) {
        _reloadUserData();
        Navigator.pushNamed(context, 'HomeScreen');
        print('created successfully');
      }).catchError((error) {
        print("Failed to book: $error");
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorResult['message'])));
    }
  }

// reload user data for provider to get access
  void _reloadUserData() async {
    CollectionReference stylist =
        FirebaseFirestore.instance.collection('stylists');
    final stylistClass = Provider.of<Stylist>(context, listen: false);
    String tid = stylistClass.tid;

    await stylist.doc(tid).get().then((query) {
      Map<String, dynamic> data = query.data() as Map<String, dynamic>;
      stylistClass.stylistRef = data;
    });
  }

// validate all field
  validateName() {
    Map errorHandler = {'status': false, 'message': ''};

    if (name.isEmpty || salon.isEmpty || _tel.isEmpty) {
      errorHandler['message'] = 'None of the field should be empty';
      return errorHandler;
    } else if (name.length < 4) {
      errorHandler['message'] =
          'stylist name should not be less than 4 characters';
      return errorHandler;
    } else if (salon.length > 20) {
      errorHandler['message'] =
          'saloon name should not be more than 20 characters';
      return errorHandler;
    } else if (_tel.trim().length != 10) {
      errorHandler['message'] = 'tel field should be only 10 integers';
      return errorHandler;
    } else {
      errorHandler['status'] = true;
      return errorHandler;
    }
  }
}
