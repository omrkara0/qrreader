import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qrreader/constants.dart';
import 'package:qrreader/model/historyModel.dart';
import 'package:qrreader/service/counterProvider.dart';
import 'package:qrreader/service/sqfliteManager.dart';
import 'package:qrreader/view/historyPage.dart';
import 'package:qrreader/view/resultPage.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:in_app_review/in_app_review.dart';

import '../service/addManager.dart';

class HomePage extends StatefulWidget {
  Database database;
  HomePage({Key? key, required this.database}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String barcodeScanRes = "";
  final InAppReview inAppReview = InAppReview.instance;

  Future<void> _scan(context, ScanMode scanMode) async {
    barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff4422', 'Cancel', true, scanMode);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ResultPage(barcodeScanRes: barcodeScanRes),
      ),
    );
  }

  BannerAd? bannerAd;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    bannerAd = AdManager().loadBanner(bannerAd);
  }

  @override
  void dispose() {
    bannerAd?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int counter = Provider.of<CounterProvider>(context).counter;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'QR and Barcode Reader Pro',
            style: kFontPoppins,
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  if (await inAppReview.isAvailable()) {
                    inAppReview.requestReview();
                  }
                },
                icon: Icon(
                  Icons.star_rounded,
                  size: 35,
                  color: Colors.yellow,
                )),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(
                flex: 2,
              ),
              Expanded(
                  child: Icon(
                Icons.qr_code_scanner_rounded,
                color: Colors.black,
                size: 250,
              )),
              Spacer(
                flex: 3,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        Provider.of<CounterProvider>(context, listen: false)
                            .increment();
                        await _scan(context, ScanMode.QR);

                        counter % 2 == 0
                            ? AdManager().loadInterstitialAd()
                            : null;
                        insertHistory(
                            HistoryModel(
                                text: barcodeScanRes,
                                dateTime: dateTime,
                                hour: hour),
                            widget.database);
                      },
                      child: Text(
                        'Scan QR Code',
                        style: kFontPoppins,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Provider.of<CounterProvider>(context, listen: false)
                            .increment();
                        await _scan(context, ScanMode.BARCODE);

                        counter % 2 == 0
                            ? AdManager().loadInterstitialAd()
                            : null;
                        insertHistory(
                            HistoryModel(
                                text: barcodeScanRes,
                                dateTime: dateTime,
                                hour: hour),
                            widget.database);
                      },
                      child: Text(
                        'Scan Barcode',
                        style: kFontPoppins,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => HistoryPage(
                              database: widget.database,
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.history, size: 40)),
                  IconButton(
                      onPressed: () {}, icon: Icon(Icons.settings, size: 40)),
                ],
              ),
              Spacer(
                flex: 2,
              ),
              bannerAd != null
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: SafeArea(
                        child: SizedBox(
                          width: bannerAd!.size.width.toDouble(),
                          height: bannerAd!.size.height.toDouble(),
                          child: AdWidget(ad: bannerAd!),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
            ],
          ),
        ));
  }
}
