import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: MyScreen(),
    );
  }
}






class MyScreen extends StatefulWidget {
  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  String apiResult = 'NA';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Traffic Cop API Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                callApi();
              },
              child: Text('Call API'),
            ),
            SizedBox(height: 20),
            Text("IVT Score", style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: 20),
            Text(apiResult),
          ],
        ),
      ),
    );
  }

  String getLanguage() {
    return Platform.localeName;
  }

  int getTimeZoneOffset() {
    final date = DateTime.now();
    final timeZoneOffset = date.timeZoneOffset;
    final minutesOffset = timeZoneOffset.inMinutes;
    return -minutesOffset;
  }


  Future<void> callApi() async {
    final url = Uri.parse('https://tc.pubguru.net/v1');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token ADD_TOKEN_HERE'
    };

    final requestBody = {
      'appId': 'com.example.tcapi.tc_api_demo_flutter',
      'navigatorLanguage': getLanguage(),
      'timezoneOffset': getTimeZoneOffset(),
    };

    print('Request body: $requestBody');

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        print('Response body: $responseBody');
        final ivtScore = responseBody['ivtScore'];
        print('API call successful. Value: $ivtScore');
        setState(() {
          apiResult = '$ivtScore';
        });
      } else {
        print('API call failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during API call: $e');
    }
  }
}