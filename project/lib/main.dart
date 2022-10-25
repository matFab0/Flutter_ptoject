import 'package:flutter/material.dart';
import 'package:project/pages/login_page.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

 void main() async {
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
   );
   runApp(const LoginPage());
 }
