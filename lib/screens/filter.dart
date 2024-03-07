import 'package:kirei/app_config.dart';
import 'package:kirei/data_model/feature_category_response.dart';
import 'package:kirei/my_theme.dart';
import 'package:kirei/providers/category_passing_controller.dart';
import 'package:kirei/repositories/skin_types_repository.dart';
import 'package:kirei/screens/main.dart';
import 'package:kirei/screens/product_details.dart';
import 'package:kirei/screens/seller_details.dart';
import 'package:kirei/ui_sections/drawer.dart';
import 'package:flutter/material.dart';
import 'package:kirei/ui_elements/product_card.dart';
import 'package:kirei/ui_elements/shop_square_card.dart';
import 'package:kirei/ui_elements/brand_square_card.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:kirei/custom/toast_component.dart';
import 'package:kirei/repositories/category_repository.dart';
import 'package:kirei/repositories/brand_repository.dart';
import 'package:kirei/repositories/shop_repository.dart';
import 'package:kirei/helpers/reg_ex_inpur_formatter.dart';
import 'package:kirei/repositories/product_repository.dart';
import 'package:kirei/helpers/shimmer_helper.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kirei/repositories/search_repository.dart';
import 'package:kirei/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:one_context/one_context.dart';
import 'package:http/http.dart' as http;

class WhichFilter {
  String option_key;
  String name;

  WhichFilter(this.option_key, this.name);

  static List<WhichFilter> getWhichFilterList() {
    return <WhichFilter>[
      WhichFilter('product',
          AppLocalizations.of(OneContext().context).filter_screen_product),
      // WhichFilter('sellers',
      //     AppLocalizations.of(OneContext().context).filter_screen_sellers),
      // WhichFilter('brands',
      //     AppLocalizations.of(OneContext().context).filter_screen_brands),
    ];
  }
}

class Filter extends StatefulWidget {
  Filter(
      {Key key,
        this.selected_filter = "product",
        this.selected_skin,
        this.good_for,
        this.tag,
        this.type,
        this.category,
        this.categoryIndex,
        this.key_ingredients,
      })
      : super(key: key);

  String selected_filter;
  String selected_skin;
  String tag;
  String good_for;
  String key_ingredients;
  String category;
  String type;
  int categoryIndex;

  // dynamic _searchBar;
  // get searchBar => _searchBar;
  //
  // get searchBarTwo(BuildContext context){
  //   _searchBar = _FilterState().buildTopAppbar(context);
  // }

  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  final _amountValidator = RegExInputFormatter.withRegex(
      '^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,})?\$');

  ScrollController _productScrollController = ScrollController();
  ScrollController _brandScrollController = ScrollController();
  ScrollController _shopScrollController = ScrollController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  ScrollController _scrollController;
  WhichFilter _selectedFilter;
  String _givenSelectedFilterOptionKey; // may be it can come from another page
  var _selectedSort = "default";

  List<WhichFilter> _which_filter_list = WhichFilter.getWhichFilterList();
  List<DropdownMenuItem<WhichFilter>> _dropdownWhichFilterItems;
  List<dynamic> _selectedCategories = [];
  List<dynamic> _selectedBrands = [];
  List<dynamic> _selectedSkins = [];

  final TextEditingController _searchController = new TextEditingController();
  final TextEditingController _minPriceController = new TextEditingController();
  final TextEditingController _maxPriceController = new TextEditingController();

  //--------------------
  List<dynamic> _filterBrandList = List();
  bool _filteredBrandsCalled = false;
  List<dynamic> _filterCategoryList = List();
  bool _filteredCategoriesCalled = false;

  List<dynamic> _searchSuggestionList = List();

  var _allSubCategories =[];
  bool _isAllCategoryInitial = true;


  //----------------------------------------
  String _searchKey = "";

  List<dynamic> _productList = [];
  bool _isProductInitial = true;
  int _productPage = 1;
  int _totalProductData = 0;
  bool _showProductLoadingContainer = false;

  List<dynamic> _brandList = [];
  bool _isBrandInitial = true;
  int _brandPage = 1;
  int _totalBrandData = 0;
  bool _showBrandLoadingContainer = false;
  String _selectedCategory = "";
  List<dynamic> _shopList = [];
  bool _isShopInitial = true;
  int _shopPage = 1;
  int _totalShopData = 0;
  bool _showShopLoadingContainer = false;


  //----------------------------------------

  fetchFilteredBrands() async {
    var filteredBrandResponse =
    await SkinTypesRepository().getFilterPageSkinTypes();
    print("callllllled");
    _filterBrandList.addAll(filteredBrandResponse.skinTypes);
    print(_filterBrandList);
    _filteredBrandsCalled = true;
    setState(() {});
  }

  fetchFilteredCategories() async {
    var filteredCategoriesResponse =
    await CategoryRepository().getFilterPageCategories();
    _filterCategoryList.addAll(filteredCategoriesResponse.categories);
    _filteredCategoriesCalled = true;
    setState(() {});
  }

  // fetchAllCategory() async {
  //   var allCategory = await CategoryRepository().getCategories();
  //   //print(allCategory);
  //   _allSubCategories.addAll(allCategory.categories);
  //   print('sub category ${_allSubCategories.toString()}');
  //   // for()
  //   //print('_allSubCategories: ${_allSubCategories.toString()}');
  //   _isAllCategoryInitial = false;
  //   setState(() {});
  // }
  var _featuredCategoryList = [];
  bool _isCategoryInitial = true;

