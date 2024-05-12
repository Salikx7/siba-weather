import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:siba_weather/screens/signIn.dart';
import 'package:siba_weather/utils/consts.dart';
import 'package:weather/weather.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siba_weather/utils/string_extensions.dart';
import 'package:appbar_dropdown/appbar_dropdown.dart'; // Import the appbar_dropdown package

class HomeScreen extends StatefulWidget {
  final String firstName; // Add this line to accept the first name

  const HomeScreen({Key? key, required this.firstName}) : super(key: key);

  @override
  State<HomeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final WeatherFactory wf = WeatherFactory(OpenWeather_API_KEY);
  Weather? weather;
  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchWeather("Sukkur");
    startTimer();
  }

  void fetchWeather(String cityName) async {
    try {
      Weather? fetchedWeather = await wf.currentWeatherByCityName(cityName);
      if (fetchedWeather == null) {
        if (mounted) {
          // Check if the widget is still mounted
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Invalid location'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        setState(() {
          weather = fetchedWeather;
        });
      }
    } catch (e) {
      if (mounted) {
        // Check if the widget is still mounted
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void startTimer() {
    Timer.periodic(Duration(minutes: 1), (timer) {
      fetchWeather(
          _cityController.text.isEmpty ? "Sukkur" : _cityController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: buildUI(),
      ),
    );
  }

  void signOut() async {
    try {
      print("Signing out...");
      await FirebaseAuth.instance.signOut();
      print("Signed out. Navigating to sign-in screen...");
      Navigator.pushReplacementNamed(context, '/signin');
      print("Signed out successfully.");
    } catch (e) {
      // Handle any errors that occur during sign-out
      print("Sign out failed: $e");
    }
  }

  Widget buildUI() {
    int currentHour = DateTime.now().hour;

    // Determine the greeting based on the time of day
    String greeting;
    if (currentHour < 12) {
      greeting = "Good Morning";
    } else if (currentHour < 18) {
      greeting = "Good Afternoon";
    } else {
      greeting = "Good Evening";
    }

    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 20, left: 40, right: 0, bottom: 8),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.07,
                  padding: EdgeInsets.fromLTRB(10, 10, 9, 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 0.1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.17),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: Offset(0, 4),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: TextField(
                    controller: _cityController,
                    decoration: InputDecoration(
                      hintText: 'Search for any location',
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          fetchWeather(_cityController.text);
                        },
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.more_vert), // This icon can be customized
                onPressed: () {
                  showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(
                        100, 130, 0, 0), // Adjust as needed
                    items: <PopupMenuEntry>[
                      PopupMenuItem<String>(
                        value: 'Sign Out',
                        child: ListTile(
                          title: Text('Sign Out'),
                          onTap: signOut,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: weather == null
              ? const Center(child: CircularProgressIndicator())
              : SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      Text(
                        "$greeting, ${widget.firstName}!",
                        style: GoogleFonts.quicksand(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      locationheader(),
                      dateTimeInfo(),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05),
                      weatherIcon(),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      currentTemperature(),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      extraInfo(),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  Widget locationheader() {
    return Text(
      weather?.areaName ?? "",
      style: GoogleFonts.quicksand(
        fontSize: 47,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Widget dateTimeInfo() {
    DateTime now = weather!.date!;
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              DateFormat("EEEE").format(now),
              style: GoogleFonts.quicksand(
                  fontSize: 15, fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              DateFormat("h:mm a").format(now),
              style: GoogleFonts.quicksand(
                  fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ],
        )
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
      ],
    );
  }

  Widget currentTemperature() {
    return Column(
      children: [
        Text(
          "${weather?.temperature?.celsius?.toStringAsFixed(0) ?? ""}°C",
          style:
              GoogleFonts.quicksand(fontSize: 52, fontWeight: FontWeight.w400),
        ),
        Text(
          (weather?.weatherDescription ?? "").capitalize(),
          style: GoogleFonts.quicksand(
              fontSize: 15, color: Colors.black, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget extraInfo() {
    return Container(
        height: MediaQuery.sizeOf(context).height * 0.15,
        width: MediaQuery.sizeOf(context).width * 0.8,
        decoration: BoxDecoration(
          color: Color(0xFFD6CCFF),
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
                  "Feels Like: ${weather?.tempFeelsLike?.celsius?.toStringAsFixed(0)}°C",
                  style:
                      GoogleFonts.quicksand(fontSize: 15, color: Colors.black),
                ),
                Text(
                  "Clouds: ${weather?.cloudiness?.toStringAsFixed(0)}%",
                  style:
                      GoogleFonts.quicksand(fontSize: 15, color: Colors.black),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Wind: ${(weather?.windSpeed != null ? weather!.windSpeed!.toDouble() * 3.6 : 0).toStringAsFixed(0)} km/h",
                  style:
                      GoogleFonts.quicksand(fontSize: 15, color: Colors.black),
                ),
                Text(
                  "Humidity: ${weather?.humidity?.toStringAsFixed(0)}%",
                  style:
                      GoogleFonts.quicksand(fontSize: 15, color: Colors.black),
                ),
              ],
            )
          ],
        ));
  }
}
