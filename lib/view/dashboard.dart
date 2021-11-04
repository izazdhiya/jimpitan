import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jimpitan/view/jimpitan.dart';
import 'package:jimpitan/view/pengambilan.dart';
import 'package:jimpitan/view/warga.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  static var today = DateTime.now();
  String date = '${today.day} / ${today.month} / ${today.year}';

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference jimpitan = firestore.collection('jimpitan');
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
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Gembong RT 13 RW 07",
                                            style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    color: Color(0xFFFAFAFA),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w500))),
                                        Icon(
                                          Icons.menu,
                                          color: Color(0xFFFAFAFA),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Center(
                                        child: Column(
                                      children: [
                                        Text("TOTAL",
                                            style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    color: Color(0xFFFAFAFA),
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w500))),
                                        StreamBuilder<QuerySnapshot>(
                                          stream: jimpitan
                                              .where('jumlah')
                                              .snapshots(),
                                          builder: (_, snapshot) {
                                            if (snapshot.hasData) {
                                              List myDocCount = snapshot
                                                  .data!.docs
                                                  .map((e) => e['jumlah'])
                                                  .toList();
                                              num jumlahjimpitan = 0;
                                              for (var i in myDocCount) {
                                                jumlahjimpitan =
                                                    jumlahjimpitan + i;
                                              }
                                              return Text(
                                                  NumberFormat.simpleCurrency(
                                                          locale: 'id')
                                                      .format(jumlahjimpitan),
                                                  style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                          color:
                                                              Color(0xFFFAFAFA),
                                                          fontSize: 30,
                                                          fontWeight: FontWeight
                                                              .w500)));
                                            } else {
                                              return Center(
                                                  child: Center(
                                                      child: Text('Rp 0',
                                                          style: GoogleFonts.poppins(
                                                              textStyle: TextStyle(
                                                                  color: Color(
                                                                      0xFFFAFAFA),
                                                                  fontSize: 30,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)))));
                                            }
                                          },
                                        ),
                                        Text("$date",
                                            style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    color: Color(0xFFFAFAFA),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w500)))
                                      ],
                                    )),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 2,
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: 15, top: 5, right: 15, bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        child: Center(
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                          RawMaterialButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Jimpitan()));
                                            },
                                            child: new Icon(
                                              Icons.money_rounded,
                                              color: Color(0xFFFAFAFA),
                                              size: 35.0,
                                            ),
                                            shape: new CircleBorder(),
                                            elevation: 2.0,
                                            fillColor: Color(0xFFFF5521),
                                            padding: const EdgeInsets.all(15.0),
                                          ),
                                          Text("Jimpitan",
                                              style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500)))
                                        ]))),
                                    Container(
                                        child: Center(
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                          RawMaterialButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Pengambilan()));
                                            },
                                            child: new Icon(
                                              Icons.receipt,
                                              color: Color(0xFFFAFAFA),
                                              size: 35.0,
                                            ),
                                            shape: new CircleBorder(),
                                            elevation: 2.0,
                                            fillColor: Color(0xFFFF5521),
                                            padding: const EdgeInsets.all(15.0),
                                          ),
                                          Text("Pengambilan",
                                              style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500)))
                                        ]))),
                                    Container(
                                        child: Center(
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                          RawMaterialButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Warga()));
                                            },
                                            child: new Icon(
                                              Icons.people,
                                              color: Color(0xFFFAFAFA),
                                              size: 35.0,
                                            ),
                                            shape: new CircleBorder(),
                                            elevation: 2.0,
                                            fillColor: Color(0xFFFF5521),
                                            padding: const EdgeInsets.all(15.0),
                                          ),
                                          Text("Warga",
                                              style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500)))
                                        ]))),
                                  ],
                                ),
                              )),
                          Expanded(
                              flex: 4,
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
                                          Text("Jimpitan Harian",
                                              style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500))),
                                          TextButton(
                                              onPressed: () {},
                                              child: Text("Selengkapnya >",
                                                  style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                          color:
                                                              Color(0xFFFF5521),
                                                          fontSize: 14,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight: FontWeight
                                                              .w500))))
                                        ],
                                      )),
                                      Container(
                                        child: Column(children: [
                                          for (int i = 0; i < 3; i++)
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: 5, bottom: 5),
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: Color(0xFFFAFAFA),
                                                borderRadius:
                                                    BorderRadius.circular(10),
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
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0xFFC4C4C4),
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          10),
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          10)),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                              "19/10/2021",
                                                              style: GoogleFonts.poppins(
                                                                  textStyle: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500))),
                                                        ),
                                                      )),
                                                  Expanded(
                                                      flex: 2,
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10,
                                                                right: 10),
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0xFFFAFAFA),
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topRight: Radius
                                                                      .circular(
                                                                          10),
                                                                  bottomRight:
                                                                      Radius.circular(
                                                                          10)),
                                                        ),
                                                        child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text("TOTAL : ",
                                                                  style: GoogleFonts.poppins(
                                                                      textStyle: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w500))),
                                                              Text("Rp 200.000",
                                                                  style: GoogleFonts.poppins(
                                                                      textStyle: TextStyle(
                                                                          color: Color(
                                                                              0xFF348A36),
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w500)))
                                                            ]),
                                                      )),
                                                ],
                                              ),
                                            )
                                        ]),
                                      )
                                    ],
                                  ))),
                          Expanded(
                              flex: 1,
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: 15, top: 5, right: 15, bottom: 10),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFF5521),
                                ),
                                child: Center(
                                    child: Text("RT 13 RW 07 | ©Copyright 2021",
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                color: Color(0xFFFAFAFA),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500)))),
                              ))
                        ],
                      )
                    :
                    // Landscape View
                    Row(children: [
                        Expanded(
                            flex: 1,
                            child: Column(children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: 10, top: 20, right: 10, bottom: 5),
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
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Gembong RT 13 RW 07",
                                                style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                        color:
                                                            Color(0xFFFAFAFA),
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500))),
                                            Icon(
                                              Icons.menu,
                                              color: Color(0xFFFAFAFA),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 10),
                                        child: Center(
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
                                            Text("Rp 10.000.000",
                                                style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                        color:
                                                            Color(0xFFFAFAFA),
                                                        fontSize: 30,
                                                        fontWeight:
                                                            FontWeight.w500))),
                                            Text("20/10/2021",
                                                style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                        color:
                                                            Color(0xFFFAFAFA),
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500)))
                                          ],
                                        )),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 2,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: 10, top: 5, right: 10, bottom: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                            child: Center(
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                              RawMaterialButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Jimpitan()));
                                                },
                                                child: new Icon(
                                                  Icons.money_rounded,
                                                  color: Color(0xFFFAFAFA),
                                                  size: 35.0,
                                                ),
                                                shape: new CircleBorder(),
                                                elevation: 2.0,
                                                fillColor: Color(0xFFFF5521),
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                              ),
                                              Text("Jimpitan",
                                                  style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500)))
                                            ]))),
                                        Container(
                                            child: Center(
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                              RawMaterialButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Pengambilan()));
                                                },
                                                child: new Icon(
                                                  Icons.receipt,
                                                  color: Color(0xFFFAFAFA),
                                                  size: 35.0,
                                                ),
                                                shape: new CircleBorder(),
                                                elevation: 2.0,
                                                fillColor: Color(0xFFFF5521),
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                              ),
                                              Text("Pengambilan",
                                                  style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500)))
                                            ]))),
                                        Container(
                                            child: Center(
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                              RawMaterialButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Warga()));
                                                },
                                                child: new Icon(
                                                  Icons.people,
                                                  color: Color(0xFFFAFAFA),
                                                  size: 35.0,
                                                ),
                                                shape: new CircleBorder(),
                                                elevation: 2.0,
                                                fillColor: Color(0xFFFF5521),
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                              ),
                                              Text("Warga",
                                                  style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500)))
                                            ]))),
                                      ],
                                    ),
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                    color: Color(0xFFFF5521),
                                    margin: EdgeInsets.only(
                                        left: 10,
                                        top: 10,
                                        right: 10,
                                        bottom: 5),
                                    child: Center(
                                        child: Text(
                                            "RT 13 RW 07 | ©Copyright 2021",
                                            style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    color: Color(0xFFFAFAFA),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w500)))),
                                  ))
                            ])),
                        Expanded(
                            flex: 1,
                            child: Container(
                                margin: EdgeInsets.only(
                                    left: 15, top: 5, right: 15, bottom: 5),
                                padding: EdgeInsets.only(top: 15),
                                child: Column(
                                  children: [
                                    Container(
                                        child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Jimpitan Harian",
                                            style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500))),
                                        TextButton(
                                            onPressed: () {},
                                            child: Text("Selengkapnya >",
                                                style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                        color:
                                                            Color(0xFFFF5521),
                                                        fontSize: 14,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        fontWeight:
                                                            FontWeight.w500))))
                                      ],
                                    )),
                                    Container(
                                      child: Column(children: [
                                        for (int i = 0; i < 4; i++)
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: 5, bottom: 5),
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFFAFAFA),
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFFC4C4C4),
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        10)),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                            "19/10/2021",
                                                            style: GoogleFonts.poppins(
                                                                textStyle: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500))),
                                                      ),
                                                    )),
                                                Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                      padding: EdgeInsets.only(
                                                          left: 10, right: 10),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFFFAFAFA),
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        10),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        10)),
                                                      ),
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text("TOTAL : ",
                                                                style: GoogleFonts.poppins(
                                                                    textStyle: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w500))),
                                                            Text("Rp 200.000",
                                                                style: GoogleFonts.poppins(
                                                                    textStyle: TextStyle(
                                                                        color: Color(
                                                                            0xFF348A36),
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w500)))
                                                          ]),
                                                    )),
                                              ],
                                            ),
                                          )
                                      ]),
                                    )
                                  ],
                                ))),
                      ])))
        
        
        );
  }
}
