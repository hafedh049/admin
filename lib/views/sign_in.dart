// ignore_for_file: use_build_context_synchronously

import 'package:dabka/utils/shared.dart';
import 'package:dabka/views/holder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

import '../utils/callbacks.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _ignoreStupidity = false;

  bool _obscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(FontAwesome.chevron_left_solid, size: 15, color: dark)),
          centerTitle: true,
          backgroundColor: white,
          title: Text("Admin Sign-In", style: GoogleFonts.abel(fontSize: 22, color: dark, fontWeight: FontWeight.bold)),
          elevation: 5,
          shadowColor: dark,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              Center(child: Image.asset("assets/images/logo.png", width: 150, height: 150)),
              const SizedBox(height: 40),
              SizedBox(
                height: 40,
                child: StatefulBuilder(
                  builder: (BuildContext context, void Function(void Function()) _) {
                    return TextField(
                      controller: _emailController,
                      style: GoogleFonts.abel(color: dark, fontSize: 14, fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(6),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                        disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                        hintText: "abc@xyz.com",
                        hintStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                        labelText: "E-mail",
                        labelStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                        prefixIcon: const IconButton(onPressed: null, icon: Icon(FontAwesome.envelope_solid, color: grey, size: 15)),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 40,
                child: StatefulBuilder(
                  builder: (BuildContext context, void Function(void Function()) _) {
                    return TextField(
                      controller: _passwordController,
                      obscureText: _obscureText,
                      style: GoogleFonts.abel(color: dark, fontSize: 14, fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(6),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                        disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                        hintText: "**********",
                        hintStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                        labelText: "Password",
                        labelStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                        prefixIcon: const IconButton(onPressed: null, icon: Icon(FontAwesome.lock_solid, color: grey, size: 15)),
                        suffixIcon: IconButton(
                          onPressed: () => _(() => _obscureText = !_obscureText),
                          icon: Icon(_obscureText ? FontAwesome.eye_slash : FontAwesome.eye, color: grey, size: 15),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: StatefulBuilder(
                  builder: (BuildContext context, void Function(void Function()) _) {
                    return IgnorePointer(
                      ignoring: _ignoreStupidity,
                      child: InkWell(
                        hoverColor: transparent,
                        splashColor: transparent,
                        highlightColor: transparent,
                        onTap: () async {
                          //admin@gmail.com adminadmin 4kX5FdxdqjgEVIppH4EqLZBzVLP2
                          if (!_emailController.text.contains(RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w-]{2,4}$'))) {
                            showToast(context, "Enter a correct e-mail address", color: red);
                          } else if (_passwordController.text.isEmpty) {
                            showToast(context, "Enter a correct password", color: red);
                          } else {
                            try {
                              _(() => _ignoreStupidity = true);
                              showToast(context, "Please wait...");
                              await FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => const Holder()), (Route route) => false);
                              showToast(context, "Welcome back");
                              _(() => _ignoreStupidity = false);
                            } catch (e) {
                              showToast(context, e.toString(), color: red);
                              _(() => _ignoreStupidity = false);
                            }
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 48),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: purple),
                          child: Text("Sign-in", style: GoogleFonts.abel(color: white, fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
