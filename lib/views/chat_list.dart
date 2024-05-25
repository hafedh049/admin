// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dabka/models/chat_head_model.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/helpers/error.dart';
import '../utils/helpers/wait.dart';
import '../utils/shared.dart';
import 'chat_room.dart';

class ChatsList extends StatefulWidget {
  const ChatsList({super.key});
  @override
  State<ChatsList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatsList> {
  List<ChatHead> _chats = <ChatHead>[];

  String _formatCustomDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(1.days);
    final dayBeforeYesterday = today.subtract(2.days);

    if (date.year == today.year && date.month == today.month && date.day == today.day) {
      return 'Today, at ${formatDate(date, const <String>[hh, ':', nn, ':', ss, ' ', am])}';
    } else if (date.year == today.year && date.month == today.month && date.day == yesterday.day) {
      return 'Yesterday, at ${formatDate(date, const <String>[hh, ':', nn, ':', ss, ' ', am])}';
    } else if (date.year == today.year && date.month == today.month && date.day == dayBeforeYesterday.day) {
      return '2 days ago, at ${formatDate(date, const <String>[hh, ':', nn, ':', ss, ' ', am])}';
    } else {
      return formatDate(date, const <String>[dd, '/', mm, '/', yyyy, ' ', hh, ':', nn, ':', ss, ' ', am]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(height: 10),
        Text("Old Chats", style: GoogleFonts.abel(color: dark, fontSize: 22, fontWeight: FontWeight.w500)),
        const SizedBox(height: 20),
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection('chat_heads').orderBy('timestamp', descending: true).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                _chats = snapshot.data!.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> e) => ChatHead.fromJson(e.data())).toList();
                return ListView.separated(
                  itemBuilder: (BuildContext context, int index) => GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ChatRoom(chatHead: _chats[index]))),
                    child: Card(
                      shadowColor: dark,
                      elevation: 4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          children: <Widget>[
                            const SizedBox(height: 10),
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: white,
                                image: _chats[index].remoteImage.isEmpty
                                    ? const DecorationImage(
                                        image: AssetImage('assets/images/nobody.png'),
                                        fit: BoxFit.contain,
                                      )
                                    : DecorationImage(
                                        image: CachedNetworkImageProvider(_chats[index].remoteImage),
                                        fit: BoxFit.contain,
                                      ),
                                border: Border.all(width: 2, color: purple),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: purple),
                                  child: Text(_chats[index].remoteName, style: GoogleFonts.abel(color: white, fontSize: 14, fontWeight: FontWeight.bold)),
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      if (_chats[index].remoteID == FirebaseAuth.instance.currentUser!.uid) TextSpan(text: 'You: ', style: GoogleFonts.abel(color: dark, fontSize: 12, fontWeight: FontWeight.bold)),
                                      TextSpan(text: _chats[index].lastMessage, style: GoogleFonts.abel(color: dark.withOpacity(.6), fontSize: 14, fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: purple),
                                  child: Text(_formatCustomDate(_chats[index].timestamp), style: GoogleFonts.abel(color: white, fontSize: 12, fontWeight: FontWeight.w500)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20),
                  itemCount: _chats.length,
                );
              } else if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                return Center(child: Image.asset("assets/images/empty_chat.png", color: purple));
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Wait();
              } else {
                return ErrorScreen(error: snapshot.error.toString());
              }
            },
          ),
        ),
      ],
    );
  }
}
