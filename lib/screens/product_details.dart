import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kirei/repositories/search_repository.dart';
import 'package:kirei/screens/cart.dart';
import 'package:kirei/screens/common_webview_screen.dart';
import 'package:kirei/screens/filter.dart';
import 'package:kirei/screens/login.dart';
import 'package:kirei/screens/main.dart';
import 'package:kirei/screens/product_questions.dart';
import 'package:kirei/screens/product_reviews.dart';
import 'package:kirei/ui_elements/list_product_card.dart';
import 'package:kirei/ui_elements/mini_product_card.dart';
import 'package:flutter/material.dart';
import 'package:kirei/my_theme.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:expandable/expandable.dart';
import 'dart:ui';
import 'package:flutter_html/flutter_html.dart';
import 'package:kirei/repositories/product_repository.dart';
import 'package:kirei/repositories/wishlist_repository.dart';
import 'package:kirei/repositories/cart_repository.dart';
import 'package:kirei/app_config.dart';
import 'package:kirei/helpers/shimmer_helper.dart';
import 'package:kirei/helpers/color_helper.dart';
import 'package:kirei/helpers/shared_value_helper.dart';
import 'package:kirei/custom/toast_component.dart';
import 'package:kirei/repositories/chat_repository.dart';
import 'package:kirei/screens/chat.dart';
import 'package:toast/toast.dart';
// import 'package:social_share/social_share.dart';
import 'dart:async';
import 'package:kirei/screens/video_description_screen.dart';
import 'package:photo_view/photo_view.dart';
import 'package:kirei/screens/brand_products.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:html/parser.dart' show parse;

