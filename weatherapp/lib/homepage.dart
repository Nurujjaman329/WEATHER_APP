import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:jiffy/jiffy.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  determinePosition() async {
    bool serviceEnabled;

    fetchWeatherData();
  }

  Map<String, dynamic>? weatherMap;
  Map<String, dynamic>? forecastMap;

  fetchWeatherData() async {
    String weatherUrl =
        "https://api.openweathermap.org/data/2.5/weather?lat=23.790552&lon=90.391769&units=metric&appid=f92bf340ade13c087f6334ed434f9761";
    String forecastUrl =
        "https://api.openweathermap.org/data/2.5/forecast?lat=23.790552&lon=90.391769&units=metric&appid=f92bf340ade13c087f6334ed434f9761";

    var weatherResponse = await http.get(Uri.parse(weatherUrl));
    var forecastResponse = await http.get(Uri.parse(forecastUrl));

    weatherMap = Map<String, dynamic>.from(jsonDecode(weatherResponse.body));
    forecastMap = Map<String, dynamic>.from(jsonDecode(forecastResponse.body));

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    determinePosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 116, 114, 114),
        body: forecastMap != null
            ? Column(
                children: [
                  Expanded(
                    flex: 6,
                    child: Container(
                      margin: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(255, 132, 53, 223),
                                Color.fromARGB(255, 59, 71, 236)
                              ],
                              begin: const FractionalOffset(0.0, 0.0),
                              end: const FractionalOffset(0.5, 0.0),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp),
                          //color: Color.fromARGB(255, 38, 139, 222),
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      padding: EdgeInsets.all(20),
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                "${weatherMap!["name"]}",
                                style: TextStyle(
                                    fontSize: 30, color: Colors.white),
                              ),
                              Text(
                                "${Jiffy(DateTime.now()).format("MMM do yy, h:mm ")}",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Container(
                            height: 100,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                              child: Image.network(
                                'https://play-lh.googleusercontent.com/HKQH9rgXZTJ8JSMTvN0Qlg7VPcZq1n1LK_jwiF5rCsaUZO0m1r8kJI_Sl3T2Oi7MxQ',
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                "${weatherMap!["weather"][0]["description"]}",
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${weatherMap!["main"]["temp"]}.0°",
                                style: TextStyle(
                                    fontSize: 66,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "feels like: ${weatherMap!["main"]["feels_like"]} °",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                              Text(
                                "Humidity: ${weatherMap!["main"]["humidity"]}, Pressure: ${weatherMap!["main"]["pressure"]}",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                              Text(
                                  "Sunrise: ${Jiffy(DateTime.fromMillisecondsSinceEpoch(weatherMap!["sys"]["sunrise"] * 1000)).format("h:mm a")}, Sunset: ${Jiffy(DateTime.fromMillisecondsSinceEpoch(weatherMap!["sys"]["sunset"] * 1000)).format("h:mm a")}",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 3,
                      child: Container(
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox(
                            height: 300,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: forecastMap!.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            colors: [
                                              Color.fromARGB(
                                                  255, 115, 149, 245),
                                              Color.fromARGB(255, 4, 72, 128)
                                            ],
                                            begin: const FractionalOffset(
                                                0.0, 0.0),
                                            end: const FractionalOffset(
                                                0.5, 0.0),
                                            stops: [0.0, 1.0],
                                            tileMode: TileMode.clamp),
                                        //color: Color.fromARGB(255, 52, 51, 51),
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    width: 200,
                                    margin: EdgeInsets.only(right: 10),
                                    child: Column(
                                      children: [
                                        Text(
                                          "${Jiffy(forecastMap!["list"][index]["dt_txt"]).format("EEE, h:mm a")}",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                        Image.network(
                                            "http://openweathermap.org/img/wn/${forecastMap!["list"][index]["weather"][0]["icon"]}@2x.png"),
                                        Text(
                                          "${forecastMap!["list"][index]["main"]["temp_min"]}/${forecastMap!["list"][index]["main"]["temp_max"]}",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          "${forecastMap!["list"][index]["weather"][0]["description"]}",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          ),
                        ),
                      )),
                ],
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
