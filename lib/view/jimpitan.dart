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

  List item = [];
  List<String> namawarga = [];
  var date1 = DateFormat.yMMMd().format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference jimpitan = firestore.collection('jimpitan');
    CollectionReference warga = firestore.collection('warga');

    return Scaffold(
      appBar: AppBar(
          title: Text("Jimpitan Hari Ini",
              style: GoogleFonts.poppins(
                  textStyle:
                      TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
          backgroundColor: Color(0xFFFF5521)),
      body: ListView(children: [
        StreamBuilder<QuerySnapshot>(
          stream: jimpitan.orderBy('tanggal', descending: true).snapshots(),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              var list = snapshot.data!.docs;
              var toRemove = [];
              list.forEach((e) {
                if (DateFormat.yMMMd().format(e['tanggal'].toDate()) != date1) {
                  toRemove.add(e);
                }
              });
              list.removeWhere((e) => toRemove.contains(e));
              return Column(
                children: list
                    .map((e) => ItemCard(e['nama'], e['jumlah'], e))
                    .toList(),
              );
            } else {
              return Center(child: Center(child: Text('Loading')));
            }
          },
        ),

        // FutureBuilder<QuerySnapshot>(
        //   future: jimpitan.orderBy('tanggal', descending: true).get(),
        //   builder: (_, snapshot) {
        //     data = [];
        //     if (snapshot.hasData) {
        //       List myDocCount = snapshot.data!.docs
        //           .map((e) => [e['nama'], e['jumlah'], e['tanggal'], e])
        //           .toList();
        //       for (var i in myDocCount) {
        //         if (DateFormat.yMMMd().format(i[2].toDate()) == date1) {
        //           data.add([i[0], i[1], i[3]]);
        //         }
        //       }
        //       return Container();
        //     } else {
        //       return Container();
        //     }
        //   },
        // ),
        // for (var i = 0; i < data.length; i++)
        //   ItemCard(data[i][0], data[i][1], data[i][2])
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
                          FutureBuilder<QuerySnapshot>(
                            future: warga.orderBy('nama').get(),
                            builder: (_, snapshot) {
                              if (snapshot.hasData) {
                                item.add(snapshot.data!.docs
                                    .map((e) => [e['nama']])
                                    .toList());
                                for (var i = 0; i < item[0].length; i++) {
                                  namawarga.add(item[0][i][0]);
                                }
                                return Container();
                              } else {
                                return Container();
                              }
                            },
                          ),
                          TextFormField(
                            readOnly: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nama tidak boleh kosong';
                              }
                              return null;
                            },
                            controller: _nama,
                            decoration: InputDecoration(
                              labelText: "Nama Warga",
                              icon: Icon(Icons.person),
                              suffixIcon: PopupMenuButton<String>(
                                icon: const Icon(Icons.arrow_drop_down),
                                onSelected: (String value) {
                                  _nama.text = value;
                                },
                                itemBuilder: (BuildContext context) {
                                  return namawarga.map<PopupMenuItem<String>>(
                                      (String value) {
                                    return new PopupMenuItem(
                                        child: new Text(value), value: value);
                                  }).toList();
                                },
                              ),
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
                      color: Color(0xFFC4C4C4),
                      child: Text("Batal"),
                      onPressed: () {
                        Navigator.of(context).pop();
                        item = [];
                        namawarga = [];
                        print(item);
                      },
                    ),
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
                            item = [];
                            namawarga = [];
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
                stream: jimpitan.snapshots(),
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    var list = snapshot.data!.docs;
                    var toRemove = [];
                    list.forEach((e) {
                      if (DateFormat.yMMMd().format(e['tanggal'].toDate()) !=
                          date1) {
                        toRemove.add(e);
                      }
                    });
                    list.removeWhere((e) => toRemove.contains(e));
                    List myDocCount = list.map((e) => e['jumlah']).toList();
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
                            child: Text(
                                NumberFormat.simpleCurrency(locale: 'id')
                                    .format(0),
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
    CollectionReference warga = firestore.collection('warga');

    List item = [];
    List<String> namawarga = [];
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
                                      FutureBuilder<QuerySnapshot>(
                                        future: warga.orderBy('nama').get(),
                                        builder: (_, snapshot) {
                                          if (snapshot.hasData) {
                                            item.add(snapshot.data!.docs
                                                .map((e) => [e['nama']])
                                                .toList());
                                            for (var i = 0;
                                                i < item[0].length;
                                                i++) {
                                              namawarga.add(item[0][i][0]);
                                            }
                                            return Container();
                                          } else {
                                            return Container();
                                          }
                                        },
                                      ),
                                      TextFormField(
                                        readOnly: true,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Nama tidak boleh kosong';
                                          }
                                          return null;
                                        },
                                        controller: _nama,
                                        decoration: InputDecoration(
                                          labelText: "Nama Warga",
                                          icon: Icon(Icons.person),
                                          suffixIcon: PopupMenuButton<String>(
                                            icon: const Icon(
                                                Icons.arrow_drop_down),
                                            onSelected: (String value) {
                                              _nama.text = value;
                                            },
                                            itemBuilder:
                                                (BuildContext context) {
                                              return namawarga
                                                  .map<PopupMenuItem<String>>(
                                                      (String value) {
                                                return new PopupMenuItem(
                                                    child: new Text(value),
                                                    value: value);
                                              }).toList();
                                            },
                                          ),
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
