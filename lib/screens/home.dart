import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kirei/custom/CommonFunctoins.dart';
import 'package:kirei/custom/toast_component.dart';
import 'package:kirei/my_theme.dart';
import 'package:kirei/providers/category_passing_controller.dart';
import 'package:kirei/repositories/search_repository.dart';
import 'package:kirei/screens/appointment.dart';
import 'package:kirei/screens/beauty_tips.dart';
import 'package:kirei/screens/filter.dart';
import 'package:kirei/screens/login.dart';
import 'package:kirei/screens/main.dart';
import 'package:kirei/screens/newsfeed.dart';
import 'package:kirei/screens/product_details.dart';
import 'package:kirei/theme/appThemes.dart';
import 'package:kirei/ui_elements/mini_product_card.dart';
import 'package:kirei/ui_sections/drawer.dart';
import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:kirei/repositories/sliders_repository.dart';
import 'package:kirei/repositories/category_repository.dart';
import 'package:kirei/repositories/product_repository.dart';
import 'package:kirei/app_config.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:kirei/helpers/shimmer_helper.dart';
import 'package:kirei/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:toast/toast.dart';


class Home extends StatefulWidget {
  Home({Key key, this.title, this.show_back_button = false, go_back = true, this.cartItemCount})
      : super(key: key);

  final String title;
  bool show_back_button;
  bool go_back;
  dynamic cartItemCount;


  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _current_slider = 0;
  ScrollController _productScrollController;
  ScrollController _mainScrollController = ScrollController();
  final TextEditingController _searchController = new TextEditingController();

  String _searchKey = "";
  List<dynamic> _searchSuggestionList = List();

  AnimationController pirated_logo_controller;
  Animation pirated_logo_animation;

  var _carouselImageList = [];
  var _featuredCategoryList = [];
  var _allCategories = [];
  var _featuredProductList = [];
  var _recommendedProductList = [];
  var _popularSearchProductList = [];
  var _trendingProductList = [];
  var _bestSellingProductList = [];
  var _hotDealsProductList = [];
  var _newArrivalProductList = [];
  bool _isFeaturedProuctInitial = true;
  bool _isRecommendedProuctInitial = true;
  bool _isPopularSearchProductInital = true;
  bool _isTrendingProductInitial = true;
  bool _isBestSellingProductInitial = true;
  bool _isHotDealsProductInitial = true;
  bool _isNewArrivalsProductInitial = true;
  bool _isCategoryInitial = true;
  bool _isAllCategoryIntial = true;
  bool _isCarouselInitial = true;
  int _totalFeaturedProductData = 0;
  int _totalRecommendedProductData = 0;
  int _totalPopularSearchProductData = 0;
  int _totalTrendingProductData = 0;
  int _totalBestSellingProductData = 0;
  int _totalHotDealsProductData = 0;
  int _totalNewArrivalsProductData = 0;
  int _productPage = 1;
  bool _showProductLoadingContainer = false;

  @override
  void initState() {
    print("app_mobile_language.en${app_mobile_language.$}");
    print("app_language.${app_language.$}");
    print("app_language_rtl${app_language_rtl.$}");

    // TODO: implement initState
    super.initState();
    // In initState()
    // if (AppConfig.purchase_code == "") {
    //   initPiratedAnimation();
    // }

    fetchAll();

    _mainScrollController.addListener(() {


      if (_mainScrollController.position.pixels ==
          _mainScrollController.position.maxScrollExtent) {
        setState(() {
          _productPage++;
        });
        _showProductLoadingContainer = true;
        fetchHomeProducts();
       //  fetchRecommendedProducts();
        fetchPopularSearchedProducts();
         fetchTrendingProducts();
        // fetchBestSellingProducts();
        // fetchHotDealsProducts();
        //fetchNewArrivalsProducts();
      }
    });
  }

  onPopped(value) async {
    reset();
  }

  fetchAll() {
    fetchCarouselImages();
    fetchFeaturedCategories();
    fetchHomeProducts();
    //fetchRecommendedProducts();
    fetchPopularSearchedProducts();
    fetchTrendingProducts();
    // fetchBestSellingProducts();
    // fetchHotDealsProducts();
    //fetchNewArrivalsProducts();

    // AddonsHelper().setAddonsData();
    // BusinessSettingHelper().setBusinessSettingData();
  }

  fetchCarouselImages() async {
    var carouselResponse = await SlidersRepository().getSliders();
    print(carouselResponse);
    carouselResponse.sliders.forEach((slider) {
      if(slider.photo != null) {
        _carouselImageList.add(slider.photo);
      }
    });
    _isCarouselInitial = false;
    setState(() {});
  }

  fetchFeaturedCategories() async {
    var categoryResponse =
    await CategoryRepository().getHomeFeaturedCategories();
    print(categoryResponse);

    _featuredCategoryList.addAll(categoryResponse);
    print(_featuredCategoryList);
    _isCategoryInitial = false;
    setState(() {});
  }


  fetchHomeProducts() async {
    var productResponse = await ProductRepository().getHomeProducts(context);


    _hotDealsProductList.addAll(productResponse.featuredProducts);
     _newArrivalProductList.addAll(productResponse.newProducts);
     _bestSellingProductList.addAll(productResponse.bestsellingProducts);

    _isBestSellingProductInitial = false;
    _totalBestSellingProductData = productResponse.bestsellingProducts.length;
    _isNewArrivalsProductInitial = false;
    _totalNewArrivalsProductData = productResponse.newProducts.length;
    _isHotDealsProductInitial = false;
    _totalHotDealsProductData = productResponse.featuredProducts.length;
    _isFeaturedProuctInitial = false;
    _totalFeaturedProductData = productResponse.featuredProducts.length;
    _showProductLoadingContainer = false;
    setState(() {});
  }

