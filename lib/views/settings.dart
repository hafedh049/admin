// ignore_for_file: use_build_context_synchronously

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:dabka/utils/callbacks.dart';
import 'package:dabka/views/holder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

import '../utils/shared.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final Map<String, String> _languages = <String, String>{
    "en": "English",
    "fr": "Français",
    "ar": "العربية",
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: white,
        title: Text("Settings", style: GoogleFonts.abel(fontSize: 22, fontWeight: FontWeight.bold, color: purple)),
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(FontAwesome.chevron_left_solid, size: 20, color: purple)),
      ),
      body: Column(
        children: <Widget>[
          Card(
            shadowColor: dark,
            elevation: 6,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: StatefulBuilder(
                builder: (BuildContext context, void Function(void Function()) _) {
                  return Row(
                    children: <Widget>[
                      Text("Language (${_languages[settingsBox!.get('language')]})", style: GoogleFonts.abel(color: dark, fontSize: 14, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      SizedBox(
                        height: 30,
                        child: AnimatedToggleSwitch<String>.rolling(
                          current: settingsBox!.get("language"),
                          values: const <String>["en", "fr", "ar"],
                          onChanged: (String value) {
                            settingsBox!.put("language", value);
                            _(() {});
                          },
                          iconList: <Container>[
                            for (final String key in _languages.keys)
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(image: AssetImage("assets/icons/$key.png"), fit: BoxFit.contain),
                                ),
                              ),
                          ],
                          style: const ToggleStyle(backgroundColor: grey, borderColor: dark),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            shadowColor: dark,
            elevation: 6,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: StatefulBuilder(
                builder: (BuildContext context, void Function(void Function()) _) {
                  return Row(
                    children: <Widget>[
                      Text("Theme (${settingsBox!.get('theme').toUpperCase()})", style: GoogleFonts.abel(color: dark, fontSize: 14, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      SizedBox(
                        height: 30,
                        child: AnimatedToggleSwitch<String>.rolling(
                          current: settingsBox!.get("theme"),
                          values: const <String>["light", "dark"],
                          onChanged: (String value) {
                            settingsBox!.put("theme", value);
                            _(() {});
                          },
                          iconList: <Container>[
                            for (final String key in const <String>["light", "dark"])
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(image: AssetImage("assets/icons/$key.png"), fit: BoxFit.contain),
                                ),
                              ),
                          ],
                          style: const ToggleStyle(backgroundColor: grey, borderColor: dark),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () async {
              showToast(context, "Bye");
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => const Holder()), (Route route) => false);
            },
            child: Card(
              shadowColor: dark,
              elevation: 6,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: <Widget>[
                    Card(
                      shadowColor: dark,
                      elevation: 4,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: white),
                        width: 50,
                        height: 50,
                        child: const Icon(FontAwesome.door_closed_solid, size: 25, color: purple),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text("Sign Out", style: GoogleFonts.abel(color: dark, fontSize: 14, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Card(
                      shadowColor: dark,
                      elevation: 4,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: white),
                        width: 50,
                        height: 50,
                        child: const Icon(FontAwesome.chevron_right_solid, size: 25, color: dark),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
