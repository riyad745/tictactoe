// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../constants/appcolor.dart';
import '../../../controller/game_logic.dart';

class TwoPlayerGameScreen extends StatefulWidget {
  const TwoPlayerGameScreen({Key? key});

  @override
  State<TwoPlayerGameScreen> createState() => _TwoPlayerGameScreenState();
}

class _TwoPlayerGameScreenState extends State<TwoPlayerGameScreen> {
  late BannerAd bannerAd;
  bool isAdLoaded = false;
  var adUnit = "ca-app-pub-9073197646522848/6858351533";
  late String lastValue;
  bool gameOver = false;
  int turn = 0;
  String result = "";
  List<int> scoreboard = [0, 0, 0, 0, 0, 0, 0, 0];

  Game game = Game();

  @override
  void initState() {
    super.initState();
    initBannerAd();
    restartGame();
  }

  void restartGame() {
    lastValue = "X";
    gameOver = false;
    turn = 0;
    result = "";
    scoreboard = [0, 0, 0, 0, 0, 0, 0, 0];
    game.board = Game.initGameBoard();
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
          if (kDebugMode) {
            print(error);
          }
        },
      ),
      request: const AdRequest(),
    );

    bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    double boardWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.primaryColor,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "It's",
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                  const SizedBox(width: 10,),
                  lastValue == 'X'
                      ? const Text("Player1",  style: TextStyle(color: Colors.white, fontSize: 30),)
                      : const Text("Player2",  style: TextStyle(color: Colors.white, fontSize: 30),),
                  const SizedBox(width: 10,),
                  const Text(
                    "Turn",
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                ],
              ),

              const SizedBox(
                height: 50.0,
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: boardWidth,
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: Game.borderlenth ~/ 3,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                            childAspectRatio: 1.0,
                          ),
                          itemCount: Game.borderlenth,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: gameOver
                                  ? null
                                  : () {
                                      if (game.board![index] == "") {
                                        setState(() {
                                          game.board![index] = lastValue;
                                          turn++;
                                          gameOver = game.winnerCheck(
                                              lastValue, index, scoreboard, 3);
                                          if (gameOver) {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                content:
                                                    Text(result),
                                                title: const Text("Congratulations"),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      restartGame();
                                                    },
                                                    child: const Text("Ok"),
                                                  ),
                                                ],
                                              ),
                                            );
                                            result = lastValue == "X" ?  "Player1 is the winner" : "Player2 isthe winner";
                                          } else if (!gameOver && turn == 9) {
                                            result = "It's a Draw";
                                            gameOver = true;
                                          }
                                          lastValue = (lastValue == "X") ? "O" : "X";
                                        });
                                      }
                                    },
                              child: Container(
                                width: Game.blocSize,
                                height: Game.blocSize,
                                decoration: BoxDecoration(
                                  color: AppColor.secondaryColor,
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Center(
                                  child: Text(
                                    game.board![index],
                                    style: TextStyle(
                                      color: game.board![index] == "X"
                                          ? Colors.yellowAccent
                                          : Colors.pink,
                                      fontSize: 64,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Text(
                      result,
                      style: const TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                    const SizedBox(
                      height: 10.00,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          restartGame();
                        });
                      },
                      icon: const Icon(Icons.replay),
                      label: const Text("Repeat the game"),
                    ),
                  ],
                ),
              ),
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
      ),
    );
  }
}
