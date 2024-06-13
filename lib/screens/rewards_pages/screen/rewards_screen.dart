import 'package:flutter/material.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import '../../../my_theme.dart';

class MyRewardsScreen extends StatefulWidget {
  const MyRewardsScreen({
    Key key,
  }) : super(key: key);

  @override
  State<MyRewardsScreen> createState() => _MyRewardsScreenState();
}

AppBar buildAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: MyTheme.primary,
    centerTitle: true,
    leading: IconButton(
      icon: Icon(Icons.arrow_back, color: MyTheme.white),
      onPressed: () => Navigator.of(context).pop(),
    ),
    title: Text(
      'My Rewards',
      style: TextStyle(fontSize: 16, color: MyTheme.white),
    ),
    elevation: 0.0,
    titleSpacing: 0,
  );
}

Container buildCircleStatusShape({bool isDone}) {
  return Container(
    height: 25,
    width: 25,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: isDone ? MyTheme.secondary : Colors.transparent,
      border: !isDone
          ? Border.all(color: MyTheme.secondary, width: 1.5)
          : Border.all(color: MyTheme.white, width: 0),
    ),
    child: isDone
        ? Icon(
            Icons.star,
            size: 12,
            color: MyTheme.white,
          )
        : Icon(
            Icons.lock,
            size: 12,
          ),
  );
}

Container buildHeaderPart() {
  return Container(
    padding: EdgeInsets.all(16),
    height: 286,
    color: MyTheme.white,
    child: Column(
      children: [
        Row(
          children: [
            Text(
              'Levels',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline),
            ),
            SizedBox(
              width: 10,
            ),
            buildCircleStatusShape(isDone: true),
            SizedBox(
              width: 5,
            ),
            Text(
              'Bronze',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            buildCircleStatusShape(isDone: true),
            SizedBox(
              width: 5,
            ),
            Text(
              'Silver',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            buildCircleStatusShape(isDone: false),
            SizedBox(
              width: 5,
            ),
            Text(
              'Gold',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        LinearProgressBar(
          maxSteps: 9,
          progressType: LinearProgressBar.progressTypeLinear,
          currentStep: 5,
          progressColor: Colors.deepPurple,
          backgroundColor: Colors.blueAccent,
          dotsAxis: Axis.horizontal,
          // OR Axis.vertical
          dotsActiveSize: 20,
          dotsInactiveSize: 20,
          dotsSpacing:
              EdgeInsets.only(right: 5),
          // also can use any EdgeInsets.
        )
      ],
    ),
  );
}

class _MyRewardsScreenState extends State<MyRewardsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [buildHeaderPart()],
        ),
      ),
    );
  }
}
