import 'package:dabka/views/category_list.dart';
import 'package:dabka/views/charts.dart';
import 'package:dabka/views/chat_list.dart';
import 'package:dabka/views/orders_list.dart';
import 'package:dabka/views/sign_in.dart';
import 'package:dabka/views/offers_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

import '../utils/shared.dart';
import 'drawer.dart';
import 'users_list.dart';

class Holder extends StatefulWidget {
  const Holder({super.key});

  @override
  State<Holder> createState() => _HolderState();
}

class _HolderState extends State<Holder> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey<ScaffoldState>();
  final GlobalKey<State<StatefulWidget>> _menuKey = GlobalKey<State<StatefulWidget>>();

  final PageController _pageController = PageController();

  final List<Map<String, dynamic>> _pages = <Map<String, dynamic>>[
    <String, dynamic>{
      "title": "Users".tr,
      "icon": FontAwesome.users_between_lines_solid,
      "page": const UsersList(),
    },
    <String, dynamic>{
      "title": "Categories".tr,
      "icon": FontAwesome.square_solid,
      "page": const CategoriesList(),
    },
    <String, dynamic>{
      "title": "Orders".tr,
      "icon": FontAwesome.first_order_brand,
      "page": const OrdersList(),
    },
    <String, dynamic>{
      "title": "Chats".tr,
      "icon": Bootstrap.chat_square_text_fill,
      "page": const ChatsList(),
    },
    <String, dynamic>{
      "title": "Charts".tr,
      "icon": FontAwesome.chart_pie_solid,
      "page": const Charts(),
    },
    <String, dynamic>{
      "title": "Offers".tr,
      "icon": FontAwesome.star_solid,
      "page": const OffersList(),
    },
  ];

  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser == null
        ? const SignIn()
        : GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              key: _drawerKey,
              drawer: const DDrawer(),
              appBar: AppBar(
                centerTitle: true,
                backgroundColor: white,
                title: Text(appTitle, style: GoogleFonts.abel(fontSize: 22, fontWeight: FontWeight.bold, color: purple)),
                leading: IconButton(onPressed: () => _drawerKey.currentState!.openDrawer(), icon: const Icon(FontAwesome.bars_solid, size: 20, color: purple)),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: PageView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  onPageChanged: (int page) => _menuKey.currentState!.setState(() => _currentPage = page),
                  itemBuilder: (BuildContext context, int index) => _pages[index]["page"],
                  itemCount: _pages.length,
                ),
              ),
              bottomNavigationBar: StatefulBuilder(
                key: _menuKey,
                builder: (BuildContext context, void Function(void Function()) _) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Card(
                      elevation: 6,
                      shadowColor: dark,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: _pages
                              .map(
                                (Map<String, dynamic> e) => InkWell(
                                  hoverColor: transparent,
                                  splashColor: transparent,
                                  highlightColor: transparent,
                                  onTap: () => _pageController.jumpToPage(_pages.indexOf(e)),
                                  child: AnimatedContainer(
                                    duration: 300.milliseconds,
                                    padding: EdgeInsets.symmetric(horizontal: _currentPage == _pages.indexOf(e) ? 10 : 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Icon(e["icon"], size: 20, color: _currentPage == _pages.indexOf(e) ? purple : dark.withOpacity(.6)),
                                        const SizedBox(height: 5),
                                        AnimatedDefaultTextStyle(
                                          duration: 300.milliseconds,
                                          style: GoogleFonts.abel(
                                            fontSize: 12,
                                            color: _currentPage == _pages.indexOf(e) ? purple : dark.withOpacity(.6),
                                            fontWeight: _currentPage == e["title"] ? FontWeight.bold : FontWeight.w500,
                                          ),
                                          child: Text(e["title"]),
                                        ),
                                        if (_currentPage == _pages.indexOf(e)) ...<Widget>[
                                          const SizedBox(height: 5),
                                          Container(color: purple, height: 2, width: 10),
                                        ],
                                        const SizedBox(height: 5),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
  }
}