  fetchRecommendedProducts() async {
    var productResponse = await ProductRepository().getRecommendedProducts();
    _recommendedProductList.addAll(productResponse.products);
    _isRecommendedProuctInitial = false;
    _totalRecommendedProductData = productResponse.products.length;
    _showProductLoadingContainer = false;
    setState(() {});
  }

  fetchPopularSearchedProducts() async {
    var productResponse = await ProductRepository().getPopularSearchProducts();
    _popularSearchProductList.addAll(productResponse.products);
    _isPopularSearchProductInital = false;
    _totalPopularSearchProductData = productResponse.products.length;
    _showProductLoadingContainer = false;
    setState(() {});
  }

  fetchTrendingProducts() async {
    var productResponse = await ProductRepository().getTrendingProducts();
    _trendingProductList.addAll(productResponse.products);
    _isTrendingProductInitial = false;
    _totalTrendingProductData = productResponse.products.length;
    _showProductLoadingContainer = false;
    setState(() {});
  }

  // fetchHotDealsProducts() async {
  //   var productResponse = await ProductRepository().getHotDealsProducts();
  //   _hotDealsProductList.addAll(productResponse.products);
  //   _isHotDealsProductInitial = false;
  //   _totalHotDealsProductData = productResponse.products.length;
  //   _showProductLoadingContainer = false;
  //   setState(() {});
  // }

  reset() {
    _carouselImageList.clear();
    _featuredCategoryList.clear();
    _isCarouselInitial = true;
    _isCategoryInitial = true;

    setState(() {});

    resetProductList();
  }

  fetchNewArrivalsProducts() async {
    // var productResponse = await ProductRepository().getNewArrivalsProducts();
    // _newArrivalProductList.addAll(productResponse.products);
    // _isNewArrivalsProductInitial = false;
    // _totalNewArrivalsProductData = productResponse.products.length;
    // _showProductLoadingContainer = false;
    // setState(() {});
  }

  Future<void> _onRefresh() async {
    reset();
    fetchAll();
  }

  resetProductList() {
    _featuredProductList.clear();
    _isFeaturedProuctInitial = true;
    _isRecommendedProuctInitial = true;
    _isPopularSearchProductInital = true;
    _isBestSellingProductInitial = true;
    _isHotDealsProductInitial = true;
    _isNewArrivalsProductInitial = true;
    _totalFeaturedProductData = 0;
    _totalRecommendedProductData = 0;
    _totalPopularSearchProductData = 0;
    _totalHotDealsProductData = 0;
    _totalTrendingProductData = 0;
    _totalBestSellingProductData = 0;
    _totalNewArrivalsProductData = 0;
    _productPage = 1;
    _showProductLoadingContainer = false;
    setState(() {});
  }

