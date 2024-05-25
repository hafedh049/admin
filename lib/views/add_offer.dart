// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dabka/models/category_model.dart';
import 'package:dabka/models/offer_model.dart';
import 'package:dabka/utils/shared.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:uuid/uuid.dart';

import '../utils/callbacks.dart';
import '../utils/helpers/error.dart';
import '../utils/helpers/wait.dart';

class AddOffer extends StatefulWidget {
  const AddOffer({super.key});

  @override
  State<AddOffer> createState() => _AddOfferState();
}

class _AddOfferState extends State<AddOffer> {
  final TextEditingController _offerNameController = TextEditingController();
  final TextEditingController _offerTypeController = TextEditingController(text: "EXCLUSIVE");

  final GlobalKey<State<StatefulWidget>> _offerImageKey = GlobalKey<State<StatefulWidget>>();

  File? _banner;

  bool _ignoreStupidity = false;

  List<CategoryModel> _categories = <CategoryModel>[];

  CategoryModel? _selectedCategory;

  double _max = 100;

  @override
  void dispose() {
    _offerNameController.dispose();
    _offerTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Add Offer", style: GoogleFonts.poppins(color: dark, fontSize: 20)),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(FontAwesome.chevron_left_solid, size: 15, color: purple),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance.collection('categories').get(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              _categories = snapshot.data!.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> e) => CategoryModel.fromJson(e.data())).toList();
              _selectedCategory = _categories.first;
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    StatefulBuilder(
                      key: _offerImageKey,
                      builder: (BuildContext context, void Function(void Function()) _) {
                        return GestureDetector(
                          onTap: () async {
                            final XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
                            if (file != null) {
                              _(() => _banner = File(file.path));
                            }
                          },
                          child: AnimatedContainer(
                            width: MediaQuery.sizeOf(context).width,
                            height: 150,
                            duration: 300.ms,
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: grey.withOpacity(.3), width: 2),
                              image: _banner == null
                                  ? const DecorationImage(
                                      image: AssetImage("assets/images/thumbnail1.png"),
                                      fit: BoxFit.cover,
                                    )
                                  : DecorationImage(
                                      image: FileImage(_banner!),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    Card(
                      shadowColor: dark,
                      color: white,
                      elevation: 6,
                      borderOnForeground: true,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Card(
                              elevation: 6,
                              shadowColor: dark,
                              child: CustomDropdown<CategoryModel>.search(
                                hintText: 'Pick a category',
                                items: _categories,
                                excludeSelected: false,
                                initialItem: _categories.first,
                                onChanged: (CategoryModel value) => _selectedCategory = value,
                              ),
                            ),
                            Text("Offer Name", style: GoogleFonts.abel(fontSize: 16, color: dark, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 40,
                              child: TextField(
                                controller: _offerNameController,
                                style: GoogleFonts.abel(color: dark, fontSize: 14, fontWeight: FontWeight.w500),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(6),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                                  disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                                  focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                                  hintText: "Offer",
                                  hintStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                                  labelText: "Enter the offer name",
                                  labelStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                                  prefixIcon: const IconButton(onPressed: null, icon: Icon(FontAwesome.user, color: grey, size: 15)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text("Offer Type", style: GoogleFonts.abel(fontSize: 16, color: dark, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 40,
                              child: TextField(
                                controller: _offerTypeController,
                                readOnly: true,
                                style: GoogleFonts.abel(color: dark, fontSize: 14, fontWeight: FontWeight.w500),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(6),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                                  disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                                  focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                                  hintText: "Offer Type",
                                  hintStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                                  labelText: "Pick the offer type",
                                  labelStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                                  prefixIcon: const IconButton(onPressed: null, icon: Icon(FontAwesome.user, color: grey, size: 15)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 40,
                      child: StatefulBuilder(
                        builder: (BuildContext context, void Function(void Function()) _) {
                          return Row(
                            children: <Widget>[
                              Text("0 %", style: GoogleFonts.abel(fontSize: 14, color: dark, fontWeight: FontWeight.bold)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Slider(
                                  value: _max,
                                  max: 100,
                                  onChanged: (double value) => _(() => _max = value),
                                  activeColor: purple,
                                  divisions: 10,
                                  label: '${_max.toStringAsFixed(0)}%',
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text("100 %", style: GoogleFonts.abel(fontSize: 14, color: dark, fontWeight: FontWeight.bold)),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: StatefulBuilder(
                        builder: (BuildContext context, void Function(void Function()) _) {
                          return IgnorePointer(
                            ignoring: _ignoreStupidity,
                            child: InkWell(
                              hoverColor: transparent,
                              splashColor: transparent,
                              highlightColor: transparent,
                              onTap: () async {
                                if (_offerNameController.text.trim().isEmpty) {
                                  showToast(context, "Offer name is required", color: red);
                                } else if (_max == 0) {
                                  showToast(context, "Why are you doing a discount then ?", color: red);
                                } else if (_max == 100) {
                                  showToast(context, "Are you serious ?", color: red);
                                } else {
                                  try {
                                    _(() => _ignoreStupidity = true);
                                    showToast(context, "Please wait...");
                                    String path = "";

                                    final String offerID = const Uuid().v8();

                                    if (_banner != null) {
                                      final TaskSnapshot task = await FirebaseStorage.instance.ref().child("/offers/$offerID.png").putFile(_banner!);
                                      path = await task.ref.getDownloadURL();
                                    }

                                    await FirebaseFirestore.instance.collection("offers").doc(offerID).set(
                                          OfferModel(
                                            offerID: offerID,
                                            categoryID: _selectedCategory!.categoryID,
                                            category: _selectedCategory!.categoryName,
                                            username: "ADMIN",
                                            userID: FirebaseAuth.instance.currentUser!.uid,
                                            offerName: _offerNameController.text.trim(),
                                            offerType: _offerTypeController.text.trim(),
                                            offerImage: path,
                                            offerDiscount: _max,
                                            timestamp: Timestamp.now().toDate(),
                                          ).toJson(),
                                        );

                                    _offerNameController.clear();
                                    _offerImageKey.currentState!.setState(() => _banner = null);

                                    showToast(context, "Offer Created Successfully");
                                    _(() => _ignoreStupidity = false);
                                  } catch (e) {
                                    showToast(context, e.toString(), color: red);
                                    _(() => _ignoreStupidity = false);
                                  }
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 48),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: purple),
                                child: Text("Add Offer", style: GoogleFonts.abel(color: white, fontSize: 14, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    LottieBuilder.asset("assets/lotties/empty.json", reverse: true),
                    Text("Sorry you can't add an offer without the existance of a category", style: GoogleFonts.abel(fontSize: 18, color: dark, fontWeight: FontWeight.w500)),
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
    );
  }
}
