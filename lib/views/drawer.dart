import 'package:dabka/utils/shared.dart';
import 'package:dabka/views/about_us.dart';
import 'package:dabka/views/settings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

class DDrawer extends StatefulWidget {
  const DDrawer({super.key});

  @override
  State<DDrawer> createState() => _DDrawerState();
}

class _DDrawerState extends State<DDrawer> {
  late final List<Map<String, dynamic>> _tiles;
  @override
  void initState() {
    _tiles = <Map<String, dynamic>>[
      <String, dynamic>{
        "icon": FontAwesome.house_chimney_solid,
        "tile": "Home",
        "page": () => Navigator.pop(context),
      },
      <String, dynamic>{"tile": "DIVIDER"},
      <String, dynamic>{
        "icon": FontAwesome.gear_solid,
        "tile": "Settings",
        "page": const Settings(),
      },
      <String, dynamic>{
        "icon": Bootstrap.hexagon_half,
        "tile": "About Us",
        "page": const AboutUs(),
      },
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 273,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 10),
              Card(
                shape: const CircleBorder(),
                elevation: 6,
                shadowColor: dark,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Image.asset("assets/images/logo.png", width: 60, height: 60),
                ),
              ),
              const SizedBox(height: 20),
              for (final Map<String, dynamic> tile in _tiles) ...<Widget>[
                tile["tile"] == "DIVIDER"
                    ? const Divider(indent: 25, endIndent: 25, color: grey, height: .3, thickness: .3)
                    : InkWell(
                        splashColor: transparent,
                        highlightColor: transparent,
                        hoverColor: transparent,
                        onTap: () => tile['tile'] == 'Home' ? Navigator.pop(context) : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => tile["page"])),
                        child: Row(
                          children: <Widget>[
                            Icon(tile["icon"], size: 20, color: dark.withOpacity(.5)),
                            const SizedBox(width: 20),
                            Text(tile["tile"], style: GoogleFonts.abel(color: dark.withOpacity(.9), fontSize: 14, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                const SizedBox(height: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
