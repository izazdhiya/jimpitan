import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TambahJimpitan extends StatefulWidget {
  const TambahJimpitan({Key? key}) : super(key: key);

  @override
  _TambahJimpitanState createState() => _TambahJimpitanState();
}

class _TambahJimpitanState extends State<TambahJimpitan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Tambah Jimpitan",
                style: GoogleFonts.poppins(
                    textStyle:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
            backgroundColor: Color(0xFFFF5521)),
        body: LayoutBuilder(builder: (context, index) => Container()));
  }
}