  // fetchFeaturedCategories() async {
  //   var categoryResponse =
  //   await CategoryRepository().getHomeFeaturedCategories();
  //
  //   //print(categoryResponse);
  //   // print("featuredCategory-------->" + categoryResponse.categories.toString());
  //
  //   _featuredCategoryList.addAll(categoryResponse);
  //   //print(_featuredCategoryList);
  //   //print(''_featuredCategoryList);
  //   _isCategoryInitial = false;
  //   setState(() {});
  // }
  Future<List<FeaturedCategory>> getSubCategories() async {
    var categoryKey = Provider.of<CategoryPassingController>(context, listen: false);
    if(categoryKey.categoryKey == null || categoryKey.categoryKey == ''){
      _shimmerShow = false;
    }
    Uri url = Uri.parse("${AppConfig.BASE_URL}/sub-categories/${categoryKey.categoryKey}");
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    // print("${ENDP.GET_CATEGORIES}");
    //  print("categoriesssss1: ${response.body.toString()}");
    // print(featuredCategoryListFromJson(response.body).toString()) ;
    List<FeaturedCategory> categories = featuredCategoryListFromJson(response.body);
    _shimmerShow = false;

    // print("Categories:");
    // categories.forEach((category) {
    //   print(category); // This will implicitly call toString() method of FeaturedCategory
    // });
    _allSubCategories = categories;
    if(_allSubCategories.length > 0){
      _isSubcategoryExist = true;
    }

    return categories;
  }

  bool _isSubcategoryExist = false;
  bool _shimmerShow = true;


  // bool _isVisible = true;
  // double _scrollPosition = 0.0;
  // double _scrollThreshold = 50.0; // Adjust as needed

  // void _scrollListener() {
  //   double newPosition = _scrollController.position.pixels;
  //   setState(() {
  //     if (newPosition > _scrollPosition && _isVisible) {
  //       _isVisible = false;
  //     } else if (newPosition < _scrollPosition && !_isVisible) {
  //       _isVisible = true;
  //     }
  //     _scrollPosition = newPosition;
  //   });
  // }

  // visibileMethod(){
  //
  //   if(widget.category == "skin-care" || widget.category == "hair-care" || widget.category == "make-up" || widget.category == "body-care"){
  //     isTrue = true;
  //   } else {
  //     isTrue = false;
  //
  //   }
  // }

  @override
  void initState() {
    init();
    getSubCategories();
    //fetchFeaturedCategories();
    //fetchAllCategory();
    //print(_allSubCategories);
    // print(widget.categoryIndex);
    //visibileMethod();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _productScrollController.dispose();
    _brandScrollController.dispose();
    _shopScrollController.dispose();
    super.dispose();
  }
  onPopped(value) async {
    reset();
  }

  init() {
    _givenSelectedFilterOptionKey = widget.selected_filter;

    _dropdownWhichFilterItems =
        buildDropdownWhichFilterItems(_which_filter_list);
    _selectedFilter = _dropdownWhichFilterItems[0].value;

    for (int x = 0; x < _dropdownWhichFilterItems.length; x++) {
      if (_dropdownWhichFilterItems[x].value.option_key ==
          _givenSelectedFilterOptionKey) {
        _selectedFilter = _dropdownWhichFilterItems[x].value;
      }
    }

    fetchFilteredCategories();
    fetchFilteredBrands();

    if (_selectedFilter.option_key == "sellers") {
      fetchShopData();
    } else if (_selectedFilter.option_key == "brands") {
      fetchBrandData();
    } else {
      fetchProductData();
    }




    //set scroll listeners

    _productScrollController.addListener(() {
      if (_productScrollController.position.pixels ==
          _productScrollController.position.maxScrollExtent) {
        setState(() {
          _productPage++;
        });
        _showProductLoadingContainer = true;
        fetchProductData();
      }
    });

    _brandScrollController.addListener(() {
      if (_brandScrollController.position.pixels ==
          _brandScrollController.position.maxScrollExtent) {
        setState(() {
          _brandPage++;
        });
        _showBrandLoadingContainer = true;
        fetchBrandData();
      }
    });

    _shopScrollController.addListener(() {
      if (_shopScrollController.position.pixels ==
          _shopScrollController.position.maxScrollExtent) {
        setState(() {
          _shopPage++;
        });
        _showShopLoadingContainer = true;
        fetchShopData();
      }
    });
  }

  fetchProductData() async {
    var providerValue = Provider.of<CategoryPassingController>(context, listen: false);
    //print("sc:"+_selectedCategories.join(",").toString());
    //print("sb:"+_selectedBrands.join(",").toString());
    var productResponse = await ProductRepository().getFilteredProducts(
      page: _productPage,
      //name: _searchKey,
      name: providerValue.searchKey ?? _searchKey,
      sort_key: _selectedSort,
      categories:
      providerValue.categoryKey != null ? providerValue.categoryKey : _selectedCategory,
      skin_type: widget.selected_skin != null
          ? widget.selected_skin
          : _selectedBrands.join(",").toString(),
      tag: widget.tag,
      good_for: widget.good_for,
      type: providerValue.typeKey,
      key_ingredients: widget.key_ingredients,
      max: _maxPriceController.text.toString(),
      min: _minPriceController.text.toString(),
      //search: widget.search.toString(),
    );

    _productList.addAll(productResponse.products);
    print(_productList);
    _isProductInitial = false;
    _totalProductData = productResponse.meta.total;
    _showProductLoadingContainer = false;
    setState(() {});
  }

  resetProductList() {
    _productList.clear();
    _isProductInitial = true;
    _totalProductData = 0;
    _productPage = 1;
    _showProductLoadingContainer = false;
    setState(() {});
  }

  fetchBrandData() async {
    var brandResponse =
    await BrandRepository().getBrands(page: _brandPage, name: _searchKey);
    _brandList.addAll(brandResponse.brands);
    _isBrandInitial = false;
    _totalBrandData = brandResponse.meta.total;
    _showBrandLoadingContainer = false;
    setState(() {});
  }

