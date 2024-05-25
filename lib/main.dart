import 'package:dabka/utils/callbacks.dart';
import 'package:dabka/utils/helpers/error.dart';
import 'package:dabka/utils/helpers/wait.dart';
import 'package:dabka/views/holder.dart';
import 'package:dabka/views/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';

import 'translations/translation.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Main());
}

class Main extends StatelessWidget {
  Main({super.key});
  final FlutterLocalization localization = FlutterLocalization.instance;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      supportedLocales: localization.supportedLocales,
      localizationsDelegates: localization.localizationsDelegates,
      locale: const Locale('ar', 'AR'),
      fallbackLocale: const Locale('ar', 'AR'),
      translations: Translation(),
      home: FutureBuilder<bool>(
        future: init(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            return FirebaseAuth.instance.currentUser == null ? const SignIn() : const Holder();
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Wait();
          } else {
            return ErrorScreen(error: snapshot.error.toString());
          }
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
