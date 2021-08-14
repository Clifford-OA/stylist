import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stylist/pages/book_detail_page.dart';

class BookedTile extends StatefulWidget {
  final service;
  final String personId;
  BookedTile(this.service, this.personId);

  @override
  _BookedTileState createState() => _BookedTileState();
}

class _BookedTileState extends State<BookedTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 30),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2 - 40,
                    child: Text(
                      widget.service['cusName'],
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
                    widget.service['title'],
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
              Text(
                '\Ghc${widget.service['price']}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              MaterialButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            BookDetailPage(widget.service, widget.personId))),
                color:  widget.service['status'] == 'confirmed' ? Colors.green : Colors.black54,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child:  Text(
                  widget.service['status'],
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
 
  }
}
