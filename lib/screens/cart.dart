import 'package:kirei/providers/cart_count_update.dart';
import 'package:kirei/screens/checkout.dart';
import 'package:kirei/screens/login.dart';
import 'package:kirei/screens/main.dart';
import 'package:kirei/screens/product_details.dart';
import 'package:flutter/material.dart';
import 'package:kirei/my_theme.dart';
import 'package:kirei/ui_sections/drawer.dart';
import 'package:flutter/widgets.dart';
import 'package:kirei/repositories/cart_repository.dart';
import 'package:kirei/helpers/shared_value_helper.dart';
import 'package:kirei/helpers/shimmer_helper.dart';
import 'package:kirei/custom/toast_component.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Cart extends StatefulWidget {
  Cart({Key key, this.has_bottomnav}) : super(key: key);
  final bool has_bottomnav;

  @override
  CartState createState() => CartState();
}

class CartState extends State<Cart> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController _mainScrollController = ScrollController();
  var _shopList = [];
  bool _isInitial = true;
  var _cartTotal = 0.00;
  var _cartTotalString = ". . .";
  bool _termsChecked = false;
  int _isPreorder=0;

  bool _hasItem = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (is_logged_in.$ == true) {
      fetchData();
    }
  }


  @override
  void dispose() {
    super.dispose();
    _mainScrollController.dispose();
  }

  fetchCartCount() async {
    var total_a = 0;
    var demolist = _shopList[0].cart_items;

    demolist.forEach((val1) {
      total_a += val1.quantity;
    });


    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setInt("cartItemCount", total_a);
    print(sharedPreferences.getInt("cartItemCount"));
    setState(() {});
  }

  fetchData() async {
    print(user_id.$);

    var cartResponseList =
        await CartRepository().getCartResponseList(user_id.$,context);

    print('cartResponse list ${cartResponseList}');
    if (cartResponseList != null && cartResponseList.length > 0) {
      _shopList.clear(); // Clear the existing list before adding new items
      _shopList.addAll(cartResponseList);
      print(_shopList);
    }
    _isInitial = false;

     fetchCartCount();
    getSetCartTotal();
    setState(() {});
  }

  getSetCartTotal() {
    _cartTotal = 0.00;

    if (_shopList.length > 0) {
      _shopList.forEach((shop) {
        if (shop.cart_items.length > 0) {
          shop.cart_items.forEach((cart_item) {
            _cartTotal += double.parse(
                ((cart_item.price + cart_item.tax) * cart_item.quantity)
                    .toStringAsFixed(2));
            _cartTotalString =
                "${cart_item.currency_symbol}${_cartTotal.toStringAsFixed(2)}";
          });
        }
      });
    }

    if (mounted) {
      setState(() {});
    }
  }

  partialTotalString(index) {
    var partialTotal = 0.00;
    var partialTotalString = "";
    if (_shopList[index].cart_items.length > 0) {
      _shopList[index].cart_items.forEach((cart_item) {
        partialTotal += (cart_item.price + cart_item.tax) * cart_item.quantity;
        partialTotalString =
            "${cart_item.currency_symbol}${partialTotal.toStringAsFixed(2)}";
      });
    }

    return partialTotalString;
  }

  onQuantityIncrease(
      seller_index, item_index, VoidCallback increaseItem) async {
    print('working');
    if (_shopList[seller_index].cart_items[item_index].quantity <
        _shopList[seller_index].cart_items[item_index].upper_limit) {
      _shopList[seller_index].cart_items[item_index].quantity++;
      getSetCartTotal();

      var responseData = await CartRepository().getCartQuantityResponse(
          _shopList[seller_index].cart_items[item_index].id,
          _shopList[seller_index].cart_items[item_index].quantity);

      if(responseData["result"].toString() == "false"){
        ToastComponent.showDialog(
            "${responseData["message"].toString()}",
            context,
            gravity: Toast.CENTER,
            duration: Toast.LENGTH_LONG);
      } else {
        increaseItem();
        setState(() {});
      }

    } else {
      ToastComponent.showDialog(
          "${AppLocalizations.of(context).cart_screen_cannot_order_more_than} ${_shopList[seller_index].cart_items[item_index].upper_limit} ${AppLocalizations.of(context).cart_screen_items_of_this}",
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
    }
  }

  onQuantityDecrease(seller_index, item_index, VoidCallback decreaseCartItem) {
    if (_shopList[seller_index].cart_items[item_index].quantity >
        _shopList[seller_index].cart_items[item_index].lower_limit) {
      _shopList[seller_index].cart_items[item_index].quantity--;
      getSetCartTotal();

      CartRepository().getCartQuantityResponse(
          _shopList[seller_index].cart_items[item_index].id,
          _shopList[seller_index].cart_items[item_index].quantity);

      setState(() {});
      decreaseCartItem();
    } else {
      ToastComponent.showDialog(
          "${AppLocalizations.of(context).cart_screen_cannot_order_less_than} ${_shopList[seller_index].cart_items[item_index].lower_limit} ${AppLocalizations.of(context).cart_screen_items_of_this}",
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
    }
  }

  onPressDelete(cart_id, VoidCallback deleteCartItem) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: EdgeInsets.only(
                  top: 16.0, left: 2.0, right: 2.0, bottom: 2.0),
              content: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(
                  AppLocalizations.of(context).cart_screen_sure_remove_item,
                  maxLines: 3,
                  style: TextStyle(color: MyTheme.secondary, fontSize: 14),
                ),
              ),
              actions: [
                FlatButton(
                  child: Text(
                    AppLocalizations.of(context).cart_screen_cancel,
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
                FlatButton(
                  color: MyTheme.primary,
                  child: Text(
                    AppLocalizations.of(context).cart_screen_confirm,
                    style: TextStyle(color: MyTheme.white),
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    confirmDelete(cart_id, deleteCartItem);
                  },
                ),
              ],
            ));
  }

  confirmDelete(cart_id, VoidCallback deleteCartItem) async {
    var cartDeleteResponse =
        await CartRepository().getCartDeleteResponse(cart_id);

    if (cartDeleteResponse.result == true) {
      ToastComponent.showDialog(cartDeleteResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      deleteCartItem();
      await reset(); // Wait for reset to complete
      await fetchData(); // Wait for fetchData to complete
    } else {
      ToastComponent.showDialog(cartDeleteResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    }
  }

  onPressUpdate() {
    process(mode: "update");
  }

  onPressProceedToShipping() {
    process(mode: "proceed_to_shipping");
  }

  process({mode}) async {
    var cart_ids = [];
    var prod_ids = [];
    var cart_quantities = [];
    if (_shopList.length > 0) {
      _shopList.forEach((shop) {
        if (shop.cart_items.length > 0) {
          shop.cart_items.forEach((cart_item) {
            _isPreorder=cart_item.preorderAvailable;
            cart_ids.add(cart_item.id);
            prod_ids.add(cart_item.product_id);

            cart_quantities.add(cart_item.quantity);
          });
        }
      });
    }

   

    if (cart_ids.length == 0) {
      return;
    }

    var cart_ids_string = cart_ids.join(',').toString();
    var cart_quantities_string = cart_quantities.join(',').toString();
    var prod_ids_string = prod_ids.join(',').toString();



    var cartProcessResponse = await CartRepository()
        .getCartProcessResponse(cart_ids_string, cart_quantities_string);

    if (cartProcessResponse.result == false) {
      ToastComponent.showDialog(cartProcessResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    } else {
      ToastComponent.showDialog(cartProcessResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);

      if (mode == "update") {
        reset();
        fetchData();
      } else if (mode == "proceed_to_shipping") {

        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Checkout(
            title: "Checkout",
            product_ids: prod_ids_string,
            product_quantities: cart_quantities_string,
            allCartProductList: _shopList[0].cart_items,
            isPreorder:_isPreorder,
          );
        })).then((value) {
          onPopped(value);
        });
      }
    }
  }

  reset() {
    _shopList = [];
    _isInitial = true;
    _cartTotal = 0.00;
    _cartTotalString = ". . .";
    setState(() {});
  }

  Future<void> _onRefresh() async {
    reset();
    fetchData();
  }

  onPopped(value) async {
    reset();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    var addCartProduct = Provider.of<CartCountUpdate>(context, listen: true);


    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
          key: _scaffoldKey,
          drawer: MainDrawer(),
          backgroundColor: Colors.grey[200],
          appBar: buildAppBar(context),
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
                  slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: buildCartSellerList(
                            () => addCartProduct.getDecrease(),
                            () => addCartProduct.getIncrease(),
                            () => addCartProduct.getDelete(context),
                            () => {},
                          ),
                        ),
                        Container(
                          height: widget.has_bottomnav ? 140 : 100,
                        )
                      ]),
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: _shopList.length != 0
                    ? buildBottomContainer()
                    : Container(),
              )
            ],
          )),
    );
  }

  Container buildBottomContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),

      height: widget.has_bottomnav ? 188 : 150,
      child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          AppLocalizations.of(context).cart_screen_total_amount,
                          style: TextStyle(
                              color: MyTheme.secondary,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text("$_cartTotalString",
                            style: TextStyle(
                                color: MyTheme.secondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
              ),


              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 48,
                    decoration: BoxDecoration(
                        color: MyTheme.secondary,
                        borderRadius: app_language_rtl.$
                            ? const BorderRadius.only(
                                topLeft: const Radius.circular(8.0),
                                bottomLeft: const Radius.circular(8.0),
                                topRight: const Radius.circular(0.0),
                                bottomRight: const Radius.circular(0.0),
                              )
                            : const BorderRadius.only(
                                topLeft: const Radius.circular(0.0),
                                bottomLeft: const Radius.circular(0.0),
                                topRight: const Radius.circular(8.0),
                                bottomRight: const Radius.circular(8.0),
                              )),
                    child: RaisedButton(
                      onPressed: () {
                        onPressProceedToShipping();
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0)),
                      padding: EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: BoxDecoration(),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          color: MyTheme.secondary,
                          alignment: Alignment.center,
                          child: Text(
                            AppLocalizations.of(context)
                                .product_details_screen_button_checkout
                                .toUpperCase(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    )),
              ),
            ],
          )),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(color: MyTheme.primary),
      ),
      leading: GestureDetector(
        onTap: () {
          _scaffoldKey.currentState.openDrawer();
        },
        child: Builder(
          builder: (context) => Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 18.0, horizontal: 0.0),
            child: Container(
              child: Image.asset('assets/hamburger.png',
                  height: 16, color: Theme.of(context).primaryIconTheme.color),
            ),
          ),
        ),
      ),
      title: Text(
        AppLocalizations.of(context).cart_screen_shopping_cart,
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildCartSellerList(VoidCallback decreaseCartItem, VoidCallback increaseItem,
      VoidCallback deleteCartItem, VoidCallback setCartCount) {
    if (is_logged_in.$ == false) {
      return Container(
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/profile.png"),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.07,
              ),
              Align(
                alignment: Alignment.center,
                child: Center(
                    child: Text(
                      AppLocalizations.of(context).cart_screen_please_log_in,
                      style: TextStyle(color: MyTheme.secondary),
                    )),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) => Login()));
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        width: MediaQuery.of(context).size.width * 0.5,
                        color: MyTheme.secondary,

                        alignment: Alignment.center,
                        child: Text(
                          "Login Now",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ));
    } else if (_isInitial && _shopList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildListShimmer(item_count: 5, item_height: 100.0));
    } else if (_shopList.length > 0) {
      return SingleChildScrollView(
        child: ListView.builder(
          itemCount: _shopList.length,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0.0, top: 16.0),
                    child: Row(
                      children: [
                      ],
                    ),
                  ),
                  buildCartSellerItemList(index, decreaseCartItem, increaseItem,
                      deleteCartItem, setCartCount),
                ],
              ),
            );
          },
        ),
      );
    } else if (!_isInitial && _shopList.length == 0) {
      return Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/cart_empty_bag.png"),
            Container(
                height: 100,
                child: Center(
                    child: Text(
                  AppLocalizations.of(context).cart_screen_cart_empty,
                  style: TextStyle(color: MyTheme.secondary),
                ))),
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Main(pageIndex: 1,)));
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.5,
                color: MyTheme.secondary,
                alignment: Alignment.center,
                child: Text(
                  "GO SHOP",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ),
            )
          ],
        ),
      );
    }
  }

  SingleChildScrollView buildCartSellerItemList(
      seller_index,
      VoidCallback decreaseCartItem,
      VoidCallback increaseItem,
      VoidCallback deleteCartItem,
      VoidCallback setCartCount) {
    return SingleChildScrollView(
      child: ListView.builder(
        itemCount: _shopList[seller_index].cart_items.length,
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: buildCartSellerItemCard(seller_index, index,
                decreaseCartItem, increaseItem, deleteCartItem, setCartCount),
          );
        },
      ),
    );
  }

  buildCartSellerItemCard(
      seller_index,
      item_index,
      VoidCallback decreaseCartItem,
      VoidCallback increaseItem,
      VoidCallback deleteCartItem,
      VoidCallback setCartCount) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: MyTheme.light_grey, width: 1.0),
        borderRadius: BorderRadius.circular(0.0),
      ),
      elevation: 0.0,
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Container(
            width: 90,
            height: 100,
            child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/placeholder.png',
                  image: _shopList[seller_index]
                      .cart_items[item_index]
                      .product_thumbnail_image,
                  fit: BoxFit.fitWidth,
                ))),
        GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (_)=> ProductDetails(
              id: _shopList[seller_index].cart_items[item_index]
                  .product_id,
              stock: _shopList[seller_index].cart_items[item_index].upper_limit
            )));
          },
          child: Container(
            width: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _shopList[seller_index]
                            .cart_items[item_index]
                            .product_name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            color: MyTheme.secondary,
                            fontSize: 14,
                            height: 1.6,
                            fontWeight: FontWeight.w400),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              _shopList[seller_index]
                                      .cart_items[item_index]
                                      .currency_symbol +
                                  (_shopList[seller_index]
                                              .cart_items[item_index]
                                              .price *
                                          _shopList[seller_index]
                                              .cart_items[item_index]
                                              .quantity)
                                      .toStringAsFixed(2),
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  color: MyTheme.secondary,
                                  fontSize: 14,
                                  height: 1.6,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Spacer(),
                          SizedBox(
                            height: 28,
                            child: InkWell(
                              onTap: () {},
                              child: IconButton(
                                onPressed: () {
                                  onPressDelete(
                                      _shopList[seller_index]
                                          .cart_items[item_index]
                                          .id,
                                      deleteCartItem);
                                  setCartCount();
                                },
                                icon: Icon(
                                  Icons.delete_forever_outlined,
                                  color: MyTheme.dark_grey,
                                  size: 24,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: Column(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: FlatButton(
                  padding: EdgeInsets.all(0),
                  child: Icon(
                    Icons.add,
                    color: MyTheme.secondary,
                    size: 18,
                  ),
                  color: Colors.white,
                  onPressed: () {
                    onQuantityIncrease(seller_index, item_index, increaseItem);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: MyTheme.dark_grey, // Set border color
                      width: 1.0, // Set border width
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(
                        0.0), // Add some padding inside the border
                    child: Center(
                      child: Text(
                        _shopList[seller_index]
                            .cart_items[item_index]
                            .quantity
                            .toString(),
                        style: TextStyle(
                            color: MyTheme.secondary,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 24,
                height: 24,
                child: FlatButton(
                  padding: EdgeInsets.all(0),
                  child: Icon(
                    Icons.remove,
                    color: MyTheme.secondary,
                    size: 18,
                  ),
                  height: 30,
                  color: Colors.white,
                  onPressed: () {
                    onQuantityDecrease(
                        seller_index, item_index, decreaseCartItem);
                  },
                ),
              )
            ],
          ),
        )
      ]),
    );
  }
}
