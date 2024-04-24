import 'dart:convert';

import 'package:kirei/custom/scroll_to_hide_widget.dart';
import 'package:kirei/data_model/pickup_points_response.dart';
import 'package:kirei/repositories/pickup_points_repository.dart';

import 'package:flutter/material.dart';
import 'package:kirei/my_theme.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:kirei/helpers/shared_value_helper.dart';
import 'package:kirei/repositories/address_repository.dart';
import 'package:kirei/helpers/shimmer_helper.dart';
import 'package:kirei/data_model/city_response.dart';
import 'package:kirei/data_model/country_response.dart';
import 'package:kirei/custom/toast_component.dart';
import 'package:kirei/screens/address.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShippingInfo extends StatefulWidget {
  int owner_id;
  final dynamic product_ids;
  final dynamic product_quantities;

  ShippingInfo(
      {Key key, this.owner_id, this.product_ids, this.product_quantities})
      : super(key: key);

  @override
  _ShippingInfoState createState() => _ShippingInfoState();
}

class _ShippingInfoState extends State<ShippingInfo> {
  ScrollController _mainScrollController = ScrollController();

  // integer type variables
  int _seleted_shipping_address = 0;
  int _seleted_shipping_pickup_point = 0;

  // list type variables
  List<dynamic> _shippingAddressList = [];
  List<PickupPoint> _pickupList = [];
  List<City> _cityList = [];
  List<Country> _countryList = [];

  String _shipping_cost_string = ". . .";
  String _orderNote = '';
  String _selectedPaymentMethod = 'bkash'; // Default to bKash

  // String variable for coupon code
  String _couponCode = '';
  // Boolean variables
  bool isVisible = true;
  bool _isInitial = true;
  bool _shippingOptionIsAddress = true;

