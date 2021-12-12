import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DetailPengambilan extends StatefulWidget {
  final String nama;
  final e;
  const DetailPengambilan({Key? key, required this.nama, this.e})
      : super(key: key);

  @override
  _DetailPengambilanState createState() => _DetailPengambilanState();
}

class _DetailPengambilanState extends State<DetailPengambilan> {
  List data = [];
  num totaljimpitan = 0;
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference jimpitan = firestore.collection('jimpitan');
    CollectionReference riwayat = firestore.collection('riwayat');
    Size screenSize = MediaQuery.of(context).size;
    int heightSize = screenSize.height.toInt();
    int widthSize = screenSize.width.toInt();
    return Scaffold(
        body: LayoutBuilder(
            builder: (context, index) => Container(
                child: heightSize > widthSize
                    ?
                    // Portrait View
                    Column(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: 15, top: 30, right: 15, bottom: 5),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color(0xFFFF5521),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    spreadRadius: 5,
                                    blurRadius: 5,
                                  )
                                ],
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Container(
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.person,
                                              color: Color(0xFFFAFAFA),
                                            ),
                                            SizedBox(width: 10),
                                            Text(widget.nama,
                                                style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                        color:
                                                            Color(0xFFFAFAFA),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500))),
                                          ],
                                        ),
                                      )),
                                  Expanded(
                                    flex: 5,
                                    child: Center(
                                        child: Column(
                                      children: [
                                        Container(
                                            child: Column(
                                          children: [
                                            Text("TOTAL",
                                                style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                        color:
                                                            Color(0xFFFAFAFA),
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500))),
                                            StreamBuilder<QuerySnapshot>(
                                              stream: jimpitan
                                                  .where('nama',
                                                      isEqualTo: widget.nama)
                                                  .snapshots(),
                                              builder: (_, snapshot) {
                                                if (snapshot.hasData) {
                                                  data.add(snapshot.data!.docs
                                                      .map(
                                                          (e) => [e['nama'], e])
                                                      .toList());
                                                  List myDocCount = snapshot
                                                      .data!.docs
                                                      .map((e) => e['jumlah'])
                                                      .toList();
                                                  num jumlahjimpitan = 0;
                                                  for (var i in myDocCount) {
                                                    jumlahjimpitan =
                                                        jumlahjimpitan + i;
                                                  }
                                                  totaljimpitan =
                                                      jumlahjimpitan;
                                                  return Text(
                                                      NumberFormat
                                                              .simpleCurrency(
                                                                  locale: 'id')
                                                          .format(
                                                              jumlahjimpitan),
                                                      style: GoogleFonts.poppins(
                                                          textStyle: TextStyle(
                                                              color: Color(
                                                                  0xFFFAFAFA),
                                                              fontSize: 30,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)));
                                                } else {
                                                  return Center(
                                                      child: Center(
                                                          child: Text('Rp 0',
                                                              style: GoogleFonts.poppins(
                                                                  textStyle: TextStyle(
                                                                      color: Color(
                                                                          0xFFFAFAFA),
                                                                      fontSize:
                                                                          30,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500)))));
                                                }
                                              },
                                            ),
                                          ],
                                        )),
                                        SizedBox(height: 20),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 50, right: 50),
                                          child: MaterialButton(
                                            color: Color(0xFF117B00),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            onPressed: () {
                                              if (totaljimpitan < 100000) {
                                                AlertDialog alert = AlertDialog(
                                                  title: Text("Peringatan"),
                                                  content: Text(
                                                      "Saldo Tidak Mencukupi!"),
                                                  actions: [
                                                    MaterialButton(
                                                      color: Color(0xFFC4C4C4),
                                                      child: Text("OK"),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return alert;
                                                  },
                                                );
                                              } else {
                                                AlertDialog alert = AlertDialog(
                                                  title: Text("Konfirmasi"),
                                                  content: Text(
                                                      "Mengambil Uang Jimpitan Sejumlah " +
                                                          NumberFormat
                                                                  .simpleCurrency(
                                                                      locale:
                                                                          'id')
                                                              .format(
                                                                  totaljimpitan)),
                                                  actions: [
                                                    MaterialButton(
                                                      color: Color(0xFFC4C4C4),
                                                      child: Text("Batal"),
                                                      onPressed: () {
                                                        print(data);
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    MaterialButton(
                                                      color: Color(0xFF117B00),
                                                      child: Text("Ambil",
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFFFAFAFA),
                                                          )),
                                                      onPressed: () {
                                                        for (var i = 0;
                                                            i < data[0].length;
                                                            i++) {
                                                          jimpitan
                                                              .doc((data[0][i]
                                                                      [1])
                                                                  .id)
                                                              .delete();
                                                        }

                                                        riwayat.add({
                                                          'tanggal':
                                                              DateTime.now(),
                                                          'nama': widget.nama,
                                                          'jumlah': int.tryParse(
                                                              totaljimpitan
                                                                  .toString())
                                                        });
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                              content: Text(
                                                                  'Uang Jimpitan Sudah Diambil')),
                                                        );
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    )
                                                  ],
                                                );
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return alert;
                                                  },
                                                );
                                              }
                                            },
                                            child: Center(
                                                child: Text("Ambil",
                                                    style: GoogleFonts.poppins(
                                                        textStyle: TextStyle(
                                                            color: Color(
                                                                0xFFFAFAFA),
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)))),
                                          ),
                                        )
                                      ],
                                    )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 5,
                              child: Container(
                                  margin: EdgeInsets.only(
                                      left: 15, top: 5, right: 15, bottom: 5),
                                  child: Column(
                                    children: [
                                      Container(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Rincian Jimpitan",
                                              style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500))),
                                          SizedBox(
                                              height: 50,
                                              child: Icon(Icons.menu))
                                        ],
                                      )),
                                      Expanded(
                                        child: ListView(children: [
                                          StreamBuilder<QuerySnapshot>(
                                            stream: jimpitan
                                                .where('nama',
                                                    isEqualTo: widget.nama)
                                                .snapshots(),
                                            builder: (_, snapshot) {
                                              if (snapshot.hasData) {
                                                return Column(
                                                  children: snapshot.data!.docs
                                                      .map((e) => ItemCard(
                                                          e['jumlah'],
                                                          e['tanggal'],
                                                          e))
                                                      .toList(),
                                                );
                                              } else {
                                                return Center(
                                                    child: Text('Loading'));
                                              }
                                            },
                                          )
                                        ]),
                                      )
                                    ],
                                  ))),
                        ],
                      )
                    :
                    // Landscape View
                    Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: 10,
                                          top: 30,
                                          right: 10,
                                          bottom: 15),
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFF5521),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            spreadRadius: 5,
                                            blurRadius: 5,
                                          )
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                              child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.person,
                                                  color: Color(0xFFFAFAFA),
                                                  size: 50,
                                                ),
                                                SizedBox(width: 10),
                                                Text(widget.nama,
                                                    style: GoogleFonts.poppins(
                                                        textStyle: TextStyle(
                                                            color: Color(
                                                                0xFFFAFAFA),
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500))),
                                              ],
                                            ),
                                          )),
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: 10, bottom: 5),
                                            width: 200,
                                            height: 1,
                                            color: Colors.white,
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 10),
                                            child: Center(
                                                child: Column(
                                              children: [
                                                Text("TOTAL",
                                                    style: GoogleFonts.poppins(
                                                        textStyle: TextStyle(
                                                            color: Color(
                                                                0xFFFAFAFA),
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500))),
                                                StreamBuilder<QuerySnapshot>(
                                                  stream: jimpitan
                                                      .where('nama',
                                                          isEqualTo:
                                                              widget.nama)
                                                      .snapshots(),
                                                  builder: (_, snapshot) {
                                                    if (snapshot.hasData) {
                                                      data.add(snapshot
                                                          .data!.docs
                                                          .map((e) =>
                                                              [e['nama'], e])
                                                          .toList());
                                                      List myDocCount = snapshot
                                                          .data!.docs
                                                          .map((e) =>
                                                              e['jumlah'])
                                                          .toList();
                                                      num jumlahjimpitan = 0;
                                                      for (var i
                                                          in myDocCount) {
                                                        jumlahjimpitan =
                                                            jumlahjimpitan + i;
                                                      }
                                                      totaljimpitan =
                                                          jumlahjimpitan;
                                                      return Text(
                                                          NumberFormat
                                                                  .simpleCurrency(
                                                                      locale:
                                                                          'id')
                                                              .format(
                                                                  jumlahjimpitan),
                                                          style: GoogleFonts.poppins(
                                                              textStyle: TextStyle(
                                                                  color: Color(
                                                                      0xFFFAFAFA),
                                                                  fontSize: 30,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)));
                                                    } else {
                                                      return Center(
                                                          child: Center(
                                                              child: Text(
                                                                  'Rp 0',
                                                                  style: GoogleFonts.poppins(
                                                                      textStyle: TextStyle(
                                                                          color: Color(
                                                                              0xFFFAFAFA),
                                                                          fontSize:
                                                                              30,
                                                                          fontWeight:
                                                                              FontWeight.w500)))));
                                                    }
                                                  },
                                                ),
                                              ],
                                            )),
                                          ),
                                          SizedBox(height: 20),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 50, right: 50),
                                            child: MaterialButton(
                                              color: Color(0xFF117B00),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              onPressed: () {
                                                if (totaljimpitan < 100000) {
                                                  AlertDialog alert =
                                                      AlertDialog(
                                                    title: Text("Peringatan"),
                                                    content: Text(
                                                        "Saldo Tidak Mencukupi!"),
                                                    actions: [
                                                      MaterialButton(
                                                        color:
                                                            Color(0xFFC4C4C4),
                                                        child: Text("OK"),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return alert;
                                                    },
                                                  );
                                                } else {
                                                  AlertDialog alert =
                                                      AlertDialog(
                                                    title: Text("Konfirmasi"),
                                                    content: Text(
                                                        "Mengambil Uang Jimpitan Sejumlah " +
                                                            NumberFormat
                                                                    .simpleCurrency(
                                                                        locale:
                                                                            'id')
                                                                .format(
                                                                    totaljimpitan)),
                                                    actions: [
                                                      MaterialButton(
                                                        color:
                                                            Color(0xFFC4C4C4),
                                                        child: Text("Batal"),
                                                        onPressed: () {
                                                          print(data);
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                      MaterialButton(
                                                        color:
                                                            Color(0xFF117B00),
                                                        child: Text("Ambil",
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFFFAFAFA),
                                                            )),
                                                        onPressed: () {
                                                          for (var i = 0;
                                                              i <
                                                                  data[0]
                                                                      .length;
                                                              i++) {
                                                            jimpitan
                                                                .doc((data[0][i]
                                                                        [1])
                                                                    .id)
                                                                .delete();
                                                          }

                                                          riwayat.add({
                                                            'tanggal':
                                                                DateTime.now(),
                                                            'nama': widget.nama,
                                                            'jumlah': int.tryParse(
                                                                totaljimpitan
                                                                    .toString())
                                                          });
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            const SnackBar(
                                                                content: Text(
                                                                    'Uang Jimpitan Sudah Diambil')),
                                                          );
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      )
                                                    ],
                                                  );
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return alert;
                                                    },
                                                  );
                                                }
                                              },
                                              child: Center(
                                                  child: Text("Ambil",
                                                      style: GoogleFonts.poppins(
                                                          textStyle: TextStyle(
                                                              color: Color(
                                                                  0xFFFAFAFA),
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)))),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                          Expanded(
                              flex: 1,
                              child: Container(
                                  margin: EdgeInsets.only(
                                      left: 15, top: 20, right: 15, bottom: 5),
                                  child: Column(
                                    children: [
                                      Container(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Rincian Jimpitan",
                                              style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500))),
                                          SizedBox(
                                              height: 50,
                                              child: Icon(Icons.menu))
                                        ],
                                      )),
                                      Expanded(
                                        child: ListView(children: [
                                          StreamBuilder<QuerySnapshot>(
                                            stream: jimpitan
                                                .where('nama',
                                                    isEqualTo: widget.nama)
                                                .snapshots(),
                                            builder: (_, snapshot) {
                                              if (snapshot.hasData) {
                                                return Column(
                                                  children: snapshot.data!.docs
                                                      .map((e) => ItemCard(
                                                          e['jumlah'],
                                                          e['tanggal'],
                                                          e))
                                                      .toList(),
                                                );
                                              } else {
                                                return Center(
                                                    child: Text('Loading'));
                                              }
                                            },
                                          )
                                        ]),
                                      )
                                    ],
                                  ))),
                        ],
                      ))));
  }
}

class ItemCard extends StatelessWidget {
  final int jumlah;
  final tanggal;
  final e;

  ItemCard(this.jumlah, this.tanggal, this.e);

  @override
  Widget build(BuildContext context) {
    DateTime myDateTime = tanggal.toDate();
    var date = DateFormat.yMMMd().format(myDateTime);
    return Container(
      margin: EdgeInsets.only(top: 5, bottom: 5),
      height: 50,
      decoration: BoxDecoration(
        color: Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 2,
            blurRadius: 2,
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFC4C4C4),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10)),
                ),
                child: Center(
                  child: Text(date.toString(),
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500))),
                ),
              )),
          Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                  color: Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Text(NumberFormat.simpleCurrency(locale: 'id').format(jumlah),
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              color: Color(0xFF348A36),
                              fontSize: 14,
                              fontWeight: FontWeight.w500)))
                ]),
              )),
        ],
      ),
    );
  }
}
