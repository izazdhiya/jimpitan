import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Jimpitan extends StatefulWidget {
  const Jimpitan({Key? key}) : super(key: key);

  @override
  _JimpitanState createState() => _JimpitanState();
}

class _JimpitanState extends State<Jimpitan> {
  TextEditingController _nama = TextEditingController();
  TextEditingController _jumlah = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  RegExp regx = RegExp(r"^[0-9_]*$", caseSensitive: false);

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference jimpitan = firestore.collection('jimpitan');
    return Scaffold(
      appBar: AppBar(
          title: Text("Jimpitan Hari Ini",
              style: GoogleFonts.poppins(
                  textStyle:
                      TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
          backgroundColor: Color(0xFFFF5521)),
      body: ListView(children: [
        StreamBuilder<QuerySnapshot>(
          stream: jimpitan
              .where('tanggal',
                  isGreaterThan: DateTime.now().subtract(Duration(days: 1)))
              .orderBy('tanggal', descending: true)
              .snapshots(),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: snapshot.data!.docs
                    .map((e) => ItemCard(e['nama'], e['jumlah'], e))
                    .toList(),
              );
            } else {
              return Center(child: Center(child: Text('Loading')));
            }
          },
        )
      ]),
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
                            controller: _nama,
                            decoration: InputDecoration(
                              labelText: 'Nama Warga',
                              icon: Icon(Icons.person),
                            ),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Jumlah tidak boleh kosong';
                              } else if (!(regx.hasMatch(value))) {
                                return 'Hanya boleh angka!';
                              }
                              return null;
                            },
                            controller: _jumlah,
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
                            jimpitan.add({
                              'tanggal': DateTime.now(),
                              'nama': _nama.text,
                              'jumlah': int.tryParse(_jumlah.text)
                            });
                            _nama.text = '';
                            _jumlah.text = '';
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
              child: StreamBuilder<QuerySnapshot>(
                stream: jimpitan
                    .where('tanggal',
                        isGreaterThan:
                            DateTime.now().subtract(Duration(days: 1)))
                    .snapshots(),
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    List myDocCount =
                        snapshot.data!.docs.map((e) => e['jumlah']).toList();
                    num jumlahjimpitan = 0;
                    for (var i in myDocCount) {
                      jumlahjimpitan = jumlahjimpitan + i;
                    }
                    return Text(
                        NumberFormat.simpleCurrency(locale: 'id')
                            .format(jumlahjimpitan),
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                color: Color(0xFFFAFAFA),
                                fontSize: 18,
                                fontWeight: FontWeight.w500)));
                  } else {
                    return Center(
                        child: Center(
                            child: Text('Rp 0',
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Color(0xFFFAFAFA),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500)))));
                  }
                },
              ),
            )
          ],
        ),
      )),
    );
  }
}

class ItemCard extends StatelessWidget {
  final String nama;
  final int jumlah;
  final e;

  ItemCard(this.nama, this.jumlah, this.e);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    RegExp regx = RegExp(r"^[0-9_]*$", caseSensitive: false);
    TextEditingController _nama = TextEditingController();
    TextEditingController _jumlah = TextEditingController();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference jimpitan = firestore.collection('jimpitan');
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 15, top: 5, right: 15, bottom: 5),
      padding: EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 5),
      decoration: BoxDecoration(
        color: Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 3,
            blurRadius: 3,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(nama,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600, fontSize: 16)),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(
                    NumberFormat.simpleCurrency(locale: 'id').format(jumlah),
                    style: GoogleFonts.poppins(
                        color: Color(0xFF348A36),
                        fontWeight: FontWeight.w500,
                        fontSize: 12)),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                height: 40,
                width: 60,
                child: MaterialButton(
                    shape: CircleBorder(),
                    color: Colors.yellow[600],
                    child: Center(
                        child: Icon(
                      Icons.edit,
                      color: Colors.white,
                    )),
                    onPressed: () {
                      _nama.text = nama;
                      _jumlah.text = jumlah.toString();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              scrollable: true,
                              title: Text('Edit Jimpitan'),
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
                                        controller: _nama,
                                        decoration: InputDecoration(
                                          labelText: 'Nama Warga',
                                          icon: Icon(Icons.person),
                                        ),
                                      ),
                                      TextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Jumlah tidak boleh kosong';
                                          } else if (!(regx.hasMatch(value))) {
                                            return 'Hanya boleh angka!';
                                          }
                                          return null;
                                        },
                                        controller: _jumlah,
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
                                      "Simpan",
                                      style:
                                          TextStyle(color: Color(0xFFFAFAFA)),
                                    ),
                                    color: Color(0xFF117B00),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        jimpitan.doc(e.id).update({
                                          'nama': _nama.text,
                                          'jumlah': int.tryParse(_jumlah.text)
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Data berhasil disimpan!')),
                                        );

                                        Navigator.of(context).pop();
                                      }
                                    })
                              ],
                            );
                          });
                    }),
              ),
              SizedBox(
                height: 40,
                width: 60,
                child: MaterialButton(
                    shape: CircleBorder(),
                    color: Colors.red[900],
                    child: Center(
                        child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    )),
                    onPressed: () {
                      AlertDialog alert = AlertDialog(
                        title: Text("Konfirmasi"),
                        content: Text("Yakin ingin menghapus data?"),
                        actions: [
                          MaterialButton(
                            color: Color(0xFFDF0000),
                            child: Text("YA",
                                style: TextStyle(
                                  color: Color(0xFFFAFAFA),
                                )),
                            onPressed: () {
                              jimpitan.doc(e.id).delete();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Data berhasil dihapus!')),
                              );
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
                    }),
              )
            ],
          )
        ],
      ),
    );
  }
}
