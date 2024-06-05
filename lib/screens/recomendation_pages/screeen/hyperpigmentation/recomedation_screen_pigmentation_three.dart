import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kirei/custom/toast_component.dart';
import 'package:kirei/screens/recomendation_pages/screeen/hyperpigmentation/recomedation_screen_pigmentation_four.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import '../../../../my_theme.dart';
import '../../recommendetion_controller.dart';

class RecomendationScreenPigmentationThree extends StatefulWidget {
  const RecomendationScreenPigmentationThree({
    Key key,
  }) : super(key: key);

  @override
  State<RecomendationScreenPigmentationThree> createState() => _RecomendationScreenPigmentationThreeState();
}

class _RecomendationScreenPigmentationThreeState extends State<RecomendationScreenPigmentationThree> {
  List<int> selectedValues = []; // To store selected values

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: buildAppBar(context),
      body: Consumer<RecommendationController>(
          builder: (context, provider, child) {
            return ListView(
              physics: BouncingScrollPhysics(),
              children: [
                SizedBox(
                  height: 16,
                ),
                buildHeaderProgressbar(historyProgress: 1, goalProgress: 3/5),
                SizedBox(
                  height: 25,
                ),
                buildLinearProgressbar(percent: 3),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                      child: Text(
                        RecommendationController()
                            .questions.relatedQuestionsBasedOnPrimaryConcern.primaryConcerns['hyperpigmentation'].questions[1].question,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      )),
                ),
                SizedBox(
                  height: 8,
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: RecommendationController()
                        .questions.relatedQuestionsBasedOnPrimaryConcern.primaryConcerns['hyperpigmentation'].questions[1].options.length,
                    itemBuilder: (BuildContext context, int index) {
                      return buildQuestionContainer(
                          ansText: RecommendationController()
                              .questions.relatedQuestionsBasedOnPrimaryConcern.primaryConcerns['hyperpigmentation'].questions[1].options[index],
                          selectedAns: index);
                    }),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [buildBackButton(), buildNextButton()],
                  ),
                )
              ],
            );
          }),
    );
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
        'Ai Recommendation',
        style: TextStyle(fontSize: 16, color: MyTheme.white),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildCircularProgressIndicator({String titleText, double percent}) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25), color: MyTheme.secondary),
      child: Row(
        children: [
          Text(
            titleText,
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: MyTheme.white),
          ),
          SizedBox(
            width: 8,
          ),
          CircularPercentIndicator(
            radius: 10,
            lineWidth: 2.0,
            percent: percent,
            progressColor: MyTheme.primary,
            reverse: true,
          ),
        ],
      ),
    );
  }

  Row buildHeaderProgressbar({double historyProgress, double goalProgress}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildCircularProgressIndicator(
            titleText: 'Skin care History', percent: historyProgress),
        SizedBox(
          width: 8,
        ),
        Container(
          width: 10,
          height: 1,
          color: Colors.red,
        ),
        SizedBox(
          width: 8,
        ),
        buildCircularProgressIndicator(
            titleText: 'Skin care Goal', percent: goalProgress),
      ],
    );
  }

  buildLinearProgressbar({int percent}) {
    return Column(
      children: [
        LinearPercentIndicator(
          width: MediaQuery.of(context).size.width * 1,
          lineHeight: 5.0,
          percent: percent / 5,
          backgroundColor: Colors.grey[350],
          progressColor: MyTheme.secondary,
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          '${percent}/5',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        )
      ],
    );
  }

  buildQuestionContainer({int selectedAns, String ansText}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        width: MediaQuery.of(context).size.width,
        height: 70,
        decoration: BoxDecoration(
            border: Border.all(width: 2, color: Colors.grey[300])),
        child: Row(
          children: [
            Consumer<RecommendationController>(
                builder: (context, provider, child) {
                  return Checkbox(
                      value: selectedValues.contains(selectedAns),
                      onChanged: (value) {
                        setState(() {
                          if (value) {
                            selectedValues.add(selectedAns);
                          } else {
                            selectedValues.remove(selectedAns);
                          }
                          print(selectedValues);
                        });
                      });
                }),
            SizedBox(
              width: 8,
            ),
            Text(
              ansText,
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  buildNextButton() {
    return Consumer<RecommendationController>(
        builder: (context, provider, child) {
          return InkWell(
            onTap: () {
              if (selectedValues.isEmpty) {
                ToastComponent.showDialog(
                    'Ans is required', context,
                    gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
                return;
              }
              provider.pigmentationThreeSelected = selectedValues
                  .map((index) => String.fromCharCode(65 + index).toLowerCase())
                  .toList();
              print(provider.skinCareConcern);
              Navigator.push(context, MaterialPageRoute(builder: (_) => RecomendationScreenPigmentationFour()));
            },
            child: Container(
              alignment: Alignment.center,
              height: 50,
              width: 120,
              color: MyTheme.secondary,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'NEXT',
                    style: TextStyle(
                        color: MyTheme.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: MyTheme.white,
                  )
                ],
              ),
            ),
          );
        });
  }

  buildBackButton() {
    return Consumer<RecommendationController>(
        builder: (context, provider, child) {
          return InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              alignment: Alignment.center,
              height: 50,
              width: 120,
              color: MyTheme.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_back_ios_new,
                    size: 16,
                    color: MyTheme.secondary,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Text(
                    'BACK',
                    style: TextStyle(
                        color: MyTheme.secondary, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
