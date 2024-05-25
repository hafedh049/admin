import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../utils/shared.dart';
import 'app_feedback.dart';
import 'faq.dart';
import 'privacy_policy.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  final List<Map<String, dynamic>> _list = const <Map<String, dynamic>>[
    <String, dynamic>{
      "tile": "FAQ",
      "page": FAQ(),
    },
    <String, dynamic>{
      "tile": "App Feedback",
      "page": AppFeedback(),
    },
    <String, dynamic>{
      "tile": "Privacy Policy",
      "page": PrivacyPolicy(),
    },
    <String, dynamic>{
      "tile": "Terms & Conditions",
      "page": null,
    },
  ];

  final List<Map<String, dynamic>> _socials = <Map<String, dynamic>>[
    <String, dynamic>{
      "tile": "Facebook",
      "link": "https://www.facebook.com",
      "icon": FontAwesome.facebook_f_brand,
      "color": blue,
    },
    <String, dynamic>{
      "tile": "Instagram",
      "link": "https://www.instagram.com",
      "icon": FontAwesome.square_instagram_brand,
      "color": Colors.amber,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: white,
        title: Text("About Us", style: GoogleFonts.abel(fontSize: 16, fontWeight: FontWeight.bold, color: dark)),
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(FontAwesome.chevron_left_solid, size: 15, color: purple)),
        elevation: 6,
        shadowColor: dark,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            for (final Map<String, dynamic> item in _list) ...<Widget>[
              InkWell(
                hoverColor: transparent,
                splashColor: transparent,
                highlightColor: transparent,
                onTap: item["page"] == null ? null : () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => item["page"])),
                child: Card(
                  elevation: 4,
                  shadowColor: dark,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: Row(
                      children: <Widget>[
                        Text(item["tile"], style: GoogleFonts.abel(fontSize: 10, fontWeight: FontWeight.w500, color: dark)),
                        const Spacer(),
                        const IconButton(onPressed: null, icon: Icon(FontAwesome.chevron_right_solid, size: 15, color: purple)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 10),
            const Divider(thickness: .3, height: .3, color: grey),
            const SizedBox(height: 20),
            for (final Map<String, dynamic> item in _socials) ...<Widget>[
              InkWell(
                hoverColor: transparent,
                splashColor: transparent,
                highlightColor: transparent,
                onTap: () async => await launchUrlString(item["url"]),
                child: Card(
                  elevation: 4,
                  shadowColor: dark,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: Row(
                      children: <Widget>[
                        IconButton(onPressed: null, icon: Icon(item["icon"], size: 20, color: item["color"])),
                        Text(item["tile"], style: GoogleFonts.abel(fontSize: 10, fontWeight: FontWeight.w500, color: dark)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }
}
