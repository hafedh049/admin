import 'package:dabka/utils/callbacks.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../utils/shared.dart';

class AppFeedback extends StatefulWidget {
  const AppFeedback({super.key});

  @override
  State<AppFeedback> createState() => _AppFeedbackState();
}

class _AppFeedbackState extends State<AppFeedback> {
  final TextEditingController _feedbackController = TextEditingController();

  int _rating = 0;

  Future<void> _sendFeedback() async {
    if (_feedbackController.text.trim().isEmpty) {
      showToast(context, "Review or comment is empty");
    }
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: white,
        title: Text("App Feedback", style: GoogleFonts.abel(fontSize: 16, fontWeight: FontWeight.bold, color: dark)),
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(FontAwesome.chevron_left_solid, size: 15, color: purple)),
        elevation: 6,
        shadowColor: dark,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Card(
                elevation: 4,
                shadowColor: dark,
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: <Widget>[
                      Text("How would you rate Dabka", style: GoogleFonts.abel(fontSize: 12, fontWeight: FontWeight.w500, color: dark)),
                      const SizedBox(height: 10),
                      StatefulBuilder(
                        builder: (BuildContext context, void Function(void Function()) _) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              for (int index = 1; index <= 5; index += 1)
                                IconButton(
                                  onPressed: () => _(() => _rating = index),
                                  icon: Icon(FontAwesome.star, size: 25, color: index <= _rating ? purple : grey),
                                ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text("Send us your feedback", style: GoogleFonts.abel(fontSize: 12, fontWeight: FontWeight.w500, color: dark)),
            const SizedBox(height: 5),
            Text(
              "We always care about our customers opinions. So leave us a comment about your experience with the app, or share with us any issues you might have.",
              style: GoogleFonts.abel(fontSize: 10, fontWeight: FontWeight.w500, color: dark),
            ),
            const SizedBox(height: 20),
            StatefulBuilder(
              builder: (BuildContext context, void Function(void Function()) _) {
                return TextField(
                  maxLines: 7,
                  controller: _feedbackController,
                  style: GoogleFonts.abel(color: dark, fontSize: 14, fontWeight: FontWeight.w500),
                  onChanged: (String value) => _(() {}),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(6),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                    disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                    hintText: "Type your feedback here.",
                    alignLabelWithHint: true,
                    helperMaxLines: 7,
                    hintStyle: GoogleFonts.abel(color: grey, fontSize: 12, fontWeight: FontWeight.w500),
                    labelText: "Feedback",
                    labelStyle: GoogleFonts.abel(color: grey, fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            InkWell(
              hoverColor: transparent,
              splashColor: transparent,
              highlightColor: transparent,
              onTap: _sendFeedback,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 48),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: purple),
                child: Text("Send Feedback", style: GoogleFonts.abel(color: white, fontSize: 14, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
