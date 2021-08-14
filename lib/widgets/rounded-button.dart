import 'package:flutter/material.dart';
import 'package:stylist/constant.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    required this.buttonName,
    this.action,
  });

  final String buttonName;
  final action;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.08,
      width: size.width * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: kBlue,
      ),
      child: FlatButton(
        onPressed: action, // => Navigator.pushNamed(context, 'HomeScreen'),
        child: Text(
          buttonName,
          style: kBodyText.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
