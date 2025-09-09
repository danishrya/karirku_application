import 'package:flutter/material.dart';
import 'package:karirku_application/components/logoskip.dart';
import 'package:karirku_application/home/screen/home_screen/home_screen.dart';
import 'package:karirku_application/home/screen/main.screen/main_screen.dart';
import 'package:karirku_application/preferences/assets.dart';

class ThirdOnBoarding extends StatefulWidget {
  const ThirdOnBoarding({super.key});

  @override
  State<ThirdOnBoarding> createState() => _ThirdOnBoardingState();
}

final _nameController = TextEditingController();

class _ThirdOnBoardingState extends State<ThirdOnBoarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(padding: EdgeInsets.only(), child: LogoSkip()),
            const Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(
                'Latih Diri & Tunjukkan Potensi Terbaikmu',
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Ikuti simulasi wawancara, pelatihan karier, dan micro-project untuk menarik perhatian HRD dan membangun portofolio.',
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 380,
              child: Image.asset(MainAssets.ob2, fit: BoxFit.contain),
            ),
            const SizedBox(height: 24),
            const Text(
              'What is your name?',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w600,
                color: Color(0xFF27214D),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 400,
              child: TextFormField(
                controller: _nameController,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF27214D),
                ),
                decoration: InputDecoration(
                  hintText: 'Enter your name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Color(0xFF27214D),
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 360,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  if (_nameController.text.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainScreen(
                          // name: _nameController.text, // 🔥 kirim nama beneran
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF27214D),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
