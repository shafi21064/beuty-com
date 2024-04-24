import 'package:flutter/material.dart';
import 'package:kirei/my_theme.dart';
import 'package:kirei/repositories/product_repository.dart';
import 'package:kirei/helpers/shimmer_helper.dart';
import 'package:kirei/helpers/string_helper.dart';
import 'package:kirei/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FlashDealProducts extends StatefulWidget {
  FlashDealProducts({Key key, this.flash_deal_id, this.flash_deal_name})
      : super(key: key);
  final int flash_deal_id;
  final String flash_deal_name;

  @override
  _FlashDealProductsState createState() => _FlashDealProductsState();
}

class _FlashDealProductsState extends State<FlashDealProducts> {
  TextEditingController _searchController = new TextEditingController();

  Future<dynamic> _future;

  List<dynamic> _searchList;
  List<dynamic> _fullList;
  ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    _future =
        ProductRepository().getFlashDealProducts(id: widget.flash_deal_id);
    _searchList = [];
    _fullList = [];
    super.initState();
  }

  _buildSearchList(search_key) async {
    _searchList.clear();

    if (search_key.isEmpty) {
      _searchList.addAll(_fullList);
      setState(() {});
    } else {
      for (var i = 0; i < _fullList.length; i++) {
        if (StringHelper().stringContains(_fullList[i].name, search_key)) {
          _searchList.add(_fullList[i]);
          setState(() {});
        }
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(context),
        body: buildProductList(context),
      ),
    );
  }

  bool shouldProductBoxBeVisible(product_name, search_key) {
    if (search_key == "") {
      return true; //do not check if the search key is empty
    }
    return StringHelper().stringContains(product_name, search_key);
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: 75,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Container(
          width: 250,
          child: TextField(
            controller: _searchController,
            onChanged: (txt) {
              _buildSearchList(txt);
            },
            onTap: () {},
            autofocus: true,
            decoration: InputDecoration(
                hintText:
                    "${AppLocalizations.of(context).flash_deal_products_screen_search_products_from} : " +
                        widget.flash_deal_name,
                hintStyle: TextStyle(fontSize: 14.0, color: MyTheme.light_grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyTheme.white, width: 0.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyTheme.white, width: 0.0),
                ),
                contentPadding: EdgeInsets.all(0.0)),
          )),
      elevation: 0.0,
      titleSpacing: 0,
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
          child: IconButton(
            icon: Icon(Icons.search, color: MyTheme.dark_grey),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  buildProductList(context) {
    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container();
          } else if (snapshot.hasData) {
            var productResponse = snapshot.data;
            if (_fullList.length == 0) {
              _fullList.addAll(productResponse.products);
              _searchList.addAll(productResponse.products);
            }


            return SingleChildScrollView(
              child: GridView.builder(

                itemCount: _searchList.length,
                controller: _scrollController,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.618),
                padding: EdgeInsets.all(16),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                },
              ),
            );
          } else {
            return ShimmerHelper()
                .buildProductGridShimmer(scontroller: _scrollController);
          }
        });
  }
}
