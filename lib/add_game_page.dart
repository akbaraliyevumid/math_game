import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:math_game/consts.dart';
import 'package:math_game/util/my_button.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class Sec {
  static int maxSeconds = 0;
}

class _GamePageState extends State<GamePage> {
  // for count of score ...
  int score = 0;
  // for timer
  int seconds = Sec.maxSeconds;
  Timer? timer;
  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        seconds--;
        // for opening alertDialog after ... seconds
        if (seconds == 0) {
          timer!.cancel(); // for stoppint timer if point = 0
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: 10,
                    sigmaY: 10), // for blur background around dialog
                child: WillPopScope(
                  onWillPop: () async => false,
                  child: AlertDialog(
                    backgroundColor: Colors.blue,
                    content: SizedBox(
                      height: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Time over",
                            style: whiteTextStyle,
                          ),
                          Container(
                            margin: const EdgeInsets.all(10.0),
                            child: Text(
                              "Your score: $score",
                              style: whiteTextStyle,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => setState(() {
                              Navigator.pop(context, true);
                              seconds = Sec.maxSeconds;
                              goToNextQuestion();
                              score = 0;
                              startTimer();
                            }),
                            child: Container(
                              padding: const EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                color: Colors.blue[300],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Column(
                                children: const [
                                  Icon(
                                    Icons.replay_outlined,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  Widget buildTime() {
    return Text(
      '$seconds',
      style: whiteTextStyle,
    );
  }

  // number pad list
  List<String> numberPad = [
    '7',
    '8',
    '9',
    'C',
    '4',
    '5',
    '6',
    'DEL',
    '1',
    '2',
    '3',
    '=',
    '0',
  ];
  // number A, number B
  int numberA = Random().nextInt(99);
  int numberB = Random().nextInt(99);

  // user answer
  String userAnswer = '';

  // user tapped a button
  void buttonTapped(String button) {
    setState(() {
      if (button == '=') {
        // calculate if user is correct or incorrect
        checkResult();
      } else if (button == 'C') {
        // clear the input
        userAnswer = '';
      } else if (button == 'DEL') {
        // delete the last number
        if (userAnswer.isNotEmpty) {
          userAnswer = userAnswer.substring(0, userAnswer.length - 1);
        }
      } else if (userAnswer.length < 3) {
        // maximum of 3 numbers can be inputted
        userAnswer += button;
      }
    });
  }

  // check if user is correct or not
  void checkResult() {
    if (numberA + numberB == int.parse(userAnswer)) {
      Fluttertoast.showToast(
        msg: "Correct",
        timeInSecForIosWeb: 1,
      );
      goToNextQuestion();
      score++;
    } else {
      Fluttertoast.showToast(
        msg: "Incorrect",
        timeInSecForIosWeb: 1,
      );
      goToBackQuestion();
      AudioPlayer().play(AssetSource('audio/windows_xp_error.mp3'));
    }
  }

  // create random numbers
  var randomNumber = Random();

  void goToNextQuestion() {
    // reset values
    setState(() {
      userAnswer = '';
    });

    // create a new answer
    numberA = randomNumber.nextInt(99);
    numberB = randomNumber.nextInt(99);
  }

  void goToBackQuestion() {
    setState(() {
      userAnswer = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[300],
      body: Column(
        children: [
          Container(
            height: 160,
            color: Colors.blue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    buildTime(),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '$score',
                      style: whiteTextStyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
          //
          Expanded(
            child: Container(
              color: Colors.blue[300],
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //question
                    Text(
                      '$numberA + $numberB = ',
                      style: whiteTextStyle,
                    ),
                    //answer
                    Container(
                      height: 50.0,
                      width: 100.0,
                      decoration: BoxDecoration(
                        color: Colors.blue[400],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          userAnswer,
                          style: whiteTextStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          //
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: GridView.builder(
                itemCount: numberPad.length,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                ),
                itemBuilder: (context, index) {
                  return MyButton(
                    onTap: () => buttonTapped(numberPad[index]),
                    child: numberPad[index],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
