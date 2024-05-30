import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../my_theme.dart';

class RecomendationScreen extends StatefulWidget {
  const RecomendationScreen({
    Key key,
  }) : super(key: key);

  @override
  State<RecomendationScreen> createState() => _RecomendationScreenState();
}

class _RecomendationScreenState extends State<RecomendationScreen> {

   int selectedValue;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: Column(
        children: [
          SizedBox(height: 16,),
          buildHeaderProgressbar(),
          SizedBox(height: 25,),
          buildLinearProgressbar(percent: 9),
          SizedBox(height: 25,),
          Center(child: Text('Question', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)),
          SizedBox(height: 8,),
          ListView.builder(
            shrinkWrap: true,
            itemCount: 3,
              itemBuilder: (context, index){
              return buildQuestionContainer(
                ansText: 'Ans',
                selectedAns: index
              );
              })


        ],
      ),
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
        'Ai Recomendation',
        style: TextStyle(fontSize: 16, color: MyTheme.white),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }



  buildCircularProgressIndicator({String titleText, double percent}) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25), color: MyTheme.primary),
      child: Row(
        children: [
          Text(
            titleText,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: MyTheme.white),
          ),
          SizedBox(
            width: 8,
          ),
          CircularPercentIndicator(
            radius: 10,
            lineWidth: 2.0,
            percent: percent,
            progressColor: MyTheme.apple_bg,
            reverse: true,
          ),
        ],
      ),
    );
  }

  Row buildHeaderProgressbar() {
    return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildCircularProgressIndicator(
                titleText: 'Skin care History', percent: .5),
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
                titleText: 'Skin care Goal', percent: .5),
          ],
        );
  }

  buildLinearProgressbar({int percent}){
    return Column(
      children: [
        LinearPercentIndicator(
          width: MediaQuery.of(context).size.width * 1,
          lineHeight: 5.0,
          percent: percent/10,
          backgroundColor: MyTheme.light_grey,
          progressColor: MyTheme.secondary,
        ),
        SizedBox(height: 8,),
        Text('${percent}/10', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),)
      ],
    );
  }

  buildQuestionContainer({int selectedAns, String ansText}){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        width: MediaQuery.of(context).size.width,
        height: 70,
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: MyTheme.light_grey)
        ),
        child: Row(
          children: [

            Radio<int>(
              value: selectedAns,
              groupValue: selectedValue,
              onChanged: (int value) {
                setState(() {
                   selectedValue = value;
                   print(value);
                });
              },
            ),
            // InkWell(
            //   onTap: (){},
            //   child: Container(
            //     padding: EdgeInsets.all(3),
            //     height: 20,
            //     width: 20,
            //     decoration: BoxDecoration(
            //       shape: BoxShape.circle,
            //       border: Border.all(width: 1)
            //     ),
            //     child:
            //     Visibility(
            //       visible: selectedAns,
            //       child: Container(
            //         height: 10,
            //         width: 10,
            //         decoration: BoxDecoration(
            //           shape: BoxShape.circle,
            //           color: MyTheme.secondary
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(width: 8,),
            Text(ansText, style: TextStyle(fontWeight: FontWeight.bold),)
          ],
        ),
      ),
    );
  }
}