class ProductDetails extends StatefulWidget {
  int id;
  String slug;
  int discount;
  int stock;
  String sale_price;
  String price;
  ProductDetails({Key key, this.id, this.slug, this.discount, this.sale_price, this.price, this.stock}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  bool _showCopied = false;
  String _appbarPriceString;
  int _currentImage = 0;
  ScrollController _mainScrollController = ScrollController();
  ScrollController _colorScrollController = ScrollController();
  ScrollController _variantScrollController = ScrollController();
  ScrollController _imageScrollController = ScrollController();
  TextEditingController sellerChatTitleController = TextEditingController();
  TextEditingController sellerChatMessageController = TextEditingController();

  final TextEditingController _searchController = new TextEditingController();
  String _searchKey = "";
  WhichFilter _selectedFilter;

  //init values
  bool _isInWishList = false;
  var _productDetailsFetched = false;
  var _productDetails = null;
  var _productImageList = [];
  var _skinTypes = [];
  var _keyIngredients = [];
  var _goodFor = [];
  var _categories = [];
  var _tags = [];
  var _colorList = [];
  int _selectedColorIndex = 0;
  var _selectedChoices = [];
  var _choiceString = "";
  var _variant = "";
  var _totalPrice;
  var _singlePrice;
  dynamic _description;
  var _singlePriceString;
  bool _isDescriptionEmpty = false;
  int _quantity = 1;
  int _stock = 0;

  List<dynamic> _relatedProducts = [];
  bool _relatedProductInit = false;
  List<dynamic> _recommendedProducts = [];
  bool _recommendedProductInit = false;

  List<dynamic> _topProducts = [];
  bool _topProductInit = false;

  @override
  void initState() {
    print("HowMuch${widget.stock}");
    fetchAll();
    super.initState();
  }

  @override
  void dispose() {
    _mainScrollController.dispose();
    _variantScrollController.dispose();
    _imageScrollController.dispose();
    _colorScrollController.dispose();
    super.dispose();
  }

  fetchAll() {
    fetchProductDetails();
    if (is_logged_in.$ == true) {
      fetchWishListCheckInfo();
    }
    fetchRelatedProducts();
    fetchRecommendedProducts();
    fetchTopProducts();
  }

  fetchProductDetails() async {
    var productDetailsResponse =
        await ProductRepository().getProductDetails(id: widget.id);

    _productDetails = productDetailsResponse.detailed_products;
    print(productDetailsResponse);

    var description = _productDetails.shortDescription;
    var document = parse(description);
    var body = document.body;
    if (body == null && body.text.trim().isEmpty) {
      _isDescriptionEmpty = true;
      print(_isDescriptionEmpty);
    }

    // sellerChatTitleController.text =
    //     productDetailsResponse.detailed_products.name;

    setProductDetailValues();

    setState(() {});
  }

  fetchRelatedProducts() async {
    var relatedProductResponse =
        await ProductRepository().getRelatedProducts(slug: widget.slug);
    _relatedProducts.addAll(relatedProductResponse.products);
    _relatedProductInit = true;

    setState(() {});
  }

  fetchRecommendedProducts() async {
    var recommendedProductResponse =
        await ProductRepository().getRecommendedProducts();
    _recommendedProducts.addAll(recommendedProductResponse.products);
    _recommendedProductInit = true;

    setState(() {});
  }

  fetchTopProducts() async {
    var topProductResponse =
        await ProductRepository().getPurchasedTogether(slug: widget.slug);
    _topProducts.addAll(topProductResponse.products);
    _topProductInit = true;
    setState(() {});
  }

  setProductDetailValues() {
    if (_productDetails != null) {
      _appbarPriceString = _productDetails.salePrice.toString();
      // _singlePrice = _productDetails.calculable_price;
      _singlePriceString = _productDetails.salePrice;
      _description = _productDetails.description;
      calculateTotalPrice();
      _stock = _productDetails.stock;
      _productDetails.pictures.forEach((photo) {
        _productImageList.add(photo.url);
      });

      _productDetails.skinTypes.forEach((skinType) {
        _skinTypes.add(skinType.name);
      });

      _productDetails.keyIngredients.forEach((key) {
        _keyIngredients.add(key.name);
      });

      _productDetails.goodFor.forEach((key) {
        _goodFor.add(key.name);
      });

      _productDetails.productCategories.forEach((productCategory) {
        _categories.add(productCategory.name);
      });

      _productDetails.productTags.forEach((productTag) {
        _tags.add(productTag.name);
      });
      print(_categories[0]);

      // _productDetails.choice_options.forEach((choice_opiton) {
      //   _selectedChoices.add(choice_opiton.options[0]);
      // });
      // _productDetails.colors.forEach((color) {
      //   _colorList.add(color);
      // });

      // setChoiceString();

      // if (_productDetails.colors.length > 0 ||
      //     _productDetails.choice_options.length > 0) {
      //   fetchAndSetVariantWiseInfo(change_appbar_string: true);
      // }
      _productDetailsFetched = true;

      setState(() {});
    }
  }

  // setChoiceString() {
  //   _choiceString = _selectedChoices.join(",").toString();
  //   //print(_choiceString);
  //   setState(() {});
  // }

  fetchWishListCheckInfo() async {
    var wishListCheckResponse =
        await WishListRepository().isProductInUserWishList(
      product_id: widget.id,
    );
    print(wishListCheckResponse);
    //print("p&u:" + widget.id.toString() + " | " + _user_id.toString());
    _isInWishList = wishListCheckResponse.is_in_wishlist;
    setState(() {});
  }

  addToWishList() async {
    var wishListCheckResponse =
        await WishListRepository().add(product_id: widget.id);
    ToastComponent.showDialog(
        "Added to Wishlist", context,
        gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    //print("p&u:" + widget.id.toString() + " | " + _user_id.toString());
    _isInWishList = wishListCheckResponse.is_in_wishlist;
    setState(() {});
  }

  removeFromWishList() async {
    var wishListCheckResponse =
        await WishListRepository().remove(product_id: widget.id);
    ToastComponent.showDialog(
        "Remove from Wishlist", context,
        gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    //print("p&u:" + widget.id.toString() + " | " + _user_id.toString());
    _isInWishList = wishListCheckResponse.is_in_wishlist;
    setState(() {});
  }

  onWishTap() {
    if (is_logged_in.$ == false) {
      ToastComponent.showDialog(
          AppLocalizations.of(context).common_login_warning, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    if (_isInWishList) {
      _isInWishList = false;
      setState(() {});
      removeFromWishList();
    } else {
      _isInWishList = true;
      setState(() {});
      addToWishList();
    }
  }

  // fetchAndSetVariantWiseInfo({bool change_appbar_string = true}) async {
  //   var _colorList = [];
  //   var color_string = _colorList.length > 0
  //       ? _colorList[_selectedColorIndex].toString().replaceAll("#", "")
  //       : "";

  //   /*print("color string: "+color_string);
  //   return;*/

  //   var variantResponse = await ProductRepository().getVariantWiseInfo(
  //       id: widget.id, color: color_string, variants: _choiceString);

  //   /*print("vr"+variantResponse.toJson().toString());
  //   return;*/

  //   _singlePrice = variantResponse.price;
  //   _stock = variantResponse.stock;
  //   if (_quantity > _stock) {
  //     _quantity = _stock;
  //     setState(() {});
  //   }

  //   _variant = variantResponse.variant;
  //   setState(() {});

  //   calculateTotalPrice();
  //   _singlePriceString = variantResponse.price_string;

  //   if (change_appbar_string) {
  //     _appbarPriceString = "${variantResponse.variant} ${_singlePriceString}";
  //   }

  //   int pindex = 0;
  //   _productDetails.pictures.forEach((photo) {
  //     if (photo.variant == _variant && variantResponse.image != "") {
  //       _currentImage = pindex;
  //     }

  //     pindex++;
  //   });

  //   setState(() {});
  // }

  reset() {
    restProductDetailValues();
    _productImageList.clear();
    _colorList.clear();
    _selectedChoices.clear();
    _relatedProducts.clear();
    _recommendedProducts.clear();
    _skinTypes.clear();
    _keyIngredients.clear();
    _categories.clear();
    _goodFor.clear();
    _tags.clear();
    _topProducts.clear();
    _choiceString = "";
    _variant = "";
    _selectedColorIndex = 0;
    _quantity = 1;
    _productDetailsFetched = false;
    _isInWishList = false;
    sellerChatTitleController.clear();
    setState(() {});
  }

  restProductDetailValues() {
    _appbarPriceString = " . . .";
    _productDetails = null;
    _productImageList.clear();
    _currentImage = 0;
    setState(() {});
  }

  Future<void> _onPageRefresh() async {
    reset();
    fetchAll();
  }

  calculateTotalPrice() {
    _totalPrice = (_singlePriceString * _quantity).toStringAsFixed(2);
    print(_totalPrice);
    setState(() {});
  }

  // _onVariantChange(_choice_options_index, value) {
  //   _selectedChoices[_choice_options_index] = value;
  //   setChoiceString();
  //   setState(() {});
  //   fetchAndSetVariantWiseInfo();
  // }

  // _onColorChange(index) {
  //   _selectedColorIndex = index;
  //   setState(() {});
  //   fetchAndSetVariantWiseInfo();
  // }

  onPressAddToCart(context, snackbar) {
    addToCart(mode: "add_to_cart", context: context, snackbar: snackbar);
  }

  onPressBuyNow(context) {
    addToCart(mode: "buy_now", context: context);
  }

  addToCart({mode, context = null, snackbar = null}) async {
    if (is_logged_in.$ == false) {
      // ToastComponent.showDialog(AppLocalizations.of(context).common_login_warning, context,
      //     gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
      return;
    }

    // print(widget.id);
    // print(_variant);
    // print(user_id.$);
    //print(_quantity);
    print(access_token.$);
    var cartAddResponse = await CartRepository()
        .getCartAddResponse(widget.id, _variant, user_id.$, _quantity);

    if (cartAddResponse.result == false) {
      ToastComponent.showDialog(cartAddResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    } else {
      if (mode == "add_to_cart") {
        if (snackbar != null && context != null) {
          Scaffold.of(context).showSnackBar(snackbar);
        }
        reset();
        fetchAll();
      } else if (mode == 'buy_now') {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Cart(has_bottomnav: false);
        })).then((value) {
          onPopped(value);
        });
      }
    }
  }

  onPopped(value) async {
    reset();
    fetchAll();
  }

  onCopyTap(setState) {
    setState(() {
      _showCopied = true;
    });
    Timer timer = Timer(Duration(seconds: 3), () {
      setState(() {
        _showCopied = false;
      });
    });
  }

  // onPressShare(context) {
  //   return showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return StatefulBuilder(builder: (context, StateSetter setState) {
  //           return AlertDialog(
  //             insetPadding: EdgeInsets.symmetric(horizontal: 10),
  //             contentPadding: EdgeInsets.only(
  //                 top: 36.0, left: 36.0, right: 36.0, bottom: 2.0),
  //             content: Container(
  //               width: 400,
  //               child: SingleChildScrollView(
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   children: [
  //                     Padding(
  //                       padding: const EdgeInsets.only(bottom: 8.0),
  //                       child: FlatButton(
  //                         minWidth: 75,
  //                         height: 26,
  //                         color: Color.fromRGBO(253, 253, 253, 1),
  //                         shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(8.0),
  //                             side:
  //                                 BorderSide(color: Colors.black, width: 1.0)),
  //                         child: Text(
  //                           AppLocalizations.of(context)
  //                               .product_details_screen_copy_product_link,
  //                           style: TextStyle(
  //                             color: MyTheme.dark_grey,
  //                           ),
  //                         ),
  //                         onPressed: () {
  //                           onCopyTap(setState);
  //                           // SocialShare.copyToClipboard(_productDetails.link);
  //                         },
  //                       ),
  //                     ),
  //                     _showCopied
  //                         ? Padding(
  //                             padding: const EdgeInsets.only(bottom: 8.0),
  //                             child: Text(
  //                               AppLocalizations.of(context).common_copied,
  //                               style: TextStyle(
  //                                   color: MyTheme.dark_grey, fontSize: 12),
  //                             ),
  //                           )
  //                         : Container(),
  //                     Padding(
  //                       padding: const EdgeInsets.only(bottom: 8.0),
  //                       child: FlatButton(
  //                         minWidth: 75,
  //                         height: 26,
  //                         color: Colors.blue,
  //                         shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(8.0),
  //                             side:
  //                                 BorderSide(color: Colors.black, width: 1.0)),
  //                         child: Text(
  //                           AppLocalizations.of(context)
  //                               .product_details_screen_share_options,
  //                           style: TextStyle(color: Colors.white),
  //                         ),
  //                         onPressed: () {
  //                           print("share links ${_productDetails.link}");
  //                           SocialShare.shareOptions(_productDetails.link);
  //                         },
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             actions: [
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                 children: [
  //                   Padding(
  //                     padding: app_language_rtl.$
  //                         ? EdgeInsets.only(left: 8.0)
  //                         : EdgeInsets.only(right: 8.0),
  //                     child: FlatButton(
  //                       minWidth: 75,
  //                       height: 30,
  //                       color: Color.fromRGBO(253, 253, 253, 1),
  //                       shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(8.0),
  //                           side: BorderSide(
  //                               color: MyTheme.secondary, width: 1.0)),
  //                       child: Text(
  //                         "CLOSE",
  //                         style: TextStyle(
  //                           color: MyTheme.secondary,
  //                         ),
  //                       ),
  //                       onPressed: () {
  //                         Navigator.of(context, rootNavigator: true).pop();
  //                       },
  //                     ),
  //                   ),
  //                 ],
  //               )
  //             ],
  //           );
  //         });
  //       });
  // }

  onTapSellerChat() {
    return showDialog(
        context: context,
        builder: (_) => Directionality(
              textDirection:
                  app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
              child: AlertDialog(
                insetPadding: EdgeInsets.symmetric(horizontal: 10),
                contentPadding: EdgeInsets.only(
                    top: 36.0, left: 36.0, right: 36.0, bottom: 2.0),
                content: Container(
                  width: 400,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                              AppLocalizations.of(context)
                                  .product_details_screen_seller_chat_title,
                              style: TextStyle(
                                  color: MyTheme.secondary, fontSize: 12)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Container(
                            height: 40,
                            child: TextField(
                              controller: sellerChatTitleController,
                              autofocus: false,
                              decoration: InputDecoration(
                                  hintText: AppLocalizations.of(context)
                                      .product_details_screen_seller_chat_enter_title,
                                  hintStyle: TextStyle(
                                      fontSize: 12.0,
                                      color: MyTheme.light_grey),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: MyTheme.light_grey, width: 0.5),
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(8.0),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: MyTheme.light_grey, width: 1.0),
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(8.0),
                                    ),
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 8.0)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                              "${AppLocalizations.of(context).product_details_screen_seller_chat_messasge} *",
                              style: TextStyle(
                                  color: MyTheme.secondary, fontSize: 12)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Container(
                            height: 55,
                            child: TextField(
                              controller: sellerChatMessageController,
                              autofocus: false,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                  hintText: AppLocalizations.of(context)
                                      .product_details_screen_seller_chat_enter_messasge,
                                  hintStyle: TextStyle(
                                      fontSize: 12.0,
                                      color: MyTheme.light_grey),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: MyTheme.light_grey, width: 0.5),
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(8.0),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: MyTheme.light_grey, width: 1.0),
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(8.0),
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.only(
                                      right: 16.0,
                                      left: 8.0,
                                      top: 16.0,
                                      bottom: 16.0)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: FlatButton(
                          minWidth: 75,
                          height: 30,
                          color: Color.fromRGBO(253, 253, 253, 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide(
                                  color: MyTheme.light_grey, width: 1.0)),
                          child: Text(
                            AppLocalizations.of(context)
                                .common_close_in_all_capital,
                            style: TextStyle(
                              color: MyTheme.secondary,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                        ),
                      ),
                      SizedBox(
                        width: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28.0),
                        child: FlatButton(
                          minWidth: 75,
                          height: 30,
                          color: MyTheme.secondary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide(
                                  color: MyTheme.light_grey, width: 1.0)),
                          child: Text(
                            AppLocalizations.of(context)
                                .common_send_in_all_capital,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          onPressed: () {
                            onPressSendMessage();
                          },
                        ),
                      )
                    ],
                  )
                ],
              ),
            ));
  }

  onPressSendMessage() async {
    var title = sellerChatTitleController.text.toString();
    var message = sellerChatMessageController.text.toString();

    if (title == "" || message == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context)
              .product_details_screen_seller_chat_title_message_empty_warning,
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
      return;
    }

    var conversationCreateResponse = await ChatRepository()
        .getCreateConversationResponse(
            product_id: widget.id, title: title, message: message);

    if (conversationCreateResponse.result == false) {
      ToastComponent.showDialog(
          AppLocalizations.of(context)
              .product_details_screen_seller_chat_creation_unable_warning,
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
      return;
    }

    Navigator.of(context, rootNavigator: true).pop();
    sellerChatTitleController.clear();
    sellerChatMessageController.clear();
    setState(() {});

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Chat(
        conversation_id: conversationCreateResponse.conversation_id,
        messenger_name: conversationCreateResponse.shop_name,
        messenger_title: conversationCreateResponse.title,
        messenger_image: conversationCreateResponse.shop_logo,
      );
      ;
    })).then((value) {
      onPopped(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    SnackBar _addedToCartSnackbar = SnackBar(
      content: Text(
        AppLocalizations.of(context)
            .product_details_screen_snackbar_added_to_cart,
        style: TextStyle(color: MyTheme.secondary),
      ),
      backgroundColor: MyTheme.light_grey,
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: AppLocalizations.of(context)
            .product_details_screen_snackbar_show_cart,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Cart(has_bottomnav: false);
          })).then((value) {
            onPopped(value);
          });
        },
        textColor: MyTheme.secondary,
        disabledTextColor: Colors.grey,
      ),
    );
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
          bottomNavigationBar: buildBottomAppBar(context, _addedToCartSnackbar),
          backgroundColor: Colors.white,
          appBar: buildAppBar(statusBarHeight, context),
          body: RefreshIndicator(
            color: MyTheme.primary,
            backgroundColor: Colors.white,
            onRefresh: _onPageRefresh,
            child: CustomScrollView(
              controller: _mainScrollController,
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              slivers: <Widget>[
                SliverList(
                    delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      16.0,
                      0.0,
                      16.0,
                      0.0,
                    ),
                    child: buildProductImageSection(),
                  ),
                ])),
                SliverList(
                    delegate: SliverChildListDelegate([
                  Padding(
                      padding: const EdgeInsets.fromLTRB(
                        16.0,
                        8.0,
                        16.0,
                        0.0,
                      ),
                      child: _productDetails != null
                          ? Text(
                              _productDetails.name,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: MyTheme.secondary,
                                  fontWeight: FontWeight.w600),
                              maxLines: 2,
                            )
                          : ShimmerHelper().buildBasicShimmer(
                              height: 30.0,
                            )),
                ])),
                SliverList(
                    delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      16.0,
                      8.0,
                      16.0,
                      0.0,
                    ),
                    child: _productDetails != null
                        ? buildRatingAndWishButtonRow()
                        : ShimmerHelper().buildBasicShimmer(
                            height: 30.0,
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      16.0,
                      16.0,
                      16.0,
                      0.0,
                    ),
                    child: _productDetails != null
                        ? buildBrandRow()
                        : ShimmerHelper().buildBasicShimmer(
                            height: 50.0,
                          ),
                  ),
                  Divider(
                    height: 24.0,
                  ),
                ])),
                SliverList(
                    delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      16.0,
                      8.0,
                      16.0,
                      0.0,
                    ),
                    child: _productDetails != null
                        ? buildMainPriceRow()
                        : ShimmerHelper().buildBasicShimmer(
                            height: 30.0,
                          ),
                  ),
                ])),
                // SliverList(
                //     delegate: SliverChildListDelegate([
                //   club_point_addon_installed.$
                //       ? Padding(
                //           padding: const EdgeInsets.fromLTRB(
                //             16.0,
                //             8.0,
                //             16.0,
                //             0.0,
                //           ),
                //           child: _productDetails != null
                //               ? buildClubPointRow()
                //               : ShimmerHelper().buildBasicShimmer(
                //                   height: 30.0,
                //                 ),
                //         )
                //       : Container(),
                //   Divider(
                //     height: 24.0,
                //   ),
                // ])),
                // SliverList(
                //     delegate: SliverChildListDelegate([
                //   _productDetails != null
                //       ? buildChoiceOptionList()
                //       : buildVariantShimmers(),
                // ])),
                // SliverToBoxAdapter(
                //   child: Padding(
                //     padding: const EdgeInsets.fromLTRB(
                //       16.0,
                //       16.0,
                //       16.0,
                //       0.0,
                //     ),
                //     // child: _productDetails != null
                //     //     ? (_colorList.length > 0
                //     //         ? buildColorRow()
                //     //         : Container())
                //     //     : ShimmerHelper().buildBasicShimmer(
                //     //         height: 30.0,
                //     //       ),
                //   ),
                // ),
                SliverList(
                    delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      16.0,
                      8.0,
                      16.0,
                      0.0,
                    ),
                    child: _productDetails != null
                        ? buildQuantityRow()
                        : ShimmerHelper().buildBasicShimmer(
                            height: 30.0,
                          ),
                  ),
                ])),
                SliverList(
                    delegate: SliverChildListDelegate([
                  // Padding(
                  //   padding: const EdgeInsets.fromLTRB(
                  //     16.0,
                  //     16.0,
                  //     16.0,
                  //     0.0,
                  //   ),
                  //   child: _productDetails != null
                  //       ? buildTotalPriceRow()
                  //       : ShimmerHelper().buildBasicShimmer(
                  //           height: 30.0,
                  //         ),
                  // ),
                  Visibility(
                    visible: !_isDescriptionEmpty,
                    child: Divider(
                      height: 24.0,
                    ),
                  ),
                ])),
                // SliverList(
                //     delegate: SliverChildListDelegate([
                //   Padding(
                //     padding: const EdgeInsets.fromLTRB(
                //       16.0,
                //       0.0,
                //       16.0,
                //       0.0,
                //     ),
                //     // child: _productDetails != null
                //     //     ? buildSellerRow(context)
                //     //     : ShimmerHelper().buildBasicShimmer(
                //     //         height: 50.0,
                //     //       ),
                //   ),
                //   Divider(
                //     height: 24,
                //   ),
                // ])),
                SliverList(
                  delegate: SliverChildListDelegate([
                    // Visibility(
                    //   visible: !_isDescriptionEmpty,
                    //   child: Padding(
                    //     padding: const EdgeInsets.fromLTRB(
                    //       16.0,
                    //       0.0,
                    //       16.0,
                    //       0.0,
                    //     ),
                    //     child: Text(
                    //       AppLocalizations.of(context)
                    //           .product_details_screen_description,
                    //       style: TextStyle(
                    //           color: MyTheme.secondary,
                    //           fontSize: 14,
                    //           fontWeight: FontWeight.w600),
                    //     ),
                    //   ),
                    // ),

                    Visibility(
                      visible: !_isDescriptionEmpty,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          8.0,
                          0.0,
                          8.0,
                          0.0,
                        ),
                        child: _productDetails != null
                            ? buildExpandableDescription()
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 0.0),
                                child: ShimmerHelper().buildBasicShimmer(
                                  height: 60.0,
                                )),
                      ),
                    ),

                    Visibility(
                      visible: _skinTypes.length > 0,
                      child: Divider(
                        height: 24.0,
                      ),
                    ),

                    Visibility(
                      visible: _skinTypes.length > 0,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          16.0,
                          0.0,
                          16.0,
                          0.0,
                        ),
                        child: _productDetails != null
                            ? buildSkinTypesRow()
                            : ShimmerHelper().buildBasicShimmer(
                                height: 50.0,
                              ),
                      ),
                    ),
                    Visibility(
                      visible: _keyIngredients.length > 0,
                      child: Divider(
                        height: 24.0,
                      ),
                    ),
                    Visibility(
                      visible: _keyIngredients.length > 0,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          16.0,
                          0.0,
                          16.0,
                          0.0,
                        ),
                        child: _productDetails != null
                            ? buildKeyIngredientsRow()
                            : ShimmerHelper().buildBasicShimmer(
                                height: 50.0,
                              ),
                      ),
                    ),
                    Visibility(
                      visible: _goodFor.length > 0,
                      child: Divider(
                        height: 24.0,
                      ),
                    ),
                    Visibility(
                      visible: _goodFor.length > 0,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          16.0,
                          0.0,
                          16.0,
                          0.0,
                        ),
                        child: _productDetails != null
                            ? buildGoodForRow()
                            : ShimmerHelper().buildBasicShimmer(
                                height: 50.0,
                              ),
                      ),
                    ),
                    Visibility(
                      visible: _categories.length > 0,
                      child: Divider(
                        height: 24.0,
                      ),
                    ),
                    Visibility(
                      visible: _categories.length > 0,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          16.0,
                          0.0,
                          16.0,
                          0.0,
                        ),
                        child: _productDetails != null
                            ? buildCategoriesRow()
                            : ShimmerHelper().buildBasicShimmer(
                                height: 50.0,
                              ),
                      ),
                    ),
                    Visibility(
                      visible: _tags.length > 0,
                      child: Divider(
                        height: 24.0,
                      ),
                    ),
                    Visibility(
                      visible: _tags.length > 0,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          16.0,
                          0.0,
                          16.0,
                          0.0,
                        ),
                        child: _productDetails != null
                            ? buildTagsRow()
                            : ShimmerHelper().buildBasicShimmer(
                                height: 50.0,
                              ),
                      ),
                    ),
                    Divider(
                      height: 24.0,
                    ),
                    // InkWell(
                    //   onTap: () {
                    //     if (_productDetails.video_link == "") {
                    //       ToastComponent.showDialog(
                    //           AppLocalizations.of(context)
                    //               .product_details_screen_video_not_available,
                    //           context,
                    //           gravity: Toast.CENTER,
                    //           duration: Toast.LENGTH_LONG);
                    //       return;
                    //     }

                    //     Navigator.push(context,
                    //         MaterialPageRoute(builder: (context) {
                    //       return VideoDescription(
                    //         url: _productDetails.video_link,
                    //       );
                    //     })).then((value) {
                    //       onPopped(value);
                    //     });
                    //   },
                    //   child: Container(
                    //     height: 40,
                    //     child: Padding(
                    //       padding: const EdgeInsets.fromLTRB(
                    //         16.0,
                    //         0.0,
                    //         8.0,
                    //         0.0,
                    //       ),
                    //       child: Row(
                    //         children: [
                    //           Text(
                    //             AppLocalizations.of(context)
                    //                 .product_details_screen_video,
                    //             style: TextStyle(
                    //                 color: MyTheme.secondary,
                    //                 fontSize: 14,
                    //                 fontWeight: FontWeight.w600),
                    //           ),
                    //           Spacer(),
                    //           Icon(
                    //             Ionicons.ios_add,
                    //             color: MyTheme.secondary,
                    //             size: 24,
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // Divider(
                    //   height: 1,
                    // ),
                    ExpansionTile(
                      title: Text(
                        AppLocalizations.of(context)
                            .product_details_screen_description
                            .toUpperCase(),
                        style: TextStyle(
                          color: MyTheme.secondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: Icon(
                        Icons.keyboard_arrow_down,
                        color: MyTheme.secondary,
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            16.0,
                            0.0,
                            8.0,
                            0.0,
                          ),
                          child: _description != null
                              ? Html(
                                  data: _description,
                                )
                              : Container(),
                        ),
                      ],
                    ),

                    Divider(
                      height: 1,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ProductReviews(id: widget.id);
                        })).then((value) {
                          onPopped(value);
                        });
                      },
                      child: Container(
                        height: 40,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            16.0,
                            0.0,
                            8.0,
                            0.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)
                                    .product_details_screen_reviews
                                    .toUpperCase(),
                                style: TextStyle(
                                    color: MyTheme.secondary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                              Icon(
                                Ionicons.ios_add,
                                color: MyTheme.secondary,
                                size: 24,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      height: 1,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ProductQuestions(id: widget.id);
                        })).then((value) {
                          onPopped(value);
                        });
                      },
                      child: Container(
                        height: 40,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            16.0,
                            0.0,
                            8.0,
                            0.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)
                                    .product_details_product_questions
                                    .toUpperCase(),
                                style: TextStyle(
                                    color: MyTheme.secondary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                              // Spacer(),
                              Icon(
                                Ionicons.ios_add,
                                color: MyTheme.secondary,
                                size: 24,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      height: 1,
                    ),
                  ]),
                ),
                // SliverList(
                //   delegate: SliverChildListDelegate([
                //     Padding(
                //       padding: const EdgeInsets.fromLTRB(
                //         16.0,
                //         36.0,
                //         16.0,
                //         0.0,
                //       ),
                //       child: Text(
                //         AppLocalizations.of(context)
                //             .product_details_screen_products_purchased
                //             .toUpperCase(),
                //         style: TextStyle(
                //             color: MyTheme.secondary,
                //             fontSize: 16,
                //             fontWeight: FontWeight.w600),
                //       ),
                //     ),
                //     Padding(
                //       padding: const EdgeInsets.fromLTRB(
                //         16.0,
                //         16.0,
                //         16.0,
                //         0.0,
                //       ),
                //       child: buildTopSellingProductList(),
                //     )
                //   ]),
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
                      child: Text(
                        AppLocalizations.of(context)
                            .product_details_screen_products_recommended
                            .toUpperCase(),
                        style: TextStyle(
                            color: MyTheme.secondary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        8.0,
                        16.0,
                        0.0,
                        0.0,
                      ),
                      child: buildRecommendedProductList(),
                    )
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
                      child: Text(
                        AppLocalizations.of(context)
                            .product_details_screen_products_related
                            .toUpperCase(),
                        style: TextStyle(
                            color: MyTheme.secondary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        8.0,
                        16.0,
                        0.0,
                        0.0,
                      ),
                      child: buildProductsMayLikeList(),
                    )
                  ]),
                ),
              ],
            ),
          )),
    );
  }

  Row buildSellerRow(BuildContext context) {
    //print("sl:" +  _productDetails.shop_logo);
    return Row(
      children: [
        _productDetails.added_by == "admin"
            ? Container()
            : Padding(
                padding: app_language_rtl.$
                    ? EdgeInsets.only(left: 8.0)
                    : EdgeInsets.only(right: 8.0),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2.0),
                    border: Border.all(
                        color: Color.fromRGBO(112, 112, 112, .3), width: 0.5),
                    //shape: BoxShape.rectangle,
                  ),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/placeholder.png',
                    image: _productDetails.shop_logo,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
        Container(
          width: MediaQuery.of(context).size.width * (.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context).product_details_screen_seller,
                  style: TextStyle(
                    color: Color.fromRGBO(153, 153, 153, 1),
                  )),
              Text(
                _productDetails.shop_name,
                style: TextStyle(
                    color: MyTheme.secondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
        Spacer(),
        Container(
            child: Row(
          children: [
            InkWell(
              onTap: () {
                if (is_logged_in == false) {
                  ToastComponent.showDialog("You need to log in", context,
                      gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
                  return;
                }

                onTapSellerChat();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  AppLocalizations.of(context)
                      .product_details_screen_chat_with_seller,
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Color.fromRGBO(7, 101, 136, 1),
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Icon(Icons.message, size: 16, color: Color.fromRGBO(7, 101, 136, 1))
          ],
        ))
      ],
    );
  }

  Row buildTotalPriceRow() {
    return Row(
      children: [
        Padding(
          padding: app_language_rtl.$
              ? EdgeInsets.only(left: 8.0)
              : EdgeInsets.only(right: 8.0),
          child: Container(
            width: 75,
            child: Text(
              AppLocalizations.of(context).product_details_screen_total_price,
              style: TextStyle(color: Color.fromRGBO(153, 153, 153, 1)),
            ),
          ),
        ),
        Text(
          "৳" + _totalPrice.toString(),
          style: TextStyle(
              color: MyTheme.secondary,
              fontSize: 18.0,
              fontWeight: FontWeight.w600),
        )
      ],
    );
  }

  Row buildQuantityRow() {
    return Row(
      children: [
        Padding(
          padding: app_language_rtl.$
              ? EdgeInsets.only(left: 8.0)
              : EdgeInsets.only(right: 8.0),
          child: Container(
            width: 75,
            child: Text(
              AppLocalizations.of(context).product_details_screen_quantity,
              style: TextStyle(color: Color.fromRGBO(153, 153, 153, 1)),
            ),
          ),
        ),
        Container(
          height: 36,
          width: 120,
          decoration: BoxDecoration(
            // border:
            //     Border.all(color: Color.fromRGBO(222, 222, 222, 1), width: 1),
            // borderRadius: BorderRadius.circular(36.0),
              color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              buildQuantityDownButton(),
              Container(
                  height: 33,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: MyTheme.dark_grey, // Set border color
                      width: 1.0, // Set border width
                    ),
                  ),
                  width: 33,
                  child: Center(
                      child: Text(
                        _quantity.toString(),
                        style: TextStyle(fontSize: 18, color: MyTheme.secondary),
                      ))),
              buildQuantityUpButton()
            ],
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
        //   child: Container(
        //
        //   ),
        //   // child: Text(
        //   //   //"(${_stock} ${AppLocalizations.of(context).product_details_screen_available})",
        //   //   _stock != null ? 'In Stock' : 'out of stock',
        //   //   style: TextStyle(
        //   //       //color: Color.fromRGBO(152, 152, 153, 1),
        //   //     color: MyTheme.primary,
        //   //       fontWeight: FontWeight.w600,
        //   //       fontSize: 14),
        //   // ),
        // ),

        SizedBox(
          width: MediaQuery.of(context).size.width * 0.15,),

        Text(
          //   //"(${_stock} ${AppLocalizations.of(context).product_details_screen_available})",
          _stock != 0 ? 'In Stock' : 'Stock Out',
          style: TextStyle(
            //color: Color.fromRGBO(152, 152, 153, 1),
              color: _stock != 0? Colors.green : MyTheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 14),
        )
      ],
    );
  }

  Padding buildVariantShimmers() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16.0,
        0.0,
        8.0,
        0.0,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: [
                Padding(
                  padding: app_language_rtl.$
                      ? EdgeInsets.only(left: 8.0)
                      : EdgeInsets.only(right: 8.0),
                  child: ShimmerHelper()
                      .buildBasicShimmer(height: 30.0, width: 60),
                ),
                Padding(
                  padding: app_language_rtl.$
                      ? EdgeInsets.only(left: 8.0)
                      : EdgeInsets.only(right: 8.0),
                  child: ShimmerHelper()
                      .buildBasicShimmer(height: 30.0, width: 60),
                ),
                Padding(
                  padding: app_language_rtl.$
                      ? EdgeInsets.only(left: 8.0)
                      : EdgeInsets.only(right: 8.0),
                  child: ShimmerHelper()
                      .buildBasicShimmer(height: 30.0, width: 60),
                ),
                Padding(
                  padding: app_language_rtl.$
                      ? EdgeInsets.only(left: 8.0)
                      : EdgeInsets.only(right: 8.0),
                  child: ShimmerHelper()
                      .buildBasicShimmer(height: 30.0, width: 60),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: [
                Padding(
                  padding: app_language_rtl.$
                      ? EdgeInsets.only(left: 8.0)
                      : EdgeInsets.only(right: 8.0),
                  child: ShimmerHelper()
                      .buildBasicShimmer(height: 30.0, width: 60),
                ),
                Padding(
                  padding: app_language_rtl.$
                      ? EdgeInsets.only(left: 8.0)
                      : EdgeInsets.only(right: 8.0),
                  child: ShimmerHelper()
                      .buildBasicShimmer(height: 30.0, width: 60),
                ),
                Padding(
                  padding: app_language_rtl.$
                      ? EdgeInsets.only(left: 8.0)
                      : EdgeInsets.only(right: 8.0),
                  child: ShimmerHelper()
                      .buildBasicShimmer(height: 30.0, width: 60),
                ),
                Padding(
                  padding: app_language_rtl.$
                      ? EdgeInsets.only(left: 8.0)
                      : EdgeInsets.only(right: 8.0),
                  child: ShimmerHelper()
                      .buildBasicShimmer(height: 30.0, width: 60),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildChoiceOptionList() {
    return ListView.builder(
      // itemCount: _productDetails.choice_options.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          // child: buildChoiceOpiton(_productDetails.choice_options, index),
        );
      },
    );
  }

  buildChoiceOpiton(choice_options, choice_options_index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16.0,
        8.0,
        16.0,
        0.0,
      ),
      child: Row(
        children: [
          Padding(
            padding: app_language_rtl.$
                ? EdgeInsets.only(left: 8.0)
                : EdgeInsets.only(right: 8.0),
            child: Container(
              width: 75,
              child: Text(
                choice_options[choice_options_index].title,
                style: TextStyle(color: Color.fromRGBO(153, 153, 153, 1)),
              ),
            ),
          ),
          Container(
            height: 40,
            width: MediaQuery.of(context).size.width - (75 + 40),
            child: Scrollbar(
              controller: _variantScrollController,
              isAlwaysShown: false,
              child: ListView.builder(
                itemCount: choice_options[choice_options_index].options.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: buildChoiceItem(
                        choice_options[choice_options_index].options[index],
                        choice_options_index,
                        index),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  buildChoiceItem(option, choice_options_index, index) {
    return Padding(
      padding: app_language_rtl.$
          ? EdgeInsets.only(left: 8.0)
          : EdgeInsets.only(right: 8.0),
      child: InkWell(
        onTap: () {
          //  _onVariantChange(choice_options_index, option);
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: _selectedChoices[choice_options_index] == option
                    ? MyTheme.secondary
                    : Color.fromRGBO(224, 224, 225, 1),
                width: 1.5),
            borderRadius: BorderRadius.circular(3.0),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 3.0),
            child: Center(
              child: Text(
                option,
                style: TextStyle(
                    color: _selectedChoices[choice_options_index] == option
                        ? MyTheme.secondary
                        : Color.fromRGBO(224, 224, 225, 1),
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),
    );
  }

  buildColorRow() {
    return Row(
      children: [
        Padding(
          padding: app_language_rtl.$
              ? EdgeInsets.only(left: 8.0)
              : EdgeInsets.only(right: 8.0),
          child: Container(
            width: 75,
            child: Text(
              AppLocalizations.of(context).product_details_screen_color,
              style: TextStyle(color: Color.fromRGBO(153, 153, 153, 1)),
            ),
          ),
        ),
        Container(
          height: 40,
          width: MediaQuery.of(context).size.width - (75 + 40),
          child: Scrollbar(
            controller: _colorScrollController,
            isAlwaysShown: false,
            child: ListView.builder(
              itemCount: _colorList.length,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: buildColorItem(index),
                );
              },
            ),
          ),
        )
      ],
    );
  }

  buildColorItem(index) {
    return Padding(
      padding: app_language_rtl.$
          ? EdgeInsets.only(left: 8.0)
          : EdgeInsets.only(right: 8.0),
      child: InkWell(
        onTap: () {
          // _onColorChange(index);
        },
        child: Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
              border: Border.all(
                  color: _selectedColorIndex == index
                      ? Colors.purple
                      : Colors.white,
                  width: 1),
              borderRadius: BorderRadius.circular(16.0),
              color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Color.fromRGBO(222, 222, 222, 1), width: 1),
                  borderRadius: BorderRadius.circular(16.0),
                  color: ColorHelper.getColorFromColorCode(_colorList[index])),
              child: _selectedColorIndex == index
                  ? buildColorCheckerContainer()
                  : Container(),
            ),
          ),
        ),
      ),
    );
  }

  buildColorCheckerContainer() {
    return Padding(
        padding: const EdgeInsets.all(3),
        child: /*Icon(FontAwesome.check, color: Colors.white, size: 16),*/
            Image.asset(
          "assets/white_tick.png",
          width: 16,
          height: 16,
        ));
  }

  Row buildClubPointRow() {
    return Row(
      children: [
        Padding(
          padding: app_language_rtl.$
              ? EdgeInsets.only(left: 8.0)
              : EdgeInsets.only(right: 8.0),
          child: Container(
            width: 75,
            child: Text(
              AppLocalizations.of(context).product_details_screen_club_point,
              style: TextStyle(color: Color.fromRGBO(153, 153, 153, 1)),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: MyTheme.secondary, width: 1),
              borderRadius: BorderRadius.circular(16.0),
              color: Color.fromRGBO(253, 235, 212, 1)),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
            child: Text(
              _productDetails.earn_point.toString(),
              style: TextStyle(color: MyTheme.secondary, fontSize: 12.0),
            ),
          ),
        )
      ],
    );
  }

  Row buildMainPriceRow() {
    return Row(
      children: [
        Padding(
          padding: app_language_rtl.$
              ? EdgeInsets.only(left: 8.0)
              : EdgeInsets.only(right: 8.0),
          child: Container(
            width: 75,
            child: Text(
              AppLocalizations.of(context).product_details_screen_price,
              style: TextStyle(color: Color.fromRGBO(153, 153, 153, 1)),
            ),
          ),
        ),
        Visibility(
          visible: _productDetails.salePrice != _productDetails.price,
          child: Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Text("৳" + _productDetails.price.toString(),
                style: TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Color.fromRGBO(224, 224, 225, 1),
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600)),
          ),
        ),
        Text(
          "৳" + _productDetails.salePrice.toString(),
          style: TextStyle(
              color: MyTheme.secondary,
              fontSize: 18.0,
              fontWeight: FontWeight.w600),
        )
      ],
    );
  }

  AppBar buildAppBar(double statusBarHeight, BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: MyTheme.primary,
        ),
      ),
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      centerTitle: true,
      title: Container(
        height: kToolbarHeight +
            statusBarHeight -
            (MediaQuery.of(context).viewPadding.top > 40 ? 32.0 : 16.0),
        //MediaQuery.of(context).viewPadding.top is the statusbar height, with a notch phone it results almost 50, without a notch it shows 24.0.For safety we have checked if its greater than thirty
        child:Container(
          width: MediaQuery.of(context).size.width * .78,
          child: Container(
            child: Padding(
                padding: MediaQuery.of(context).viewPadding.top >
                    30 //MediaQuery.of(context).viewPadding.top is the statusbar height, with a notch phone it results almost 50, without a notch it shows 24.0.For safety we have checked if its greater than thirty
                    ? const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0)
                    : const EdgeInsets.symmetric(vertical: 6.0, horizontal: 0.0),
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
                            return ProductDetails(id: suggestion.id);
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
      ),
      elevation: 0.0,
      titleSpacing: 0,
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 2.0),
          child: Icon(Icons.search, color: Colors.white),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 2.0),
          child: InkWell(
            onTap: (){
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=> Main()), (route) => false);
            },
              child: Icon(Icons.home_outlined, color: Colors.white)),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 2.0),
          child: InkWell(
              onTap: (){
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=> Main(
                  pageIndex: 2,
                )), (route) => false);
              },
              child: Icon(Icons.shopping_bag_outlined, color: Colors.white)),
        ),

      ],
    );
  }
  //
  // init() {
  //   _givenSelectedFilterOptionKey = widget.selected_filter;
  //
  //   _dropdownWhichFilterItems =
  //       buildDropdownWhichFilterItems(_which_filter_list);
  //   _selectedFilter = _dropdownWhichFilterItems[0].value;
  //
  //   for (int x = 0; x < _dropdownWhichFilterItems.length; x++) {
  //     if (_dropdownWhichFilterItems[x].value.option_key ==
  //         _givenSelectedFilterOptionKey) {
  //       _selectedFilter = _dropdownWhichFilterItems[x].value;
  //     }
  //   }

  _onSearchSubmit() {
    // reset();
    // if (_selectedFilter.option_key == "sellers") {
    //   resetShopList();
    //   fetchShopData();
    // } else if (_selectedFilter.option_key == "brands") {
    //   resetBrandList();
    //   fetchBrandData();
    // } else {
    //   resetProductList();
    //   fetchProductData();
    // }
  }
  // resetShopList() {
  //   _shopList.clear();
  //   _isShopInitial = true;
  //   _totalShopData = 0;
  //   _shopPage = 1;
  //   _showShopLoadingContainer = false;
  //   setState(() {});
  // }


  buildBottomAppBar(BuildContext context, _addedToCartSnackbar) {
    return Builder(builder: (BuildContext context) {
      return BottomAppBar(
        child: Container(
          color: Colors.transparent,
          height: 44,
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Visibility(
                visible: widget.stock > 0,
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: 44,
                  child: RaisedButton(
                    onPressed: () {
                      onPressAddToCart(context, _addedToCartSnackbar);
                    },
                    // shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(80.0)),
                    padding: EdgeInsets.all(0.0),
                    child: Ink(
                      color: MyTheme.secondary,
                      child: Container(
                          constraints:
                              BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons
                                    .shopping_bag_outlined, // Use the appropriate cart icon
                                color: Colors.white,
                                size: 17,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              // Add some space between the icon and text
                              Text(
                                AppLocalizations.of(context)
                                    .product_details_screen_button_add_to_cart,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
              ),
              // SizedBox(
              //   width: 1,
              // ),
              Visibility(
                visible: widget.stock > 0,
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: 44,
                  child: RaisedButton(
                    onPressed: () {
                      onPressBuyNow(context);
                    },
                    padding: EdgeInsets.all(0.0),
                    child: Ink(
                      color: MyTheme.primary,
                      child: Container(
                        constraints:
                            BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                        alignment: Alignment.center,
                        child: Text(
                          AppLocalizations.of(context)
                              .product_details_screen_button_buy_now,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Visibility(
                visible: widget.stock == 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 44,
                  child: RaisedButton(
                    onPressed: () {
                      onPressBuyNow(context);
                    },
                    padding: EdgeInsets.all(0.0),
                    child: Ink(
                      // color: MyTheme.primary,
                      child: Container(
                        constraints:
                            BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                        alignment: Alignment.center,
                        child: Text(
                          AppLocalizations.of(context)
                              .product_details_screen_button_out_of_stock
                              .toUpperCase(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  buildRatingAndWishButtonRow() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ProductReviews(id: widget.id);
            })).then((value) {
              onPopped(value);
            });
          },
          child: RatingBar(
            itemSize: 18.0,
            ignoreGestures: true,
            initialRating: double.parse(_productDetails.ratings.toString()),
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            ratingWidget: RatingWidget(
              full: Icon(FontAwesome.star, color: Colors.amber),
              empty: Icon(FontAwesome.star,
                  color: Color.fromRGBO(224, 224, 225, 1)),
            ),
            itemPadding: EdgeInsets.only(right: 1.0),
            onRatingUpdate: (rating) {
              //print(rating);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            "(" + _productDetails.reviews.toString() + ")",
            style: TextStyle(
                color: Color.fromRGBO(152, 152, 153, 1), fontSize: 14),
          ),
        ),
        Spacer(),
        _isInWishList
            ? InkWell(
                onTap: () {
                  onWishTap();
                },
                child: Icon(
                  FontAwesome.heart,
                  color: MyTheme.secondary,
                  size: 20,
                ),
              )
            : InkWell(
                onTap: () {
                  onWishTap();
                },
                child: Icon(
                  FontAwesome.heart_o,
                  color: Color.fromRGBO(230, 46, 4, 1),
                  size: 20,
                ),
              )
      ],
    );
  }

  buildBrandRow() {
    return _productDetails.productBrands.length > 0
        ? InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return BrandProducts(
                  id: _productDetails.productBrands[0].pivot.product_brand_id,
                  brand_name: _productDetails.productBrands[0].name,
                );
              }));
            },
            child: Row(
              children: [
                Padding(
                  padding: app_language_rtl.$
                      ? EdgeInsets.only(left: 8.0)
                      : EdgeInsets.only(right: 8.0),
                  child: Container(
                    width: 75,
                    child: Text(
                      AppLocalizations.of(context).product_details_screen_brand,
                      style: TextStyle(color: Color.fromRGBO(153, 153, 153, 1)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    _productDetails.productBrands[0].name,
                    style: TextStyle(
                        color: Color.fromRGBO(152, 152, 153, 1), fontSize: 16),
                  ),
                ),
              ],
            ),
          )
        : Container();
  }

  ExpandableNotifier buildExpandableDescription() {
    return ExpandableNotifier(
        child: ScrollOnExpand(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Visibility(
            child: Expandable(
              collapsed: Container(
                  height: 50,
                  child: Html(data: _productDetails.shortDescription ?? '')),
              expanded: Container(
                  child: Html(data: _productDetails.shortDescription ?? '')),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Builder(
                builder: (context) {
                  var controller = ExpandableController.of(context);
                  return Padding(
                    padding: const EdgeInsets.only(right: 10.0, top: 8.0),
                    child: GestureDetector(
                      child: Text(
                        !controller.expanded
                            ? AppLocalizations.of(context).common_view_more
                            : AppLocalizations.of(context).common_show_less,
                        style:
                            TextStyle(color: MyTheme.secondary, fontSize: 11),
                      ),
                      onTap: () {
                        controller.toggle();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ));
  }

  buildSkinTypesRow() {
    return _productDetails.skinTypes.length > 0
        ? Container(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Padding(
                  padding: app_language_rtl.$
                      ? EdgeInsets.only(left: 8.0)
                      : EdgeInsets.only(right: 0.0),
                  child: Container(
                    width: 75,
                    child: Text(
                      AppLocalizations.of(context)
                          .product_details_screen_skin_types,
                      style: TextStyle(
                          color: MyTheme.dark_grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                ...List.generate(_skinTypes.length, (index) {
                  final skinType = _skinTypes[index];

                  return InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Filter(
                          selected_skin: skinType,
                        );
                      }));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2.0, vertical: 2.0),
                      child: Container(
                        padding: EdgeInsets.only(
                            top: 0, bottom: 0, right: 5, left: 5),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: MyTheme.secondary,
                            width: 1.0,
                          ),
                        ),
                        child: Text(
                          "${skinType.substring(0, 1).toUpperCase()}${skinType.substring(1)}",
                          style: TextStyle(
                            color: MyTheme.secondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          )
        : Container();
  }

  buildKeyIngredientsRow() {
    return _productDetails.keyIngredients.length > 0
        ? InkWell(
            onTap: () {},
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Padding(
                  padding: app_language_rtl.$
                      ? EdgeInsets.only(left: 8.0)
                      : EdgeInsets.only(right: 4.0),
                  child: Container(
                    child: Text(
                      AppLocalizations.of(context)
                          .product_details_screen_key_ingredients,
                      style: TextStyle(
                        color: MyTheme.dark_grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                ...List.generate(_keyIngredients.length, (index) {
                  final ingredients = _keyIngredients[index];

                  return InkWell(
                    onTap: () {
                      // Handle the click on the ingredients (add your logic here)
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Filter(
                          key_ingredients: ingredients,
                        );
                      }));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Container(
                        padding: EdgeInsets.only(
                            top: 0, bottom: 0, right: 0, left: 0),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: MyTheme.secondary,
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: Text(
                          "${ingredients.substring(0, 1).toUpperCase()}${ingredients.substring(1)}${index == _keyIngredients.length - 1 ? '' : ', '}",
                          style: TextStyle(
                              color: MyTheme.secondary,
                              fontSize: 14,
                              height: 1.6,
                          fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          )
        : Container();
  }

  buildGoodForRow() {
    return _productDetails.goodFor.length > 0
        ? InkWell(
            onTap: () {},
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Padding(
                  padding: app_language_rtl.$
                      ? EdgeInsets.only(left: 8.0)
                      : EdgeInsets.only(right: 0.0),
                  child: Container(
                    width: 75,
                    child: Text(
                      AppLocalizations.of(context)
                          .product_details_screen_good_for,
                      style: TextStyle(
                        color: MyTheme.dark_grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                ...List.generate(_goodFor.length, (index) {
                  final good_for = _goodFor[index];

                  return InkWell(
                    onTap: () {
                      // Handle the click on the ingredients (add your logic here)
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Filter(
                          good_for: good_for,
                        );
                      }));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2.0, vertical: 2.0),
                      child: Container(
                        padding: EdgeInsets.only(
                            top: 0, bottom: 0, right: 5, left: 5),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: MyTheme.secondary,
                            width: 1.0,
                          ),
                        ),
                        child: Text(
                          "${good_for.substring(0, 1).toUpperCase()}${good_for.substring(1)}${index == good_for.length - 1 ? '' : ''}",
                          style: TextStyle(
                            color: MyTheme.secondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          )
        : Container();
  }

  buildCategoriesRow() {
    return _productDetails.productCategories.length > 0
        ? InkWell(
            onTap: () {},
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Padding(
                  padding: app_language_rtl.$
                      ? EdgeInsets.only(left: 8.0)
                      : EdgeInsets.only(right: 8.0),
                  child: Container(
                    width: 75,
                    child: Text(
                      AppLocalizations.of(context)
                          .product_details_screen_categories,
                      style: TextStyle(
                        color: MyTheme.secondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                ...List.generate(_categories.length, (index) {
                  final category = _categories[index];
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: InkWell(
                      onTap: () {
                        // Handle the click on the ingredients (add your logic here)
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Filter(
                            category: category,
                          );
                        }));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                          "${category.substring(0, 1).toUpperCase()}${category.substring(1)}${index == _categories.length - 1 ? '' : ','}",
                          style: TextStyle(
                            color: MyTheme.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          )
        : Container();
  }

  buildTagsRow() {
    return _productDetails.productTags.length > 0
        ? InkWell(
            onTap: () {},
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Padding(
                  padding: app_language_rtl.$
                      ? EdgeInsets.only(left: 0.0)
                      : EdgeInsets.only(right: 4.0),
                  child: Container(
                    // width: 75,
                    child: Text(
                      AppLocalizations.of(context).product_details_screen_tags,
                      style: TextStyle(
                        color: MyTheme.dark_grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                ...List.generate(_tags.length, (index) {
                  final tag = _tags[index];

                  return InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Filter(
                          tag: tag,
                        );
                      }));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Container(
                        padding: EdgeInsets.only(
                            top: 0, bottom: 0, right: 0, left: 0),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: MyTheme.secondary,
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: Text(
                          "${tag.substring(0, 1).toUpperCase()}${tag.substring(1)}${index == _tags.length - 1 ? '' : ','}",
                          style: TextStyle(
                              color: MyTheme.secondary,
                              fontSize: 14,
                              height: 1.6,
                          fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                // Spacer(),
              ],
            ),
          )
        : Container();
  }

  buildTopSellingProductList() {
    if (_topProductInit == false && _topProducts.length == 0) {
      return Column(
        children: [
          Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ShimmerHelper().buildBasicShimmer(
                height: 75.0,
              )),
          Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ShimmerHelper().buildBasicShimmer(
                height: 75.0,
              )),
          Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ShimmerHelper().buildBasicShimmer(
                height: 75.0,
              )),
        ],
      );
    } else if (_topProducts.length > 0) {
      print("top: $_topProducts");
      return SingleChildScrollView(
        child: SizedBox(
          height: 250,
          child: ListView.builder(
            itemCount: _topProducts.length,
            scrollDirection: Axis.horizontal,
            itemExtent: MediaQuery.of(context).size.width / 2.5,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 5, left: 5),
                child: MiniProductCard(
                  id: _topProducts[index].id,
                  image: _topProducts[index].pictures[0].url,
                  ratings: _topProducts[index].ratings,
                  name: _topProducts[index].name,
                  price: _topProducts[index].price.toString(),
                  sale_price: _topProducts[index].sale_price.toString(),
                  slug: _topProducts[index].slug,
                  reviews: _topProducts[index].reviews,
                  stock: _topProducts[index].stock,
                ),
              );
            },
          ),
        ),
      );
    } else {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            AppLocalizations.of(context)
                .product_details_screen_no_related_product,
            style: TextStyle(color: MyTheme.secondary),
          )));
    }
  }

  buildProductsMayLikeList() {
    if (_relatedProductInit == false && _relatedProducts.length == 0) {
      return Row(
        children: [
          Padding(
              padding: app_language_rtl.$
                  ? EdgeInsets.only(left: 8.0)
                  : EdgeInsets.only(right: 8.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 32) / 3)),
          Padding(
              padding: app_language_rtl.$
                  ? EdgeInsets.only(left: 8.0)
                  : EdgeInsets.only(right: 8.0),
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
    } else if (_relatedProducts.length > 0) {
      return SingleChildScrollView(
        child: SizedBox(
          height: 250,
          child: ListView.builder(
            itemCount: _relatedProducts.length,
            scrollDirection: Axis.horizontal,
            itemExtent: MediaQuery.of(context).size.width / 2.5,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 5, left: 5),
                child: MiniProductCard(
                  id: _relatedProducts[index].id,
                  image: _relatedProducts[index].pictures[0].url,
                  ratings: _relatedProducts[index].ratings,
                  name: _relatedProducts[index].name,
                  price: _relatedProducts[index].price.toString(),
                  sale_price: _relatedProducts[index].sale_price.toString(),
                  slug: _relatedProducts[index].slug,
                  reviews: _relatedProducts[index].reviews,
                  stock: _relatedProducts[index].stock,
                  discount: _relatedProducts[index].discount,
                ),
              );
            },
          ),
        ),
      );
    } else {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            AppLocalizations.of(context)
                .product_details_screen_no_related_product,
            style: TextStyle(color: MyTheme.secondary),
          )));
    }
  }

  buildRecommendedProductList() {
    if (_recommendedProductInit == false && _recommendedProducts.length == 0) {
      return Row(
        children: [
          Padding(
              padding: app_language_rtl.$
                  ? EdgeInsets.only(left: 8.0)
                  : EdgeInsets.only(right: 8.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 32) / 3)),
          Padding(
              padding: app_language_rtl.$
                  ? EdgeInsets.only(left: 8.0)
                  : EdgeInsets.only(right: 8.0),
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
    } else if (_recommendedProducts.length > 0) {
      return SingleChildScrollView(
        child: SizedBox(
          height: 250,
          child: ListView.builder(
            itemCount: _recommendedProducts.length,
            scrollDirection: Axis.horizontal,
            itemExtent: MediaQuery.of(context).size.width / 2.5,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 5, left: 5),
                child: MiniProductCard(
                  id: _recommendedProducts[index].id,
                  image: _recommendedProducts[index].pictures[0].url,
                  ratings: _recommendedProducts[index].ratings,
                  name: _recommendedProducts[index].name,
                  price: _recommendedProducts[index].price.toString(),
                  sale_price: _recommendedProducts[index].sale_price.toString(),
                  slug: _recommendedProducts[index].slug,
                  reviews: _recommendedProducts[index].reviews,
                  stock: _recommendedProducts[index].stock,
                  discount: _recommendedProducts[index].discount,
                ),
              );
            },
          ),
        ),
      );
    } else {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            AppLocalizations.of(context)
                .product_details_screen_no_recommended_product,
            style: TextStyle(color: MyTheme.secondary),
          )));
    }
  }

  buildQuantityUpButton() => SizedBox(
        width: 36,
        child: IconButton(
            icon: Icon(FontAwesome.plus, size: 16, color: MyTheme.secondary),
            onPressed: () {
              if (_quantity < _stock) {
                _quantity++;
                setState(() {});
                calculateTotalPrice();
              }
            }),
      );

  buildQuantityDownButton() => SizedBox(
      width: 36,
      child: IconButton(
          icon: Icon(FontAwesome.minus, size: 16, color: MyTheme.secondary),
          onPressed: () {
            if (_quantity > 1) {
              _quantity--;
              setState(() {});
              calculateTotalPrice();
            }
          }));

  openPhotoDialog(BuildContext context, path) => showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
                child: Stack(
              children: [
                PhotoView(
                  enableRotation: true,
                  heroAttributes: const PhotoViewHeroAttributes(tag: "someTag"),
                  imageProvider: NetworkImage(path),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    decoration: ShapeDecoration(
                      color: MyTheme.dark_grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                          topRight: Radius.circular(25),
                          topLeft: Radius.circular(25),
                        ),
                      ),
                    ),
                    width: 40,
                    height: 40,
                    child: IconButton(
                      icon: Icon(Icons.clear, color: MyTheme.white),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                    ),
                  ),
                ),
              ],
            )),
          );
        },
      );

  buildProductImageSection() {
    if (_productImageList.length == 0) {
      return Row(
        children: [
          Container(
            width: 40,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: ShimmerHelper()
                      .buildBasicShimmer(height: 40.0, width: 40.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: ShimmerHelper()
                      .buildBasicShimmer(height: 40.0, width: 40.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: ShimmerHelper()
                      .buildBasicShimmer(height: 40.0, width: 40.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: ShimmerHelper()
                      .buildBasicShimmer(height: 40.0, width: 40.0),
                ),
              ],
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: ShimmerHelper().buildBasicShimmer(
                height: 190.0,
              ),
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 250,
            width: 64,
            child: Scrollbar(
              controller: _imageScrollController,
              isAlwaysShown: false,
              thickness: 4.0,
              child: Padding(
                padding: app_language_rtl.$
                    ? EdgeInsets.only(left: 8.0)
                    : EdgeInsets.only(right: 8.0),
                child: ListView.builder(
                    itemCount: _productImageList.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      int itemIndex = index;
                      return GestureDetector(
                        onTap: () {
                          _currentImage = itemIndex;
                          print(_currentImage);
                          setState(() {});
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          margin: EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 2.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: _currentImage == itemIndex
                                    ? MyTheme.secondary
                                    : Color.fromRGBO(112, 112, 112, .3),
                                width: _currentImage == itemIndex ? 2 : 1),
                            //shape: BoxShape.rectangle,
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: _productImageList[index] != null
                                  ?
                                  /*Image.asset(
                                        singleProduct.product_images[index])*/
                                  FadeInImage.assetNetwork(
                                      placeholder: 'assets/placeholder.png',
                                      image: _productImageList[index],
                                      fit: BoxFit.contain,
                                    )
                                  : Image.asset(
                                      'assets/app_logo.png',
                                      fit: BoxFit.fitWidth,
                                    )),
                        ),
                      );
                    }),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              openPhotoDialog(context, _productImageList[_currentImage]);
            },
            child: Stack(
              children: [
                Container(
                  height: 250,
                  width: MediaQuery.of(context).size.width - 96,
                  child: Container(
                      child: FadeInImage.assetNetwork(
                    placeholder: 'assets/placeholder_rectangle.png',
                    image: _productImageList[_currentImage],
                    fit: BoxFit.scaleDown,
                  )),
                ),
                Visibility(
                  visible: widget.sale_price != widget.price,
                  //visible: true,
                  child: Positioned(
                    left: 30,
                    top:15,
                    child: Container(
                      height: 33,
                      width: 33,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: MyTheme.primary,
                          shape: BoxShape.circle
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Text('-${widget.discount}%',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: MyTheme.white,
                              fontSize: 10
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }
}
