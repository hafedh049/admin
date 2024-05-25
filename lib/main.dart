import 'package:dabka/utils/callbacks.dart';
import 'package:dabka/views/holder.dart';
import 'package:dabka/views/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'translations/translation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: const Locale('ar', 'AR'),
      fallbackLocale: const Locale('ar', 'AR'),
      translations: Translation(),
      builder: (BuildContext context, Widget? child) => Directionality(textDirection: TextDirection.ltr, child: child!),
      home: FirebaseAuth.instance.currentUser == null ? const SignIn() : const Holder(),
      debugShowCheckedModeBanner: false,
    );
  }
}
