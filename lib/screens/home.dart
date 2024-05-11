import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:siba_weather/utils/consts.dart';
import 'package:weather/weather.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<HomeScreen> {
  final WeatherFactory wf = WeatherFactory(OpenWeather_API_KEY);

  Weather? weather;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    wf.currentWeatherByCityName("Madrid").then((value) {
      setState(() {
        weather = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildUI(),
    );
  }

  Widget buildUI() {
    if (weather == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          locationheader(),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.08,
          ),
          dateTimeInfo(),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.05,
          ),
          weatherIcon(),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.02,
          ),
          currentTemperature(),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.02,
          ),
          extraInfo(),
        ],
      ),
    );
  }

  Widget locationheader() {
    return Text(
      weather?.areaName ?? "",
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget dateTimeInfo() {
    DateTime now = weather!.date!;
    return Column(
      children: [
        Text(
          DateFormat("h:mm:a").format(now),
          style: const TextStyle(fontSize: 35, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                DateFormat("EEEE").format(now),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ]),
        Text(
          "${DateFormat("d / m / y").format(now)}",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget weatherIcon() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height * 0.2,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      "http://openweathermap.org/img/wn/${weather?.weatherIcon}@4x.png"))),
        ),
        Text(
          weather?.weatherDescription ?? "",
          style: const TextStyle(fontSize: 20, color: Colors.black),
        ),
      ],
    );
  }

  Widget currentTemperature() {
    return Column(
      children: [
        Text(
          "${weather?.temperature?.celsius?.toStringAsFixed(0) ?? ""}°C",
          style: const TextStyle(fontSize: 50, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget extraInfo() {
    return Container(
        height: MediaQuery.sizeOf(context).height * 0.15,
        width: MediaQuery.sizeOf(context).width * 0.8,
        decoration: BoxDecoration(
          color: Colors.deepPurpleAccent,
          borderRadius: BorderRadius.circular(
            20,
          ),
        ),
        padding: const EdgeInsets.all(
          8,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Max: ${weather?.tempMax?.celsius?.toStringAsFixed(0)}°C",
                  style: const TextStyle(fontSize: 15, color: Colors.white),
                ),
                Text(
                  "Min: ${weather?.tempMin?.celsius?.toStringAsFixed(0)}°C",
                  style: const TextStyle(fontSize: 15, color: Colors.white),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Wind: ${weather?.windSpeed?.toStringAsFixed(0)}m/s",
                  style: const TextStyle(fontSize: 15, color: Colors.white),
                ),
                Text(
                  "Humidity: ${weather?.humidity?.toStringAsFixed(0)}%",
                  style: const TextStyle(fontSize: 15, color: Colors.white),
                ),
              ],
            )
          ],
        ));
  }
}
