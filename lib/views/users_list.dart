// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dabka/models/user_model.dart';
import 'package:dabka/utils/callbacks.dart';
import 'package:dabka/utils/shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';

import '../utils/helpers/error.dart';
import '../utils/helpers/wait.dart';
import 'add_user.dart';

class UsersList extends StatefulWidget {
  const UsersList({super.key});
  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  final TextEditingController _searchController = TextEditingController();

  List<UserModel> _users = <UserModel>[];

  final GlobalKey<State<StatefulWidget>> _searchKey = GlobalKey<State<StatefulWidget>>();

  @override
  void dispose() {
    _searchController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text("Users List".tr, style: GoogleFonts.abel(fontSize: 18, color: dark, fontWeight: FontWeight.w500)),
            const Spacer(),
            IconButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const AddUser())),
              icon: const Icon(FontAwesome.circle_plus_solid, color: purple, size: 25),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Card(
            elevation: 6,
            shadowColor: dark,
            child: SizedBox(
              height: 40,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(5)),
                      child: TextField(
                        onChanged: (String value) => _searchKey.currentState!.setState(() {}),
                        controller: _searchController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search".tr,
                          contentPadding: const EdgeInsets.all(16),
                          hintStyle: GoogleFonts.itim(color: grey, fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: purple, borderRadius: BorderRadius.circular(5)),
                    child: const Icon(FontAwesome.searchengin_brand, color: white, size: 15),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection("users").snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                return StatefulBuilder(
                  key: _searchKey,
                  builder: (BuildContext context, void Function(void Function()) _) {
                    _users = snapshot.data!.docs.map((e) => UserModel.fromJson(e.data())).where((UserModel element) => element.username.toLowerCase().contains(_searchController.text.trim().toLowerCase())).toList();
                    return ListView.separated(
                      itemBuilder: (BuildContext context, int index) => GestureDetector(
                        onLongPress: () {
                          showBottomSheet(
                            context: context,
                            builder: (BuildContext context) => Container(
                              color: white,
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text("Are you sure ?".tr, style: GoogleFonts.abel(fontSize: 14, color: dark, fontWeight: FontWeight.w500)),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: <Widget>[
                                      const Spacer(),
                                      TextButton(
                                        onPressed: () async {
                                          final QuerySnapshot<Map<String, dynamic>> products = await FirebaseFirestore.instance.collection("products").where("supplierID", isEqualTo: _users[index].userID).get();
                                          for (final QueryDocumentSnapshot<Map<String, dynamic>> prod in products.docs) {
                                            final QuerySnapshot<Map<String, dynamic>> reviews = await FirebaseFirestore.instance.collection("reviews").where("productID", isEqualTo: prod.get('productID')).get();
                                            for (final QueryDocumentSnapshot<Map<String, dynamic>> review in reviews.docs) {
                                              await review.reference.delete();
                                            }
                                          }

                                          for (final QueryDocumentSnapshot<Map<String, dynamic>> prod in products.docs) {
                                            await prod.reference.delete();
                                          }

                                          await FirebaseFirestore.instance.collection("users").doc(snapshot.data!.docs[index].id).delete();
                                          showToast(context, "User deleted successfully".tr);
                                          Navigator.pop(context);
                                        },
                                        style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll<Color>(purple)),
                                        child: Text("OK".tr, style: GoogleFonts.abel(fontSize: 12, color: white, fontWeight: FontWeight.w500)),
                                      ),
                                      const SizedBox(width: 10),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        style: ButtonStyle(backgroundColor: WidgetStatePropertyAll<Color>(grey.withOpacity(.3))),
                                        child: Text("CANCEL".tr, style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: Card(
                          shadowColor: dark,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          color: white,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: _users[index].userAvatar.isEmpty
                                        ? DecorationImage(
                                            image: AssetImage("assets/images/${_users[index].gender == 'M' ? 'n' : 'f'}obody.png"),
                                            fit: BoxFit.contain,
                                          )
                                        : DecorationImage(
                                            image: NetworkImage(_users[index].userAvatar),
                                            fit: BoxFit.cover,
                                          ),
                                    border: Border.all(width: 2, color: pink),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(color: purple, borderRadius: BorderRadius.circular(5)),
                                      child: Text("UID".tr, style: GoogleFonts.abel(fontSize: 14, color: white, fontWeight: FontWeight.w500)),
                                    ),
                                    const SizedBox(width: 10),
                                    Flexible(child: Text(_users[index].userID, style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500))),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(color: purple, borderRadius: BorderRadius.circular(5)),
                                      child: Text("USERNAME".tr, style: GoogleFonts.abel(fontSize: 14, color: white, fontWeight: FontWeight.w500)),
                                    ),
                                    const SizedBox(width: 10),
                                    Flexible(child: Text(_users[index].username, style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500))),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(color: purple, borderRadius: BorderRadius.circular(5)),
                                      child: Text("E-MAIL".tr, style: GoogleFonts.abel(fontSize: 14, color: white, fontWeight: FontWeight.w500)),
                                    ),
                                    const SizedBox(width: 10),
                                    Flexible(child: Text(_users[index].email.isEmpty ? "NOT SET" : _users[index].email, style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500))),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(color: purple, borderRadius: BorderRadius.circular(5)),
                                      child: Text("PHONE NUMBER".tr, style: GoogleFonts.abel(fontSize: 14, color: white, fontWeight: FontWeight.w500)),
                                    ),
                                    const SizedBox(width: 10),
                                    Flexible(child: Text(_users[index].phoneNumber, style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500))),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(color: purple, borderRadius: BorderRadius.circular(5)),
                                      child: Text("TYPE(S)".tr, style: GoogleFonts.abel(fontSize: 14, color: white, fontWeight: FontWeight.w500)),
                                    ),
                                    const SizedBox(width: 10),
                                    for (final String type in _users[index].userType) ...<Widget>[
                                      const SizedBox(width: 10),
                                      Text(type.toUpperCase().tr, style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500)),
                                    ]
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20),
                      itemCount: _users.length,
                    );
                  },
                );
              } else if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      LottieBuilder.asset("assets/lotties/empty.json", reverse: true),
                      Text("No Users Yet!".tr, style: GoogleFonts.abel(fontSize: 18, color: dark, fontWeight: FontWeight.w500)),
                    ],
                  ),
                );
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
