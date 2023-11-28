import 'package:active_ecommerce_flutter/data_model/questions_response.dart';
import 'package:active_ecommerce_flutter/repositories/questions_repository.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'dart:ui';
import 'package:flutter/painting.dart';
import 'dart:async';

import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'package:flutter/services.dart';
import 'package:expandable/expandable.dart';

import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductQuestions extends StatefulWidget {
  int id;

  ProductQuestions({Key key, this.id}) : super(key: key);

  @override
  _ProductQuestionsState createState() => _ProductQuestionsState();
}

class _ProductQuestionsState extends State<ProductQuestions> {
  final TextEditingController _myQuestionTextController =
      TextEditingController();
  final TextEditingController _myNameTextController = TextEditingController();
  ScrollController _xcrollController = ScrollController();
  ScrollController scrollController = ScrollController();

  List<dynamic> _questionsList = [];
  bool _isInitial = true;
  int _page = 1;
  int _totalData = 0;
  bool _showLoadingContainer = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchData();

    _xcrollController.addListener(() {
      //print("position: " + _xcrollController.position.pixels.toString());
      //print("max: " + _xcrollController.position.maxScrollExtent.toString());

      if (_xcrollController.position.pixels ==
          _xcrollController.position.maxScrollExtent) {
        setState(() {
          _page++;
        });
        _showLoadingContainer = true;
        fetchData();
      }
    });
  }

  fetchData() async {
    var questionResponse = await QuestionsRepository().getQuestionResponse(
      widget.id,
      page: _page,
    );
    _questionsList.addAll(questionResponse.data);
    print(_questionsList);
    _isInitial = false;
    _totalData = questionResponse.meta.total;
    _showLoadingContainer = false;
    setState(() {});
  }

  reset() {
    _questionsList.clear();
    _isInitial = true;
    _totalData = 0;
    _page = 1;
    _showLoadingContainer = false;
    _myQuestionTextController.text = "";
    _myNameTextController.text = "";

    setState(() {});
  }

  Future<void> _onRefresh() async {
    reset();
    fetchData();
  }

  onTapReviewSubmit(context) async {
    // if (is_logged_in.$ == false) {
    //   ToastComponent.showDialog("You need to login to give a review", context,
    //       gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    //   return;
    // }

    //return;
    var myQuestionText = _myQuestionTextController.text.toString();
    var myNameText = _myNameTextController.text.toString();
    //print(chatText);
    if (myQuestionText == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context)
              .product_reviews_screen_review_empty_warning,
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
      return;
    }
    if (myNameText == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context).product_reviews_screen_star_warning,
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
      return;
    }

    var questionSubmitResponse = await QuestionsRepository()
        .getQuestionSubmitResponse(widget.id, myNameText, myQuestionText);

    if (questionSubmitResponse.result == false) {
      ToastComponent.showDialog(questionSubmitResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    ToastComponent.showDialog(questionSubmitResponse.message, context,
        gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);

    reset();
    fetchData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _xcrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: buildAppBar(context),
          body: Stack(
            children: [
              RefreshIndicator(
                color: MyTheme.accent_color,
                backgroundColor: Colors.white,
                onRefresh: _onRefresh,
                displacement: 0,
                child: CustomScrollView(
                  controller: _xcrollController,
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: buildProductQuestionsList(),
                        ),
                        Container(
                          height: 120,
                        )
                      ]),
                    )
                  ],
                ),
              ), //original

              Align(
                alignment: Alignment.bottomCenter,
                child: buildBottomBar(context),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: buildLoadingContainer()),
            ],
          )),
    );
  }

  buildBottomBar(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          decoration: new BoxDecoration(color: Colors.white54.withOpacity(0.6)),
          height: 120,
          //color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(
                top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
            child: buildGiveQuestionSection(context),
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Text(
        AppLocalizations.of(context).product_questions_screen_questions,
        style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildProductQuestionsList() {
    if (_isInitial && _questionsList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildListShimmer(item_count: 10, item_height: 75.0));
    } else if (_questionsList.length > 0) {
      return SingleChildScrollView(
        child: ListView.builder(
          controller: scrollController,
          itemCount: _questionsList.length,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 0.0),
              child: buildProductQuestionsItem(index),
            );
          },
        ),
      );
    } else if (_totalData == 0) {
      return Container(
        height: 300,
        child: Center(
            child: Text(AppLocalizations.of(context)
                .product_reviews_screen_no_reviews_yet)),
      );
    } else {
      return Container(); // should never be happening
    }
  }

  buildProductQuestionsItem(index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35),
                border: Border.all(
                  color: Color.fromRGBO(112, 112, 112, .3),
                  width: 1,
                ),
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    _questionsList[index].name.length >= 2
                        ? _questionsList[index]
                            .name
                            .substring(0, 2)
                            .toUpperCase()
                        : _questionsList[index].name.toUpperCase(),
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  width: 180,
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          _questionsList[index].name,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 13,
                              height: 1.6,
                              fontWeight: FontWeight.w600),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            _questionsList[index].time,
                            style: TextStyle(color: MyTheme.medium_grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
          ]),
          Padding(
            padding: const EdgeInsets.only(left: 56.0),
            child: buildExpandableQuestions(index),
          ),
          if (_questionsList[index].replies != null &&
              _questionsList[index].replies.isNotEmpty)
            ..._questionsList[index].replies.map((reply) {
              return Padding(
                padding: const EdgeInsets.only(left: 50.0, top: 10.0),
                child: buildReplySection(reply),
              );
            }),
        ],
      ),
    );
  }

  buildReplySection(reply) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35),
                  border: Border.all(
                    color: Color.fromRGBO(112, 112, 112, .3),
                    width: 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child: Image.asset(
                    'assets/app_logo.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                    width: 180,
                    child: Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            reply.name,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 13,
                                height: 1.6,
                                fontWeight: FontWeight.w600),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Text(
                              reply.time,
                              style: TextStyle(color: MyTheme.medium_grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Spacer(),
            ]),
            Padding(
              padding: const EdgeInsets.only(left: 56.0),
              child: buildExpandableReplies(reply),
            )
          ],
        ));
  }

  ExpandableNotifier buildExpandableReplies(reply) {
    return ExpandableNotifier(
        child: ScrollOnExpand(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expandable(
            collapsed: Container(
                height: reply.text.length > 100 ? 32 : 16,
                child: Text(reply.text,
                    style: TextStyle(color: MyTheme.font_grey))),
            expanded: Container(
                child: Text(reply.text,
                    style: TextStyle(color: MyTheme.font_grey))),
          ),
          reply.text.length > 100
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Builder(
                      builder: (context) {
                        var controller = ExpandableController.of(context);
                        return FlatButton(
                          child: Text(
                            !controller.expanded
                                ? AppLocalizations.of(context).common_view_more
                                : AppLocalizations.of(context).common_show_less,
                            style: TextStyle(
                                color: MyTheme.font_grey, fontSize: 11),
                          ),
                          onPressed: () {
                            controller.toggle();
                          },
                        );
                      },
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    ));
  }

  ExpandableNotifier buildExpandableQuestions(index) {
    return ExpandableNotifier(
        child: ScrollOnExpand(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expandable(
            collapsed: Container(
                height: _questionsList[index].text.length > 100 ? 32 : 16,
                child: Text(_questionsList[index].text,
                    style: TextStyle(color: MyTheme.font_grey))),
            expanded: Container(
                child: Text(_questionsList[index].text,
                    style: TextStyle(color: MyTheme.font_grey))),
          ),
          _questionsList[index].text.length > 100
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Builder(
                      builder: (context) {
                        var controller = ExpandableController.of(context);
                        return FlatButton(
                          child: Text(
                            !controller.expanded
                                ? AppLocalizations.of(context).common_view_more
                                : AppLocalizations.of(context).common_show_less,
                            style: TextStyle(
                                color: MyTheme.font_grey, fontSize: 11),
                          ),
                          onPressed: () {
                            controller.toggle();
                          },
                        );
                      },
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    ));
  }

  Container buildLoadingContainer() {
    return Container(
      height: _showLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(_totalData == _questionsList.length
            ? AppLocalizations.of(context)
                .product_reviews_screen_no_more_reviews
            : AppLocalizations.of(context)
                .product_reviews_screen_loading_more_reviews),
      ),
    );
  }

  buildGiveQuestionSection(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(right: 60.0),
          height: 40,
          width: (MediaQuery.of(context).size.width - 32) * (4 / 5),
          child: TextField(
            autofocus: false,
            maxLines: null,
            inputFormatters: [
              LengthLimitingTextInputFormatter(125),
            ],
            controller: _myNameTextController,
            decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromRGBO(251, 251, 251, 1),
                hintText: AppLocalizations.of(context)
                    .product_questions_screen_type_your_name,
                hintStyle:
                    TextStyle(fontSize: 14.0, color: MyTheme.textfield_grey),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: MyTheme.textfield_grey, width: 0.5),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(35.0),
                ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: MyTheme.medium_grey, width: 0.5),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(35.0),
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0)),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 40,
              width: (MediaQuery.of(context).size.width - 32) * (4 / 5),
              child: TextField(
                autofocus: false,
                maxLines: null,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(125),
                ],
                controller: _myQuestionTextController,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromRGBO(251, 251, 251, 1),
                    hintText: AppLocalizations.of(context)
                        .product_questions_screen_type_your_question,
                    hintStyle: TextStyle(
                        fontSize: 14.0, color: MyTheme.textfield_grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: MyTheme.textfield_grey, width: 0.5),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(35.0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: MyTheme.medium_grey, width: 0.5),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(35.0),
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  onTapReviewSubmit(context);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    color: MyTheme.accent_color,
                    borderRadius: BorderRadius.circular(35),
                    border: Border.all(
                        color: Color.fromRGBO(112, 112, 112, .3), width: 1),
                    //shape: BoxShape.rectangle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
