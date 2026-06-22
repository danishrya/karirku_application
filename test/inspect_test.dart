import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:karirku_application/firebase_options.dart';

void main() {
  test('inspect firestore data', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized');
    final querySnapshot = await FirebaseFirestore.instance.collection('jobs').get();
    print('Jobs count: ${querySnapshot.docs.length}');
    for (var doc in querySnapshot.docs) {
      print('Job ID: ${doc.id}');
      print('Job Data: ${doc.data()}');
    }
    
    final usersSnapshot = await FirebaseFirestore.instance.collection('users').get();
    print('Users count: ${usersSnapshot.docs.length}');
    for (var doc in usersSnapshot.docs) {
      print('User ID: ${doc.id}');
      print('User Data: ${doc.data()}');
    }
  });
}
