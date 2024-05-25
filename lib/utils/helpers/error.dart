import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key, required this.error});
  final String error;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              LottieBuilder.asset("assets/lotties/error.json", reverse: true),
              Center(child: Text(error, style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500), textAlign: TextAlign.center)),
            ],
          ),
        ),
      ),
    );
  }
}
