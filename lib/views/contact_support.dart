import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../utils/shared.dart';

class ContactSupport extends StatefulWidget {
  const ContactSupport({super.key});

  @override
  State<ContactSupport> createState() => _ContactSupportState();
}

class _ContactSupportState extends State<ContactSupport> {
  bool _check = false;

  Future<void> _sendFeedback() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: white,
        title: Text("Privacy Policy", style: GoogleFonts.abel(fontSize: 16, fontWeight: FontWeight.bold, color: dark)),
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(FontAwesome.chevron_left_solid, size: 15, color: purple)),
        elevation: 6,
        shadowColor: dark,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              """Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed mi risus, lobortis maximus neque eget, maximus eleifend nulla. Aliquam ornare, lorem eget ornare feugiat, justo neque mollis magna, non luctus sem turpis at eros. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Integer ac accumsan lacus, id suscipit orci. Nullam sit amet porttitor est, ultrices luctus turpis. Morbi cursus mi neque, vitae rutrum velit gravida vel. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Aliquam nec gravida leo.
Ut dapibus, metus ut vulputate ultricies, nunc erat ultricies odio, id efficitur tortor magna vel urna. Nullam nec leo quis dolor feugiat aliquet. Maecenas ac hendrerit turpis, a euismod arcu. Mauris rutrum enim in pretium fermentum. Cras justo metus, eleifend eget arcu et, aliquam consectetur leo. Aenean porta libero at tortor varius volutpat. Cras id est ac elit dictum dignissim et id massa. Nulla dignissim est quam, at ultrices magna pellentesque sit amet. Nunc lobortis tortor massa, at porttitor dolor luctus et. Ut tincidunt imperdiet nulla ac pellentesque. Pellentesque in porta nunc. Aenean consequat massa et velit porta finibus.
Duis nec felis nibh. Quisque et luctus eros, ac gravida nunc. Sed dictum nec nisi dapibus consequat. Vestibulum condimentum consectetur eleifend. Sed eget neque fermentum, aliquet mi eget, mollis lectus. In porttitor rhoncus enim, vel condimentum libero finibus nec. Cras at fermentum arcu.""",
              style: GoogleFonts.abel(fontSize: 10, fontWeight: FontWeight.w500, color: dark),
            ),
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Image.asset("assets/images/logo.png", width: 150, height: 150, color: dark.withOpacity(.05)),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        StatefulBuilder(
                          builder: (BuildContext context, void Function(void Function()) _) {
                            return Checkbox(
                              checkColor: white,
                              activeColor: purple,
                              value: _check,
                              onChanged: (bool? value) => _(() => _check = value!),
                            );
                          },
                        ),
                        const SizedBox(width: 5),
                        Text("Agree on the Privacy Policy.", style: GoogleFonts.abel(color: dark, fontSize: 14, fontWeight: FontWeight.w500)),
                      ],
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
                        child: Text("Continue", style: GoogleFonts.abel(color: white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
