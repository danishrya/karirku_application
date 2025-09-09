import 'package:flutter/material.dart';
import 'package:karirku_application/components/logoskip.dart';
import 'package:karirku_application/onboarding/onboarding3.dart';
import 'package:karirku_application/preferences/assets.dart';

// import '../components/logoskip.dart';

class SecondOnBoarding extends StatelessWidget {
  const SecondOnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.only(), child: LogoSkip()),
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(
                'CV Cerdas, Peluang Lebih Besar',
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Unggah CV-mu dan biarkan sistem pintar kami mencocokkannya dengan lowongan yang paling relevan.',
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(height: 24),
            SizedBox(
              height: 400,
              child: Image.asset(MainAssets.ob2, fit: BoxFit.contain),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ThirdOnBoarding()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF24A4FF),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 180),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text('next', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                // aksi tombol
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(394, 50),
                side: const BorderSide(color: Color(0xff24A4FF)), // border biru
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
