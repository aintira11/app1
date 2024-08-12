import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/config.dart';
import 'package:flutter_application_1/models/response/trip_idx_get_res.dart';
import 'package:http/http.dart' as http;

class TripPage extends StatefulWidget {
  int idx = 0;
  //ส่งค่า idx เข้ามา แล้วเอาไปใส่ แอดติบิ้วเลย
  TripPage({super.key, required this.idx});

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  String url = '';
  // Create late variables
  late TripIdxGetResponse trip;
  late Future<void> loadData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    log(widget.idx.toString());
    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายละเอียดทริป'),
      ),
      // Loding data with FutureBuilder
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: loadData,
          builder: (context, snapshot) {
            // Loading...
            if (snapshot.connectionState != ConnectionState.done) {
              //ถ้ายังไม่เสร็จ ให้โชว์หมุนๆ
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            // Load Done
            return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trip.name,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0)),
                ),
                const SizedBox(height: 10.0), 
                Text(trip.country),
                const SizedBox(height: 16.0), // เว้นระยะห่าง 16 พิกเซล
                Image.network(trip.coverimage),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('ราคา ${trip.price.toString()} บาท'),
                    Text('โซน${trip.destinationZone}')
                  ],
                ),
                const SizedBox(height: 16.0), // เว้นระยะห่าง 16 พิกเซล
                Text(trip.detail),
                Center(
                  child: FilledButton(
                    onPressed: () {},
                    child: const Text('จองเลย!!!'),
                  ),
                )
              ],
            ));
          },
        ),
      ),
    );
  }

  // Async function for api call
  Future<void> loadDataAsync() async {
     await Future.delayed(const Duration(seconds: 1));
    var config = await Configuration.getConfig();
    url = config['apiEndpoint'];
    var res = await http.get(Uri.parse('$url/trips/${widget.idx.toString()}'));
    log(res.body);
    trip = tripIdxGetResponseFromJson(res.body);
  }
}
