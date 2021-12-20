import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class RiwayatPengambilan extends StatefulWidget {
  const RiwayatPengambilan({Key? key}) : super(key: key);

  @override
  _RiwayatPengambilanState createState() => _RiwayatPengambilanState();
}

class _RiwayatPengambilanState extends State<RiwayatPengambilan> {
  var items = ["7 Hari Terakhir", "30 Hari Terakhir", "Semua Transaksi"];
  int filter = 100000;
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference riwayat = firestore.collection('riwayat');
    return Scaffold(
        appBar: AppBar(
            title: Text("Riwayat Pengambilan",
                style: GoogleFonts.poppins(
                    textStyle:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: PopupMenuButton<String>(
                  icon: const Icon(Icons.filter_list_sharp),
                  onSelected: (String value) {
                    if (value == "7 Hari Terakhir") {
                      filter = 7;
                    } else if (value == "30 Hari Terakhir") {
                      filter = 30;
                    } else {
                      filter = 100000;
                    }
                    setState(() {});
                  },
                  itemBuilder: (BuildContext context) {
                    return items.map<PopupMenuItem<String>>((String value) {
                      return new PopupMenuItem(
                          child: new Text(value), value: value);
                    }).toList();
                  },
                ),
              )
            ],
            backgroundColor: Color(0xFFFF5521)),
        body: LayoutBuilder(
            builder: (context, index) => Container(
                    child: Column(
                  children: [
                    Expanded(
                      child: ListView(children: [
                        StreamBuilder<QuerySnapshot>(
                          stream: riwayat
                              .where('tanggal',
                                  isGreaterThan: DateTime.now()
                                      .subtract(Duration(days: filter)))
                              .orderBy('tanggal', descending: true)
                              .snapshots(),
                          builder: (_, snapshot) {
                            if (snapshot.hasData) {
                              return Column(
                                children: snapshot.data!.docs
                                    .map((e) => ItemCard(e['nama'],
                                        e['tanggal'], e['jumlah'], e))
                                    .toList(),
                              );
                            } else {
                              return Center(
                                  child: Center(child: Text('Loading')));
                            }
                          },
                        )
                      ]),
                    )
                  ],
                ))));
  }
}

class ItemCard extends StatelessWidget {
  final String nama;
  final tanggal;
  final int jumlah;
  final e;

  ItemCard(this.nama, this.tanggal, this.jumlah, this.e);

  @override
  Widget build(BuildContext context) {
    DateTime myDateTime = tanggal.toDate();
    var date = DateFormat.yMMMd().format(myDateTime);
    return Container(
      margin: EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 5),
      height: 50,
      decoration: BoxDecoration(
        color: Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 5,
            blurRadius: 5,
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                  color: Color(0xFFC4C4C4),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: Text(nama,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600, fontSize: 16)),
                    ),
                    SizedBox(
                      child: Text(date.toString(),
                          style: GoogleFonts.poppins(
                              color: Color(0xFFFF5521),
                              fontWeight: FontWeight.w500,
                              fontSize: 12)),
                    ),
                  ],
                ),

                // Center(
                //   child: Text("19/10/2021",
                //       style: GoogleFonts.poppins(
                //           textStyle: TextStyle(
                //               fontSize: 12, fontWeight: FontWeight.w500))),
                // ),
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
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("TOTAL : ",
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500))),
                      Text(
                          NumberFormat.simpleCurrency(locale: 'id')
                              .format(jumlah),
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: Color(0xFFFF5521),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500)))
                    ]),
              )),
        ],
      ),
    );
    // Container(
    //   width: double.infinity,
    //   margin: EdgeInsets.only(left: 15, top: 5, right: 15, bottom: 5),
    //   padding: EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 5),
    //   decoration: BoxDecoration(
    //     color: Color(0xFFFAFAFA),
    //     borderRadius: BorderRadius.circular(10),
    //     boxShadow: [
    //       BoxShadow(
    //         color: Colors.black12,
    //         spreadRadius: 3,
    //         blurRadius: 3,
    //       )
    //     ],
    //   ),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     children: [
    // Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     SizedBox(
    //       width: MediaQuery.of(context).size.width * 0.5,
    //       child: Text(nama,
    //           style: GoogleFonts.poppins(
    //               fontWeight: FontWeight.w600, fontSize: 16)),
    //     ),
    //     SizedBox(
    //       width: MediaQuery.of(context).size.width * 0.5,
    //       child: Text(date.toString(),
    //           style: GoogleFonts.poppins(
    //               color: Color(0xFFFF5521),
    //               fontWeight: FontWeight.w500,
    //               fontSize: 12)),
    //     ),
    //   ],
    // ),
    //       Row(
    //         children: [
    //           SizedBox(
    //             child: Text(
    //                 NumberFormat.simpleCurrency(locale: 'id').format(jumlah),
    //                 style: GoogleFonts.poppins(
    //                     color: Colors.red[900],
    //                     fontWeight: FontWeight.w500,
    //                     fontSize: 16)),
    //           ),
    //           SizedBox()
    //         ],
    //       )
    //     ],
    //   ),
    // );
  }
}
