import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../utils/shared.dart';

class FAQ extends StatefulWidget {
  const FAQ({super.key});

  @override
  State<FAQ> createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
  final List<Map<String, dynamic>> _list = <Map<String, dynamic>>[
    <String, dynamic>{
      "question": "This is a dummy question ?",
      "answer": "This is a dummy answer.",
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
        padding: const EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            for (final Map<String, dynamic> item in _list)
              InkWell(
                hoverColor: transparent,
                splashColor: transparent,
                highlightColor: transparent,
                onTap: () => showModalBottomSheet(
                  context: context,
                  showDragHandle: true,
                  builder: (BuildContext context) => Container(
                    alignment: Alignment.center,
                    width: MediaQuery.sizeOf(context).width * .8,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: Text(item["answer"], style: GoogleFonts.abel(fontSize: 10, fontWeight: FontWeight.w500, color: dark), textAlign: TextAlign.center),
                  ),
                ),
                child: Card(
                  elevation: 4,
                  shadowColor: dark,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: Text(item["question"], style: GoogleFonts.abel(fontSize: 10, fontWeight: FontWeight.w500, color: dark)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
