import 'package:dabka/utils/shared.dart';
import 'package:dabka/views/settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

class DDrawer extends StatefulWidget {
  const DDrawer({super.key});

  @override
  State<DDrawer> createState() => _DDrawerState();
}

class _DDrawerState extends State<DDrawer> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> tiles = <Map<String, dynamic>>[
      <String, dynamic>{
        "icon": FontAwesome.house_chimney_solid,
        "tile": "Home".tr,
        "page": () => Navigator.pop(context),
      },
      <String, dynamic>{"tile": "DIVIDER"},
      <String, dynamic>{
        "icon": FontAwesome.gear_solid,
        "tile": "Settings".tr,
        "page": const Settings(),
      },
    ];
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
              for (final Map<String, dynamic> tile in tiles) ...<Widget>[
                tile["tile"] == "DIVIDER"
                    ? const Divider(indent: 25, endIndent: 25, color: grey, height: .3, thickness: .3)
                    : InkWell(
                        splashColor: transparent,
                        highlightColor: transparent,
                        hoverColor: transparent,
                        onTap: () => tile['tile'] == 'Home'.tr ? Navigator.pop(context) : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => tile["page"])),
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
