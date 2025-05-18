import 'package:flutter/material.dart';

class AnggotaPage extends StatelessWidget {
  final List<Map<String, String>> anggota = [
    {
      'nama': 'Ikhsan Syahri R',
      'nim': '123220024',
      'kelas': 'IF - C',
      'foto': 'assets/ikhsan.png',
    },
    {
      'nama': 'Ghefira Nur S',
      'nim': '123220178',
      'kelas': 'IF - C',
      'foto': 'assets/salsa.png',
    },
    {
      'nama': 'Aziizah Intan R.N',
      'nim': '123220201',
      'kelas': 'IF - C',
      'foto': 'assets/aira.png',
    },
    {
      'nama': 'Najla Nadhifa',
      'nim': '123220205',
      'kelas': 'IF - C',
      'foto': 'assets/difa.png',
    },
  ];

  final Color primaryColor = const Color(0xFF604652);
  final Color secondaryColor = const Color(0xFFD29F80);
  final Color bgColor = const Color(0xFFF7F0E8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Daftar Anggota',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        itemCount: anggota.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final data = anggota[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
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
                    borderRadius: BorderRadius.circular(40),
                    child: Image.asset(
                      data['foto']!,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['nama']!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "NIM: ${data['nim']!}",
                          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                        Text(
                          "Kelas: ${data['kelas']!}",
                          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.verified_user_rounded, color: secondaryColor, size: 28),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
