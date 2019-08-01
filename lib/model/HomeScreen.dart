import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;
import 'package:project/model/userDetailsModel.dart';

import '../Utils.dart';

class Home extends StatefulWidget {

  final String token;
  Home({Key key, @required this.token}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Home(token: token);
  }
}

class _Home extends State<Home> {
  var loading = false;
  final String token;
  _Home({@required this.token}) : super();

  Map _source = {ConnectivityResult.none: false};
  MyConnectivity _connectivity = MyConnectivity.instance;

  @override
  void initState() {
    super.initState();
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });
  }

  Widget build(BuildContext context) {
    String onlineStatus;
    switch (_source.keys.toList()[0]) {
      case ConnectivityResult.none:
        onlineStatus = "Offline";
        break;
      case ConnectivityResult.mobile:
        onlineStatus = "Mobile: Online";
        break;
      case ConnectivityResult.wifi:
        onlineStatus = "WiFi: Online";
    }

    if (onlineStatus.toUpperCase().contains("OFFLINE")) {
      return Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 0.19),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new IconButton(
                    icon: new Icon(Icons.signal_wifi_off),
                    tooltip: 'Internet no disponible',
                    onPressed: () => {},
                  ),
                  new Text("Internet no disponible")
                ],
              )
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder<UserDetailsModel>(
          future: getUserDetails(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text("Welcome "+snapshot.data.name);
            } else if (snapshot.hasError) {
              return Text("Error Feting name : ${snapshot.error}");
            }

            // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Future<UserDetailsModel> getUserDetails() async {
    print("received token is token : "+token);
    var theIncomingData = await http.post(
        "http://xpensa.net/api/get_user_details",
        body: FormData.from({
          "token": token.toString(),
        }));
    if(theIncomingData.statusCode == 200){
      print(theIncomingData.body);
      return UserDetailsModel.fromJson(json.decode(theIncomingData.body));
    }else{
      throw Exception('Failed to load post');
    }
  }
}
