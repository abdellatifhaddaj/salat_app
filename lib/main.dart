import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'مواقيت الصلاة',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const PrayerTimesPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PrayerTimesPage extends StatefulWidget {
  const PrayerTimesPage({super.key});

  @override
  State<PrayerTimesPage> createState() => _PrayerTimesPageState();
}

class _PrayerTimesPageState extends State<PrayerTimesPage> {
  PrayerTimes? _prayerTimes;
  String _location = 'الرباط، المغرب';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _getPrayerTimes();
  }

  Future<void> _getPrayerTimes() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      double lat = 34.0209; // الرباط
      double lng = -6.8416;
      
      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition();
        lat = position.latitude;
        lng = position.longitude;
        _location = 'موقعك الحالي';
      }

      final coordinates = Coordinates(lat, lng);
      final params = CalculationMethod.morocco();
      params.madhab = Madhab.shafi;
      final prayerTimes = PrayerTimes.today(coordinates, params);

      setState(() {
        _prayerTimes = prayerTimes;
        _loading = false;
      });
    } catch (e) {
      final coordinates = Coordinates(34.0209, -6.8416);
      final params = CalculationMethod.morocco();
      params.madhab = Madhab.shafi;
      final prayerTimes = PrayerTimes.today(coordinates, params);
      setState(() {
        _prayerTimes = prayerTimes;
        _location = 'الرباط، المغرب';
        _loading = false;
      });
    }
  }

  String _formatTime(DateTime? time) {
    if (time == null) return '--:--';
    return DateFormat('HH:mm').format(time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مواقيت الصلاة'),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _getPrayerTimes,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.location_on, color: Colors.green),
                      title: Text(_location),
                      subtitle: Text(DateFormat('EEEE, d MMMM yyyy', 'ar').format(DateTime.now())),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildPrayerCard('الفجر', _prayerTimes?.fajr, Icons.dark_mode),
                  _buildPrayerCard('الشروق', _prayerTimes?.sunrise, Icons.wb_sunny),
                  _buildPrayerCard('الظهر', _prayerTimes?.dhuhr, Icons.light_mode),
                  _buildPrayerCard('العصر', _prayerTimes?.asr, Icons.wb_twilight),
                  _buildPrayerCard('المغرب', _prayerTimes?.maghrib, Icons.nights_stay),
                  _buildPrayerCard('العشاء', _prayerTimes?.isha, Icons.bedtime),
                ],
              ),
            ),
    );
  }

  Widget _buildPrayerCard(String name, DateTime? time, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        trailing: Text(_formatTime(time), style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}
