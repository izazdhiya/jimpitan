// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jimpitan/view/dashboard.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<String> user = ['admin123@jimpitan.com', 'admin123'];

  bool _isHidePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _isHidePassword = !_isHidePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    // int heightSize = screenSize.height.toInt();
    // int widthSize = screenSize.width.toInt();
    return Scaffold(
        body: Container(
            child: ListView(
      children: [
        SizedBox(
          height: screenSize.height / 10,
        ),
        Container(
            height: screenSize.height / 4,
            child: Column(children: [
              Container(
                  child: Center(
                child: Image.asset("assets/images/logo.png",
                    width: 80, height: 80),
              )),
              Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Center(
                      child: Text("JIMPITAN",
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: Color(0xFFFF5521),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500))))),
            ])),
        Container(
            margin: EdgeInsets.only(left: 30, right: 30),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email tidak boleh kosong';
                          }
                          return null;
                        },
                        controller: _email,
                        decoration: InputDecoration(
                          labelText: 'Email',
                        ),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password tidak boleh kosong';
                          }
                          return null;
                        },
                        controller: _password,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          suffixIcon: GestureDetector(
                              onTap: () {
                                _togglePasswordVisibility();
                              },
                              child: Icon(
                                  _isHidePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: _isHidePassword
                                      ? Colors.grey
                                      : Colors.blue)),
                        ),
                        obscureText: _isHidePassword,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: screenSize.height / 10,
                ),
                MaterialButton(
                  color: Colors.blue,
                  onPressed: () {
                    if (_email.text == user[0] && _password.text == user[1]) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Dashboard()));
                    } else {
                      AlertDialog alert = AlertDialog(
                        title: Text("Peringatan!"),
                        content: Text("Email atau Password Salah"),
                        actions: [
                          MaterialButton(
                            color: Color(0xFFDF0000),
                            child: Text("OK",
                                style: TextStyle(
                                  color: Color(0xFFFAFAFA),
                                )),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      );
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return alert;
                        },
                      );
                    }
                  },
                  child: Text(
                    "LOGIN",
                    style: TextStyle(color: Color(0xFFFAFAFA)),
                  ),
                )
              ],
            )),
        SizedBox(
          height: screenSize.height / 5,
        ),
        Container(
            child: Center(
                child: Text("Gembong RT 13 RW 07",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: Color(0xFFFF5521),
                            fontSize: 12,
                            fontWeight: FontWeight.w500)))))
      ],
    )));
  }
}