  initPiratedAnimation() {
    pirated_logo_controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));
    pirated_logo_animation = Tween(begin: 40.0, end: 60.0).animate(
        CurvedAnimation(
            curve: Curves.bounceOut, parent: pirated_logo_controller));

    pirated_logo_controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        pirated_logo_controller.repeat();
      }
    });

    pirated_logo_controller.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pirated_logo_controller?.dispose();
    _mainScrollController.dispose();
  }

  // ///upload image for search product by multipart request
  // //for image uploading
  final ImagePicker _picker = ImagePicker();
  XFile _file;

  chooseAndUploadImageForSearchProduct(context) async {

    var status = await Permission.photos.request();

    if (status.isDenied) {
      // We didn't ask for permission yet.
      showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title:
            Text(AppLocalizations.of(context).common_photo_permission),
            content: Text(
                AppLocalizations.of(context).common_app_needs_permission),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(AppLocalizations.of(context).common_deny),
                onPressed: () => Navigator.of(context).pop(),
              ),
              CupertinoDialogAction(
                child: Text(AppLocalizations.of(context).common_settings),
                onPressed: () => openAppSettings(),
              ),
            ],
          ));
    } else if (status.isRestricted) {
      ToastComponent.showDialog(
          AppLocalizations.of(context).common_give_photo_permission, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    } else if (status.isGranted) {
      _file = await _picker.pickImage(source: ImageSource.gallery);

      if (_file == null) {
        ToastComponent.showDialog(
            AppLocalizations
                .of(context)
                .common_no_file_chosen, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }

      List<int> imageBytes = File(_file.path).readAsBytesSync();
      Uint8List imageUint8List = Uint8List.fromList(imageBytes);

      var productSearchByImageResponse =
      await SearchRepository().getSearchByImageProductListResponse(
         imageName: _file.path.split('/').last,
         imageBytes: imageUint8List,
      );

      if(productSearchByImageResponse.products.isNotEmpty){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Main(pageIndex: 1,data: productSearchByImageResponse.products,)));
      } else{
        ToastComponent.showDialog(
            "Some thing went wrong",
            context,
            gravity: Toast.CENTER,
            duration: Toast.LENGTH_LONG);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        CommonFunctions(context).appExitDialog();
        return widget.go_back;
      },
      child: Directionality(
          textDirection:
          app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
          child: DynamicTheme(
              themeCollection: themeCollection,
              defaultThemeId: AppThemes.Default,
              builder: (context, theme) {
                return Container(
                  child: Scaffold(
                      key: _scaffoldKey,
                      backgroundColor: Theme.of(context).colorScheme.background,
                      appBar: buildAppBar(statusBarHeight, context),
                      drawer: MainDrawer(),
                      body: Stack(
                        children: [
                          RefreshIndicator(
                            color: MyTheme.primary,
                            backgroundColor: Colors.white,
                            onRefresh: _onRefresh,
                            displacement: 0,
                            child: CustomScrollView(
                              controller: _mainScrollController,
                              physics: const BouncingScrollPhysics(
                                  parent: AlwaysScrollableScrollPhysics()),
                              slivers: <Widget>[
                                SliverList(
                                  delegate: SliverChildListDelegate([
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        13.0,
                                        16.0,
                                        13.0,
                                        0.0,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: MyTheme
                                              .light_grey, // Set your desired background color here
                                          borderRadius: BorderRadius.circular(
                                              10.0), // Set the border radius
                                        ),
                                        width:
                                        MediaQuery.of(context).size.width *
                                            .78,
                                        child: Container(
                                          child: Padding(
                                              padding: EdgeInsets.all(0),
                                              child: Consumer<CategoryPassingController>(
                                                builder: (widget, value, child) {
                                                  return TypeAheadField(
                                                    // ignore: missing_return
                                                    suggestionsCallback:
                                                    // ignore: missing_return
                                                        (pattern) async {
                                                      //return await BackendService.getSuggestions(pattern);
                                                      if (pattern != "") {
                                                        var suggestions =
                                                        await SearchRepository()
                                                            .getSearchSuggestionListResponse(
                                                          query_key: pattern,
                                                        );
                                                        print('this is sugetion ${suggestions.products}');

                                                        return suggestions.products;
                                                      }
                                                    },
                                                    loadingBuilder: (context) {
                                                      return Container(
                                                        height: 50,
                                                        child: Center(
                                                            child: Text(
                                                              AppLocalizations.of(
                                                                  context)
                                                                  .filter_screen_loading_suggestions,
                                                              style: TextStyle(
                                                                  color: MyTheme
                                                                      .dark_grey),
                                                            )),
                                                      );
                                                    },
                                                    itemBuilder:
                                                        (context, suggestion) {
                                                      print('this is sugetion $suggestion');
                                                      return Visibility(
                                                        visible: _searchController
                                                            .text !=
                                                            "",
                                                        child: suggestion == null? Container(
                                                          height: 50,
                                                          child: Center(
                                                              child: Text(
                                                                AppLocalizations.of(
                                                                    context)
                                                                    .filter_screen_loading_suggestions,
                                                                style: TextStyle(
                                                                    color: MyTheme
                                                                        .dark_grey),
                                                              )),
                                                        ) : ListTile(
                                                          onTap: () {
                                                            Navigator.push(context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) {
                                                                      return ProductDetails(
                                                                          id: suggestion
                                                                              .id,
                                                                        stock: suggestion.stock,
                                                                      );
                                                                    }))
                                                                .then((value) {
                                                              onPopped(value);
                                                            });
                                                          },
                                                          contentPadding:
                                                          EdgeInsets.only(
                                                              top: 5),
                                                          dense: true,
                                                          leading: Image.network(
                                                            suggestion.pictures[0]
                                                                .url, // Replace with the actual URL of your image
                                                            width:
                                                            40, // Adjust the width as needed
                                                            height:
                                                            40, // Adjust the height as needed
                                                            fit: BoxFit.cover,
                                                          ),
                                                          title: RichText(
                                                            text: TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                  text: suggestion
                                                                      .name,
                                                                  style: TextStyle(
                                                                      color: MyTheme
                                                                          .secondary),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          subtitle: RichText(
                                                            text: TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                  text: suggestion
                                                                      .sale_price !=
                                                                      suggestion
                                                                          .price
                                                                      ? "৳" +
                                                                      suggestion
                                                                          .price
                                                                          .toString()
                                                                      : '',
                                                                  style: TextStyle(
                                                                    color: MyTheme
                                                                        .dark_grey,
                                                                    decoration: suggestion
                                                                        .sale_price !=
                                                                        suggestion
                                                                            .price
                                                                        ? TextDecoration
                                                                        .lineThrough
                                                                        : TextDecoration
                                                                        .none,
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                  text: suggestion
                                                                      .sale_price !=
                                                                      suggestion
                                                                          .price
                                                                      ? ' ৳${suggestion.sale_price.toString()}'
                                                                      : "৳" +
                                                                      suggestion
                                                                          .price
                                                                          .toString(),
                                                                  style: TextStyle(
                                                                      color: MyTheme
                                                                          .dark_grey),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    noItemsFoundBuilder: (context) {
                                                      return Container(
                                                        height: 50,
                                                        child: Center(
                                                            child: Text(
                                                                AppLocalizations.of(
                                                                    context)
                                                                    .filter_screen_no_suggestion_available,
                                                                style: TextStyle(
                                                                    color: MyTheme
                                                                        .dark_grey))),
                                                      );
                                                    },
                                                    onSuggestionSelected:
                                                        (suggestion) {
                                                      _searchController.text =
                                                          suggestion.name;
                                                      _searchKey = suggestion.name;
                                                      setState(() {});
                                                      // _onSearchSubmit();
                                                    },
                                                    textFieldConfiguration:
                                                    TextFieldConfiguration(
                                                      onTap: () {},
                                                      controller: _searchController,
                                                      onSubmitted: (txt) {
                                                        _searchKey = txt;
                                                        value.setSearchKey(_searchKey);
                                                        print('navigating to filter');

                                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>Main(pageIndex: 1,)));
                                                      },
                                                      style: TextStyle(
                                                          color: MyTheme.secondary),
                                                      autofocus: false,
                                                      cursorColor:
                                                      MyTheme.secondary,
                                                      decoration: InputDecoration(
                                                          prefixIcon: Icon(
                                                            Icons.search,
                                                            color:
                                                            MyTheme.secondary,
                                                          ),
                                                          suffixIcon: IconButton(
                                                              onPressed: (){
                                                                chooseAndUploadImageForSearchProduct(context);
                                                              },
                                                              icon: Icon(
                                                                Icons.camera_alt,
                                                                color: MyTheme.secondary,
                                                              ),
                                                          ),
                                                          hintText: AppLocalizations
                                                              .of(context)
                                                              .filter_screen_search_here,
                                                          border: InputBorder.none,
                                                          hintStyle: TextStyle(
                                                              fontSize: 14.0,
                                                              color: MyTheme
                                                                  .secondary),
                                                          alignLabelWithHint: true,
                                                          contentPadding:
                                                          EdgeInsets.only(
                                                              left: 30,
                                                              top: 10)),
                                                    ),
                                                  );
                                                }
                                              )),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        8.0,
                                        16.0,
                                        8.0,
                                        0.0,
                                      ),
                                      child: buildHomeCarouselSlider(context),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        8.0,
                                        0.0,
                                        8.0,
                                        0.0,
                                      ),
                                      child:
                                      buildHomeFeaturedCategories(context),
                                    ),
                                  ]),
                                ),
                                SliverList(
                                  delegate: SliverChildListDelegate([
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        16.0,
                                        16.0,
                                        16.0,
                                        0.0,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)
                                                .home_screen_best_selling_products,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: MyTheme.secondary),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                              4.0,
                                              16.0,
                                              8.0,
                                              0.0,
                                            ),
                                            child: buildHomeBestSellingProducts(
                                                context),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                                ),

                                SliverList(
                                  delegate: SliverChildListDelegate([
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        16.0,
                                        16.0,
                                        16.0,
                                        0.0,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)
                                                .home_screen_searched_products,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: MyTheme.secondary),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                              4.0,
                                              16.0,
                                              8.0,
                                              0.0,
                                            ),
                                            child: buildPopularSearchProducts(
                                                context),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                                ),
                                SliverList(
                                  delegate: SliverChildListDelegate([
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        16.0,
                                        16.0,
                                        16.0,
                                        0.0,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)
                                                .home_screen_trending_products,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: MyTheme.secondary),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                              4.0,
                                              16.0,
                                              8.0,
                                              0.0,
                                            ),
                                            child:
                                            buildTrendingProducts(context),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                                ),
                                SliverList(
                                  delegate: SliverChildListDelegate([
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        16.0,
                                        16.0,
                                        16.0,
                                        0.0,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)
                                                .home_screen_hot_deals_products,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: MyTheme.secondary),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                              4.0,
                                              16.0,
                                              8.0,
                                              0.0,
                                            ),
                                            child:
                                            buildHotDealsProducts(context),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                                ),
                                SliverList(
                                  delegate: SliverChildListDelegate([
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        16.0,
                                        16.0,
                                        16.0,
                                        0.0,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)
                                                .home_screen_featured_products,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: MyTheme.secondary),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                              4.0,
                                              16.0,
                                              8.0,
                                              0.0,
                                            ),
                                            child: buildNewArrivalsProducts(
                                                context),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 80,
                                    )
                                  ]),
                                ),
                              ],
                            ),
                          ),
                          Align(
                              alignment: Alignment.center,
                              child: buildProductLoadingContainer())
                        ],
                      )),
                );
              })),
    );
  }


  buildHomeBestSellingProducts(context) {
    if (_isBestSellingProductInitial && _bestSellingProductList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildHomeProductGridShimmer(scontroller: _productScrollController));
    } else if (_bestSellingProductList.length > 0) {
      //snapshot.hasData
      return SingleChildScrollView(
        child: SizedBox(
          height: 250,
          child: ListView.builder(
            itemCount: _bestSellingProductList.length,
            scrollDirection: Axis.horizontal,
            itemExtent: MediaQuery.of(context).size.width / 2.5,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 5, left: 5),
                child: MiniProductCard(
                  preorderAvailable: _bestSellingProductList[index].preorderAvailable,
                  requestAvailable: _bestSellingProductList[index].requestAvailable,
                  id: _bestSellingProductList[index].id,
                  image: _bestSellingProductList[index].pictures[0].url,
                  ratings: _bestSellingProductList[index].ratings,
                  name: _bestSellingProductList[index].name,
                  price: _bestSellingProductList[index].price.toString(),
                  sale_price:
                  _bestSellingProductList[index].sale_price.toString(),
                  slug: _bestSellingProductList[index].slug,
                  reviews: _bestSellingProductList[index].reviews,
                  stock: _bestSellingProductList[index].stock,
                  discount: _bestSellingProductList[index].discount,
                ),
              );
            },
          ),
        ),
      );
    } else if (_totalBestSellingProductData == 0) {
      return Center(
          child: Text(
              AppLocalizations.of(context).common_no_product_is_available));
    } else {
      return Container(); // should never be happening
    }
  }

  buildHomeRecommendedProducts(context) {
    if (_isRecommendedProuctInitial && _recommendedProductList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildProductGridShimmer(scontroller: _productScrollController));
    } else if (_recommendedProductList.length > 0) {
      //snapshot.hasData
      return SingleChildScrollView(
        child: SizedBox(
          height: 250,
          child: ListView.builder(
            itemCount: _recommendedProductList.length,
            scrollDirection: Axis.horizontal,
            itemExtent: MediaQuery.of(context).size.width / 2.5,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 5, left: 5),
                child: MiniProductCard(
                     preorderAvailable: _recommendedProductList[index].preorderAvailable,

                    id: _recommendedProductList[index].id,
                    image: _recommendedProductList[index].pictures[0].url,
                    ratings: _recommendedProductList[index].ratings,
                    name: _recommendedProductList[index].name,
                    price: _recommendedProductList[index].price.toString(),
                    sale_price:
                    _recommendedProductList[index].sale_price.toString(),
                    slug: _recommendedProductList[index].slug,
                    reviews: _recommendedProductList[index].reviews,
                    stock: _recommendedProductList[index].stock,
                    discount:  _recommendedProductList[index].discount,

                ),
              );
            },
          ),
        ),
      );
    } else if (_totalRecommendedProductData == 0) {
      return Center(
          child: Text(
              AppLocalizations.of(context).common_no_product_is_available));
    } else {
      return Container(); // should never be happening
    }
  }

  buildPopularSearchProducts(context) {
    if (_isPopularSearchProductInital &&
        _popularSearchProductList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildProductGridShimmer(scontroller: _productScrollController));
    } else if (_popularSearchProductList.length > 0) {
      //snapshot.hasData
      return SingleChildScrollView(
        child: SizedBox(
          height: 250,
          child: ListView.builder(
            itemCount: _popularSearchProductList.length,
            scrollDirection: Axis.horizontal,
            itemExtent: MediaQuery.of(context).size.width / 2.5,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 5, left: 5),
                child: MiniProductCard(
                  preorderAvailable: _popularSearchProductList[index].preorderAvailable,

                  id: _popularSearchProductList[index].id,
                  image: _popularSearchProductList[index].pictures[0].url,
                  ratings: _popularSearchProductList[index].ratings,
                  name: _popularSearchProductList[index].name,
                  price: _popularSearchProductList[index].price.toString(),
                  sale_price:
                  _popularSearchProductList[index].sale_price.toString(),
                  slug: _popularSearchProductList[index].slug,
                  reviews: _popularSearchProductList[index].reviews,
                  stock: _popularSearchProductList[index].stock,
                  discount: _popularSearchProductList[index].discount,
                ),
              );
            },
          ),
        ),
      );
    } else if (_totalRecommendedProductData == 0) {
      return Center(
          child: Text(
              AppLocalizations.of(context).common_no_product_is_available));
    } else {
      return Container(); // should never be happening
    }
  }

  buildTrendingProducts(context) {
    if (_isTrendingProductInitial && _trendingProductList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildProductGridShimmer(scontroller: _productScrollController));
    } else if (_trendingProductList.length > 0) {
      //snapshot.hasData
      return SingleChildScrollView(
        child: SizedBox(
          height: 250,
          child: ListView.builder(
            itemCount: _trendingProductList.length,
            scrollDirection: Axis.horizontal,
            itemExtent: MediaQuery.of(context).size.width / 2.5,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 5, left: 5),
                child: MiniProductCard(
                  preorderAvailable: _trendingProductList[index].preorderAvailable,

                  id: _trendingProductList[index].id,
                  image: _trendingProductList[index].pictures[0].url,
                  ratings: _trendingProductList[index].ratings,
                  name: _trendingProductList[index].name,
                  price: _trendingProductList[index].price.toString(),
                  sale_price: _trendingProductList[index].sale_price.toString(),
                  slug: _trendingProductList[index].slug,
                  reviews: _trendingProductList[index].reviews,
                  stock: _trendingProductList[index].stock,
                  discount: _trendingProductList[index].discount,
                ),
              );
            },
          ),
        ),
      );
    } else if (_totalTrendingProductData == 0) {
      return Center(
          child: Text(
              AppLocalizations.of(context).common_no_product_is_available));
    } else {
      return Container(); // should never be happening
    }
  }

  buildHotDealsProducts(context) {
    if (_isHotDealsProductInitial && _hotDealsProductList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildProductGridShimmer(scontroller: _productScrollController));
    } else if (_hotDealsProductList.length > 0) {
      //snapshot.hasData
      return SingleChildScrollView(
        child: SizedBox(
          height: 250,
          child: ListView.builder(
            itemCount: _hotDealsProductList.length,
            scrollDirection: Axis.horizontal,
            itemExtent: MediaQuery.of(context).size.width / 2.5,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 5, left: 5),
                child: MiniProductCard(
                                    preorderAvailable: _hotDealsProductList[index].preorderAvailable,

                  id: _hotDealsProductList[index].id,
                  image: _hotDealsProductList[index].pictures[0].url,
                  ratings: _hotDealsProductList[index].ratings,
                  name: _hotDealsProductList[index].name,
                  price: _hotDealsProductList[index].price.toString(),
                  sale_price: _hotDealsProductList[index].sale_price.toString(),
                  slug: _hotDealsProductList[index].slug,
                  reviews: _hotDealsProductList[index].reviews,
                  stock: _hotDealsProductList[index].stock,
                  discount: _hotDealsProductList[index].discount,
                ),
              );
            },
          ),
        ),
      );
    } else if (_totalTrendingProductData == 0) {
      return Center(
          child: Text(
              AppLocalizations.of(context).common_no_product_is_available));
    } else {
      return Container(); // should never be happening
    }
  }

  buildNewArrivalsProducts(context) {
    if (_isNewArrivalsProductInitial && _newArrivalProductList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildProductGridShimmer(scontroller: _productScrollController));
    } else if (_newArrivalProductList.length > 0) {
      //snapshot.hasData
      return SingleChildScrollView(
        child: SizedBox(
          height: 250,
          child: ListView.builder(
            itemCount: _newArrivalProductList.length,
            scrollDirection: Axis.horizontal,
            itemExtent: MediaQuery.of(context).size.width / 2.5,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 5, left: 5),
                child: MiniProductCard(
                                      preorderAvailable: _newArrivalProductList[index].preorderAvailable,

                  id: _newArrivalProductList[index].id,
                  image: _newArrivalProductList[index].pictures[0].url,
                  ratings: _newArrivalProductList[index].ratings,
                  name: _newArrivalProductList[index].name,
                  price: _newArrivalProductList[index].price.toString(),
                  sale_price:
                  _newArrivalProductList[index].sale_price.toString(),
                  slug: _newArrivalProductList[index].slug,
                  reviews: _newArrivalProductList[index].reviews,
                  stock: _newArrivalProductList[index].stock,
                  discount: _newArrivalProductList[index].discount,
                ),
              );
            },
          ),
        ),
      );
    } else if (_newArrivalProductList == 0) {
      return Center(
          child: Text(
              AppLocalizations.of(context).common_no_product_is_available));
    } else {
      return Container(); // should never be happening
    }
  }

  buildHomeFeaturedCategories(context) {
    if (_isCategoryInitial && _featuredCategoryList.length == 0) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Padding(
                padding: const EdgeInsets.only(right: 8.0, top: 8),
                child: ClipOval(
                    child: ShimmerHelper()
                        .buildBasicShimmer(height: 58.0, width: 58.0))),
            Padding(
                padding: const EdgeInsets.only(right: 8.0, top: 8),
                child: ClipOval(
                    child: ShimmerHelper()
                        .buildBasicShimmer(height: 58.0, width: 58.0))),
            Padding(
                padding: const EdgeInsets.only(right: 8.0, top: 8),
                child: ClipOval(
                    child: ShimmerHelper()
                        .buildBasicShimmer(height: 58.0, width: 58.0))),
            Padding(
                padding: const EdgeInsets.only(right: 8.0, top: 8),
                child: ClipOval(
                    child: ShimmerHelper()
                        .buildBasicShimmer(height: 58.0, width: 58.0))),
            Padding(
                padding: const EdgeInsets.only(right: 8.0, top: 8),
                child: ClipOval(
                    child: ShimmerHelper()
                        .buildBasicShimmer(height: 58.0, width: 58.0))),
            Padding(
                padding: const EdgeInsets.only(right: 8.0, top: 8),
                child: ClipOval(
                    child: ShimmerHelper()
                        .buildBasicShimmer(height: 58.0, width: 58.0))),
          ],
        ),
      );
    } else if (_featuredCategoryList.length > 0) {
      //snapshot.hasData
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_featuredCategoryList.length, (index) {
            return Consumer<CategoryPassingController>(
              builder: (widget, value, child) {
                return GestureDetector(
                  onTap: () {
                    if (_featuredCategoryList[index]?.itemType == "type") {

                      value.setTypeKey(_featuredCategoryList[index]?.slug);

                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return Main(pageIndex: 1,);
                      }));
                    } else if (_featuredCategoryList[index]?.itemType ==
                        "category") {

                      value.setCategoryKey(_featuredCategoryList[index]?.slug);

                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return Main(pageIndex: 1,);
                      }));
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          String slug = _featuredCategoryList[index]?.slug;

                          switch (slug) {
                            case 'BeautyTips()':
                              return BeautyTips();
                            case 'FeedList()':
                              return FeedList();
                            case 'Appointment()':
                              return Appointment();
                            default:
                              return Container();
                          }
                        }),
                      );
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 5),
                    padding: EdgeInsets.only(top: 16),
                    height: 120,
                    width: 76,
                    child: Column(
                      children: [
                        Container(
                          height: 56,
                          width: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: ClipOval(
                            child: _featuredCategoryList[index]?.icon != null
                                ? FadeInImage.assetNetwork(
                              image: _featuredCategoryList[index]?.icon,
                              placeholder: 'assets/placeholder.png',
                              fit: BoxFit.cover,
                              height: 56,
                              width: 56,
                            )
                                : Image.asset(
                              'assets/placeholder.png',
                              fit: BoxFit.cover,
                              height: 56,
                              width: 56,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            _featuredCategoryList[index]?.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: MyTheme.secondary,
                              fontWeight: FontWeight.w300,
                              fontSize: 12,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
            );
          }),
        ),
      );
    } else if (!_isCategoryInitial && _featuredCategoryList.length == 0) {
      return Container(
          height: 120,
          child: Center(
              child: Text(
                AppLocalizations.of(context).home_screen_no_category_found,
                style: TextStyle(color: MyTheme.secondary),
              )));
    } else {
      // should not be happening
      return Container(
        height: 120,
      );
    }
  }

  buildHomeMenuRow(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Filter(
                  type: "new-arrivals",
                );
              }));
            },
            child: Container(
              padding: EdgeInsets.only(top: 8),
              height: 120,
              width: MediaQuery.of(context).size.width / 5 - 4,
              child: Column(
                children: [
                  Container(
                    height: 56,
                    width: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        "assets/arrivals.jpg",
                        fit: BoxFit
                            .cover, // You can adjust this based on your needs
                        height: 56,
                        width: 56,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      "New Arrivals",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context)
                              .buttonTheme
                              .colorScheme
                              .secondary,
                          fontWeight: FontWeight.w300,
                          fontSize: 13),
                    ),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Filter(
                  category: "skin-care",
                );
              }));
            },
            child: Container(
              padding: EdgeInsets.only(top: 8),
              height: 120,
              width: MediaQuery.of(context).size.width / 5 - 4,
              child: Column(
                children: [
                  Container(
                    height: 56,
                    width: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        "assets/skin-care.jpeg",
                        fit: BoxFit
                            .cover, // You can adjust this based on your needs
                        height: 56,
                        width: 56,
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text("Skin Care",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: MyTheme.secondary,
                              fontWeight: FontWeight.w300,
                              fontSize: 13))),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Filter(
                  category: "hair-care",
                );
              }));
            },
            child: Container(
              padding: EdgeInsets.only(top: 8),
              height: 120,
              width: MediaQuery.of(context).size.width / 5 - 4,
              child: Column(
                children: [
                  Container(
                    height: 56,
                    width: 56,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color:
                        Theme.of(context).buttonTheme.colorScheme.primary,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(1.0),
                            spreadRadius: 0,
                            blurRadius: 9,
                            offset: Offset(0, 1),
                          ),
                        ]),
                    child: ClipOval(
                      child: Image.asset(
                        "assets/haircare.jpeg",
                        fit: BoxFit
                            .cover, // You can adjust this based on your needs
                        height: 56,
                        width: 56,
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text("Hair Care",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: MyTheme.secondary,
                              fontWeight: FontWeight.w300,
                              fontSize: 13))),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Filter(
                  category: "make-up",
                );
              }));
            },
            child: Container(
              padding: EdgeInsets.only(top: 8),
              height: 120,
              width: MediaQuery.of(context).size.width / 5 - 4,
              child: Column(
                children: [
                  Container(
                    height: 56,
                    width: 56,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color:
                        Theme.of(context).buttonTheme.colorScheme.primary,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(1.0),
                            spreadRadius: 0,
                            blurRadius: 9,
                            offset: Offset(0, 1),
                          ),
                        ]),
                    child: ClipOval(
                      child: Image.asset(
                        "assets/makeup.jpeg",
                        fit: BoxFit
                            .cover, // You can adjust this based on your needs
                        height: 56,
                        width: 56,
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text("Make Up",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: MyTheme.secondary,
                              fontWeight: FontWeight.w300,
                              fontSize: 13))),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Filter(
                  category: "supplements",
                );
              }));
            },
            child: Container(
              padding: EdgeInsets.only(top: 8),
              height: 120,
              width: MediaQuery.of(context).size.width / 5 - 4,
              child: Column(
                children: [
                  Container(
                    height: 56,
                    width: 56,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color:
                        Theme.of(context).buttonTheme.colorScheme.primary,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(1.0),
                            spreadRadius: 0,
                            blurRadius: 9,
                            offset: Offset(0, 1),
                          ),
                        ]),
                    child: ClipOval(
                      child: Image.asset(
                        "assets/Supplements.jpeg",
                        fit: BoxFit
                            .cover, // You can adjust this based on your needs
                        height: 56,
                        width: 56,
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text("Supplements",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: MyTheme.secondary,
                              fontWeight: FontWeight.w300,
                              fontSize: 13))),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Filter(
                  category: "daiso-japan",
                );
              }));
            },
            child: Container(
              padding: EdgeInsets.only(top: 8),
              height: 120,
              width: MediaQuery.of(context).size.width / 5 - 4,
              child: Column(
                children: [
                  Container(
                    height: 56,
                    width: 56,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color:
                        Theme.of(context).buttonTheme.colorScheme.primary,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(1.0),
                            spreadRadius: 0,
                            blurRadius: 9,
                            offset: Offset(0, 1),
                          ),
                        ]),
                    //<div style="padding:3px">hjgh</div>
                    child: ClipOval(
                      child: Image.asset(
                        "assets/daiso-japan.png",
                        fit: BoxFit
                            .cover, // You can adjust this based on your needs
                        height: 56,
                        width: 56,
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 8, right: 5, left: 5),
                      child: Text("Daiso Japan",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: MyTheme.secondary,
                              fontWeight: FontWeight.w300,
                              fontSize: 13))),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Filter(
                  category: "green-tea",
                  
                );
              }));
            },
            child: Container(
              padding: EdgeInsets.only(top: 8),
              height: 120,
              width: MediaQuery.of(context).size.width / 5 - 4,
              child: Column(
                children: [
                  Container(
                    height: 56,
                    width: 56,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color:
                        Theme.of(context).buttonTheme.colorScheme.primary,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(1.0),
                            spreadRadius: 0,
                            blurRadius: 9,
                            offset: Offset(0, 1),
                          ),
                        ]),
                    //<div style="padding:3px">hjgh</div>
                    child: ClipOval(
                      child: Image.asset(
                        "assets/green-tea.png",
                        fit: BoxFit
                            .cover, // You can adjust this based on your needs
                        height: 56,
                        width: 56,
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text("Green Tea",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: MyTheme.secondary,
                              fontWeight: FontWeight.w300,
                              fontSize: 13))),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return BeautyTips();
              }));
            },
            child: Container(
              padding: EdgeInsets.only(top: 8),
              height: 120,
              width: MediaQuery.of(context).size.width / 5 - 4,
              child: Column(
                children: [
                  Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Image.asset(
                          "assets/beauty-tips-new.png",
                          //color: Colors.white,
                        ),
                      )),
                  Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text("Beauty Tips",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: MyTheme.secondary,
                              fontWeight: FontWeight.w300,
                              fontSize: 13))),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return FeedList();
              }));
            },
            child: Container(
              padding: EdgeInsets.only(top: 8),
              height: 120,
              width: MediaQuery.of(context).size.width / 5 - 4,
              child: Column(
                children: [
                  Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Image.asset(
                          "assets/community-new.png",
                          // color: Colors.white,
                        ),
                      )),
                  Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text("Community",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: MyTheme.secondary,
                              fontWeight: FontWeight.w300,
                              fontSize: 13))),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Appointment();
              }));
            },
            child: Container(
              padding: EdgeInsets.only(top: 8),
              height: 120,
              width: MediaQuery.of(context).size.width / 5 - 4,
              child: Column(
                children: [
                  Container(
                    height: 56,
                    width: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),

                    ),
                    //<div style="padding:3px">hjgh</div>
                    child: ClipOval(
                      child: Image.asset(
                        "assets/expert2.jpg",
                        fit: BoxFit
                            .cover, // You can adjust this based on your needs
                        height: 56,
                        width: 56,
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text("Appointment",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: MyTheme.secondary,
                              fontWeight: FontWeight.w300,
                              fontSize: 13))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildHomeCarouselSlider(context) {
    if (_isCarouselInitial && _carouselImageList.length == 0) {
      return Padding(
        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
        child: Shimmer.fromColors(
          baseColor: MyTheme.light_grey,
          highlightColor: MyTheme.light_grey,
          child: Container(
            height: 120,
            width: double.infinity,
            color: Colors.white,
          ),
        ),
      );
    } else if (_carouselImageList.length > 0) {
      return CarouselSlider(
        options: CarouselOptions(
            aspectRatio: 2.67,
            viewportFraction: 1,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 5),
            autoPlayAnimationDuration: Duration(milliseconds: 1000),
            autoPlayCurve: Curves.easeInCubic,
            enlargeCenterPage: true,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index, reason) {
              setState(() {
                _current_slider = index;
              });
            }),
        items: _carouselImageList.map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Stack(
                children: <Widget>[
                  Container(
                      width: double.infinity,
                      height: 200,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/placeholder.png',
                            //placeholder: 'assets/placeholder.png',
                            image: i ?? '',
                            fit: BoxFit.fill,
                          ))),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _carouselImageList.map((url) {
                        int index = _carouselImageList.indexOf(url);
                        return Container(
                          width: 16.0,
                          height: 6.0,
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            // shape: BoxShape.circle,
                            color: _current_slider == index
                                ? MyTheme.secondary
                                : Color.fromRGBO(112, 112, 112, .3),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              );
            },
          );
        }).toList(),
      );
    } else if (!_isCarouselInitial && _carouselImageList.length == 0) {
      return Container(
          height: 120,
          child: Center(
              child: Text(
                AppLocalizations.of(context).home_screen_no_carousel_image_found,
                style: TextStyle(color: MyTheme.secondary),
              )));
    } else {
      // should not be happening
      return Container(
        height: 120,
      );
    }
  }

  AppBar buildAppBar(double statusBarHeight, BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,

      leading: GestureDetector(
        onTap: () {
          _scaffoldKey.currentState.openDrawer();
        },
        child: widget.show_back_button
            ? Builder(
          builder: (context) => IconButton(
              icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
              onPressed: () {
                if (!widget.go_back) {
                  return;
                }
                return Navigator.of(context).pop();
              }),
        )
            : Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 18.0, horizontal: 0.0),
            child: Container(
              child: Image.asset(
                'assets/hamburger.png',
                height: 16,
                //color: MyTheme.dark_grey,
                color: MyTheme.dark_grey,
              ),
            ),
          ),
        ),
      ),

      title: Container(
        height: kToolbarHeight +
            statusBarHeight -
            (MediaQuery.of(context).viewPadding.top > 40 ? 16.0 : 16.0),
        //MediaQuery.of(context).viewPadding.top is the statusbar height, with a notch phone it results almost 50, without a notch it shows 24.0.For safety we have checked if its greater than thirty
        child: Container(
          child: Padding(
              padding: app_language_rtl.$
                  ? const EdgeInsets.only(top: 14.0, bottom: 14, left: 12)
                  : const EdgeInsets.only(top: 14.0, bottom: 14, right: 12),
              // when notification bell will be shown , the right padding will cease to exist.
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      margin: EdgeInsets.only(
                        //left: MediaQuery.of(context).size.width / 3.7),
                          left: 15),
                      child: Image.asset(
                        "assets/login_registration_form_logo.png",
                      )),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return Filter();
                            }));
                      },
                      child: Container(
                          padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.blueGrey[50]),
                          child: Row(
                            children: [
                            ],
                          )))
                ],
              )),
        ),
      ),



      elevation: 0.0,
      titleSpacing: 0,


      actions: <Widget>[

        Container(
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
          child:
          is_logged_in.$ == false ?

          GestureDetector(
            onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=> Login())),
            child: Row(
              children: [
                Text("Hi, ",
                  style: TextStyle(
                    color: MyTheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),

                ),
                Text("User",
                  style: TextStyle(
                      color: MyTheme.secondary,
                      fontWeight: FontWeight.w600
                  ),
                ),
                SizedBox(width: 5,),
                Icon(Icons.account_circle_outlined, color: MyTheme.secondary,),

              ],
            ),
          )
              :
          GestureDetector(
            onTap: (){
              //Navigator.push(context, MaterialPageRoute(builder: (_)=> Profile()));
              Navigator.push(context, MaterialPageRoute(builder: (_)=> Main(
                pageIndex: 3,
              )));
            },
            child: Row(
              children: [
                Text("Hi, ",
                  style: TextStyle(
                    color: MyTheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),

                ),
                Text("${user_name.$}",
                  style: TextStyle(
                      color: MyTheme.secondary,
                      fontWeight: FontWeight.w600
                  ),
                ),


                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: MyTheme.secondary,
                      width: 2 * 0.8, //8
                    ),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                        //TODO:change the avatar
                        image: avatar_original.$ != null ? NetworkImage("${avatar_original.$}") : AssetImage('assets/placeholder.png') //TODO:change the avatar
                    ),
                  ),

                ),
              ],
            ),
          ),
        ),




      ],
    );
  }

  buildHomeSearchBox(BuildContext context) {
    return TextField(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Filter();
        }));
      },
      autofocus: false,
      decoration: InputDecoration(
          hintText: AppLocalizations.of(context).home_screen_search,
          hintStyle: TextStyle(fontSize: 12.0, color: MyTheme.light_grey),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyTheme.light_grey, width: 0.5),
            borderRadius: const BorderRadius.all(
              const Radius.circular(16.0),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyTheme.light_grey, width: 1.0),
            borderRadius: const BorderRadius.all(
              const Radius.circular(16.0),
            ),
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.search,
              color: MyTheme.light_grey,
              size: 20,
            ),
          ),
          contentPadding: EdgeInsets.all(0.0)),
    );
  }

  Container buildProductLoadingContainer() {
    return Container(
      height: _showProductLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(_totalFeaturedProductData == _featuredProductList.length
            ? AppLocalizations.of(context).common_no_more_products
            : AppLocalizations.of(context).common_loading_more_products),
      ),
    );
  }
}
