import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jimpitan/view/dashboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startSplashScreen();
  }

  startSplashScreen() async {
    var duration = const Duration(seconds: 5);
    return Timer(duration, () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
        return Dashboard();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    int heightSize = screenSize.height.toInt();
    int widthSize = screenSize.width.toInt();
    return Scaffold(
        body: LayoutBuilder(
            builder: (context, constraints) => Container(
                child: heightSize > widthSize
                    ?
                    // Portrait View
                    Column(
                        children: [
                          SizedBox(
                            height: screenSize.height / 4,
                          ),
                          Container(
                              height: screenSize.height / 4,
                              child: Column(children: [
                                Container(
                                    child: Center(
                                  child: Image.asset("assets/images/logo.png",
                                      width: 100, height: 100),
                                )),
                                Container(
                                    margin: EdgeInsets.only(top: 20),
                                    child: Center(
                                        child: Text("JIMPITAN",
                                            style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    color: Color(0xFFFF5521),
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w500))))),
                              ])),
                          SizedBox(
                            height: screenSize.height / 5,
                          ),
                          Container(
                              child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.blue),
                          )),
                          SizedBox(
                            height: screenSize.height / 5,
                          ),
                          Container(
                              child: Center(
                                  child: Text("Gembong RT 13/ 07",
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              color: Color(0xFFFF5521),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500)))))
                        ],
                      )
                    :
                    // Landscape View
                    Column(
                        children: [
                          SizedBox(
                            height: screenSize.height / 5,
                          ),
                          Container(
                              height: screenSize.height / 3,
                              child: Column(children: [
                                Container(
                                    child: Center(
                                  child: Image.asset("assets/images/logo.png",
                                      width: 70, height: 70),
                                )),
                                Container(
                                    margin: EdgeInsets.only(top: 20),
                                    child: Center(
                                        child: Text("JIMPITAN",
                                            style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    color: Color(0xFFFF5521),
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w500))))),
                              ])),
                          SizedBox(
                            height: screenSize.height / 7,
                          ),
                          Container(
                              child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.blue),
                          )),
                          SizedBox(
                            height: screenSize.height / 7,
                          ),
                          Container(
                              child: Center(
                                  child: Text("Gembong RT 13/ 07",
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              color: Color(0xFFFF5521),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500)))))
                        ],
                      ))));
  }
}
