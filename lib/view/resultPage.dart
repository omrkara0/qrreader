import 'package:flutter/material.dart';
import 'package:qrreader/constants.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../service/addManager.dart';

class ResultPage extends StatefulWidget {
  String barcodeScanRes;

  ResultPage({super.key, required this.barcodeScanRes});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  BannerAd? bannerAd;

  bool isValidUrl(String url) {
    try {
      Uri.parse(url);
      return true;
    } catch (e) {
      return false;
    }
  }

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
            Spacer(),
            Expanded(
              flex: 3,
              child: Center(
                child: SelectableText(
                  widget.barcodeScanRes,
                  style: kFontPoppins30,
                ),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        await Clipboard.setData(
                            ClipboardData(text: widget.barcodeScanRes));

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Copied to Clipboard"),
                        ));
                      },
                      child: Row(
                        children: [
                          Icon(Icons.copy),
                          SizedBox(width: 10),
                          Text("Copy"),
                        ],
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        bool _validURL =
                            Uri.parse(widget.barcodeScanRes).isAbsolute;

                        if (_validURL) {
                          if (!await launchUrl(
                              Uri.parse(widget.barcodeScanRes))) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Not a valid URL"),
                            ));
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Not a valid URL"),
                          ));
                        }
                      },
                      child: Row(
                        children: [
                          Icon(Icons.language),
                          SizedBox(width: 10),
                          Text("Open In Browser"),
                        ],
                      )),
                ],
              ),
            ),
            Spacer(),
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
