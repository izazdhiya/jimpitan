import 'package:flutter/material.dart';

class Pengambilan extends StatefulWidget {
  const Pengambilan({Key? key}) : super(key: key);

  @override
  _PengambilanState createState() => _PengambilanState();
}

class _PengambilanState extends State<Pengambilan> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    int heightSize = screenSize.height.toInt();
    int widthSize = screenSize.width.toInt();
    return Scaffold(
        appBar: AppBar(
            title: Text("Pengambilan Jimpitan"),
            backgroundColor: Color(0xFFFF5521)),
        body: LayoutBuilder(
            builder: (context, index) => Container(
                child: heightSize > widthSize
                    ?
                    // Portrait View
                    Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: TextField(),
                          ),
                          Expanded(
                              flex: 5,
                              child: Container(
                                color: Colors.yellow,
                              ))
                        ],
                      )
                    : Column(
                        children: [TextField()],
                      ))));
  }
}
