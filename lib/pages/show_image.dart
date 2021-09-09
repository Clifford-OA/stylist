import 'package:flutter/material.dart';

class ShowImage extends StatelessWidget {
  const ShowImage({Key? key, required this.imgUrl}) : super(key: key);
  final imgUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: Image.network(imgUrl)
              
          ),
        ),
        // onTap: () {
        //   Navigator.pop(context);
        // },
      ),
    );
  }
}
