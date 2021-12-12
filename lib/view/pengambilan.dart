import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jimpitan/view/detailpengambilan.dart';
import 'package:jimpitan/view/riwayat.dart';

class Pengambilan extends StatefulWidget {
  const Pengambilan({Key? key}) : super(key: key);

  @override
  _PengambilanState createState() => _PengambilanState();
}

class _PengambilanState extends State<Pengambilan> {
  // TextEditingController _search = TextEditingController();

  // @override
  // void initState() {
  //   super.initState();
  //   _search.addListener(onSearchChanged);
  // }

  // @override
  // void dispose() {
  //   _search.removeListener(onSearchChanged);
  //   _search.dispose();
  //   super.dispose();
  // }

  // onSearchChanged() {
  //   print(_search.text);
  // }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference warga = firestore.collection('warga');
    // var filter = '';
    // Size screenSize = MediaQuery.of(context).size;
    // int heightSize = screenSize.height.toInt();
    // int widthSize = screenSize.width.toInt();
    return Scaffold(
        appBar: AppBar(
            title: Text("Pengambilan Jimpitan",
                style: GoogleFonts.poppins(
                    textStyle:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
            actions: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: IconButton(
                    icon: Icon(
                      Icons.layers,
                      color: Color(0xFFFAFAFA),
                    ),
                    tooltip: 'Riwayat Pengambilan',
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RiwayatPengambilan()));
                    },
                  ))
            ],
            backgroundColor: Color(0xFFFF5521)),
        body: LayoutBuilder(
            builder: (context, index) => Container(
                    child: Column(
                  children: [
                    // Container(
                    //   padding: EdgeInsets.all(15),
                    //   child: TextField(
                    //     controller: _search,
                    //     decoration: InputDecoration(
                    //       filled: true,
                    //       hintText: "Masukkan nama warga...",
                    //       suffixIcon: IconButton(
                    //           onPressed: () {}, icon: Icon(Icons.search)),
                    //       border: OutlineInputBorder(
                    //         borderRadius: BorderRadius.all(Radius.circular(10)),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Expanded(
                      child: ListView(children: [
                        StreamBuilder<QuerySnapshot>(
                          stream: warga
                              // .where('nama', arrayContains: _search.text)
                              .orderBy('nama')
                              .snapshots(),
                          builder: (_, snapshot) {
                            if (snapshot.hasData) {
                              return Column(
                                children: snapshot.data!.docs
                                    .map((e) => ItemCard(e['nama'], e))
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
  final e;

  ItemCard(this.nama, this.e);

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference jimpitan = firestore.collection('jimpitan');
    return Container(
        margin: EdgeInsets.only(left: 15, top: 5, right: 15, bottom: 5),
        child: MaterialButton(
          height: 50,
          color: Color(0xFFC4C4C4),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailPengambilan(nama: nama, e: e)));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(nama,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600, fontSize: 16)),
              Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream: jimpitan.where('nama', isEqualTo: nama).snapshots(),
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
                                  color: Color(0xFF348A36),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)));
                    } else {
                      return Center(
                          child: Center(
                              child: Text('Rp 0',
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          color: Color(0xFF348A36),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)))));
                    }
                  },
                ),
              ),
              // Text(NumberFormat.simpleCurrency(locale: 'id').format(jumlah),
              //     style: GoogleFonts.poppins(
              //         color: Color(0xFF348A36),
              //         fontWeight: FontWeight.w500,
              //         fontSize: 16)),
            ],
          ),
        ));
  }
}
