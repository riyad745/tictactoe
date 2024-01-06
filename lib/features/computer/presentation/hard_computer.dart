// ignore_for_file: use_key_in_widget_constructors

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../constants/appcolor.dart';
import '../../../controller/game_logic.dart';

class ComputerHardGameScreen extends StatefulWidget {
  const ComputerHardGameScreen({Key? key});

  @override
  State<ComputerHardGameScreen> createState() => _ComputerHardGameScreenState();
}

class _ComputerHardGameScreenState extends State<ComputerHardGameScreen> {
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

  int getComputerMove() {
    Random random = Random();
    int computerMove;
    do {
      computerMove = random.nextInt(Game.borderlenth);
    } while (game.board![computerMove] != "");
    return computerMove;
  }

  void makeComputerMove() async {
    if (!gameOver) {
      await Future.delayed(const Duration(milliseconds: 500));
      int computerMoveIndex = getComputerMove();
      if (game.board![computerMoveIndex] == "") {
        setState(() {
          game.board![computerMoveIndex] = lastValue;
          turn++;
          gameOver =
              game.winnerCheck(lastValue, computerMoveIndex, scoreboard, 3);
          if (gameOver) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: Text("$result is the winner."),
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
            result = "$lastValue is the winner";
          } else if (!gameOver && turn == 9) {
            result = "It's a Draw";
            gameOver = true;
          }
          lastValue = (lastValue == "X") ? "O" : "X";
        });
      }
    }
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
                  const SizedBox(
                    width: 10,
                  ),
                  lastValue == 'X'
                      ? const Icon(
                          Icons.person,
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.android,
                          color: Colors.white,
                        ),
                  const SizedBox(
                    width: 10,
                  ),
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
                                                content: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Text(
                                                      "The",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 30),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    result == 'X'
                                                        ? const Icon(
                                                            Icons.person,
                                                            color: Colors.black,
                                                          )
                                                        : const Icon(
                                                            Icons.android,
                                                            color: Colors.black,
                                                          ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    const Text(
                                                      "is winner",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 30),
                                                    ),
                                                  ],
                                                ),
                                                title: const Text(
                                                    "Congratulations"),
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
                                            result = "$lastValue is the winner";
                                          } else if (!gameOver && turn == 9) {
                                            result = "It's a Draw";
                                            gameOver = true;
                                          }
                                          lastValue =
                                              (lastValue == "X") ? "O" : "X";
                                          makeComputerMove();
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
