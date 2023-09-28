import 'package:flutter/material.dart';
import 'package:qrreader/service/addManager.dart';
import 'package:qrreader/service/counterProvider.dart';
import 'package:qrreader/view/homePage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = openDatabase(
    join(await getDatabasesPath(), 'history_database.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE history(text TEXT, dateTime TEXT, hour TEXT)',
      );
    },
    version: 1,
  );
  final db = await database;
  MobileAds.instance.initialize();
  await AdManager().createAppOpenAd();
  runApp(MyApp(
    database: db,
  ));
}

class MyApp extends StatelessWidget {
  Database database;
  MyApp({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CounterProvider()),
      ],
      child: MaterialApp(
        title: 'Qr & Barcode Reader Pro',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: HomePage(
          database: database,
        ),
      ),
    );
  }
}
