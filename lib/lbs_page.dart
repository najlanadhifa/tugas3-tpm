import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

void showAppSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
      backgroundColor: const Color(0xFF604652),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      duration: const Duration(seconds: 2),
      elevation: 6,
    ),
  );
}

class LBSPage extends StatefulWidget {
  @override
  _LBSPageState createState() => _LBSPageState();
}

class _LBSPageState extends State<LBSPage> {
  LatLng? _currentPosition;
  LatLng? _destinationPosition;
  bool _loading = false;
  bool _selectingDestination = false;
  StreamSubscription<Position>? _positionStream;

  double get _distance {
    if (_currentPosition != null && _destinationPosition != null) {
      return Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        _destinationPosition!.latitude,
        _destinationPosition!.longitude,
      );
    }
    return 0;
  }

  String get _distanceString {
    if (_distance == 0) return '';
    if (_distance < 1000) {
      return '${_distance.toStringAsFixed(0)} m';
    } else {
      return '${(_distance / 1000).toStringAsFixed(2)} km';
    }
  }

  List<LatLng> get _routeCoordinates {
    if (_currentPosition != null && _destinationPosition != null) {
      return [_currentPosition!, _destinationPosition!];
    }
    return [];
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _loading = true);

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showAppSnackbar(context, 'Layanan lokasi tidak aktif.');
      setState(() => _loading = false);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        showAppSnackbar(context, 'Izin lokasi ditolak.');
        setState(() => _loading = false);
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _loading = false;
    });
  }

  void _startLocationStream() {
    _positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 5,
      ),
    ).listen((Position position) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation().then((_) {
      _startLocationStream();
    });
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Color(0xFF604652);
    final Color accentColor = Color(0xFFD29F80);
    final Color bgColor = Color(0xFFF5F5F0);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('Pelacak Lokasi',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _currentPosition == null
          ? Center(
              child: _loading
                  ? CircularProgressIndicator(color: accentColor)
                  : Text('Lokasi tidak tersedia.',
                      style: TextStyle(color: primaryColor, fontSize: 16)),
            )
          : Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(24)),
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: _currentPosition!,
                        initialZoom: 16,
                        onTap: _selectingDestination
                            ? (tapPosition, latlng) {
                                setState(() {
                                  _destinationPosition = latlng;
                                  _selectingDestination = false;
                                });
                                showAppSnackbar(context, 'Lokasi tujuan dipilih.');
                              }
                            : null,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.app',
                        ),
                        PolylineLayer(
                          polylines: [
                            if (_routeCoordinates.isNotEmpty)
                              Polyline(
                                points: _routeCoordinates,
                                color: accentColor,
                                strokeWidth: 5,
                              ),
                          ],
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: _currentPosition!,
                              width: 44,
                              height: 44,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 8,
                                    )
                                  ],
                                ),
                                child: Icon(Icons.my_location,
                                    color: primaryColor, size: 30),
                              ),
                            ),
                            if (_destinationPosition != null)
                              Marker(
                                point: _destinationPosition!,
                                width: 44,
                                height: 44,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 8,
                                      )
                                    ],
                                  ),
                                  child: Icon(Icons.location_pin,
                                      color: accentColor, size: 35),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(32)),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accentColor,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              icon: Icon(Icons.refresh),
                              label: Text(
                                _loading ? 'Memuat...' : 'Perbarui Lokasi Saya',
                                style: TextStyle(fontSize: 16),
                              ),
                              onPressed: _loading
                                  ? null
                                  : () {
                                      _getCurrentLocation();
                                      showAppSnackbar(context, 'Lokasi diperbarui.');
                                    },
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              icon: Icon(Icons.add_location_alt),
                              label: Text(
                                'Pilih Lokasi Tujuan',
                                style: TextStyle(fontSize: 16),
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectingDestination = true;
                                });
                                showAppSnackbar(
                                    context, 'Tap pada peta untuk memilih tujuan.');
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Icon(Icons.my_location, color: primaryColor, size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Lat: ${_currentPosition!.latitude.toStringAsFixed(6)}, '
                              'Lng: ${_currentPosition!.longitude.toStringAsFixed(6)}',
                              style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      if (_destinationPosition != null) ...[
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.location_pin, color: accentColor, size: 20),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Lat: ${_destinationPosition!.latitude.toStringAsFixed(6)}, '
                                'Lng: ${_destinationPosition!.longitude.toStringAsFixed(6)}',
                                style: TextStyle(
                                    color: accentColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.route, color: Colors.grey[700], size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Jarak: ',
                              style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              _distanceString,
                              style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}