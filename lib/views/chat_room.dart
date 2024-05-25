import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dabka/models/message_model.dart';
import 'package:dabka/utils/helpers/error.dart';
import 'package:dabka/utils/helpers/wait.dart';
import 'package:dabka/utils/shared.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:uuid/uuid.dart';

import '../models/chat_head_model.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key, required this.chatHead});
  final ChatHead chatHead;

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late final Stream<QuerySnapshot<Map<String, dynamic>>> _stream;

  List<MessageModel> _messages = <MessageModel>[];

  @override
  void initState() {
    _stream = FirebaseFirestore.instance.collection('messages').where('roomID', isEqualTo: widget.chatHead.roomID).orderBy('timestamp', descending: true).snapshots();
    super.initState();
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;
    final String message = _messageController.text.trim();
    _messageController.clear();
    final String messageID = const Uuid().v8();
    final Timestamp now = Timestamp.now();

    await Future.wait(
      <Future>[
        FirebaseFirestore.instance.collection('messages').doc(messageID).set(
              MessageModel(
                messageID: messageID,
                roomID: widget.chatHead.roomID,
                message: message,
                timestamp: now.toDate(),
                senderID: FirebaseAuth.instance.currentUser!.uid,
                receiverID: widget.chatHead.remoteID,
                type: "text",
              ).toJson(),
            ),
        FirebaseFirestore.instance.collection('chat_heads').doc(widget.chatHead.roomID).set(
              ChatHead(
                roomID: widget.chatHead.roomID,
                timestamp: now.toDate(),
                remoteName: widget.chatHead.remoteName,
                remoteID: widget.chatHead.remoteID,
                remoteImage: widget.chatHead.remoteImage,
                lastMessage: message,
                lastMessageType: "text",
              ).toJson(),
            ),
      ],
    );

    _scrollToBottom();
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: 300.milliseconds,
      curve: Curves.easeOut,
    );
  }

  String _formatCustomDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(1.days);
    final dayBeforeYesterday = today.subtract(2.days);

    if (date.year == today.year && date.month == today.month && date.day == today.day) {
      return '${"Today, at".tr} ${formatDate(date, const <String>[hh, ':', nn, ':', ss, ' ', am])}';
    } else if (date.year == today.year && date.month == today.month && date.day == yesterday.day) {
      return '${"Yesterday, at".tr} ${formatDate(date, const <String>[hh, ':', nn, ':', ss, ' ', am])}';
    } else if (date.year == today.year && date.month == today.month && date.day == dayBeforeYesterday.day) {
      return '${"2 days ago, at".tr} ${formatDate(date, const <String>[hh, ':', nn, ':', ss, ' ', am])}';
    } else {
      return formatDate(date, const <String>[dd, '/', mm, '/', yyyy, ' ', hh, ':', nn, ':', ss, ' ', am]);
    }
  }

  Widget _buildMessage(MessageModel message) {
    final messageText = message.message;
    final messageTime = message.timestamp;

    return Row(
      mainAxisAlignment: message.senderID == FirebaseAuth.instance.currentUser!.uid ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Column(
          crossAxisAlignment: message.senderID == FirebaseAuth.instance.currentUser!.uid ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
              decoration: BoxDecoration(
                color: message.senderID == FirebaseAuth.instance.currentUser!.uid ? purple : blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                messageText,
                style: GoogleFonts.abel(color: message.senderID == FirebaseAuth.instance.currentUser!.uid ? white : dark),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatCustomDate(messageTime),
              style: GoogleFonts.abel(color: grey, fontSize: 10),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.chatHead.remoteName, style: GoogleFonts.abel(color: dark, fontSize: 18, fontWeight: FontWeight.w500)),
          backgroundColor: white,
          elevation: 8,
          leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(FontAwesome.chevron_left_solid, size: 15, color: dark)),
          shadowColor: dark,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: _stream,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Wait();
              } else if (snapshot.hasError) {
                return ErrorScreen(error: snapshot.error.toString());
              }

              _messages = snapshot.data!.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> doc) => MessageModel.fromJson(doc.data())).toList();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: ListView.separated(
                      controller: _scrollController,
                      reverse: true,
                      itemCount: _messages.length,
                      separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10),
                      itemBuilder: (BuildContext context, int index) {
                        final MessageModel message = _messages[index];
                        final messageWidget = _buildMessage(message);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: messageWidget,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Card(
                      shadowColor: dark,
                      elevation: 6,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                controller: _messageController,
                                decoration: InputDecoration(
                                  hintText: 'Type a message'.tr,
                                  hintStyle: GoogleFonts.abel(color: grey),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                                ),
                                onSubmitted: (String _) => _sendMessage(),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(icon: const Icon(Icons.send, color: purple), onPressed: _sendMessage),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
