import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/pages/home_page.dart';
import 'package:weather_app/pages/search_page.dart';
import 'package:weather_app/providers/weather_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent));
    return ChangeNotifierProvider(
      create: (_) => WeatherProvider(),
      lazy: false,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyApp',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        // home: HomePage(),
        initialRoute: "/",
        routes: {
          '/': (context) => HomePage(),
          'search': (context) => SearchPage(),
        },
      ),
    );
  }
}
