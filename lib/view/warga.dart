import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Warga extends StatefulWidget {
  const Warga({Key? key}) : super(key: key);

  @override
  _WargaState createState() => _WargaState();
}

class _WargaState extends State<Warga> {
  List list = [];
  bool data = true;
  TextEditingController _nama = TextEditingController();
  // TextEditingController _norumah = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // RegExp regx = RegExp(r"^[0-9_]*$", caseSensitive: false);

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference warga = firestore.collection('warga');
    return Scaffold(
      appBar: AppBar(
          title: Text("Daftar Warga",
              style: GoogleFonts.poppins(
                  textStyle:
                      TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
          backgroundColor: Color(0xFFFF5521)),
      body: ListView(children: [
        StreamBuilder<QuerySnapshot>(
          stream: warga.orderBy('nama').snapshots(),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              list = [];
              list.add(snapshot.data!.docs.map((e) => e['nama']).toList());
              return Column(
                children: snapshot.data!.docs
                    .map((e) => ItemCard(e['nama'], e))
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
                  title: Text('Tambah Warga'),
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          // TextFormField(
                          //   validator: (value) {
                          //     if (value == null || value.isEmpty) {
                          //       return 'Jumlah tidak boleh kosong';
                          //     } else if (!(regx.hasMatch(value))) {
                          //       return 'Hanya boleh angka!';
                          //     }
                          //     return null;
                          //   },
                          //   controller: _norumah,
                          //   decoration: InputDecoration(
                          //     labelText: 'Nomor Rumah',
                          //     icon: Icon(Icons.home),
                          //   ),
                          //   keyboardType: TextInputType.number,
                          // ),
                          TextFormField(
                            validator: (value) {
                              // for (var i = 0; i < list.length; i++) {
                              if (value == null || value.isEmpty) {
                                return 'Nama tidak boleh kosong';
                              } else if (data == false) {
                                return 'Nama sudah ada';
                              }
                              return null;
                              // }
                            },
                            controller: _nama,
                            decoration: InputDecoration(
                              labelText: 'Nama Warga',
                              icon: Icon(Icons.person),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    MaterialButton(
                      color: Color(0xFFC4C4C4),
                      child: Text("Batal"),
                      onPressed: () {
                        data = true;
                        Navigator.of(context).pop();
                      },
                    ),
                    MaterialButton(
                        child: Text(
                          "Tambah",
                          style: TextStyle(color: Color(0xFFFAFAFA)),
                        ),
                        color: Color(0xFF0043A7),
                        onPressed: () {
                          for (var i = 0; i < list[0].length; i++) {
                            if (_nama.text == list[0][i].toString()) {
                              data = false;
                              break;
                            } else {
                              data = true;
                            }
                          }
                          if (_formKey.currentState!.validate()) {
                            warga.add({
                              // 'norumah': _norumah.text,
                              'nama': _nama.text,
                            });
                            // _norumah.text = '';
                            _nama.text = '';

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
        child: Icon(Icons.person_add),
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
              child: Text("Jumlah Warga",
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          color: Color(0xFFFAFAFA),
                          fontSize: 18,
                          fontWeight: FontWeight.w500))),
            ),
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: warga.orderBy('nama').snapshots(),
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    List myDocCount = snapshot.data!.docs;
                    int jumlahwarga = myDocCount.length;
                    return Text(
                        jumlahwarga
                            .toString(), //+ setTotal(data, widget.index, widget.counter),
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                color: Color(0xFFFAFAFA),
                                fontSize: 18,
                                fontWeight: FontWeight.w500)));
                  } else {
                    return Center(
                        child: Center(
                            child: Text('0',
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
  final e;

  ItemCard(this.nama, this.e);

  @override
  Widget build(BuildContext context) {
    List list = [];
    bool data = true;
    final _formKey = GlobalKey<FormState>();
    TextEditingController _nama = TextEditingController();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference warga = firestore.collection('warga');

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
              StreamBuilder<QuerySnapshot>(
                stream: warga.orderBy('nama').snapshots(),
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    list = [];
                    list.add(
                        snapshot.data!.docs.map((e) => e['nama']).toList());
                    return Container();
                  } else {
                    return Container();
                  }
                },
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(nama,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500, fontSize: 16)),
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
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              scrollable: true,
                              title: Text('Edit Warga'),
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
                                          } else if (data == false) {
                                            return 'Nama sudah ada';
                                          }
                                          return null;
                                        },
                                        controller: _nama,
                                        decoration: InputDecoration(
                                          labelText: 'Nama Warga',
                                          icon: Icon(Icons.person),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              actions: [
                                MaterialButton(
                                  color: Color(0xFFC4C4C4),
                                  child: Text("Batal"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                MaterialButton(
                                    child: Text(
                                      "Simpan",
                                      style:
                                          TextStyle(color: Color(0xFFFAFAFA)),
                                    ),
                                    color: Color(0xFF117B00),
                                    onPressed: () {
                                      print(list);
                                      for (var i = 0; i < list[0].length; i++) {
                                        if (_nama.text ==
                                            list[0][i].toString()) {
                                          data = false;
                                          break;
                                        } else {
                                          data = true;
                                        }
                                      }
                                      if (_formKey.currentState!.validate()) {
                                        warga.doc(e.id).update({
                                          'nama': _nama.text,
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
                            color: Color(0xFFC4C4C4),
                            child: Text("TIDAK"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          MaterialButton(
                            color: Color(0xFFDF0000),
                            child: Text("YA",
                                style: TextStyle(
                                  color: Color(0xFFFAFAFA),
                                )),
                            onPressed: () {
                              warga.doc(e.id).delete();
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
