import 'package:flutter/material.dart';
import 'package:qrreader/constants.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../service/addManager.dart';

class ResultPage extends StatefulWidget {
  String barcodeScanRes;

  ResultPage({super.key, required this.barcodeScanRes});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
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
    if (widget.barcodeScanRes == "-1") {
      widget.barcodeScanRes = "Error";
    }
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Result',
              style: kFontPoppins,
            )),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  widget.barcodeScanRes,
                  style: kFontPoppins30,
                ),
              ),
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
        ));
  }
}
