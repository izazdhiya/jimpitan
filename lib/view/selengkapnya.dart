import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Selengkapnya extends StatefulWidget {
  const Selengkapnya({Key? key}) : super(key: key);

  @override
  _SelengkapnyaState createState() => _SelengkapnyaState();
}

class _SelengkapnyaState extends State<Selengkapnya> {
  var date1 = DateFormat.yMMMd().format(DateTime.now());
  List data = [];

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference jimpitan = firestore.collection('jimpitan');
    // Size screenSize = MediaQuery.of(context).size;
    // int heightSize = screenSize.height.toInt();
    // int widthSize = screenSize.width.toInt();
    return Scaffold(
      appBar: AppBar(
          title: Text("Jimpitan harian",
              style: GoogleFonts.poppins(
                  textStyle:
                      TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
          backgroundColor: Color(0xFFFF5521)),
      body: LayoutBuilder(
          builder: (context, index) => Container(
                  child: Column(
                children: [
                  Container(
                      child: Column(children: [
                    Container(
                      height: 40,
                      width: double.infinity,
                      margin: EdgeInsets.only(
                          left: 60, top: 20, right: 60, bottom: 20),
                      child: MaterialButton(
                          minWidth: 40,
                          color: Color(0xFFFF5521),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onPressed: () {
                            DatePicker.showDatePicker(context,
                                theme: DatePickerTheme(
                                  containerHeight: 210.0,
                                ),
                                showTitleActions: true,
                                minTime: DateTime(2000, 1, 1),
                                maxTime: DateTime(2030, 12, 31),
                                onConfirm: (date) {
                              print('confirm $date');
                              date1 = DateFormat.yMMMd().format(date);
                              setState(() {});
                            },
                                currentTime: DateTime.now(),
                                locale: LocaleType.en);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: Color(0xFFFAFAFA),
                              ),
                              Container(
                                child: Text(date1,
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Color(0xFFFAFAFA),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500))),
                              ),
                              SizedBox(
                                width: 20,
                              )
                            ],
                          )),
                    ),
                  ])),
                  Expanded(
                    child: ListView(children: [
                      StreamBuilder<QuerySnapshot>(
                        stream: jimpitan.orderBy('nama').snapshots(),
                        builder: (_, snapshot) {
                          if (snapshot.hasData) {
                            var list = snapshot.data!.docs;
                            var toRemove = [];
                            list.forEach((e) {
                              if (DateFormat.yMMMd()
                                      .format(e['tanggal'].toDate()) !=
                                  date1) {
                                toRemove.add(e);
                              }
                            });
                            list.removeWhere((e) => toRemove.contains(e));
                            return Column(
                              children: list
                                  .map((e) => ItemCard(e['nama'], e['jumlah']))
                                  .toList(),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ]),
                  )
                ],
              ))),
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
                    List myDocCount = snapshot.data!.docs
                        .map((e) => [e['nama'], e['jumlah'], e['tanggal']])
                        .toList();
                    num jumlahjimpitan = 0;
                    for (var i in myDocCount) {
                      if (DateFormat.yMMMd().format(i[2].toDate()) == date1) {
                        jumlahjimpitan = jumlahjimpitan + i[1];
                      }
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

  ItemCard(this.nama, this.jumlah);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 15, top: 5, right: 15, bottom: 5),
        child: Container(
          width: double.infinity,
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
              Text(nama,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600, fontSize: 16)),
              Container(
                  child: Text(
                      NumberFormat.simpleCurrency(locale: 'id').format(jumlah),
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              color: Color(0xFF348A36),
                              fontSize: 16,
                              fontWeight: FontWeight.w500)))),
            ],
          ),
        ));
  }
}
