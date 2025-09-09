import 'package:flutter/material.dart';
import 'package:karirku_application/home/screen/home_screen/home_screen.dart';

class LogoSkip extends StatelessWidget {
  const LogoSkip({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // Biar tidak nabrak status bar
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start, // isi ada di atas
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 120, // atur tinggi logo biar rapi
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(
                          name: '',
                          // 🔥 kirim nama beneran
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: const [
                      Text(
                        'Skip',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.skip_next, color: Colors.blue, size: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Tambahan konten lain di bawah
        ],
      ),
    );
  }
}
