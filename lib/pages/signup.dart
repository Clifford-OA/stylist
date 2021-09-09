import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:stylist/auth/auth.dart';
import 'package:stylist/auth/stylist.dart';
import 'package:stylist/auth/userData.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stylist/constant.dart';
import 'package:stylist/widgets/background-image.dart';
import 'package:stylist/widgets/password-input.dart';
import 'package:stylist/widgets/rounded-button.dart';
import 'package:stylist/widgets/text-field-input.dart';
import 'package:provider/provider.dart';
// import 'package:beauty_plus/widgets/widgets.dart';

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email = '';
  String name = '';
  String tel = '';
  String saloonName = '';
  String password = '';
  String passwordConf = '';
  bool isLoading = false;

// validate all field 
  validateName() {
    Map errorHandler = {'status': false, 'message': ''};
    if (name.isEmpty || saloonName.isEmpty || tel.isEmpty){
      errorHandler['message'] = 'None of the field should be empty';
      return errorHandler;
    } else if (name.length < 4) {
      errorHandler['message'] = 'stylist name should not be less than 4 characters';
      return errorHandler;
    }else if (saloonName.length > 20) {
      errorHandler['message'] = 'saloon name should not be more than 20 characters';
      return errorHandler;
    }else if (tel.trim().length != 10 ) {
      errorHandler['message'] = 'tel field should be only 10 integers';
      return errorHandler;
    }else if (password != passwordConf) {
      errorHandler['message'] = 'password and passwordConf must be equal';
      return errorHandler;
    }
     else {
      errorHandler['status'] = true;
      return errorHandler;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return isLoading == false
        ? Stack(
            children: [
              backgroundImage('assets/images/1.jpg'),
              Scaffold(
                backgroundColor: Colors.transparent,
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                   
                      SizedBox(
                        height: size.width * 0.1,
                      ),
                      Column(
                        children: [
                          TextInputField(
                            onChanged: (value) {
                              setState(() {
                                name = value;
                              });
                            },
                            icon: FontAwesomeIcons.user,
                            hint: 'stylist name',
                            inputType: TextInputType.name,
                            inputAction: TextInputAction.next,
                            formatters: [
                               FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]'))

                            ],
                          ),
                           TextInputField(
                            onChanged: (value) {
                              setState(() {
                                saloonName = value;
                              });
                            },
                            icon: FontAwesomeIcons.store,
                            hint: 'salon name',
                            inputType: TextInputType.name,
                            inputAction: TextInputAction.next,
                             formatters: [
                               FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]'))

                            ],
                          ),
                          TextInputField(
                            onChanged: (value) {
                              setState(() {
                                email = value;
                              });
                            },
                            icon: FontAwesomeIcons.envelope,
                            hint: 'Email',
                            inputType: TextInputType.emailAddress,
                            inputAction: TextInputAction.next,
                          ),
                           TextInputField(
                            onChanged: (value) {
                              setState(() {
                                tel = value;
                              });
                            },
                            icon: FontAwesomeIcons.phone,
                            hint: 'tel',
                            inputType: TextInputType.name,
                            inputAction: TextInputAction.next,
                             formatters: [
                               FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                          PasswordInput(
                            onChanged: (value) {
                              setState(() {
                                password = value;
                              });
                            },
                            icon: FontAwesomeIcons.lock,
                            hint: 'Password',
                            inputAction: TextInputAction.next,
                            inputType: TextInputType.text,
                          ),
                          PasswordInput(
                            onChanged: (value) {
                              setState(() {
                                passwordConf = value;
                              });
                            },
                            icon: FontAwesomeIcons.lock,
                            hint: 'Confirm Password',
                            inputAction: TextInputAction.done,
                            inputType: TextInputType.text,
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          RoundedButton(
                            buttonName: 'Register',
                            action: validateAndSignUp,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account?',
                                style: kBodyText,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/');
                                },
                                child: Text(
                                  'Login',
                                  style: kBodyText.copyWith(
                                      color: kBlue,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }

// load current user data for provider to get access 
   void _loadUserData()async {
      CollectionReference stylist = FirebaseFirestore.instance.collection('stylists');
      final authClass = Provider.of<AuthClass>(context, listen: false);
      final stylistClass = Provider.of<Stylist>(context, listen: false);
      String tid = authClass.auth.currentUser!.uid;

      await stylist.doc(tid).get().then((query){
        Map<String, dynamic> data = query.data() as Map<String, dynamic>;
        stylistClass.stylistRef = data;
      });
   }

// validate and sign users up 
  void validateAndSignUp() {
    final userData = Provider.of<UserData>(context, listen: false);
    UserData _userData = userData.userDataRef;
    final errorResult = validateName();
    if (errorResult['status']) {
      setState(() {
        isLoading = true;
      });
      AuthClass().createAccount(_userData, email, password).then((value) async {
        if (value['status']) {
          _userData.stylistName = name;
          _userData.saloonName = saloonName;
          _userData.tel= tel;
          print('UserDataId : ' + _userData.tid);
          await _userData.saveInfo();
        _loadUserData();
        setState(() {
            isLoading = false;
          });
          Navigator.pushNamed(context, 'HomeScreen');
        } else {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(value['message'])));
        }
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorResult['message'])));
    }
  }

  
}
