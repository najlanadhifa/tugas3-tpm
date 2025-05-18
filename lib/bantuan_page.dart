import 'package:flutter/material.dart';

class BantuanPage extends StatefulWidget {
  @override
  _BantuanPageState createState() => _BantuanPageState();
}

class _BantuanPageState extends State<BantuanPage> {
  final List<Map<String, String>> bantuanList = [
    {
      'judul': 'Beranda',
      'isi':
          '🏠 Beranda\n'
          'Menu Beranda merupakan halaman utama yang menampilkan berbagai fitur aplikasi, seperti:\n\n'
          '- Stopwatch: Mengatur dan menjalankan stopwatch.\n'
          '- Jenis Bilangan: Menampilkan jenis-jenis bilangan.\n'
          '- Tracking Lokasi (LBS): Menampilkan lokasi pengguna secara real-time.\n'
          '- Konversi Waktu: Mengonversi satuan waktu seperti menit, jam, dan detik.\n'
          '- Situs Rekomendasi: Menyediakan tautan ke situs edukatif.\n\n'
          '➡️ Untuk menggunakan fitur, cukup tekan tombol menu yang tersedia di halaman Beranda.',
    },
    {
      'judul': 'Anggota',
      'isi':
          '👥 Anggota\n'
          'Menu Anggota menampilkan daftar anggota tim pengembang aplikasi ini. Setiap anggota ditampilkan dalam bentuk kartu yang berisi:\n\n'
          '- Foto anggota\n'
          '- Nama lengkap\n'
          '- NIM (Nomor Induk Mahasiswa)\n'
          '- Kelas\n\n'
          '➡️ Kamu bisa melihat semua informasi ini dengan menggulir halaman ke bawah.',
    },
    {
      'judul': 'Bantuan',
      'isi':
          '❓ Bantuan\n'
          'Menu Bantuan memberikan informasi mengenai:\n\n'
          '- Fungsi dari setiap menu dalam aplikasi\n'
          '- Panduan dasar penggunaan fitur\n\n'
          '➡️ Jika kamu merasa bingung saat menggunakan aplikasi, buka halaman ini kapan saja untuk mendapatkan penjelasan.',
    },
  ];

  final Color primaryColor = Color(0xFF604652);
  final Color accentColor = Color(0xFFD29F80);

  List<bool> _isExpanded = [];

  @override
  void initState() {
    super.initState();
    _isExpanded = List.generate(bantuanList.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDFDFD),
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Pusat Bantuan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        itemCount: bantuanList.length,
        itemBuilder: (context, index) {
          final item = bantuanList[index];
          return AnimatedContainer(
            duration: Duration(milliseconds: 300),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              onExpansionChanged: (expanded) {
              setState(() {
                for (int i = 0; i < _isExpanded.length; i++) {
                  _isExpanded[i] = i == index ? expanded : false;
                }
              });
            },
              trailing: Icon(
                _isExpanded[index]
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: accentColor,
              ),
              title: Text(
                item['judul']!,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: primaryColor,
                ),
              ),
              children: [
                Text(
                  item['isi']!,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: Colors.grey.shade800,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
