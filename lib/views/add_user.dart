// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dabka/models/user_model.dart';
import 'package:dabka/utils/callbacks.dart';
import 'package:dabka/utils/shared.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_field/intl_phone_number_field.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _obscureText = true;

  bool _ignoreStupidity = false;

  File? _image;

  String _gender = 'M';

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
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
          backgroundColor: white,
          title: Text("Add User", style: GoogleFonts.poppins(color: dark, fontSize: 20)),
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
                  builder: (BuildContext context, void Function(void Function()) _) {
                    return GestureDetector(
                      onTap: () async {
                        showModalBottomSheet(
                          backgroundColor: white,
                          context: context,
                          builder: (BuildContext context) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              InkWell(
                                hoverColor: transparent,
                                splashColor: transparent,
                                highlightColor: transparent,
                                onTap: () async {
                                  final XFile? file = await ImagePicker().pickImage(source: ImageSource.camera);
                                  if (file != null) {
                                    final CroppedFile? finalFile = await ImageCropper().cropImage(sourcePath: file.path);
                                    if (finalFile != null) {
                                      _(() => _image = File(finalFile.path));
                                    }
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(color: purple.withOpacity(.1), borderRadius: BorderRadius.circular(5)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      const Icon(FontAwesome.camera_solid, color: purple, size: 20),
                                      const SizedBox(width: 5),
                                      Text("Camera", style: GoogleFonts.abel(fontSize: 16, color: purple, fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                hoverColor: transparent,
                                splashColor: transparent,
                                highlightColor: transparent,
                                onTap: () async {
                                  final XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
                                  if (file != null) {
                                    final CroppedFile? finalFile = await ImageCropper().cropImage(sourcePath: file.path);
                                    if (finalFile != null) {
                                      _(() => _image = File(finalFile.path));
                                    }
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(color: purple.withOpacity(.1), borderRadius: BorderRadius.circular(5)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      const Icon(FontAwesome.camera_solid, color: purple, size: 20),
                                      const SizedBox(width: 5),
                                      Text("Gallery", style: GoogleFonts.abel(fontSize: 16, color: purple, fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      child: AnimatedContainer(
                        width: 80,
                        height: 80,
                        duration: 300.ms,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: white,
                          border: Border.all(color: grey.withOpacity(.3), width: 2),
                          image: _image == null ? const DecorationImage(image: AssetImage("assets/images/nobody.png"), fit: BoxFit.cover) : DecorationImage(image: FileImage(_image!), fit: BoxFit.cover),
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
                        Text("Username", style: GoogleFonts.abel(fontSize: 16, color: dark, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 40,
                          child: TextField(
                            controller: _usernameController,
                            style: GoogleFonts.abel(color: dark, fontSize: 14, fontWeight: FontWeight.w500),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(6),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                              disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                              focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                              hintText: "Username",
                              hintStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                              labelText: "Enter username",
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
                        Text("E-mail", style: GoogleFonts.abel(fontSize: 16, color: dark, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 40,
                          child: TextField(
                            controller: _emailController,
                            style: GoogleFonts.abel(color: dark, fontSize: 14, fontWeight: FontWeight.w500),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(6),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                              disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                              focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                              hintText: "E-mail",
                              hintStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                              labelText: "Enter your e-mail",
                              labelStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                              prefixIcon: const IconButton(onPressed: null, icon: Icon(FontAwesome.lock_solid, color: grey, size: 15)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
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
                        Text("Password", style: GoogleFonts.abel(fontSize: 16, color: dark, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 40,
                          child: StatefulBuilder(
                            builder: (BuildContext context, void Function(void Function()) _) {
                              return TextField(
                                controller: _passwordController,
                                obscureText: _obscureText,
                                style: GoogleFonts.abel(color: dark, fontSize: 14, fontWeight: FontWeight.w500),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(6),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                                  disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                                  focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                                  hintText: "**********",
                                  hintStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                                  labelText: "كلمة المرور",
                                  labelStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                                  prefixIcon: const IconButton(onPressed: null, icon: Icon(FontAwesome.lock_solid, color: grey, size: 15)),
                                  suffixIcon: IconButton(
                                    onPressed: () => _(() => _obscureText = !_obscureText),
                                    icon: Icon(_obscureText ? FontAwesome.eye_slash : FontAwesome.eye, color: grey, size: 15),
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
                const SizedBox(height: 20),
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
                        Text("Phone Number", style: GoogleFonts.abel(fontSize: 16, color: dark, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 10),
                        InternationalPhoneNumberInput(
                          height: 40,
                          controller: _phoneController,
                          formatter: MaskedInputFormatter('## ### ###'),
                          initCountry: CountryCodeModel(name: "Tunisia", dial_code: "+216", code: "TN"),
                          betweenPadding: 10,
                          onInputChanged: (IntPhoneNumber phone) {},
                          dialogConfig: DialogConfig(
                            backgroundColor: white,
                            searchBoxBackgroundColor: grey.withOpacity(.1),
                            searchBoxIconColor: grey,
                            countryItemHeight: 50,
                            topBarColor: grey,
                            selectedItemColor: grey,
                            selectedIcon: const Padding(padding: EdgeInsets.only(left: 10), child: Icon(FontAwesome.check_solid, size: 15, color: blue)),
                            textStyle: GoogleFonts.abel(color: dark, fontSize: 14, fontWeight: FontWeight.w500),
                            searchBoxTextStyle: GoogleFonts.abel(color: dark, fontSize: 14, fontWeight: FontWeight.w500),
                            titleStyle: GoogleFonts.abel(color: dark, fontSize: 16, fontWeight: FontWeight.bold),
                            searchBoxHintStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                            flatFlag: true,
                            itemFlagSize: 20,
                            title: "حدد الدولة",
                            searchBoxRadius: 5,
                            searchHintText: "بحث",
                          ),
                          countryConfig: CountryConfig(
                            decoration: BoxDecoration(border: Border.all(width: .3, color: grey), borderRadius: BorderRadius.circular(8)),
                            flatFlag: true,
                            flagSize: 20,
                            textStyle: GoogleFonts.abel(color: dark, fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          phoneConfig: PhoneConfig(
                            focusedColor: grey,
                            enabledColor: grey,
                            errorColor: grey,
                            labelStyle: GoogleFonts.abel(color: dark, fontSize: 14, fontWeight: FontWeight.w500),
                            labelText: "رقم الهاتف",
                            floatingLabelStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                            radius: 8,
                            hintText: "رقم الهاتف",
                            borderWidth: .3,
                            backgroundColor: transparent,
                            decoration: null,
                            popUpErrorText: false,
                            showCursor: true,
                            autovalidateMode: AutovalidateMode.disabled,
                            textStyle: GoogleFonts.abel(color: dark, fontSize: 14, fontWeight: FontWeight.w500),
                            hintStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                StatefulBuilder(
                  builder: (BuildContext context, void Function(void Function()) _) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          splashColor: transparent,
                          hoverColor: transparent,
                          highlightColor: transparent,
                          onTap: () => _gender == "M" ? null : _(() => _gender = "M"),
                          child: AnimatedContainer(
                            duration: 300.ms,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: white,
                              border: Border.all(color: _gender == "M" ? pink : grey, width: _gender == "M" ? .8 : .3),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Text("Male", style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text("OR", style: GoogleFonts.abel(fontSize: 12, color: grey, fontWeight: FontWeight.w500)),
                        const SizedBox(width: 10),
                        InkWell(
                          splashColor: transparent,
                          hoverColor: transparent,
                          highlightColor: transparent,
                          onTap: () => _gender == "F" ? null : _(() => _gender = "F"),
                          child: AnimatedContainer(
                            duration: 300.ms,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: white,
                              border: Border.all(color: _gender == "F" ? pink : grey, width: _gender == "F" ? .8 : .3),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Text("Female", style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500)),
                          ),
                        ),
                      ],
                    );
                  },
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
                            if (_usernameController.text.trim().isEmpty) {
                              showToast(context, "Username is required", color: red);
                            } else if (!_emailController.text.contains(RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w-]{2,4}$'))) {
                              showToast(context, "Enter a correct e-mail address", color: red);
                            } else if (!_passwordController.text.contains(RegExp(r'^\w{6,}$'))) {
                              showToast(context, "Enter a correct password", color: red);
                            } else if (_phoneController.text.trim().replaceAll(" ", "").isEmpty || _phoneController.text.trim().replaceAll(" ", "").length < 8) {
                              showToast(context, "Enter a valid phone number please", color: red);
                            } else {
                              try {
                                _(() => _ignoreStupidity = true);
                                showToast(context, "Please wait...");
                                final UserCredential creds = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);

                                String path = "";

                                if (_image != null) {
                                  final TaskSnapshot task = await FirebaseStorage.instance.ref().child("/images/${creds.user!.uid}.png").putFile(_image!);
                                  path = await task.ref.getDownloadURL();
                                }

                                await FirebaseFirestore.instance.collection("users").doc(creds.user!.uid).set(
                                      UserModel(
                                        userID: creds.user!.uid,
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                        phoneNumber: _phoneController.text,
                                        username: _usernameController.text,
                                        categoryName: '',
                                        categoryID: '',
                                        userAvatar: _image == null ? '' : path,
                                        userType: const <String>["CLIENT"],
                                        userDescription: '',
                                        followers: 0,
                                        gender: _gender,
                                      ).toJson(),
                                    );

                                _usernameController.clear();
                                _emailController.clear();
                                _passwordController.clear();
                                _phoneController.clear();

                                showToast(context, "User Created Successfully");
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
                            child: Text("Create User", style: GoogleFonts.abel(color: white, fontSize: 14, fontWeight: FontWeight.bold)),
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
