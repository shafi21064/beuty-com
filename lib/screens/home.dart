import 'package:kirei/custom/CommonFunctoins.dart';
import 'package:kirei/data_model/shop_details_response.dart';
import 'package:kirei/helpers/addons_helper.dart';
import 'package:kirei/helpers/business_setting_helper.dart';
import 'package:kirei/my_theme.dart';
import 'package:kirei/providers/locale_provider.dart';
import 'package:kirei/screens/appointment.dart';
import 'package:kirei/screens/beauty_tips.dart';
import 'package:kirei/screens/filter.dart';
import 'package:kirei/screens/flash_deal_list.dart';
import 'package:kirei/screens/newsfeed.dart';
import 'package:kirei/screens/personal_recommendation.dart';
import 'package:kirei/screens/todays_deal_products.dart';
import 'package:kirei/screens/top_selling_products.dart';
import 'package:kirei/screens/category_products.dart';
import 'package:kirei/screens/category_list.dart';
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
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:kirei/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'package:kirei/ui_elements/product_card.dart';
import 'package:kirei/helpers/shimmer_helper.dart';
import 'package:kirei/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'BeautyBooks.dart';
import 'kireiYT.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title, this.show_back_button = false, go_back = true})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  bool show_back_button;
  bool go_back;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _current_slider = 0;
  ScrollController _productScrollController;
  ScrollController _mainScrollController = ScrollController();

  AnimationController pirated_logo_controller;
  Animation pirated_logo_animation;

  var _carouselImageList = [];
  var _featuredCategoryList = [];
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
    if (AppConfig.purchase_code == "") {
      initPiratedAnimation();
    }

    fetchAll();

    _mainScrollController.addListener(() {
      //print("position: " + _xcrollController.position.pixels.toString());
      //print("max: " + _xcrollController.position.maxScrollExtent.toString());

      if (_mainScrollController.position.pixels ==
          _mainScrollController.position.maxScrollExtent) {
        setState(() {
          _productPage++;
        });
        _showProductLoadingContainer = true;
        fetchFeaturedProducts();
        fetchRecommendedProducts();
        fetchPopularSearchedProducts();
        fetchTrendingProducts();
        fetchBestSellingProducts();
        fetchHotDealsProducts();
        fetchNewArrivalsProducts();
      }
    });
  }

  fetchAll() {
    fetchCarouselImages();
    fetchFeaturedCategories();
    fetchFeaturedProducts();
    fetchRecommendedProducts();
    fetchPopularSearchedProducts();
    fetchTrendingProducts();
    fetchBestSellingProducts();
    fetchHotDealsProducts();
    fetchNewArrivalsProducts();

    // AddonsHelper().setAddonsData();
    // BusinessSettingHelper().setBusinessSettingData();
  }

  fetchCarouselImages() async {
    var carouselResponse = await SlidersRepository().getSliders();
    carouselResponse.sliders.forEach((slider) {
      _carouselImageList.add(slider.photo);
    });
    _isCarouselInitial = false;
    setState(() {});
  }

  fetchFeaturedCategories() async {
    var categoryResponse =
        await CategoryRepository().getHomeFeaturedCategories();
    print(categoryResponse);
    // print("featuredCategory-------->" + categoryResponse.categories.toString());

    // _featuredCategoryList.addAll(categoryResponse.categories);
    _isCategoryInitial = false;
    setState(() {});
  }

  fetchBestSellingProducts() async {
    var productResponse = await ProductRepository().getBestSellingProducts();
    _bestSellingProductList.addAll(productResponse.products);
    print("recomeened-------->${_bestSellingProductList}");
    _isBestSellingProductInitial = false;
    _totalBestSellingProductData = productResponse.products.length;
    _showProductLoadingContainer = false;
    setState(() {});
  }

  fetchFeaturedProducts() async {
    var productResponse = await ProductRepository().getFeaturedProducts();

    _featuredProductList.addAll(productResponse.products);
    // print(_featuredProductList);
    _isFeaturedProuctInitial = false;
    _totalFeaturedProductData = productResponse.products.length;
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

  fetchHotDealsProducts() async {
    var productResponse = await ProductRepository().getHotDealsProducts();
    _hotDealsProductList.addAll(productResponse.products);
    _isHotDealsProductInitial = false;
    _totalHotDealsProductData = productResponse.products.length;
    _showProductLoadingContainer = false;
    setState(() {});
  }

  reset() {
    _carouselImageList.clear();
    _featuredCategoryList.clear();
    _isCarouselInitial = true;
    _isCategoryInitial = true;

    setState(() {});

    resetProductList();
  }

  fetchNewArrivalsProducts() async {
    var productResponse = await ProductRepository().getNewArrivalsProducts();
    _newArrivalProductList.addAll(productResponse.products);
    _isNewArrivalsProductInitial = false;
    _totalNewArrivalsProductData = productResponse.products.length;
    _showProductLoadingContainer = false;
    setState(() {});
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

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    //print(MediaQuery.of(context).viewPadding.top);
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
                                    AppConfig.purchase_code == ""
                                        ? Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                              8.0,
                                              16.0,
                                              8.0,
                                              0.0,
                                            ),
                                            child: Container(
                                              height: 140,
                                              color: Colors.black,
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                      left: 20,
                                                      top: 0,
                                                      child: AnimatedBuilder(
                                                          animation:
                                                              pirated_logo_animation,
                                                          builder:
                                                              (context, child) {
                                                            return Image.asset(
                                                              "assets/pirated_square.png",
                                                              height:
                                                                  pirated_logo_animation
                                                                      .value,
                                                              color:
                                                                  Colors.white,
                                                            );
                                                          })),
                                                  Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 24.0,
                                                              left: 24,
                                                              right: 24),
                                                      child: Text(
                                                        "This is a pirated app. Do not use this. It may have security issues.",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        8.0,
                                        16.0,
                                        8.0,
                                        0.0,
                                      ),
                                      child: SizedBox(
                                        height: 45,
                                        child: TextField(
                                          textAlign: TextAlign
                                              .start, // Center align the text
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: MyTheme
                                                .white, // Set the background color to white
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: BorderSide(
                                                  color: MyTheme
                                                      .light_grey), // Set the border color
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: BorderSide(
                                                  color: MyTheme
                                                      .light_grey), // Set the border color for focused state
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: BorderSide(
                                                  color: MyTheme
                                                      .light_grey), // Set the border color for enabled state
                                            ),
                                            contentPadding: EdgeInsets.only(
                                                top: 12,
                                                left:
                                                    12), // Add padding to the top
                                            hintText: "Search with AI & Images",

                                            suffixIcon: const Icon(
                                                Icons.search_outlined),
                                            alignLabelWithHint:
                                                true, // Center align the placeholder
                                          ),
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
                                      // child: buildHomeMenuRow(context),
                                    ),
                                  ]),
                                ),
                                // SliverList(
                                //   delegate: SliverChildListDelegate([
                                //     Padding(
                                //       padding: const EdgeInsets.fromLTRB(
                                //         16.0,
                                //         8.0,
                                //         16.0,
                                //         0.0,
                                //       ),
                                //       child: Column(
                                //         crossAxisAlignment:
                                //             CrossAxisAlignment.start,
                                //         children: [
                                //           Text(
                                //             AppLocalizations.of(context)
                                //                 .home_screen_featured_categories,
                                //             style: GoogleFonts.ubuntu(
                                //                 fontSize: 16,
                                //                 color: Theme.of(context)
                                //                     .buttonTheme
                                //                     .colorScheme
                                //                     .primary),
                                //           ),
                                //         ],
                                //       ),
                                //     ),
                                //   ]),
                                // ),
                                // SliverToBoxAdapter(
                                //   child: Padding(
                                //     padding: const EdgeInsets.fromLTRB(
                                //       16.0,
                                //       8.0,
                                //       0.0,
                                //       0.0,
                                //     ),
                                //     child: SizedBox(
                                //       height: 172,
                                //       child:
                                //           buildHomeFeaturedCategories(context),
                                //     ),
                                //   ),
                                // ),
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
                                                .home_screen_recommended_products,
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
                                            child: buildHomeRecommendedProducts(
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

  // buildHomeFeaturedCategories(context) {
  //   if (_isCategoryInitial && _featuredCategoryList.length == 0) {
  //     return Row(
  //       children: [
  //         Padding(
  //             padding: const EdgeInsets.only(right: 8.0),
  //             child: ShimmerHelper().buildBasicShimmer(
  //                 height: 120.0,
  //                 width: (MediaQuery.of(context).size.width - 32) / 3)),
  //         Padding(
  //             padding: const EdgeInsets.only(right: 8.0),
  //             child: ShimmerHelper().buildBasicShimmer(
  //                 height: 120.0,
  //                 width: (MediaQuery.of(context).size.width - 32) / 3)),
  //         Padding(
  //             padding: const EdgeInsets.only(right: 0.0),
  //             child: ShimmerHelper().buildBasicShimmer(
  //                 height: 120.0,
  //                 width: (MediaQuery.of(context).size.width - 32) / 3)),
  //       ],
  //     );
  //   } else if (_featuredCategoryList.length > 0) {
  //     //snapshot.hasData
  //     return ListView.builder(
  //         scrollDirection: Axis.horizontal,
  //         itemCount: _featuredCategoryList.length,
  //         itemExtent: 120,
  //         itemBuilder: (context, index) {
  //           return Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 3),
  //             child: GestureDetector(
  //               onTap: () {
  //                 Navigator.push(context, MaterialPageRoute(builder: (context) {
  //                   return Filter(
  //                     // category_id: _featuredCategoryList[index].id,
  //                     category: _featuredCategoryList[index].name,
  //                   );
  //                 }));
  //               },
  //               child: Card(
  //                 clipBehavior: Clip.antiAliasWithSaveLayer,
  //                 // shape: RoundedRectangleBorder(
  //                 //   side: new BorderSide(color: MyTheme.light_grey, width: 0.0),
  //                 //   borderRadius: BorderRadius.circular(16.0),
  //                 // ),
  //                 // elevation: 77,
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: <Widget>[
  //                     Container(
  //                         //width: 100,

  //                         height: 120,
  //                         child: ClipRRect(
  //                             // borderRadius: BorderRadius.vertical(
  //                             //     top: Radius.circular(16),
  //                             //     bottom: Radius.zero),

  //                             child: _featuredCategoryList[index].banner == ''
  //                                 ? Image.asset(
  //                                     'assets/app_logo.png',
  //                                     fit: BoxFit.fitWidth,
  //                                   )
  //                                 : FadeInImage.assetNetwork(
  //                                     placeholder: 'assets/placeholder.png',
  //                                     image:
  //                                         _featuredCategoryList[index].banner,
  //                                     fit: BoxFit.fitWidth,
  //                                   ))),
  //                     Padding(
  //                       padding: EdgeInsets.fromLTRB(8, 8, 8, 4),
  //                       child: Container(
  //                         height: 32,
  //                         child: Text(
  //                           _featuredCategoryList[index].name,
  //                           textAlign: TextAlign.center,
  //                           overflow: TextOverflow.ellipsis,
  //                           maxLines: 2,
  //                           style: TextStyle(
  //                               fontSize: 11, color: MyTheme.secondary),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           );
  //         });
  //   } else if (!_isCategoryInitial && _featuredCategoryList.length == 0) {
  //     return Container(
  //         height: 120,
  //         child: Center(
  //             child: Text(
  //           AppLocalizations.of(context).home_screen_no_category_found,
  //           style: TextStyle(color: MyTheme.secondary),
  //         )));
  //   } else {
  //     // should not be happening
  //     return Container(
  //       height: 120,
  //     );
  //   }
  // }

  buildHomeBestSellingProducts(context) {
    if (_isBestSellingProductInitial && _bestSellingProductList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildProductGridShimmer(scontroller: _productScrollController));
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

  buildHomeFeaturedProducts(context) {
    if (_isFeaturedProuctInitial && _featuredProductList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildProductGridShimmer(scontroller: _productScrollController));
    } else if (_featuredProductList.length > 0) {
      //snapshot.hasData
      return SingleChildScrollView(
        child: SizedBox(
          height: 250,
          child: ListView.builder(
            itemCount: _featuredProductList.length,
            scrollDirection: Axis.horizontal,
            itemExtent: MediaQuery.of(context).size.width / 2.5,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 5, left: 5),
                child: MiniProductCard(
                  id: _featuredProductList[index].id,
                  image: _featuredProductList[index].pictures[0].url,
                  ratings: _featuredProductList[index].ratings,
                  name: _featuredProductList[index].name,
                  price: _featuredProductList[index].price.toString(),
                  sale_price: _featuredProductList[index].sale_price.toString(),
                  slug: _featuredProductList[index].slug,
                  reviews: _featuredCategoryList[index].reviews,
                  stock: _featuredCategoryList[index].stock,
                ),
              );
            },
          ),
        ),
      );
      // return GridView.builder(
      //   // 2
      //   //addAutomaticKeepAlives: true,
      //   itemCount: _featuredProductList.length,
      //   controller: _productScrollController,
      //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //       crossAxisCount: 2,
      //       crossAxisSpacing: 10,
      //       mainAxisSpacing: 10,
      //       childAspectRatio: 0.618),
      //   padding: EdgeInsets.all(8),
      //   physics: NeverScrollableScrollPhysics(),
      //   shrinkWrap: true,
      //   itemBuilder: (context, index) {
      //     // 3
      //     return ProductCard(
      //       id: _featuredProductList[index].id,
      //       image: _featuredProductList[index].pictures[0].url,
      //       ratings: _featuredProductList[index].ratings,
      //       name: _featuredProductList[index].name,
      //       price: _featuredProductList[index].price.toString(),
      //       sale_price: _featuredProductList[index].sale_price.toString(),
      //       slug:_featuredProductList[index].slug,
      //     );
      //   },
      // );
    } else if (_totalFeaturedProductData == 0) {
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
                  id: _trendingProductList[index].id,
                  image: _trendingProductList[index].pictures[0].url,
                  ratings: _trendingProductList[index].ratings,
                  name: _trendingProductList[index].name,
                  price: _trendingProductList[index].price.toString(),
                  sale_price: _trendingProductList[index].sale_price.toString(),
                  slug: _trendingProductList[index].slug,
                  reviews: _trendingProductList[index].reviews,
                  stock: _trendingProductList[index].stock,
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
                  id: _hotDealsProductList[index].id,
                  image: _hotDealsProductList[index].pictures[0].url,
                  ratings: _hotDealsProductList[index].ratings,
                  name: _hotDealsProductList[index].name,
                  price: _hotDealsProductList[index].price.toString(),
                  sale_price: _hotDealsProductList[index].sale_price.toString(),
                  slug: _hotDealsProductList[index].slug,
                  reviews: _hotDealsProductList[index].reviews,
                  stock: _hotDealsProductList[index].stock,
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
      return Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 32) / 3)),
          Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 32) / 3)),
          Padding(
              padding: const EdgeInsets.only(right: 0.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 32) / 3)),
        ],
      );
    } else if (_featuredCategoryList.length > 0) {
      //snapshot.hasData
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_featuredCategoryList.length, (index) {
            return GestureDetector(
              onTap: () {
                if (_featuredCategoryList[index].type == "type") {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Filter(
                      type: _featuredCategoryList[index]?.slug,
                    );
                  }));
                } else if (_featuredCategoryList[index].type == "category") {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Filter(
                      category: _featuredCategoryList[index]?.slug,
                    );
                  }));
                } else {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return _featuredCategoryList[index]?.slug;
                  }));
                }
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
                        child: FadeInImage.assetNetwork(
                          image: _featuredCategoryList[index]?.icon,
                          placeholder: 'assets/placeholder.png',
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
                          color: Theme.of(context)
                              .buttonTheme
                              .colorScheme
                              .secondary,
                          fontWeight: FontWeight.w300,
                          fontSize: 13,
                        ),
                      ),
                    )
                  ],
                ),
              ),
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
                      // color:
                      //     Theme.of(context).buttonTheme.colorScheme.primary,
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.grey.withOpacity(1.0),
                      //     spreadRadius: 0,
                      //     blurRadius: 9,
                      //     offset: Offset(0, 1),
                      //   ),
                      // ]
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
                    //<div style="padding:3px">hjgh</div>
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
                    //<div style="padding:3px">hjgh</div>
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
                        // color:
                        //     Theme.of(context).buttonTheme.colorScheme.primary,
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.grey.withOpacity(1.0),
                        //     spreadRadius: 0,
                        //     blurRadius: 9,
                        //     offset: Offset(0, 1),
                        //   ),
                        // ],
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
                        // color:
                        //     Theme.of(context).buttonTheme.colorScheme.primary,
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.grey.withOpacity(1.0),
                        //     spreadRadius: 0,
                        //     blurRadius: 9,
                        //     offset: Offset(0, 1),
                        //   ),
                        // ]
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
                      // color:
                      //     Theme.of(context).buttonTheme.colorScheme.primary,
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.grey.withOpacity(1.0),
                      //     spreadRadius: 0,
                      //     blurRadius: 9,
                      //     offset: Offset(0, 1),
                      //   ),
                      // ]
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
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/placeholder_rectangle.png',
                            image: i,
                            fit: BoxFit.cover,
                          ))),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _carouselImageList.map((url) {
                        int index = _carouselImageList.indexOf(url);
                        return Container(
                          width: 7.0,
                          height: 7.0,
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _current_slider == index
                                ? MyTheme.white
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
                          left: MediaQuery.of(context).size.width / 3.7),
                      child: Image.asset(
                        "assets/logo.png",
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
                              //Text('Search ',style: TextStyle(color: Colors.blueGrey),),
                              // Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: Icon(
                              //     Icons.search_sharp,
                              //     color: Colors.blueGrey,
                              //   ),
                              // ),
                            ],
                          )))
                ],
              )),
        ),
      ),
      elevation: 0.0,
      titleSpacing: 0,
      actions: <Widget>[
        InkWell(
          onTap: () {
            ToastComponent.showDialog(
                AppLocalizations.of(context).common_coming_soon, context,
                gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
          },
          child: Visibility(
            visible: false,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 18.0, horizontal: 12.0),
              child: Image.asset(
                'assets/bell.png',
                height: 16,
                color: MyTheme.dark_grey,
              ),
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
