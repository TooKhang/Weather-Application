import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var temp = 0.0, hum = 0, weather = "";

  String selectLoc = "Changlun";
  List<String> locList = [
    "Changlun",
    "Jitra",
    "Alor Setar",
  ];
  String desc = "No record";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Simple Weather App",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          DropdownButton(
            itemHeight: 60,
            value: selectLoc,
            onChanged: (newValue) {
              setState(() {
                selectLoc = newValue.toString();
              });
            },
            items: locList.map((selectLoc) {
              return DropdownMenuItem(
                value: selectLoc,
                child: Text(
                  selectLoc,
                ),
              );
            }).toList(),
          ),
          ElevatedButton(
              onPressed: _loadweather, child: const Text("Load Weather")),
          Text(desc,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Future<void> _loadweather() async {
    var apiid = "66aba88409280f8e787b251529351169";
    var url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$selectLoc&appid=$apiid&units=metric');
    var response = await http.get(url);
    var rescode = response.statusCode;
    if (rescode == 200) {
      var jsonData = response.body;
      var parsedJson = json.decode(jsonData);
      temp = parsedJson['main']['temp'];
      hum = parsedJson['main']['humidity'];
      weather = parsedJson['weather'][0]['main'];
      
      setState(() {
        desc =
            "The current weather in $selectLoc is $weather. The current temperature is $temp Celcius and humidity is $hum percent. ";
      });
    } else {
      print("Failed");
    }
  }
}
