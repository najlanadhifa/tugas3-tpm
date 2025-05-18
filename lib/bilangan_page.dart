import 'package:flutter/material.dart';
import 'dart:math';

class BilanganPage extends StatefulWidget {
  @override
  _BilanganPageState createState() => _BilanganPageState();
}

class _BilanganPageState extends State<BilanganPage> {
  final TextEditingController _controller = TextEditingController();
  String _hasil = '';

  bool isPrima(int number) {
    if (number < 2) return false;
    for (int i = 2; i <= sqrt(number).toInt(); i++) {
      if (number % i == 0) return false;
    }
    return true;
  }

  void _cekJenisBilangan() {
    final input = _controller.text;
    if (input.isEmpty || double.tryParse(input) == null) {
      setState(() => _hasil = 'Masukkan angka yang valid!');
      return;
    }

    double angka = double.parse(input);
    List<String> jenis = [];

    // Cacah = >= 0 dan bulat
    if (angka >= 0 && angka % 1 == 0) jenis.add('Cacah');

    // Bulat
    if (angka % 1 == 0) jenis.add('Bulat');
    else jenis.add('Desimal');

    // Positif / Negatif / Nol
    if (angka > 0) jenis.add('Positif');
    else if (angka < 0) jenis.add('Negatif');
    else jenis.add('Nol');

    // Genap / Ganjil (hanya berlaku untuk bilangan bulat)
    if (angka % 1 == 0) {
      jenis.add(angka.toInt() % 2 == 0 ? 'Genap' : 'Ganjil');
    }

    // Prima (hanya untuk bilangan bulat positif)
    if (angka % 1 == 0 && angka > 1 && isPrima(angka.toInt())) {
      jenis.add('Prima');
    }

    setState(() {
      _hasil = 'Jenis bilangan:\n- ' + jenis.join('\n- ');
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Color(0xFF604652);
    final Color accentColor = Color(0xFFD29F80);
    final Color bgColor = Color(0xFFF5F5F0);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('Jenis Bilangan', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Masukkan angka (maksimal 15 digit):',
              style: TextStyle(fontSize: 16, color: primaryColor, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              maxLength: 15,
              decoration: InputDecoration(
                counterText: '',
                hintText: 'Contoh: 12, -5, 3.14',
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _cekJenisBilangan,
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text('Cek Jenis Bilangan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 24),
            Text(
              _hasil,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
