import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Weather App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _cityController = TextEditingController();
  String _weatherText = '';
  bool _loading = false;

  Future<void> fetchWeather(String city) async {
    setState(() {
      _loading = true;
      _weatherText = 'Loading...';
    });

    try {
      final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=055e78f2005f9e43d2031b711a8973d8&units=metric',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final temp = data['main']['temp'];
        final description = data['weather'][0]['description'];

        setState(() {
          _weatherText = 'Temperature: $temp°C\nCondition: $description';
        });
      } else {
        setState(() {
          _weatherText =
          'Error: ${response.statusCode} - ${response.reasonPhrase}';
        });
      }
    } catch (e) {
      setState(() {
        _weatherText = 'Failed to fetch weather: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Text(
              'Weather App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child:
              TextField(
                controller: _cityController,
                decoration: InputDecoration(
                  hintText: 'Enter a city',
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
              ),
              onPressed: _loading
                  ? null
                  : () {
                final city = _cityController.text.trim();
                if (city.isEmpty) {
                  setState(() {
                    _weatherText = 'Please enter a city name.';
                  });
                  return;
                }
                fetchWeather(city);
              },
              child: Text('Search'),
            ),
            Text(
              _weatherText,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}