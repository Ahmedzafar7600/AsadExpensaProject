import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flat_icons_flutter/flat_icons_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'Utils.dart';
import 'model/HomeScreen.dart';
import 'model/loginModel.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Login();
  }
}

class _Login extends State<Login> {
  @override
  AssetImage background = new AssetImage('images/background.png');
  AssetImage logo = new AssetImage('images/xpensa.png');

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var formkey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _saving = false;

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
          color: Colors.white12,
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
          )),
        ),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Image(
                  image: background,
                  fit: BoxFit.fill,
                  repeat: ImageRepeat.noRepeat),
              Form(
                key: formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height / 4,
                      width: MediaQuery.of(context).size.width / 4,
                      child: Image(
                        image: logo,
                        width: 100,
                        height: 100,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(90.0),
                        child: Container(
                          margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width / 20,
                              right: MediaQuery.of(context).size.width / 20),
                          color: Colors.black.withOpacity(0.20),
                          child: TextFormField(
                            controller: emailController,
                            style: TextStyle(color: Colors.white),
                            validator: (String val) {
                              if (val.isEmpty) {
                                return "Usuario";
                              }
                              return val;
                            },
                            //controller: username,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              fillColor: Colors.white.withOpacity(0.10),
                              prefixIcon: Icon(
                                FlatIcons.user,
                                color: Colors.blue,
                              ),
                              hintText: "Usuario",
                              hintStyle: TextStyle(color: Colors.grey),
                              labelText: 'Usuario',
                              labelStyle: TextStyle(color: Colors.grey[400]),
                              border: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(90.0),
                        child: Container(
                          margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width / 20,
                              right: MediaQuery.of(context).size.width / 20),
                          color: Colors.black.withOpacity(0.20),
                          child: TextFormField(
                            obscureText: true,
                            controller: passwordController,
                            style: TextStyle(color: Colors.white),
                            validator: (String val) {
                              if (val.isEmpty) {
                                return "Contrasena";
                              }
                              return val;
                            },
                            //controller: username,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              fillColor: Colors.white.withOpacity(0.10),
                              prefixIcon: Icon(
                                FlatIcons.user,
                                color: Colors.blue,
                              ),
                              hintText: "Contrasena",
                              hintStyle: TextStyle(color: Colors.grey),
                              labelText: 'Contrasena',
                              labelStyle: TextStyle(color: Colors.grey[400]),
                              border: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 40.0, right: 40.0, top: 10.0),
                      child: Container(
                        height: 60.0,
                        width: (MediaQuery.of(context).size.width),
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          onPressed: () async {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            _saving = true;
                            print("name:" + emailController.text.toString());
                            var response =
                                await http.post("http://xpensa.net/api/login",
                                    body: FormData.from({
                                      "email": emailController.text.toString(),
                                      "password":
                                          passwordController.text.toString()
                                    }));
                            if (response.statusCode == 200) {
                              print("mydata" + response.body.toString());
                              Welcome loginResponse =
                                  Welcome.fromJson(json.decode(response.body));
                              if (loginResponse.result !=
                                  "wrong email or password.") {
                                _saving = false;
                                Route route = MaterialPageRoute(
                                    builder: (BuildContext context) => Home(
                                          token: loginResponse.result,
                                        ));
                                Navigator.pushReplacement(context, route);
                              } else {

                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text(loginResponse.result),
                                ));
                                setState(() {
                                  _saving = false;
                                });
                              }
                            } else {
                              setState(() {
                                _saving = false;
                              });
                              print("mydata" +
                                  "Error getting data response code" +
                                  response.statusCode.toString());
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text("Error api call code: " +
                                    response.statusCode.toString()),
                                backgroundColor: Colors.black26,
                              ));
                            }
                          },
                          color: Color.fromRGBO(2, 109, 181, 10),
                          child: Text(
                            "Ingresar",
                            style: TextStyle(color: Colors.white, fontSize: 20.0
                                //Color.fromRGBO(25, 164, 153, 1),
//                            fontFamily: 'OpenSansRegular',
//                            fontSize: 22.0,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                  bottom: 10.0,
                  left: MediaQuery.of(context).size.width / 5,
                  child: Center(
                      child: Text(
                    'Olvidaste tu contrasena?',
                    style: TextStyle(color: Colors.blue, fontSize: 20.0),
                  )))
            ],
          ),
        ),
      ),
    );
  }
}
