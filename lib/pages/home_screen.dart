import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:stylist/auth/stylist.dart';
import 'package:stylist/widgets/service_tile.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isOpen = false;
  PanelController _panelController = PanelController();
  String imgUrl = '';
  late Map<String, dynamic> data;

  /// **********************************************
  /// LIFE CYCLE METHODS
  /// **********************************************

  /// service access widget using the service tile for current user
  Widget _displayServices(BuildContext context) {
    final stylistClass = Provider.of<Stylist>(context, listen: false);
    List services = stylistClass.serviceList;
    List<Widget> list = [
      SizedBox(height: 0.0),
    ];

    if (services.isNotEmpty) {
      services.forEach((service) => list.add(ServiceTile(service)));
    }
    return list.length > 1
        ? Column(
            children: list,
          )
        : Center(
            child: Text('Your book list is empty'),
          );
  }


  String _imageChange(String image) {
    setState(() {
      imgUrl = image;
    });
    return imgUrl;
  }

  @override
  Widget build(BuildContext context) {
    final stylistClass = Provider.of<Stylist>(context, listen: true);
    imgUrl = _imageChange(stylistClass.imgUrl);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          FractionallySizedBox(
            alignment: Alignment.topCenter,
            heightFactor: 0.7,
            child: Container(
              child: imgUrl.contains('http') ? FadeInImage.assetNetwork(
                placeholder: 'assets/images/no_picture.jpg',
                image: imgUrl,
                // imageErrorBuilder: (context, error, stackTrace) {
                //   return Image.asset(
                //     'assets/images/no_picture.jpg',
                //   );
                // },
                fit: BoxFit.cover,
              ) : Image.asset('assets/images/no_picture.jpg')
            )
          ),

          FractionallySizedBox(
            alignment: Alignment.bottomCenter,
            heightFactor: 0.3,
            child: Container(
              color: Colors.white,
            ),
          ),

          /// Sliding Panel
          SlidingUpPanel(
            controller: _panelController,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(32),
              topLeft: Radius.circular(32),
            ),
            minHeight: MediaQuery.of(context).size.height * 0.35,
            maxHeight: MediaQuery.of(context).size.height * 0.85,
            body: GestureDetector(
              onTap: () => _panelController.close(),
              child: Container(
                color: Colors.transparent,
              ),
            ),
            panelBuilder: (ScrollController controller) =>
                _panelBody(controller),
            onPanelSlide: (value) {
              if (value >= 0.2) {
                if (!_isOpen) {
                  setState(() {
                    _isOpen = true;
                  });
                }
              }
            },
            onPanelClosed: () {
              setState(() {
                _isOpen = false;
              });
            },
          ),
        ],
      ),
    );
  }

  /// **********************************************
  /// WIDGETS
  /// **********************************************

  /// Panel Body
  SingleChildScrollView _panelBody(ScrollController controller) {
    double hPadding = 40;

    return SingleChildScrollView(
      controller: controller,
      physics: ClampingScrollPhysics(),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: hPadding),
            height: MediaQuery.of(context).size.height * 0.35,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _titleSection(),
                _infoSection(),
                _actionSection(hPadding: hPadding),
              ],
            ),
          ),
          Text(
            'Service List',
            style: TextStyle(
              fontFamily: 'NimbusSanL',
              fontWeight: FontWeight.w700,
              fontSize: 30,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          OutlineButton(
            onPressed: () => Navigator.pushNamed(context, 'AddService'),
            borderSide: BorderSide(color: Colors.blue),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            child: Text(
              'ADD SERVICE',
              style: TextStyle(
                fontFamily: 'NimbusSanL',
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
       
          Container(
            padding: EdgeInsets.all(20),
            child: _displayServices(context) ,
          )
        
        ],
      ),
    );
  }

  /// Action Section
  Row _actionSection({required double hPadding}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Visibility(
          visible: !_isOpen,
          child: Expanded(
            child: OutlineButton(
              onPressed: () => _panelController.open(),
              borderSide: BorderSide(color: Colors.blue),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: Text(
                'SERVICE',
                style: TextStyle(
                  fontFamily: 'NimbusSanL',
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: !_isOpen,
          child: SizedBox(
            width: 12,
          ),
        ),
        Visibility(
          visible: !_isOpen,
          child: Expanded(
            child: OutlineButton(
              onPressed: () => Navigator.pushNamed(context, 'ProfilePage'),
              borderSide: BorderSide(color: Colors.blue),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: Text(
                'PROFILE',
                style: TextStyle(
                  fontFamily: 'NimbusSanL',
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: !_isOpen,
          child: SizedBox(
            width: 12,
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: SizedBox(
              width: _isOpen
                  ? (MediaQuery.of(context).size.width - (2 * hPadding)) / 1.6
                  : double.infinity,
              child: FlatButton(
                onPressed: () => Navigator.pushNamed(context, 'BookList'),
                color: Colors.blue,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: Text(
                  'BOOK',
                  style: TextStyle(
                    fontFamily: 'NimbusSanL',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Info Section
  Row _infoSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _infoCell(title: 'job Offer(s)', value: '1135'),
        Container(
          width: 1,
          height: 40,
          color: Colors.grey,
        ),
        _infoCell(title: 'Hourly Rate', value: "\Ghc65"),
        Container(
          width: 1,
          height: 40,
          color: Colors.grey,
        ),
        _infoCell(title: 'Location', value: 'Ayeduase'),
      ],
    );
  }

  /// Info Cell
  Column _infoCell({required String title, required String value}) {
    return Column(
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w300,
            fontSize: 14,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  /// Title Section
  Column _titleSection() {
    final stylistClass = Provider.of<Stylist>(context, listen: false);
    String stylistName = stylistClass.stylistName;
    return Column(
      children: <Widget>[
        Text(
          stylistName,
          style: TextStyle(
            fontFamily: 'NimbusSanL',
            fontWeight: FontWeight.w700,
            fontSize: 30,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          'Stylist',
          style: TextStyle(
            fontFamily: 'NimbusSanL',
            fontStyle: FontStyle.italic,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
