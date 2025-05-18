import 'package:flutter/material.dart';

class KonversiWaktuPage extends StatefulWidget {
  const KonversiWaktuPage({super.key});

  @override
  State<KonversiWaktuPage> createState() => _KonversiWaktuPageState();
}

class _KonversiWaktuPageState extends State<KonversiWaktuPage> {
  final TextEditingController _tahunController = TextEditingController();

  Map<String, String> _hasil = {
    'tahun': '0',
    'bulan': '0',
    'hari': '0',
    'jam': '0',
    'menit': '0',
    'detik': '0',
  };

  bool hasConverted = false;

  final Color bgColor = const Color(0xFFF7F0E8);
  final Color mainColor = const Color(0xFF604652);
  final Color btnLight = const Color(0xFFD29F80);

  void _konversiWaktu() {
    double tahun = double.tryParse(_tahunController.text) ?? 0;

    // Total perhitungan dalam satuan waktu
    double totalDetik = tahun * 365 * 24 * 60 * 60;
    int totalJam = (tahun * 365 * 24).floor();
    int totalMenit = (tahun * 365 * 24 * 60).floor();
    int totalDetikInt = totalDetik.floor();

    // Menambahkan perhitungan bulan dan hari
    int totalBulan = (tahun * 12).floor();
    int totalHari = (tahun * 365).floor();

    setState(() {
      _hasil = {
        'tahun': tahun.toStringAsFixed(2),
        'bulan': totalBulan.toString(),
        'hari': totalHari.toString(),
        'jam': totalJam.toString(),
        'menit': totalMenit.toString(),
        'detik': totalDetikInt.toString(),
      };
      hasConverted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        foregroundColor: Colors.white,
        title: const Text(
          'Konversi Waktu',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Masukkan jumlah tahun untuk dikonversi:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _tahunController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Jumlah Tahun',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _konversiWaktu,
              style: ElevatedButton.styleFrom(
                backgroundColor: btnLight,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Konversi',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),
            if (hasConverted)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hasil Konversi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: mainColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildResultItem(label: 'Tahun', value: _hasil['tahun']!, unit: 'tahun'),
                    _buildResultItem(label: 'Bulan', value: _hasil['bulan']!, unit: 'bulan'),
                    _buildResultItem(label: 'Hari', value: _hasil['hari']!, unit: 'hari'),
                    _buildResultItem(label: 'Jam', value: _hasil['jam']!, unit: 'jam'),
                    _buildResultItem(label: 'Menit', value: _hasil['menit']!, unit: 'menit'),
                    _buildResultItem(label: 'Detik', value: _hasil['detik']!, unit: 'detik'),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultItem({required String label, required String value, required String unit}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(Icons.access_time, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text(
            "$label:",
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          const Spacer(),
          Text(
            "$value $unit",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
