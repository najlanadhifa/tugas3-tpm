import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SitusRekomendasiPage extends StatefulWidget {
  @override
  State<SitusRekomendasiPage> createState() => _SitusRekomendasiPageState();
}

class _SitusRekomendasiPageState extends State<SitusRekomendasiPage> {
  final List<Map<String, String>> rekomendasi = [
    {'nama': 'SPADA', 'url': 'https://spada.upnyk.ac.id/', 'gambar': 'assets/download.jpg'},
    {'nama': 'SADEWA', 'url': 'https://sadewa.upnyk.ac.id/', 'gambar': 'assets/images.jpg'},
    {'nama': 'BIMA', 'url': 'https://bima.upnyk.ac.id/', 'gambar': 'assets/bima.jpg'},
    {'nama': 'Dart Official', 'url': 'https://dart.dev', 'gambar': 'assets/dart.png'},
    {'nama': 'Flutter Official', 'url': 'https://flutter.dev', 'gambar': 'assets/flutter.png'},
    {'nama': 'W3Schools', 'url': 'https://www.w3schools.com', 'gambar': 'assets/w3school.png'},
    {'nama': 'Geeks for Geeks', 'url': 'https://www.geeksforgeeks.org', 'gambar': 'assets/geeks.png'},
  ];

  List<bool> isFavorite = [];

  final Color primaryColor = const Color(0xFF604652);
  final Color secondaryColor = const Color(0xFFD29F80);
  final Color bgColor = const Color(0xFFF7F0E8);

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final savedFavorites = prefs.getStringList('favorites') ?? [];

    setState(() {
      isFavorite = rekomendasi.map((item) {
        return savedFavorites.contains(item['url']);
      }).toList();
    });
  }

  Future<void> _toggleFavorite(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final url = rekomendasi[index]['url']!;
    final savedFavorites = prefs.getStringList('favorites') ?? [];

    setState(() {
      isFavorite[index] = !isFavorite[index];
    });

    if (isFavorite[index]) {
      savedFavorites.add(url);
    } else {
      savedFavorites.remove(url);
    }

    await prefs.setStringList('favorites', savedFavorites);
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tidak dapat membuka URL: $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Situs Rekomendasi'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: rekomendasi.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final item = rekomendasi[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      item['gambar']!,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['nama']!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item['url']!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.blueGrey,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: () => _launchURL(item['url']!),
                          icon: const Icon(Icons.open_in_new, size: 18),
                          label: const Text('Kunjungi'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: secondaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isFavorite.length > index && isFavorite[index]
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: isFavorite.length > index && isFavorite[index]
                          ? Colors.red
                          : Colors.grey,
                    ),
                    onPressed: () => _toggleFavorite(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
