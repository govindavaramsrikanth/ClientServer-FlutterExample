import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String serverResponse = 'Server response';
  String ipAddress = '192.168.29.73';
  int portNo = 3000;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(serverResponse),
            Text(
              '$serverResponse',
              style: Theme.of(context).textTheme.headline4,
            ),
            FloatingActionButton(
              onPressed: _serverRequest,
              child: const Icon(Icons.ac_unit),
            )
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _makeGetRequest();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _serverRequest() async {
    var server = await HttpServer.bind(
      ipAddress,
      portNo,
    );

    print('Listening on localhost:${server.address}');
    await for (HttpRequest request in server) {
      DateTime now = DateTime.now();
      request.response
        ..write(now.hour.toString() +
            ":" +
            now.minute.toString() +
            ":" +
            now.second.toString())
        ..close();
    }
  }

  _makeGetRequest() async {
    serverResponse = "text";
    Response response = await get(_localhost());
    setState(() {
      serverResponse = response.body;
    });
  }

  String _localhost() {
    String port = portNo.toString();
    if (Platform.isAndroid)
      return "http://$ipAddress:$port"; //InternetAddress.anyIPv6.address;//InternetAddress.anyIPv4.address;
    else // for iOS simulator
      return 'http://localhost:3000';
  }
}