  resetBrandList() {
    _brandList.clear();
    _isBrandInitial = true;
    _totalBrandData = 0;
    _brandPage = 1;
    _showBrandLoadingContainer = false;
    setState(() {});
  }

  fetchShopData() async {
    var shopResponse =
    await ShopRepository().getShops(page: _shopPage, name: _searchKey);
    _shopList.addAll(shopResponse.shops);
    _isShopInitial = false;
    _totalShopData = shopResponse.meta.total;
    _showShopLoadingContainer = false;
    //print("_shopPage:" + _shopPage.toString());
    //print("_totalShopData:" + _totalShopData.toString());
    setState(() {});
  }

  reset() {
    _searchSuggestionList.clear();
    setState(() {});
  }

  resetShopList() {
    _shopList.clear();
    _isShopInitial = true;
    _totalShopData = 0;
    _shopPage = 1;
    _showShopLoadingContainer = false;
    setState(() {});
  }

  Future<void> _onProductListRefresh() async {
    reset();
    resetProductList();
    fetchProductData();
  }

  Future<void> _onBrandListRefresh() async {
    reset();
    resetBrandList();
    fetchBrandData();
  }

  Future<void> _onShopListRefresh() async {
    reset();
    resetShopList();
    fetchShopData();
  }

  _applyProductFilter() {
    reset();
    resetProductList();
    fetchProductData();
  }

  _onSearchSubmit() {
    reset();
    if (_selectedFilter.option_key == "sellers") {
      resetShopList();
      fetchShopData();
    } else if (_selectedFilter.option_key == "brands") {
      resetBrandList();
      fetchBrandData();
    } else {
      resetProductList();
      fetchProductData();
    }
  }

  _onSortChange() {
    reset();
    resetProductList();
    fetchProductData();
  }

  _onWhichFilterChange() {
    if (_selectedFilter.option_key == "sellers") {
      resetShopList();
      fetchShopData();
    } else if (_selectedFilter.option_key == "brands") {
      resetBrandList();
      fetchBrandData();
    } else {
      resetProductList();
      fetchProductData();
    }
  }

  List<DropdownMenuItem<WhichFilter>> buildDropdownWhichFilterItems(
      List which_filter_list) {
    List<DropdownMenuItem<WhichFilter>> items = List();
    for (WhichFilter which_filter_item in which_filter_list) {
      items.add(
        DropdownMenuItem(
          value: which_filter_item,
          child: Text(which_filter_item.name),
        ),
      );
    }
    return items;
  }

