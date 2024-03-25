import 'package:flutter/material.dart';
import 'package:kirei/my_theme.dart';
import 'package:kirei/helpers/shimmer_helper.dart';
import 'package:kirei/app_config.dart';
import 'package:kirei/providers/cart_count_update.dart';
import 'package:kirei/repositories/cart_repository.dart';
import 'package:kirei/repositories/wishlist_repository.dart';
import 'package:kirei/screens/login.dart';
import 'package:kirei/screens/product_details.dart';
import 'package:kirei/custom/toast_component.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:kirei/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Wishlist extends StatefulWidget {
  @override
  _WishlistState createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  ScrollController _mainScrollController = ScrollController();

  //init
  bool _wishlistInit = true;
  List<dynamic> _wishlistItems = [];
  var isPreOrder ;

  @override
  void initState() {
    if (is_logged_in.$ == true) {
      fetchWishlistItems();
    }

    super.initState();
  }

  @override
  void dispose() {
    _mainScrollController.dispose();
    super.dispose();
  }

  fetchWishlistItems() async {
    var wishlistResponse = await WishListRepository().getUserWishlist();
    _wishlistItems.addAll(wishlistResponse.wishlist_items);
    _wishlistInit = false;
    setState(() {});
    //isPreOrder = _wishlistItems[index].preorder_available;
  }

  reset() {
    _wishlistInit = true;
    _wishlistItems.clear();
    setState(() {});
  }

  Future<void> _onPageRefresh() async {
    reset();
    fetchWishlistItems();
  }

  Future<void> _onPressRemove(index) async {
    var wishlist_id = _wishlistItems[index].id;
    _wishlistItems.removeAt(index);
    setState(() {});

    var wishlistDeleteResponse =
        await WishListRepository().delete(wishlist_id: wishlist_id);

    if (wishlistDeleteResponse.result == true) {
      ToastComponent.showDialog(wishlistDeleteResponse.message, context,
          gravity: Toast.TOP, duration: Toast.LENGTH_SHORT);
    }
  }

  int _quantity = 1;
  String _variant="";

  onPressAddToCart(context, int id) {
    //print("IdValue1:" + id.toString());
    addToCart(mode: "add_to_cart", context: context, id: id);
  }
  addToCart({mode, context = null, snackbar = null, id}) async {

    //print("IdValue2:" + id.toString());

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
        .getCartAddResponse(id, _variant, user_id.$, _quantity,);

    if (cartAddResponse.result == false) {
      ToastComponent.showDialog(cartAddResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    } else {
      if (mode == "add_to_cart") {
        //fetchData();
        // if (snackbar != null && context != null) {
        //   Scaffold.of(context).showSnackBar(snackbar);
        // }

        // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        // var cartItem = sharedPreferences.getInt("cartItemCount");
        // cartItem++;
        // sharedPreferences.setInt("cartItemCount", cartItem);
        // print("kirei vai3: + ${sharedPreferences.getInt("cartItemCount")}" );



        setState(() {});

        ToastComponent.showDialog(cartAddResponse.message, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);

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
          body: RefreshIndicator(
            color: MyTheme.primary,
            backgroundColor: Colors.white,
            onRefresh: _onPageRefresh,
            child: CustomScrollView(
              controller: _mainScrollController,
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                SliverList(
                    delegate: SliverChildListDelegate([
                  buildWishlist(),
                ])),
              ],
            ),
          )),
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
        AppLocalizations.of(context).wishlist_screen_my_wishlist,
        style: TextStyle(fontSize: 16, color: MyTheme.primary),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildWishlist() {
    if (is_logged_in.$ == false) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            AppLocalizations.of(context).wishlist_screen_login_warning,
            style: TextStyle(color: MyTheme.secondary),
          )));
    } else if (_wishlistInit == true && _wishlistItems.length == 0) {
      return SingleChildScrollView(
        child: ShimmerHelper().buildListShimmer(item_count: 10),
      );
    } else if (_wishlistItems.length > 0) {
      return SingleChildScrollView(
        child: ListView.builder(
          itemCount: _wishlistItems.length,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 3.0),
              child: buildWishListItem(index),
            );
          },
        ),
      );
    } else {
      return Container(
          height: 100,
          child: Center(
              child: Text(
                  AppLocalizations.of(context).common_no_item_is_available,
                  style: TextStyle(color: MyTheme.secondary))));
    }
  }

  buildWishListItem(index) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProductDetails(
            id: _wishlistItems[index].product.id,
            stock: _wishlistItems[index].product.stock,
          );
        }));
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: Card(
              shape: RoundedRectangleBorder(
                side: new BorderSide(color: MyTheme.light_grey, width: 1.0),
                borderRadius: BorderRadius.circular(16.0),
              ),
              elevation: 0.0,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        width: 100,
                        height: 100,
                        child: ClipRRect(
                            borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(16), right: Radius.zero),
                            child: FadeInImage.assetNetwork(
                              placeholder: 'assets/placeholder.png',
                              image:
                                  _wishlistItems[index].product.thumbnail_image,
                              fit: BoxFit.cover,
                            ))),
                    Container(
                      width: 240,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                            child: Text(
                              _wishlistItems[index].product.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  color: MyTheme.secondary,
                                  fontSize: 14,
                                  height: 1.6,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(8, 4, 8, 8),
                                child: Text(
                                  _wishlistItems[index].product.base_price,
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: MyTheme.secondary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.fromLTRB(16, 4, 8, 8),
                                child: Text(
                                  _wishlistItems[index].product.stock == 0 ?  "Out of Stock" : "In Stock" ,
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      //color: MyTheme.primary,
                                      color: _wishlistItems[index].product.stock == 0 ? MyTheme.primary : Colors.green,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
          app_language_rtl.$
              ? Positioned(
                  bottom: 8,
                  left: 12,
                  child: IconButton(
                    icon: Icon(Icons.delete_forever_outlined,
                        color: MyTheme.dark_grey),
                    onPressed: () {
                      _onPressRemove(index);
                    },
                  ),
                )
              : Positioned(
                  bottom: 8,
                  right: 12,
                  child: IconButton(
                    icon: Icon(Icons.delete_forever_outlined,
                        color: MyTheme.dark_grey),
                    onPressed: () {
                      _onPressRemove(index);
                    },
                  ),
                ),
          
          Positioned(
              top: 8,
              right: 12,
              child: IconButton(
                  onPressed: (){
                    var addCartCount = Provider.of<CartCountUpdate>(context, listen: false);

                    onPressAddToCart(context, _wishlistItems[index].product.id,);
                    setState(() {
                      //print("IdValue:" + _wishlistItems[index].product.id.toString());
                    });
                    if(_wishlistItems[index].product.stock > 0 && is_logged_in.$ == true) {
                      addCartCount.getIncrease();
                    }
                    //print(_wishlistItems.length.toString());
                  },
                  icon: Icon(Icons.add_shopping_cart, color: MyTheme.dark_grey,)
              )
          ),
        ],
      ),
    );
  }
}
