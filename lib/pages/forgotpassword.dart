import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stylist/auth/auth.dart';
import 'package:stylist/constant.dart';
import 'package:stylist/widgets/background-image.dart';
import 'package:stylist/widgets/rounded-button.dart';
import 'package:stylist/widgets/text-field-input.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String email = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return isLoading == false
        ? Stack(
            children: [
              backgroundImage('assets/images/background.jpg'),
              Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: kWhite,
                    ),
                  ),
                  title: Text(
                    'Forgot Password',
                    style: kBodyText,
                  ),
                  centerTitle: true,
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.1,
                            ),
                            Container(
                              width: size.width * 0.8,
                              child: Text(
                                'Enter your email we will send instruction to reset your password',
                                style: kBodyText,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextInputField(
                              onChanged: (value) {
                                email = value;
                              },
                              icon: FontAwesomeIcons.envelope,
                              hint: 'Email',
                              inputType: TextInputType.emailAddress,
                              inputAction: TextInputAction.done,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            RoundedButton(
                              buttonName: 'Send',
                              action: resetPasswordHandler,
                            )
                          ],
                        ),
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

  void resetPasswordHandler() {
    setState(() {
      isLoading = true;
    });
    AuthClass().resetPassword(email).then((value) async {
      if (value['status']) {
        setState(() {
          isLoading = false;
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Alert!!"),
              content: Text("Check in your email to reset your password"),
              actions: <Widget>[
                FlatButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(value['message'])));
      }
    });
  }
}
