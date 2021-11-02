import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:jimpitan/view/tambahjimpitan.dart';

class Jimpitan extends StatefulWidget {
  const Jimpitan({Key? key}) : super(key: key);

  @override
  _JimpitanState createState() => _JimpitanState();
}

class _JimpitanState extends State<Jimpitan> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Size screenSize = MediaQuery.of(context).size;
    // int heightSize = screenSize.height.toInt();
    // int widthSize = screenSize.width.toInt();
    return Scaffold(
      appBar: AppBar(
          title: Text("Jimpitan Hari Ini",
              style: GoogleFonts.poppins(
                  textStyle:
                      TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
          backgroundColor: Color(0xFFFF5521)),
      body: LayoutBuilder(
          builder: (context, index) => Container(
                  child: Center(
                child: Text("Tidak Ada Data"),
              ))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  scrollable: true,
                  title: Text('Tambah Jimpitan'),
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nama tidak boleh kosong';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Nama Warga',
                              icon: Icon(Icons.person),
                            ),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Jumlah tidak boleh kosong';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Jumlah',
                              icon: Icon(Icons.attach_money),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    MaterialButton(
                        child: Text(
                          "Tambah",
                          style: TextStyle(color: Color(0xFFFAFAFA)),
                        ),
                        color: Color(0xFF0043A7),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // warga.add({
                            //   'nama': _nama.text,
                            // });
                            // _nama.text = '';
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Data berhasil disimpan!')),
                            );

                            Navigator.of(context).pop();
                          }
                        })
                  ],
                );
              });
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => TambahJimpitan()));
        },
        tooltip: 'Tambah',
        child: Icon(Icons.add),
        backgroundColor: Color(0xFFFF5521),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomAppBar(
          child: Container(
        color: Color(0xFFFF5521),
        height: 50,
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Text("TOTAL",
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          color: Color(0xFFFAFAFA),
                          fontSize: 18,
                          fontWeight: FontWeight.w500))),
            ),
            Container(
              child: Text(
                  "Rp 200.000", //+ setTotal(data, widget.index, widget.counter),
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          color: Color(0xFFFAFAFA),
                          fontSize: 18,
                          fontWeight: FontWeight.w500))),
            )
          ],
        ),
      )),
    );
  }
}
