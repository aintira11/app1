import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/Internal%20Configuration.dart';
import 'package:flutter_application_1/config/config.dart';
import 'package:flutter_application_1/models/response/customer_idx_get_res.dart';
import 'package:flutter_application_1/models/response/customer_login_post_res.dart';
import 'package:flutter_application_1/models/response/trip_get_res.dart';
import 'package:flutter_application_1/pages/profile.dart';
import 'package:flutter_application_1/pages/trip.dart';
import 'package:http/http.dart' as http;

class ShowTropPage extends StatefulWidget {
  int idx = 0;
  ShowTropPage({super.key, required this.idx});

  @override
  State<ShowTropPage> createState() => _ShowTropPageState();
}

class _ShowTropPageState extends State<ShowTropPage> {
  List<TripsGetResponse> trips = [];
  List<TripsGetResponse> filteredTrips = [];

  String url = '';
  //late = loadData  ตอนแรกจะไม่มีค่า แต่สักพักมันจะมีค่า
  late Future<void> loadData;

  // 3. use loaddata
  @override
  void initState() {
    super.initState();
    //4. loadData มีค่าแล้ว
    loadData = loadDataAsync();
    // Configuration.getConfig().then(
    //   (config) {
    //     url = config['apiEndpoint'];
    //     // getTrips();
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายการทริป'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              log(value);
              if (value == 'profile') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(idx: widget.idx,),
                    ));
              } else if (value == 'logout') {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'profile',
                child: Text('ข้อมูลส่วนตัว'),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('ออกจากระบบ'),
              ),
            ],
          ),
        ],
      ),

      // 1.create  FutureBuilder
      body: FutureBuilder<void>(
          future: loadData,
          builder: (context, Snapshot) {
            //ถ้า loaddata ยังไม่เสร็จ จะให้โชว์ อันข้างล่าง
            if (Snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('ปลายทาง'),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: FilledButton(
                                  onPressed: () => getTrips,
                                  child: const Text('ทั้งหมด')),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: FilledButton(
                                  onPressed: () => getTrips('เอเชีย'),
                                  // onPressed: () {},
                                  child: const Text('เอเชีย')),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: FilledButton(
                                  onPressed: () => getTrips('ยุโรป'),
                                  child: const Text('ยุโรป')),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: FilledButton(
                                  onPressed: () => getTrips('ประเทศไทย'),
                                  child: const Text('ประเทศไทย')),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: FilledButton(
                                  onPressed: () =>
                                      getTrips('เอเชียตะวันออกเฉียงใต้'),
                                  child: const Text('เอเชียตะวันออกเฉียงใต้')),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Column(
                          // children: filteredTrips
                          children: trips
                              .map((trip) => Card(
                                    child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              trip.name,
                                              style: const TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0)),
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 160, // กำหนดความกว้าง
                                                  height: 160, // กำหนดความสูง
                                                  child: Image.network(
                                                    trip.coverimage,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      return const Center(
                                                        child: Text(
                                                          'cannot load image',
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          'ประเทศ${trip.country}'),
                                                      Text(
                                                          'ระยะเวลา ${trip.duration} วัน'),
                                                      Text(
                                                          'ราคา ${trip.price} บาท'),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          FilledButton(
                                                              onPressed: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          TripPage(
                                                                              idx: trip.idx),
                                                                    ));
                                                              },
                                                              child: const Text(
                                                                  'รายละเอียดเพิ่มเติม')),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        )),
                                  ))
                              .toList(),
                          // children: [
                          //   Card(
                          //     child: Padding(
                          //       padding: const EdgeInsets.all(8.0),
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           const Text(
                          //             'ทะเลสาบสีชมพู Hiller Lake',
                          //             style: TextStyle(
                          //                 fontSize: 20,
                          //                 fontWeight: FontWeight.bold,
                          //                 color: Color.fromARGB(255, 0, 0, 0)),
                          //           ),
                          //           Row(
                          //             // crossAxisAlignment: CrossAxisAlignment.start,
                          //             children: [
                          //               SizedBox(
                          //                 width: 160, // กำหนดความกว้าง
                          //                 height: 160, // กำหนดความสูง
                          //                 child: Image.asset(
                          //                     'assets/images/69880cd0-431d-4014-915f-1e96ed3a7e9d.jpg'),
                          //               ),
                          //               Padding(
                          //                 padding: const EdgeInsets.all(5.0),
                          //                 child: Column(
                          //                   crossAxisAlignment: CrossAxisAlignment.start,
                          //                   children: [
                          //                     const Text('ประเทศออสเตรเลีย'),
                          //                     const Text('ระยะเวลา 10 วัน'),
                          //                     const Text('ราคา 119900 บาท'),
                          //                     Row(
                          //                       mainAxisAlignment:
                          //                           MainAxisAlignment.spaceAround,
                          //                       children: [
                          //                         FilledButton(
                          //                             onPressed: () {},
                          //                             child: const Text(
                          //                                 'รายละเอียดเพิ่มเติม')),
                          //                       ],
                          //                     ),
                          //                   ],
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          //   Card(
                          //     child: Padding(
                          //       padding: const EdgeInsets.all(8.0),
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           const Text(
                          //             'เรคยาวิก Reykjavik',
                          //             style: TextStyle(
                          //                 fontSize: 20,
                          //                 fontWeight: FontWeight.bold,
                          //                 color: Color.fromARGB(255, 0, 0, 0)),
                          //           ),
                          //           Row(
                          //             // crossAxisAlignment: CrossAxisAlignment.start,
                          //             children: [
                          //               SizedBox(
                          //                 width: 160, // กำหนดความกว้าง
                          //                 height: 160, // กำหนดความสูง
                          //                 child: Image.asset(
                          //                     'assets/images/Reykjavik.jpg'),
                          //               ),
                          //               Padding(
                          //                 padding: const EdgeInsets.all(5.0),
                          //                 child: Column(
                          //                   crossAxisAlignment: CrossAxisAlignment.start,
                          //                   children: [
                          //                     const Text('ประเทศไอซ์แลนด์'),
                          //                     const Text('ระยะเวลา 4 วัน'),
                          //                     const Text('ราคา 219900 บาท'),
                          //                     Row(
                          //                       mainAxisAlignment:
                          //                           MainAxisAlignment.spaceAround,
                          //                       children: [
                          //                         FilledButton(
                          //                             onPressed: () {},
                          //                             child: const Text(
                          //                                 'รายละเอียดเพิ่มเติม')),
                          //                       ],
                          //                     ),
                          //                   ],
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          //   Card(
                          //     child: Padding(
                          //       padding: const EdgeInsets.all(8.0),
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           const Text(
                          //             'Motonosumi-Inari Shrine',
                          //             style: TextStyle(
                          //                 fontSize: 20,
                          //                 fontWeight: FontWeight.bold,
                          //                 color: Color.fromARGB(255, 0, 0, 0)),
                          //           ),
                          //           Row(
                          //             // crossAxisAlignment: CrossAxisAlignment.start,
                          //             children: [
                          //               SizedBox(
                          //                 width: 160, // กำหนดความกว้าง
                          //                 height: 160, // กำหนดความสูง
                          //                 child: Image.asset(
                          //                     'assets/images/Motonosumi-Inari Shrine.jpg'),
                          //               ),
                          //               Padding(
                          //                 padding: const EdgeInsets.all(5.0),
                          //                 child: Column(
                          //                   crossAxisAlignment: CrossAxisAlignment.start,
                          //                   children: [
                          //                     const Text('ประเทศญี่ปุ่น'),
                          //                     const Text('ระยะเวลา 5 วัน'),
                          //                     const Text('ราคา 109900 บาท'),
                          //                     Row(
                          //                       mainAxisAlignment:
                          //                           MainAxisAlignment.spaceAround,
                          //                       children: [
                          //                         FilledButton(
                          //                             onPressed: () {},
                          //                             child: const Text(
                          //                                 'รายละเอียดเพิ่มเติม')),
                          //                       ],
                          //                     ),
                          //                   ],
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          //   Card(
                          //     child: Padding(
                          //       padding: const EdgeInsets.all(8.0),
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           const Text(
                          //             'Neuschwanstein Castle',
                          //             style: TextStyle(
                          //                 fontSize: 20,
                          //                 fontWeight: FontWeight.bold,
                          //                 color: Color.fromARGB(255, 0, 0, 0)),
                          //           ),
                          //           Row(
                          //             // crossAxisAlignment: CrossAxisAlignment.start,
                          //             children: [
                          //               SizedBox(
                          //                 width: 160, // กำหนดความกว้าง
                          //                 height: 160, // กำหนดความสูง
                          //                 child: Image.asset(
                          //                     'assets/images/Neuschwanstein Castle.jpg'),
                          //               ),
                          //               Padding(
                          //                 padding: const EdgeInsets.all(5.0),
                          //                 child: Column(
                          //                   crossAxisAlignment: CrossAxisAlignment.start,
                          //                   children: [
                          //                     const Text('ประเทศเยอรมนี'),
                          //                     const Text('ระยะเวลา 6 วัน'),
                          //                     const Text('ราคา 209900 บาท'),
                          //                     Row(
                          //                       mainAxisAlignment:
                          //                           MainAxisAlignment.spaceAround,
                          //                       children: [
                          //                         FilledButton(
                          //                             onPressed: () {},
                          //                             child: const Text(
                          //                                 'รายละเอียดเพิ่มเติม')),
                          //                       ],
                          //                     ),
                          //                   ],
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          //   Card(
                          //     child: Padding(
                          //       padding: const EdgeInsets.all(8.0),
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           const Text(
                          //             'อ่าวมารีนา Marina Bay',
                          //             style: TextStyle(
                          //                 fontSize: 20,
                          //                 fontWeight: FontWeight.bold,
                          //                 color: Color.fromARGB(255, 0, 0, 0)),
                          //           ),
                          //           Row(
                          //             // crossAxisAlignment: CrossAxisAlignment.start,
                          //             children: [
                          //               SizedBox(
                          //                 width: 160, // กำหนดความกว้าง
                          //                 height: 160, // กำหนดความสูง
                          //                 child: Image.asset(
                          //                     'assets/images/อ่าวมารีนา Marina Bay.jpg'),
                          //               ),
                          //               Padding(
                          //                 padding: const EdgeInsets.all(5.0),
                          //                 child: Column(
                          //                   crossAxisAlignment: CrossAxisAlignment.start,
                          //                   children: [
                          //                     const Text('ประเทศสิงคโปร์'),
                          //                     const Text('ระยะเวลา 4 วัน'),
                          //                     const Text('ราคา 13899 บาท'),
                          //                     Row(
                          //                       mainAxisAlignment:
                          //                           MainAxisAlignment.spaceAround,
                          //                       children: [
                          //                         FilledButton(
                          //                             onPressed: () {},
                          //                             child: const Text(
                          //                                 'รายละเอียดเพิ่มเติม')),
                          //                       ],
                          //                     ),
                          //                   ],
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   )
                          // ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }

  // getTrips({String? destinationZone }) async {
  // getTrips() async {
  // var res = await http.get(Uri.parse('$url/trips'));
  // log(res.body);
  // // setState(() {
  //   trips = tripsGetResponseFromJson(res.body);
  //   // if(destinationZone != null){
  //   //   filteredTrips = trips.where((trip)=>trip.destinationZone == destinationZone).toList();
  //   // }else{
  //   //   filteredTrips = trips;
  //   // }
  // // });
  // log(trips.length.toString());
  // }

  goToTripPage(int idx) {}

  void getTrips(String? zone) {
    http.get(Uri.parse('$url/trips')).then(
      (Value) {
        trips = tripsGetResponseFromJson(Value.body);
        List<TripsGetResponse> filteredTrips = [];
        if (zone != null) {
          for (var trip in trips) {
            if (trip.destinationZone == zone) {
              filteredTrips.add(trip);
            }
          }
          trips = filteredTrips;
        }
        setState(() {});
      },
    ).catchError((err) {
      log(err.toString());
    });
  }

  Future<void> loadDataAsync() async {
     await Future.delayed(const Duration(seconds: 1));
    var config = await Configuration.getConfig();
    url = config['apiEndpoint'];

    var res = await http.get(Uri.parse('$url/trips'));
    log(res.body);

    trips = tripsGetResponseFromJson(res.body);
    log(trips.length.toString());
  }
}
