import 'package:flutter/foundation.dart';

class Stylist extends ChangeNotifier {
  Stylist(this.imgUrl, this.tid, this.saloonName, this.serviceList, this.tel,
      this.stylistName, this.email);

  String saloonName;
  String tid;
  String stylistName;
  String imgUrl;
  int tel;
  List<dynamic> serviceList;
  String email;

  Map<String, dynamic> get stylistRef {
    return {'tid': tid, 'saloonName': saloonName, 'stylistName': stylistName};
  }

  String get stylistId => tid;

  set imageUrl(String newImageUrl) => imgUrl = newImageUrl;

  set stylistRef(Map<String, dynamic> data) {
    saloonName = data['saloonName'];
    serviceList = data['serviceList'];
    imgUrl = data['imgUrl'];
    tid = data['tid'];
    stylistName = data['stylistName'];
    email = data['email'];
    tel = data['tel'];
    notifyListeners();
  }
}

class Service {
  Service(this.duration, this.price, this.title);

  String title;
  double price;
  String duration;

  Map<String, dynamic> get serviceRef {
    return {'price': price, 'title': title};
  }

  set serviceRef(dynamic data) {
    title = data['title'];
    price = data['price'].toDouble();
    duration = data['duration'];
  }
}
