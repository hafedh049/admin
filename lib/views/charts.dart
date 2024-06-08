import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dabka/models/product_model.dart';
import 'package:dabka/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pie_chart/pie_chart.dart';

import '../models/category_model.dart';
import '../utils/helpers/error.dart';
import '../utils/helpers/wait.dart';
import '../utils/shared.dart';

class Charts extends StatefulWidget {
  const Charts({super.key});

  @override
  State<Charts> createState() => _ChartsState();
}

class _ChartsState extends State<Charts> with TickerProviderStateMixin {
  final Map<String, double> _categoriesMap = <String, double>{};

  List<UserModel> _users = <UserModel>[];
  final Map<CategoryModel, List<ProductModel>> _categories = <CategoryModel, List<ProductModel>>{};

  late final TabController _tabsController;

  @override
  void initState() {
    _tabsController = TabController(length: 2, vsync: this);
    super.initState();
  }

  Stream<List<CategoryModel>> _fetchCategories() {
    final Stream<QuerySnapshot<Map<String, dynamic>>> query = FirebaseFirestore.instance.collection("categories").snapshots();
    return query.map(
      (QuerySnapshot<Map<String, dynamic>> event) {
        return event.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> e) => CategoryModel.fromJson(e.data())).toList();
      },
    );
  }

  Stream<List<ProductModel>> _fetchProducts() {
    final Stream<QuerySnapshot<Map<String, dynamic>>> query = FirebaseFirestore.instance.collection("products").snapshots();
    return query.map(
      (QuerySnapshot<Map<String, dynamic>> event) {
        return event.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> e) => ProductModel.fromJson(e.data())).toList();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, double> dataMap = <String, double>{
      "Clients".tr: 0,
      "Suppliers".tr: 0,
    };
    return Scaffold(
      body: Column(
        children: <Widget>[
          TabBar(
            indicatorColor: purple,
            controller: _tabsController,
            tabs: <Widget>[
              Container(
                padding: const EdgeInsets.all(8),
                child: Text("Users Chart".tr, style: GoogleFonts.abel(color: dark, fontSize: 18, fontWeight: FontWeight.w500)),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Text("Categories Chart".tr, style: GoogleFonts.abel(color: dark, fontSize: 18, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TabBarView(
                controller: _tabsController,
                children: <Widget>[
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance.collection("users").snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                      if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                        _users = snapshot.data!.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> e) => UserModel.fromJson(e.data())).toList();
                        dataMap["Clients".tr] = _users.where((UserModel element) => element.userType.contains("CLIENT")).length.toDouble();
                        dataMap["Suppliers".tr] = _users.where((UserModel element) => element.userType.contains("SUPPLIER")).length.toDouble();

                        if (dataMap.values.every((double element) => element == 0)) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Expanded(child: LottieBuilder.asset("assets/lotties/empty.json", reverse: true)),
                                Text("No Users Yet!".tr, style: GoogleFonts.abel(fontSize: 18, color: dark, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          );
                        }

                        return PieChart(
                          dataMap: dataMap,
                          animationDuration: 800.milliseconds,
                          chartLegendSpacing: 32,
                          chartRadius: MediaQuery.of(context).size.width / 3.2,
                          colorList: const <Color>[purple, dark],
                          initialAngleInDegree: 0,
                          chartType: ChartType.ring,
                          ringStrokeWidth: 32,
                          centerText: "USERS".tr,
                          legendOptions: LegendOptions(
                            showLegendsInRow: false,
                            legendPosition: LegendPosition.right,
                            showLegends: true,
                            legendShape: BoxShape.circle,
                            legendTextStyle: GoogleFonts.abel(fontWeight: FontWeight.bold),
                          ),
                          chartValuesOptions: const ChartValuesOptions(
                            showChartValueBackground: true,
                            showChartValues: true,
                            showChartValuesInPercentage: true,
                            showChartValuesOutside: false,
                            decimalPlaces: 1,
                          ),
                        );
                      } else if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Expanded(child: LottieBuilder.asset("assets/lotties/empty.json", reverse: true)),
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
                  StreamBuilder<List>(
                    stream: StreamZip(<Stream>[_fetchCategories(), _fetchProducts()]),
                    builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                      if (snapshot.hasData && snapshot.data!.first.isNotEmpty) {
                        for (final CategoryModel category in snapshot.data!.first) {
                          _categories[category] = snapshot.data!.last.where((ProductModel element) => element.categoryID == category.categoryID).toList();
                          _categoriesMap[category.categoryName.tr] = _categories[category]!.length.toDouble();
                        }

                        if (_categoriesMap.values.every((double element) => element == 0)) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Expanded(child: LottieBuilder.asset("assets/lotties/empty.json", reverse: true)),
                                Text("No Categories Yet!".tr, style: GoogleFonts.abel(fontSize: 18, color: dark, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          );
                        }

                        return PieChart(
                          dataMap: _categoriesMap,
                          animationDuration: 800.milliseconds,
                          chartLegendSpacing: 32,
                          chartRadius: MediaQuery.of(context).size.width / 3.2,
                          colorList: Colors.primaries,
                          initialAngleInDegree: 0,
                          chartType: ChartType.ring,
                          ringStrokeWidth: 32,
                          centerText: "CATEGORIES".tr,
                          legendOptions: LegendOptions(
                            showLegendsInRow: false,
                            legendPosition: LegendPosition.right,
                            showLegends: true,
                            legendShape: BoxShape.circle,
                            legendTextStyle: GoogleFonts.abel(fontWeight: FontWeight.bold),
                          ),
                          chartValuesOptions: const ChartValuesOptions(
                            showChartValueBackground: true,
                            showChartValues: true,
                            showChartValuesInPercentage: true,
                            showChartValuesOutside: false,
                            decimalPlaces: 1,
                          ),
                        );
                      } else if (snapshot.hasData && snapshot.data!.first.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Expanded(child: LottieBuilder.asset("assets/lotties/empty.json", reverse: true)),
                              Text("No Products Yet!".tr, style: GoogleFonts.abel(fontSize: 18, color: dark, fontWeight: FontWeight.w500)),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
