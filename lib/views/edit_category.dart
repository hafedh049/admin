// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dabka/models/category_model.dart';
import 'package:dabka/utils/shared.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/callbacks.dart';

class EditCategory extends StatefulWidget {
  const EditCategory({super.key, required this.category});
  final CategoryModel category;
  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  final TextEditingController _categoryNameController = TextEditingController();

  final GlobalKey<State<StatefulWidget>> _categoryImageKey = GlobalKey<State<StatefulWidget>>();

  File? _image;

  bool _ignoreStupidity = false;

  @override
  void dispose() {
    _categoryNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          centerTitle: true,
          title: Text("Edit Category".tr, style: GoogleFonts.poppins(color: dark, fontSize: 20)),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(FontAwesome.chevron_left_solid, size: 15, color: purple),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                StatefulBuilder(
                  key: _categoryImageKey,
                  builder: (BuildContext context, void Function(void Function()) _) {
                    return GestureDetector(
                      onTap: () async {
                        final XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
                        if (file != null) {
                          final CroppedFile? finalFile = await ImageCropper().cropImage(sourcePath: file.path);
                          if (finalFile != null) {
                            _(() => _image = File(finalFile.path));
                          } else {
                            _(() => _image = File(file.path));
                          }
                        }
                      },
                      onLongPress: () async => _(() => _image = null),
                      child: AnimatedContainer(
                        width: 100,
                        height: 100,
                        duration: 300.milliseconds,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: white,
                          border: Border.all(color: pink, width: 2),
                          image: widget.category.categoryUrl.isNotEmpty && _image == null
                              ? DecorationImage(
                                  image: CachedNetworkImageProvider(widget.category.categoryUrl),
                                  fit: BoxFit.cover,
                                )
                              : DecorationImage(
                                  image: FileImage(_image!),
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
                        Text("Category Name".tr, style: GoogleFonts.abel(fontSize: 16, color: dark, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 40,
                          child: TextField(
                            controller: _categoryNameController..text = widget.category.categoryName,
                            style: GoogleFonts.abel(color: dark, fontSize: 14, fontWeight: FontWeight.w500),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(6),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                              disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                              focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                              hintText: "Category".tr,
                              hintStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                              labelText: "Enter Category name".tr,
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
                            if (_categoryNameController.text.trim().isEmpty) {
                              showToast(context, "Category name is required".tr, color: red);
                            } else {
                              try {
                                _(() => _ignoreStupidity = true);
                                showToast(context, "Please wait...".tr);

                                String path = widget.category.categoryUrl;

                                if (_image != null) {
                                  final TaskSnapshot task = await FirebaseStorage.instance.ref().child("/categories/${widget.category.categoryID}.png").putFile(_image!);
                                  path = await task.ref.getDownloadURL();
                                }

                                await FirebaseFirestore.instance.collection("categories").doc(widget.category.categoryID).update(
                                      CategoryModel(
                                        categoryID: widget.category.categoryID,
                                        categoryName: _categoryNameController.text,
                                        categoryUrl: path,
                                      ).toJson(),
                                    );

                                showToast(context, "Category Created Successfully".tr);
                                _(() => _ignoreStupidity = false);
                                Navigator.pop(context);
                              } catch (e) {
                                showToast(context, e.toString(), color: red);
                                _(() => _ignoreStupidity = false);
                              }
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 48),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: purple),
                            child: Text("Edit Category".tr, style: GoogleFonts.abel(color: white, fontSize: 14, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
