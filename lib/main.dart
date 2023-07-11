import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LocationScreen(),
    );
  }
}

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String _locationMessage = '';
  String ido = '';
  String keido = '';

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        ido = '${position.latitude}';
        keido = '${position.longitude}';
        _locationMessage =
            '緯度: ${position.latitude}\n経度: ${position.longitude}';
      });
    } catch (e) {
      setState(() {
        _locationMessage = '位置情報の取得に失敗しました: $e';
      });
    }
  }

  Future<void> _openGoogleMaps() async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$ido,$keido';
    if (await canLaunch(url)) {
       await launch(url);
    } else {
      final fallbackUrl = 'https://www.google.com/maps/search/?api=1&query=$ido,$keido';
      await launch(fallbackUrl, forceSafariVC: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _locationMessage,
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getLocation,
              child: Text('再取得'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _openGoogleMaps,
              child: Text(_locationMessage),
            ),
          ],
        ),
      ),
    );
  }
}
