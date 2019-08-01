import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'LoginScreen.dart';


void main() {
  runApp(
      MaterialApp(
        title: 'Xpensa',
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        theme: ThemeData(
          primaryColor: Colors.black,
          primaryColorDark: const Color(0xFF167F67),
          accentColor: const Color(0xFF167F67),

        ),
      )
  );
}


class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SplashScreen();
  }

}

class _SplashScreen extends State<SplashScreen> {

  @override
  void initState() {
    new Future.delayed(
        const Duration(seconds: 3),
            () {
          //SystemNavigator.pop();
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          );
        });
  }

  AssetImage assetImage = new AssetImage('images/splash.jpg');

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

//    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    //services.getLocation();
    return Scaffold(
        body: Stack(
          children: <Widget>[
            Image(image: assetImage,
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              width: MediaQuery
                  .of(context)
                  .size
                  .height,
              fit: BoxFit.fill,
              repeat: ImageRepeat.noRepeat,
            ),
          ],
        )
    );
  }


}