  //double variables
  double mWidth = 0;
  double mHeight = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    if (is_logged_in.$ == true) {
      fetchAll();
    }
  }

  fetchAll() {
    if (is_logged_in.$ == true) {
      fetchShippingAddressList();

      if (pick_up_status.$) {
        fetchPickupPoints();
      }
    }
    setState(() {});
  }

  fetchShippingAddressList() async {
    var addressResponse = await AddressRepository().getAddressList();
    _shippingAddressList
        .add(addressResponse.data[addressResponse.data.length - 1]);
    if (_shippingAddressList.length > 0) {
      _seleted_shipping_address = _shippingAddressList[0].id;

      _shippingAddressList.forEach((address) {
        if (address.set_default == 1 && _shippingOptionIsAddress) {
          _seleted_shipping_address = address.id;
        }
      });
    }
    _isInitial = false;
    setState(() {});

    getSetShippingCost();
  }

  fetchPickupPoints() async {
    var pickupPointsResponse =
        await PickupPointRepository().getPickupPointListResponse();
    _pickupList.addAll(pickupPointsResponse.data);
    if (!_shippingOptionIsAddress) {
      _seleted_shipping_pickup_point = _pickupList.first.id;
    }
    getSetShippingCost();
  }

  getSetShippingCost() async {
    var shippingCostResponse;
    if (_shippingOptionIsAddress) {
    } else {
    }

    if (shippingCostResponse.result == true) {
      _shipping_cost_string = shippingCostResponse.value_string;
      setState(() {});
    }
  }

  reset() {
    _shippingAddressList.clear();
    _cityList.clear();
    _pickupList.clear();
    _countryList.clear();
    _shipping_cost_string = ". . .";
    _shipping_cost_string = ". . .";
    _isInitial = true;
    _shippingOptionIsAddress = true;
    _seleted_shipping_pickup_point = 0;
    _seleted_shipping_address = 0;
  }

  Future<void> _onRefresh() async {
    reset();
    if (is_logged_in.$ == true) {
      fetchAll();
    }
  }

  onPopped(value) async {
    reset();
    fetchAll();
  }

  afterAddingAnAddress() {
    reset();
    fetchAll();
  }

  onAddressSwitch() async {
    _shipping_cost_string = ". . .";
    setState(() {});
    getSetShippingCost();
  }

  changeShippingOption(bool option) {
    if (option) {
      _seleted_shipping_pickup_point = 0;

      _shippingAddressList.length > 0
          ? _seleted_shipping_address = _shippingAddressList.first.id
          : _seleted_shipping_address = 0;
    } else {
      _seleted_shipping_address = 0;
      _pickupList.length > 0
          ? _seleted_shipping_pickup_point = _pickupList.first.id
          : _seleted_shipping_pickup_point = 0;
    }
    _shippingOptionIsAddress = option;
    getSetShippingCost();
    setState(() {});
  }

  onPressProceed(context) async {
    // Validate input
    if (_selectedPaymentMethod.isEmpty) {
      ToastComponent.showDialog("Please select a payment method", context);
      return;
    }

    if (_shippingOptionIsAddress && _seleted_shipping_address == 0) {
      ToastComponent.showDialog("Please select a shipping address", context);
      return;
    }

    if (!_shippingOptionIsAddress && _seleted_shipping_pickup_point == 0) {
      ToastComponent.showDialog("Please select a pickup point", context);
      return;
    }

    // Prepare request body
    Map<String, dynamic> requestBody = {
      "api_key": "vXrAne",
      "api_secret": "k7t2G2j3RFBI",
      "product_ids_arr": jsonEncode(widget.product_ids),
      "product_quantities_arr": jsonEncode(widget.product_quantities),
    };

    if (_shippingOptionIsAddress) {
      requestBody["shipping_address"] = _shippingAddressList[0].address;
    } else {
      requestBody["shipping_pickup_point"] = _seleted_shipping_pickup_point;
    }

    requestBody["shipping_name"] = user_name.$;
    requestBody["shipping_phone"] = user_email.$;
    requestBody["shipping_city"] = _shippingAddressList[0].city;
    requestBody["shipping_zone"] = _shippingAddressList[0].zone;
    requestBody["coupon_code"] = _couponCode;
    requestBody["is_preorder"] = false;
    requestBody["payment_type"] = _selectedPaymentMethod;

    // Call API

  }


  @override
  void dispose() {
    super.dispose();
    _mainScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mHeight = MediaQuery.of(context).size.height;
    mWidth = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar: buildBottomAppBar(context),
          body: RefreshIndicator(
            color: MyTheme.primary,
            backgroundColor: Colors.white,
            onRefresh: _onRefresh,
            displacement: 0,
            child: Container(
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 50),
                    child: CustomScrollView(
                      controller: _mainScrollController,
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      slivers: [
                        SliverList(
                            delegate: SliverChildListDelegate([
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: _shippingOptionIsAddress
                                ? buildShippingInfoList()
                                : buildPickupPoint(),
                          ),
                          _shippingOptionIsAddress
                              ? Container(
                                  height: 40,
                                  child: Center(
                                      child: InkWell(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return Address(
                                          from_shipping_info: true,
                                        );
                                      })).then((value) {
                                        onPopped(value);
                                      });
                                    },
                                    child: Visibility(
                                      visible: _shippingAddressList.length == 0,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .shipping_info_screen_go_to_address,
                                          style: TextStyle(
                                              fontSize: 14,
                                              decoration:
                                                  TextDecoration.underline,
                                              color: MyTheme.primary),
                                        ),
                                      ),
                                    ),
                                  )))
                              : Container(),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Order Note',
                                hintText: 'Add a note to your order (optional)',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _orderNote = value;
                                });
                              },
                            ),
                          ),
                        ]))
                      ],
                    ),
                  ),
                  Positioned(top: 0.0, child: customAppBar(context)),
                ],
              ),
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
        "${AppLocalizations.of(context).shipping_info_screen_shipping_cost} ${_shipping_cost_string}",
        style: TextStyle(fontSize: 16, color: MyTheme.primary),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildShippingInfoList() {
    if (is_logged_in.$ == false) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            AppLocalizations.of(context).common_login_warning,
            style: TextStyle(color: MyTheme.secondary),
          )));
    } else if (_isInitial && _shippingAddressList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildListShimmer(item_count: 5, item_height: 100.0));
    } else if (_shippingAddressList.length > 0) {
      return SingleChildScrollView(
        child: ListView.builder(
          itemCount: _shippingAddressList.length,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: buildShippingInfoItemCard(index),
            );
          },
        ),
      );
    } else if (!_isInitial && _shippingAddressList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            AppLocalizations.of(context).common_no_address_added,
            style: TextStyle(color: MyTheme.secondary),
          )));
    }
  }

  GestureDetector buildShippingInfoItemCard(index) {
    return GestureDetector(
      onTap: () {
        if (_seleted_shipping_address != _shippingAddressList[index].id) {
          _seleted_shipping_address = _shippingAddressList[index].id;

          onAddressSwitch();
        }
        setState(() {});
      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: _seleted_shipping_address == _shippingAddressList[index].id
              ? BorderSide(color: MyTheme.primary, width: 2.0)
              : BorderSide(color: MyTheme.light_grey, width: 1.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 0.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 75,
                      child: Text(
                        AppLocalizations.of(context)
                            .shipping_info_screen_address,
                        style: TextStyle(
                          color: MyTheme.secondary,
                        ),
                      ),
                    ),
                    Container(
                      width: 175,
                      child: Text(
                        _shippingAddressList[index].address ?? '',
                        maxLines: 2,
                        style: TextStyle(
                            color: MyTheme.dark_grey,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Spacer(),
                    buildShippingOptionsCheckContainer(
                        _seleted_shipping_address ==
                            _shippingAddressList[index].id)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 75,
                      child: Text(
                        AppLocalizations.of(context).shipping_info_screen_city,
                        style: TextStyle(
                          color: MyTheme.secondary,
                        ),
                      ),
                    ),
                    Container(
                      width: 200,
                      child: Text(
                        _shippingAddressList[index].city ?? '',
                        maxLines: 2,
                        style: TextStyle(
                            color: MyTheme.dark_grey,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 75,
                      child: Text(
                        AppLocalizations.of(context).shipping_info_screen_state,
                        style: TextStyle(
                          color: MyTheme.secondary,
                        ),
                      ),
                    ),
                    Container(
                      width: 200,
                      child: Text(
                        _shippingAddressList[index].zone ?? '',
                        maxLines: 2,
                        style: TextStyle(
                            color: MyTheme.dark_grey,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 75,
                      child: Text(
                        AppLocalizations.of(context)
                            .shipping_info_screen_country,
                        style: TextStyle(
                          color: MyTheme.secondary,
                        ),
                      ),
                    ),
                    Container(
                      width: 200,
                      child: Text(
                        _shippingAddressList[index].area ?? '',
                        maxLines: 2,
                        style: TextStyle(
                            color: MyTheme.dark_grey,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 75,
                      child: Text(
                        AppLocalizations.of(context)
                            .order_details_screen_postal_code,
                        style: TextStyle(
                          color: MyTheme.secondary,
                        ),
                      ),
                    ),
                    Container(
                      width: 200,
                      child: Text(
                        _shippingAddressList[index].postal_code ?? '',
                        maxLines: 2,
                        style: TextStyle(
                            color: MyTheme.dark_grey,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 75,
                      child: Text(
                        AppLocalizations.of(context).shipping_info_screen_phone,
                        style: TextStyle(
                          color: MyTheme.secondary,
                        ),
                      ),
                    ),
                    Container(
                      width: 200,
                      child: Text(
                        _shippingAddressList[index].phone ?? '',
                        maxLines: 2,
                        style: TextStyle(
                            color: MyTheme.dark_grey,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPickupPoint() {
    if (is_logged_in.$ == false) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            AppLocalizations.of(context).common_login_warning,
            style: TextStyle(color: MyTheme.secondary),
          )));
    } else if (_isInitial && _pickupList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildListShimmer(item_count: 5, item_height: 100.0));
    } else if (_pickupList.length > 0) {
      return SingleChildScrollView(
        child: ListView.builder(
          itemCount: _pickupList.length,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: buildPickupInfoItemCard(index),
            );
          },
        ),
      );
    } else if (!_isInitial && _pickupList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            AppLocalizations.of(context).no_pickup_point,
            style: TextStyle(color: MyTheme.secondary),
          )));
    }
  }

  GestureDetector buildPickupInfoItemCard(index) {
    return GestureDetector(
      onTap: () {
        if (_seleted_shipping_pickup_point != _pickupList[index].id) {
          _seleted_shipping_pickup_point = _pickupList[index].id;
          onAddressSwitch();
        }
        setState(() {});
      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: _seleted_shipping_pickup_point == _pickupList[index].id
              ? BorderSide(color: MyTheme.primary, width: 2.0)
              : BorderSide(color: MyTheme.light_grey, width: 1.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 0.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 75,
                      child: Text(
                        AppLocalizations.of(context)
                            .shipping_info_screen_address,
                        style: TextStyle(
                          color: MyTheme.secondary,
                        ),
                      ),
                    ),
                    Container(
                      width: 175,
                      child: Text(
                        _pickupList[index].address,
                        maxLines: 2,
                        style: TextStyle(
                            color: MyTheme.dark_grey,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Spacer(),
                    buildShippingOptionsCheckContainer(
                        _seleted_shipping_pickup_point == _pickupList[index].id)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 75,
                      child: Text(
                        AppLocalizations.of(context).address_screen_phone,
                        style: TextStyle(
                          color: MyTheme.secondary,
                        ),
                      ),
                    ),
                    Container(
                      width: 200,
                      child: Text(
                        _pickupList[index].phone,
                        maxLines: 2,
                        style: TextStyle(
                            color: MyTheme.dark_grey,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildShippingOptionsCheckContainer(bool check) {
    return check
        ? Container(
            height: 16,
            width: 16,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0), color: Colors.green),
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Icon(FontAwesome.check, color: Colors.white, size: 10),
            ),
          )
        : Container();
  }

  BottomAppBar buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      child: Container(
        color: Colors.transparent,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FlatButton(
              minWidth: MediaQuery.of(context).size.width,
              height: 50,
              color: MyTheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
              child: Text(
                AppLocalizations.of(context)
                    .shipping_info_screen_btn_proceed_to_checkout,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                onPressProceed(context);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget customAppBar(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: MyTheme.white,
              child: Row(
                children: [
                  Container(
                    width: 40,
                    child: Builder(
                      builder: (context) => IconButton(
                        icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 40,
                    child: Text(
                      "${AppLocalizations.of(context).shipping_info_screen_shipping_cost} ${_shipping_cost_string}",
                      style: TextStyle(fontSize: 16, color: MyTheme.primary),
                    ),
                  )
                ],
              ),
            ),
            // container for gaping into title text and title-bottom buttons
            Container(
              padding: EdgeInsets.only(top: 2),
              width: mWidth,
              color: MyTheme.light_grey,
              height: 1,
            ),
            pick_up_status.$
                ? ScrollToHideWidget(
                    child: Container(
                        color: MyTheme.white,
                        //MyTheme.light_grey,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FlatButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                setState(() {
                                  changeShippingOption(true);
                                });
                              },
                              child: Container(
                                  color: MyTheme.white,
                                  height: 50,
                                  width: (mWidth / 2) - 1,
                                  alignment: Alignment.center,
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .address_screen_address,
                                    style: TextStyle(
                                        color: _shippingOptionIsAddress
                                            ? MyTheme.dark_grey
                                            : MyTheme.dark_grey,
                                        fontWeight: _shippingOptionIsAddress
                                            ? FontWeight.w700
                                            : FontWeight.normal),
                                  )),
                            ),
                            Container(
                              width: 0.5,
                              height: 30,
                              color: MyTheme.secondary,
                            ),
                            FlatButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                setState(() {
                                  changeShippingOption(false);
                                });
                              },
                              child: Container(
                                  color: MyTheme.white,
                                  alignment: Alignment.center,
                                  height: 50,
                                  width: (mWidth / 2) - 1,
                                  child: Text(
                                    AppLocalizations.of(context).pickup_point,
                                    style: TextStyle(
                                        color: _shippingOptionIsAddress
                                            ? MyTheme.dark_grey
                                            : MyTheme.dark_grey,
                                        fontWeight: !_shippingOptionIsAddress
                                            ? FontWeight.w700
                                            : FontWeight.normal),
                                  )),
                            ),
                          ],
                        )),
                    scrollController: _mainScrollController,
                    childHeight: 40,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