  Container buildProductLoadingContainer() {
    return Container(
      height: _showProductLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(_totalProductData == _productList.length
            ? AppLocalizations.of(context).common_no_more_products
            : AppLocalizations.of(context).common_loading_more_products),
      ),
    );
  }

  Container buildBrandLoadingContainer() {
    return Container(
      height: _showBrandLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(_totalBrandData == _brandList.length
            ? AppLocalizations.of(context).common_no_more_brands
            : AppLocalizations.of(context).common_loading_more_brands),
      ),
    );
  }

  Container buildShopLoadingContainer() {
    return Container(
      height: _showShopLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(_totalShopData == _shopList.length
            ? AppLocalizations.of(context).common_no_more_shops
            : AppLocalizations.of(context).common_loading_more_shops),
      ),
    );
  }

  //--------------------

  // buildBottomButton(){
  //  return Row(
  //
  //     children: [
  //       Container(
  //         width: MediaQuery.of(context).size.width / 2,
  //         height: 44,
  //         child: RaisedButton(
  //           onPressed: () {
  //             // onPressAddToCart(context, _addedToCartSnackbar);
  //             // value.setCartValue(_quantity);
  //             Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Main()));
  //           },
  //           // shape: RoundedRectangleBorder(
  //           //     borderRadius: BorderRadius.circular(80.0)),
  //           padding: EdgeInsets.all(0.0),
  //           child: Ink(
  //             color: MyTheme.secondary,
  //             child: Container(
  //                 constraints:
  //                 BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
  //                 alignment: Alignment.center,
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     // Icon(
  //                     //   Icons
  //                     //       .shopping_bag_outlined, // Use the appropriate cart icon
  //                     //   color: Colors.white,
  //                     //   size: 17,
  //                     // ),
  //                     // SizedBox(
  //                     //   width: 2,
  //                     // ),
  //                     // Add some space between the icon and text
  //                     Text(
  //                       // AppLocalizations.of(context)
  //                       //     .product_details_screen_button_add_to_cart,
  //                       "Go to Home",
  //                       style: TextStyle(
  //                         color: Colors.white,
  //                         fontSize: 14,
  //                         fontWeight: FontWeight.w600,
  //                       ),
  //                     ),
  //                   ],
  //                 )),
  //           ),
  //         )
  //       ),
  //       SizedBox(
  //         width: 1,
  //       ),
  //       Container(
  //         width: MediaQuery.of(context).size.width / 2,
  //         height: 44,
  //         child: RaisedButton(
  //           onPressed: () {
  //             // onPressBuyNow(context);
  //             // value.setCartValue(_quantity);
  //             Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Main(pageIndex: 2,)));
  //
  //           },
  //           padding: EdgeInsets.all(0.0),
  //           child: Ink(
  //             color: MyTheme.primary,
  //             child: Container(
  //               constraints:
  //               BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
  //               alignment: Alignment.center,
  //               child: Text(
  //                 // AppLocalizations.of(context)
  //                 //     .product_details_screen_button_buy_now,
  //                 "Go to Cart",
  //                 style: TextStyle(
  //                     color: Colors.white,
  //                     fontSize: 14,
  //                     fontWeight: FontWeight.w600),
  //               ),
  //             ),
  //           ),
  //         )
  //       ),
  //     ],
  //   );
  // }


  @override
  Widget build(BuildContext context) {
    /*print(_appBar.preferredSize.height.toString()+" Appbar height");
    print(kToolbarHeight.toString()+" kToolbarHeight height");
    print(MediaQuery.of(context).padding.top.toString() +" MediaQuery.of(context).padding.top");*/
    // var discountPercentage = ((((int.parse(widget.price) - int.parse(widget.sale_price))/(int.parse(widget.price)))*100 ).toStringAsFixed(0).toString());
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: MainDrawer(),
        endDrawer: buildFilterDrawer(),
        backgroundColor: MyTheme.white,
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            // buildAppBar(context),
            _selectedFilter.option_key == 'product'
                ? buildProductList()
                : (_selectedFilter.option_key == 'brands'
                ? buildBrandList()
                : buildShopList()),
            Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: buildAppBar(context),
            ),

            Align(
              //alignment: Alignment.bottomCenter,
                child: _selectedFilter.option_key == 'product'
                    ? buildProductLoadingContainer()
                    : (_selectedFilter.option_key == 'brands'
                    ? buildBrandLoadingContainer()
                    : buildShopLoadingContainer())),


            // Align(
            //    //alignment: Alignment.bottomCenter,
            //     child: _selectedFilter.option_key == 'product'
            //         ? buildProductLoadingContainer()
            //         : (_selectedFilter.option_key == 'brands'
            //         ? buildBrandLoadingContainer()
            //         : buildShopLoadingContainer())
            // )

            // Visibility(
            //   visible: widget.category != null,
            //   child: Positioned(
            //     bottom: 0,
            //       child: buildBottomButton()
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.white.withOpacity(0.95),
        automaticallyImplyLeading: false,
        actions: [
          new Container(),
        ],
        centerTitle: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: MyTheme.primary,
          ),
          padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
          //padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          child: Column(
            children: [
              buildTopAppbar(context),
              buildBottomAppBar(context),
              // buildScrollableSubCategory() ?? SizedBox(),


              //widget.category != null ? buildScrollableSubCategory() : Container()
              //buildScrollableSubCategory()

              //buildSubCategoryList(context)
            ],
          ),
        ));
  }

  // AppBar buildAppBar(BuildContext context) {
  //   return AppBar(
  //     backgroundColor: Colors.white,
  //     centerTitle: true,
  //     leading: Builder(
  //       builder: (context) => IconButton(
  //           icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
  //           onPressed: () {
  //
  //             return Navigator.of(context).pop();
  //
  //           }),
  //     ),
  //     title: Text(
  //       AppLocalizations.of(context).order_details_screen_order_details,
  //       style: TextStyle(fontSize: 16, color: MyTheme.primary),
  //     ),
  //     elevation: 0.0,
  //     titleSpacing: 0,
  //   );
  // }

  // AppBar buildAppBar(BuildContext context) {
  //   return AppBar(
  //     centerTitle: true,
  //     flexibleSpace: Container(
  //       decoration: BoxDecoration(
  //
  //       ),
  //     ),
  //     leading: GestureDetector(
  //       onTap: () {
  //         _scaffoldKey.currentState.openDrawer();
  //       },
  //       child: Builder(
  //         builder: (context) => Padding(
  //           padding:
  //               const EdgeInsets.symmetric(vertical: 18.0, horizontal: 0.0),
  //           child: Container(
  //             child: Image.asset('assets/hamburger.png',
  //                 height: 16, color: Theme.of(context).primaryIconTheme.color),
  //           ),
  //         ),
  //       ),
  //     ),
  //     title: Text(
  //       AppLocalizations.of(context).cart_screen_shopping_cart,
  //       style: TextStyle(fontSize: 18, color: Colors.white),
  //     ),
  //     elevation: 0.0,
  //     titleSpacing: 0,
  //   );
  // }

  Row buildBottomAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Container(
        //   decoration: BoxDecoration(
        //     color: Colors.white,
        //
        //   ),
        //   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        //   height: 36,
        //   width: MediaQuery.of(context).size.width * .33,
        //   child: new DropdownButton<WhichFilter>(
        //     dropdownColor: MyTheme.primary,
        //     style: new TextStyle(
        //       color: Colors.white,
        //     ),
        //     icon: Padding(
        //       padding: app_language_rtl.$
        //           ? const EdgeInsets.only(right: 16.0)
        //           : const EdgeInsets.only(left: 16.0),
        //       // child: Icon(
        //       //   Icons.expand_more,
        //       //   color: Colors.white,
        //       // ),
        //     ),
        //     hint: Text(
        //       AppLocalizations.of(context).filter_screen_products,
        //       style: TextStyle(
        //         color: Colors.black,
        //         fontSize: 13,
        //       ),
        //     ),
        //     iconSize: 14,
        //     underline: SizedBox(),
        //     value: _selectedFilter,
        //     //items: _dropdownWhichFilterItems,
        //     onChanged: (WhichFilter selectedFilter) {
        //       setState(() {
        //         _selectedFilter = selectedFilter;
        //       });

        //       //  _onWhichFilterChange();
        //     },
        //   ),
        // ),
        GestureDetector(
          onTap: () {
            _selectedFilter.option_key == "product"
                ? _scaffoldKey.currentState.openEndDrawer()
                : ToastComponent.showDialog(
                AppLocalizations.of(context).filter_screen_sort_warning,
                context,
                gravity: Toast.CENTER,
                duration: Toast.LENGTH_LONG);
          },
          child: Container(
            decoration: BoxDecoration(color: Colors.white),
            height: 48,
            width: MediaQuery.of(context).size.width * .50,
            child: Center(
                child: Container(
                  width: 50,
                  child: Row(
                    children: [
                      Icon(
                        Icons.filter_alt_outlined,
                        size: 13,
                        color: Colors.black,
                      ),
                      SizedBox(width: 2),
                      Text(
                        AppLocalizations.of(context).filter_screen_filter,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        ),
        GestureDetector(
          onTap: () {
            _selectedFilter.option_key == "product"
                ? showDialog(
                context: context,
                builder: (_) => Directionality(
                  textDirection: app_language_rtl.$
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  child: AlertDialog(
                    contentPadding: EdgeInsets.only(
                        top: 16.0, left: 2.0, right: 2.0, bottom: 2.0),
                    content: StatefulBuilder(builder:
                        (BuildContext context, StateSetter setState) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24.0),
                              child: Text(
                                AppLocalizations.of(context)
                                    .filter_screen_sort_products_by,
                              )),
                          RadioListTile(
                            dense: true,
                            value: "default",
                            groupValue: _selectedSort,
                            activeColor: MyTheme.secondary,
                            controlAffinity:
                            ListTileControlAffinity.leading,
                            title: Text(AppLocalizations.of(context)
                                .filter_screen_default),
                            onChanged: (value) {
                              setState(() {
                                _selectedSort = value;
                              });
                              _onSortChange();
                              Navigator.pop(context);
                            },
                          ),
                          RadioListTile(
                            dense: true,
                            value: "bestseller",
                            groupValue: _selectedSort,
                            activeColor: MyTheme.secondary,
                            controlAffinity:
                            ListTileControlAffinity.leading,
                            title: Text(AppLocalizations.of(context)
                                .filter_screen_popularity),
                            onChanged: (value) {
                              setState(() {
                                _selectedSort = value;
                              });
                              _onSortChange();
                              Navigator.pop(context);
                            },
                          ),
                          RadioListTile(
                            dense: true,
                            value: "rating",
                            groupValue: _selectedSort,
                            activeColor: MyTheme.secondary,
                            controlAffinity:
                            ListTileControlAffinity.leading,
                            title: Text(AppLocalizations.of(context)
                                .filter_screen_top_rated),
                            onChanged: (value) {
                              setState(() {
                                _selectedSort = value;
                              });
                              _onSortChange();
                              Navigator.pop(context);
                            },
                          ),
                          RadioListTile(
                            dense: true,
                            value: "new",
                            groupValue: _selectedSort,
                            activeColor: MyTheme.secondary,
                            controlAffinity:
                            ListTileControlAffinity.leading,
                            title: Text(AppLocalizations.of(context)
                                .filter_screen_price_new_arrival),
                            onChanged: (value) {
                              setState(() {
                                _selectedSort = value;
                              });
                              _onSortChange();
                              Navigator.pop(context);
                            },
                          ),
                          RadioListTile(
                            dense: true,
                            value: "hot",
                            groupValue: _selectedSort,
                            activeColor: MyTheme.secondary,
                            controlAffinity:
                            ListTileControlAffinity.leading,
                            title: Text(AppLocalizations.of(context)
                                .filter_screen_hot_deals),
                            onChanged: (value) {
                              setState(() {
                                _selectedSort = value;
                              });
                              _onSortChange();
                              Navigator.pop(context);
                            },
                          ),
                          RadioListTile(
                            dense: true,
                            value: "price-desc",
                            groupValue: _selectedSort,
                            activeColor: MyTheme.secondary,
                            controlAffinity:
                            ListTileControlAffinity.leading,
                            title: Text(AppLocalizations.of(context)
                                .filter_screen_price_high_to_low),
                            onChanged: (value) {
                              setState(() {
                                _selectedSort = value;
                              });
                              _onSortChange();
                              Navigator.pop(context);
                            },
                          ),
                          RadioListTile(
                            dense: true,
                            value: "price-asc",
                            groupValue: _selectedSort,
                            activeColor: MyTheme.secondary,
                            controlAffinity:
                            ListTileControlAffinity.leading,
                            title: Text(AppLocalizations.of(context)
                                .filter_screen_price_low_to_high),
                            onChanged: (value) {
                              setState(() {
                                _selectedSort = value;
                              });
                              _onSortChange();
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    }),
                    actions: [
                      FlatButton(
                        child: Text(
                          AppLocalizations.of(context)
                              .common_close_in_all_capital,
                          style: TextStyle(color: MyTheme.dark_grey),
                        ),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true)
                              .pop();
                        },
                      ),
                    ],
                  ),
                ))
                : ToastComponent.showDialog(
                AppLocalizations.of(context).filter_screen_filter_warning,
                context,
                gravity: Toast.CENTER,
                duration: Toast.LENGTH_LONG);
          },
          child: Container(
            decoration: BoxDecoration(color: Colors.white),
            height: 48,
            width: MediaQuery.of(context).size.width * .50,
            child: Center(
                child: Container(
                  width: 50,
                  child: Row(
                    children: [
                      Icon(
                        Icons.swap_vert,
                        color: Colors.black,
                        size: 13,
                      ),
                      SizedBox(width: 2),
                      Text(
                        "Sort",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        )
      ],
    );
  }

  Row buildTopAppbar(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <
        Widget>[
      Container(
        margin: EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            _scaffoldKey.currentState.openDrawer();
          },
          child: Image.asset(
            'assets/hamburger.png',
            width: 20, // Set the width as needed
            height: 20, // Set the height as needed
            color: Colors.white,
          ),
        ),
      ),
      Container(
        width: MediaQuery.of(context).size.width * .78,
        child: Container(
          child: Padding(
              padding: MediaQuery.of(context).viewPadding.top >
                  30 //MediaQuery.of(context).viewPadding.top is the statusbar height, with a notch phone it results almost 50, without a notch it shows 24.0.For safety we have checked if its greater than thirty
                  ? const EdgeInsets.symmetric(vertical: 36)
                  : const EdgeInsets.symmetric(vertical: 14.0, horizontal: 0.0),
              child: TypeAheadField(
                // ignore: missing_return
                suggestionsCallback: (pattern) async {
                  //return await BackendService.getSuggestions(pattern);
                  if (pattern != "") {
                    var suggestions = await SearchRepository()
                        .getSearchSuggestionListResponse(
                      query_key: pattern,
                    );

                    return suggestions.products;
                  }
                },
                loadingBuilder: (context) {
                  return Container(
                    height: 50,
                    child: Center(
                        child: Text(
                          AppLocalizations.of(context)
                              .filter_screen_loading_suggestions,
                          style: TextStyle(color: MyTheme.dark_grey),
                        )),
                  );
                },
                itemBuilder: (context, suggestion) {
                  return Visibility(
                    visible: _searchController.text != "",
                    child: ListTile(
                      onTap:(){
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return ProductDetails(id: suggestion.id,
                          );
                        })).then((value) {
                          onPopped(value);
                        });

                      },
                      contentPadding: EdgeInsets.only(top: 5),
                      dense: true,
                      leading: Image.network(
                        suggestion.pictures[0]
                            .url, // Replace with the actual URL of your image
                        width: 40, // Adjust the width as needed
                        height: 40, // Adjust the height as needed
                        fit: BoxFit.cover,
                      ),
                      title: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: suggestion.name,
                              style: TextStyle(color: MyTheme.secondary),
                            ),
                          ],
                        ),
                      ),
                      subtitle: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: suggestion.sale_price != suggestion.price
                                  ? "৳" + suggestion.price.toString()
                                  : '',
                              style: TextStyle(
                                color: MyTheme.dark_grey,
                                decoration:
                                suggestion.sale_price != suggestion.price
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            TextSpan(
                              text: suggestion.sale_price != suggestion.price
                                  ? ' ৳${suggestion.sale_price.toString()}'
                                  : "৳" + suggestion.price.toString(),
                              style: TextStyle(color: MyTheme.dark_grey),
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
                            AppLocalizations.of(context)
                                .filter_screen_no_suggestion_available,
                            style: TextStyle(color: MyTheme.dark_grey))),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  _searchController.text = suggestion.name;
                  _searchKey = suggestion.name;
                  setState(() {});
                  _onSearchSubmit();
                },
                textFieldConfiguration: TextFieldConfiguration(
                  onTap: () {},
                  controller: _searchController,
                  onSubmitted: (txt) {
                    _searchKey = txt;
                    setState(() {});
                    _onSearchSubmit();
                  },
                  style: TextStyle(color: MyTheme.white),
                  autofocus: false,
                  cursorColor: MyTheme.white,
                  decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)
                          .filter_screen_search_here,
                      border: InputBorder.none,
                      hintStyle:
                      TextStyle(fontSize: 14.0, color: MyTheme.light_grey),
                      alignLabelWithHint: true,
                      // focusedBorder: OutlineInputBorder(
                      //   borderSide:
                      //       BorderSide(color: MyTheme.white, width: 0.0),
                      // ),
                      contentPadding: EdgeInsets.only(left: 30)),
                ),
              )),
        ),
      ),
      IconButton(
          icon: Icon(Icons.search, color: Colors.white),
          onPressed: () {
            _searchKey = _searchController.text.toString();
            setState(() {});
            _onSearchSubmit();
          }),
    ]);
  }

  buildFilterDrawer() {
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Drawer(
        child: Container(
          padding: EdgeInsets.only(top: 50),
          child: Column(
            children: [
              Container(
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          AppLocalizations.of(context)
                              .filter_screen_price_range,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Container(
                              height: 30,
                              width: 100,
                              child: TextField(
                                controller: _minPriceController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [_amountValidator],
                                decoration: InputDecoration(
                                    hintText: AppLocalizations.of(context)
                                        .filter_screen_minimum,
                                    hintStyle: TextStyle(
                                        fontSize: 12.0,
                                        color: MyTheme.light_grey),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: MyTheme.light_grey,
                                          width: 1.0),
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(4.0),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: MyTheme.light_grey,
                                          width: 2.0),
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(4.0),
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.all(4.0)),
                              ),
                            ),
                          ),
                          Text(" - "),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Container(
                              height: 30,
                              width: 100,
                              child: TextField(
                                controller: _maxPriceController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [_amountValidator],
                                decoration: InputDecoration(
                                    hintText: AppLocalizations.of(context)
                                        .filter_screen_maximum,
                                    hintStyle: TextStyle(
                                        fontSize: 12.0,
                                        color: MyTheme.light_grey),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: MyTheme.light_grey,
                                          width: 1.0),
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(4.0),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: MyTheme.light_grey,
                                          width: 2.0),
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(4.0),
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.all(4.0)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: CustomScrollView(slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          AppLocalizations.of(context).filter_screen_categories,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      _filterCategoryList.length == 0
                          ? Container(
                        height: 100,
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)
                                .common_no_category_is_available,
                            style: TextStyle(color: MyTheme.secondary),
                          ),
                        ),
                      )
                          : SingleChildScrollView(
                        child: buildFilterCategoryList(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          AppLocalizations.of(context).filter_screen_brands,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      _filterBrandList.length == 0
                          ? Container(
                        height: 100,
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)
                                .common_no_brand_is_available,
                            style: TextStyle(color: MyTheme.secondary),
                          ),
                        ),
                      )
                          : SingleChildScrollView(
                        child: buildFilterBrandsList(),
                      ),
                    ]),
                  )
                ]),
              ),
              Container(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FlatButton(
                      color: Color.fromRGBO(234, 67, 53, 1),
                      shape: RoundedRectangleBorder(
                        side: new BorderSide(
                            color: MyTheme.light_grey, width: 2.0),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        AppLocalizations.of(context)
                            .common_clear_in_all_capital,
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        _minPriceController.clear();
                        _maxPriceController.clear();
                        setState(() {
                          _selectedCategories.clear();
                          _selectedSkins.clear();
                          widget.type = "";
                          widget.tag = "";
                          widget.good_for = "";
                          widget.key_ingredients = "";
                          widget.category = "";
                          widget.selected_skin = "";
                          _selectedSort = "default";
                          _searchKey = "";
                          _searchController.clear();

                          _selectedCategory = "";
                          _selectedBrands.clear();
                        });
                      },
                    ),
                    FlatButton(
                      color: Color.fromRGBO(52, 168, 83, 1),
                      child: Text(
                        "APPLY",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        var min = _minPriceController.text;
                        var max = _maxPriceController.text;
                        bool apply = true;
                        if (min != "" && max != "") {
                          if (int.parse(max).compareTo(int.parse(min)) < 0) {
                            ToastComponent.showDialog(
                                AppLocalizations.of(context)
                                    .filter_screen_min_max_warning,
                                context,
                                gravity: Toast.CENTER,
                                duration: Toast.LENGTH_LONG);
                            apply = false;
                          }
                        }

                        if (apply) {
                          _applyProductFilter();
                        }
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.065,
              )
            ],
          ),
        ),
      ),
    );
  }

  ListView buildFilterBrandsList() {
    return ListView(
      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: <Widget>[
        ..._filterBrandList
            .map(
              (brand) => CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            dense: true,
            title: Text(brand.title),
            value: _selectedBrands.contains(brand.title),
            onChanged: (bool value) {
              if (value) {
                setState(() {
                  _selectedBrands.add(brand.title);
                });
              } else {
                setState(() {
                  _selectedBrands.remove(brand.title);
                });
              }
            },
          ),
        )
            .toList()
      ],
    );
  }

  ListView buildFilterCategoryList() {
    return ListView(
      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: <Widget>[
        ..._filterCategoryList
            .map(
              (category) => RadioListTile<String>(
            controlAffinity: ListTileControlAffinity.leading,
            dense: true,
            title: Text(category.name),
            groupValue: _selectedCategory,
            value: category.name,
            onChanged: (value) {
              setState(() {
                debugPrint("Val=$value");
                _selectedCategory = value;
              });
            },
          ),
        )
            .toList()
      ],
    );
  }

  Container buildProductList() {
    return Container(
      child: Expanded(
        child: buildProductScrollableList(),
      ),
    );
  }

  buildProductScrollableList() {
    if (_isProductInitial && _productList.length == 0) {
      return Container(
        //margin: widget.category!= null? EdgeInsets.only(top: 150) : EdgeInsets.only(top: 0),
        //padding: widget.category!= null? EdgeInsets.only(top: 200) : EdgeInsets.only(top: 0),
          margin:EdgeInsets.only(top: 100),
          padding:EdgeInsets.only(top: 35),
          child: ListView(
            children: [
              buildSUbCategoryLoading() ?? SizedBox(),
              ShimmerHelper()
                  .buildProductGridShimmer(scontroller: _scrollController)
            ],
          ));
    } else if (_productList.length > 0) {
      return Container(
        //margin:  EdgeInsets.only(top: 5),
        //padding: EdgeInsets.only(top: 8),
        child: RefreshIndicator(
          color: Colors.white,
          backgroundColor: MyTheme.primary,
          onRefresh: _onProductListRefresh,
          child: SingleChildScrollView(
            controller: _productScrollController,
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            child: Column(
              children: [
                SizedBox(
                    height:
                    MediaQuery.of(context).viewPadding.top > 40 ? 180 : 135
                  //MediaQuery.of(context).viewPadding.top is the statusbar height, with a notch phone it results almost 50, without a notch it shows 24.0.For safety we have checked if its greater than thirty
                ),
                //Text('data'),
                buildScrollableSubCategory() ?? SizedBox(),
                GridView.builder(
                  // 2
                  //addAutomaticKeepAlives: true,
                  itemCount: _productList.length,
                  controller: _scrollController,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 30,
                      childAspectRatio: 0.618),
                  padding: EdgeInsets.all(16),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    // 3
                    return ProductCard(
                      id: _productList[index].id,
                      name: _productList[index].name,
                      price: _productList[index].price.toString(),
                      sale_price: _productList[index].sale_price.toString(),
                      ratings: _productList[index].ratings,
                      image: _productList[index].pictures.length > 0
                          ? _productList[index].pictures[0].url
                          : "assets/placeholder.png",
                      slug: _productList[index].slug,
                      reviews: _productList[index].reviews,
                      stock: _productList[index].stock,
                      discount: _productList[index].discount,
                    );
                  },
                )
              ],
            ),
          ),
        ),
      );
    } else if (_totalProductData == 0) {
      return Center(
          child: Text(
              AppLocalizations.of(context).common_no_product_is_available));
    } else {
      return Container(); // should never be happening
    }
  }

  Container buildBrandList() {
    return Container(
      child: Expanded(
        child: buildBrandScrollableList(),
      ),
    );
  }

  buildBrandScrollableList() {
    if (_isBrandInitial && _brandList.length == 0) {
      return ShimmerHelper()
          .buildSquareGridShimmer(scontroller: _scrollController);
    } else if (_brandList.length > 0) {
      return RefreshIndicator(
        color: Colors.white,
        backgroundColor: MyTheme.primary,
        onRefresh: _onBrandListRefresh,
        child: SingleChildScrollView(
          controller: _brandScrollController,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Column(
            children: [
              SizedBox(
                  height:
                  MediaQuery.of(context).viewPadding.top > 40 ? 180 : 135
                //MediaQuery.of(context).viewPadding.top is the statusbar height, with a notch phone it results almost 50, without a notch it shows 24.0.For safety we have checked if its greater than thirty
              ),
              GridView.builder(
                // 2
                //addAutomaticKeepAlives: true,
                itemCount: _brandList.length,
                controller: _scrollController,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1),
                padding: EdgeInsets.all(8),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  // 3
                  return BrandSquareCard(
                    id: _brandList[index].id,
                    image: _brandList[index].logo,
                    name: _brandList[index].name,
                  );
                },
              )
            ],
          ),
        ),
      );
    } else if (_totalBrandData == 0) {
      return Center(
          child:
          Text(AppLocalizations.of(context).common_no_brand_is_available));
    } else {
      return Container(); // should never be happening
    }
  }

  buildSubCategoryList(BuildContext context) {
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
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Theme.of(context)
                                .buttonTheme
                                .colorScheme
                                .primary,
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
                            "assets/arrivals.jpg",
                            fit: BoxFit
                                .cover, // You can adjust this based on your needs
                            height: 50,
                            width: 50,
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
                              fontWeight: FontWeight.w300),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ]));
  }

  Container buildShopList() {
    return Container(
      child: Expanded(
        child: buildShopScrollableList(),
      ),
    );
  }

  buildShopScrollableList() {
    if (_isShopInitial && _shopList.length == 0) {
      return SingleChildScrollView(
          controller: _scrollController,
          child: ShimmerHelper()
              .buildSquareGridShimmer(scontroller: _scrollController));
    } else if (_shopList.length > 0) {
      return RefreshIndicator(
        color: Colors.white,
        backgroundColor: MyTheme.primary,
        onRefresh: _onShopListRefresh,
        child: SingleChildScrollView(
          controller: _shopScrollController,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Column(
            children: [
              SizedBox(
                  height:
                  MediaQuery.of(context).viewPadding.top > 40 ? 180 : 135
                //MediaQuery.of(context).viewPadding.top is the statusbar height, with a notch phone it results almost 50, without a notch it shows 24.0.For safety we have checked if its greater than thirty
              ),
              GridView.builder(
                // 2
                //addAutomaticKeepAlives: true,
                itemCount: _shopList.length,
                controller: _scrollController,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1),
                padding: EdgeInsets.all(8),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  // 3
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return SellerDetails();
                          }));
                    },
                    child: ShopSquareCard(
                      id: _shopList[index].id,
                      image: _shopList[index].logo,
                      name: _shopList[index].name,
                    ),
                  );
                },
              )
            ],
          ),
        ),
      );
    } else if (_totalShopData == 0) {
      return Center(
          child:
          Text(AppLocalizations.of(context).common_no_shop_is_available));
    } else {
      return Container(); // should never be happening
    }
  }

  buildSUbCategoryLoading(){
    if (_shimmerShow == true) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Card(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8,),
            color: MyTheme.white,
            child: Row(
              children: [
                Padding(
                    padding: const EdgeInsets.only(right: 8.0, top: 8, bottom: 8,),
                    child: ClipOval(
                        child: ShimmerHelper()
                            .buildBasicShimmer(height: 58.0, width: 58.0))),
                Padding(
                    padding: const EdgeInsets.only(right: 8.0, top: 8, bottom: 8),
                    child: ClipOval(
                        child: ShimmerHelper()
                            .buildBasicShimmer(height: 58.0, width: 58.0))),
                Padding(
                    padding: const EdgeInsets.only(right: 8.0, top: 8, bottom: 8),
                    child: ClipOval(
                        child: ShimmerHelper()
                            .buildBasicShimmer(height: 58.0, width: 58.0))),
                Padding(
                    padding: const EdgeInsets.only(right: 8.0, top: 8, bottom: 8),
                    child: ClipOval(
                        child: ShimmerHelper()
                            .buildBasicShimmer(height: 58.0, width: 58.0))),
                Padding(
                    padding: const EdgeInsets.only(right: 8.0, top: 8, bottom: 8),
                    child: ClipOval(
                        child: ShimmerHelper()
                            .buildBasicShimmer(height: 58.0, width: 58.0))),
                Padding(
                    padding: const EdgeInsets.only(right: 8.0, top: 8, bottom: 8),
                    child: ClipOval(
                        child: ShimmerHelper()
                            .buildBasicShimmer(height: 58.0, width: 58.0))),
              ],
            ),
          ),
        ),
      );
    }
  }

  buildScrollableSubCategory(){
    var providerValue = Provider.of<CategoryPassingController>(context, listen: false);
    if(!_shimmerShow && _allSubCategories.length == 0){
      _isSubcategoryExist == false;
      providerValue.resetCategoryKeyValue();
    }else if (_allSubCategories.length > 0){
      _isSubcategoryExist == true;
      providerValue.resetCategoryKeyValue();
      return Card(
        margin : EdgeInsets.symmetric(vertical: 5, horizontal: 0),
        elevation: 5,
        child: Column(
          children : [
            Divider(
              color: MyTheme.dark_grey,
              thickness: 1,
              height: 1,
            ),
            SizedBox(height: 5,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              color: MyTheme.white,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_allSubCategories.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_)=> Filter(
                            category: _allSubCategories[index]?.slug
                        )));
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 5, top: 3),
                        padding: EdgeInsets.only(bottom: 6,),
                        //height: 120,
                        width: MediaQuery.of(context).size.width / 5 - 4,
                        color: MyTheme.white,
                        child: Column(
                          children: [
                            Container(
                              height: 56,
                              width: 56,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                //borderRadius: BorderRadius.circular(30),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: MyTheme.light_grey, width: 1)
                              ),
                              child: ClipOval(
                                  child: _allSubCategories[index]?.icon != null
                                      ? FadeInImage.assetNetwork(
                                    image: _allSubCategories[index]?.icon,
                                    placeholder: 'assets/placeholder.png',
                                    //fit: BoxFit.cover,
                                    height: 56,
                                    width: 56,
                                  )
                                      : SizedBox()
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                _allSubCategories[index]?.name,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
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
                  }),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
