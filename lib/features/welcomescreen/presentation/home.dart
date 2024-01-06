import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tictactoe/constants/appcolor.dart';
import 'package:tictactoe/features/twoplayer/presentation/two_player.dart';

import '../../computer/presentation/widgets/game_setting.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late BannerAd bannerAd;
  bool isAdLoaded = false;
  var adUnit = "your_ad_unit_id"; // Replace with your actual ad unit ID

  @override
  void initState() {
    super.initState();
    initBannerAd();
  }

  void initBannerAd() {
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: adUnit,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          // Handle ad loading failure
        },
      ),
      request: const AdRequest(),
    );

    bannerAd.load();
  }

    @override
  void dispose() {
    bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColor.primaryColor,
              AppColor.accentColor,
              AppColor.secondaryColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset(
                'assets/images/splash.png', // Replace with the actual path to your logo image
                width: 150,
                height: 150,
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                GameSettingsDialog.show(context);
              },
              icon: const Icon(Icons.computer),
              label: const Text("Play with Computer"),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TwoPlayerGameScreen()),
                );
              },
              icon: const Icon(Icons.people),
              label: const Text("Two Players"),
            ),
            const Spacer(),
            isAdLoaded
            ? SizedBox(
                height: bannerAd.size.height.toDouble(),
                width: bannerAd.size.width.toDouble(),
                child: AdWidget(ad: bannerAd),
              )
            : const SizedBox(),
          ],
        ),
      ),
    );
  }


}
