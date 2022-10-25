import 'package:flutter/material.dart';
import 'package:math_game/consts.dart';
import 'package:math_game/add_game_page.dart';

class SetVarTime extends StatefulWidget {
  const SetVarTime({super.key});

  @override
  State<SetVarTime> createState() => _SetVarTimeState();
}

class _SetVarTimeState extends State<SetVarTime> {
  List<bool> isSelected = [
    true,
    false,
    false,
  ];
  List<int> count = [
    Sec.maxSeconds = 30,
    Sec.maxSeconds = 60,
    Sec.maxSeconds = 100,
  ];
  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      constraints: const BoxConstraints(minHeight: 50, minWidth: 100),
      isSelected: isSelected,
      selectedColor: Colors.white,
      fillColor: Colors.lightBlue.shade900,
      renderBorder: false,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            "30",
            style: whiteTextStyle,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            "60",
            style: whiteTextStyle,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            "100",
            style: whiteTextStyle,
          ),
        ),
      ],
      onPressed: (int newIndex) {
        setState(() {
          for (var index = 0; index < isSelected.length; index++) {
            if (index == newIndex) {
              isSelected[index] = true;
            } else {
              isSelected[index] = false;
            }
          }
          switch (newIndex) {
            case 0:
              Sec.maxSeconds = 30;
              break;
            case 1:
              Sec.maxSeconds = 60;
              break;
            case 2:
              Sec.maxSeconds = 100;
              break;
          }
        });
      },
    );
  }
}
