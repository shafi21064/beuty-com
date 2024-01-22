import 'dart:convert';

import 'package:kirei/data_model/city_response.dart';
import 'package:kirei/data_model/country_response.dart';
import 'package:kirei/data_model/pickup_points_response.dart';
import 'package:kirei/repositories/address_repository.dart';
import 'package:kirei/repositories/pickup_points_repository.dart';
import 'package:kirei/screens/address.dart';
import 'package:flutter/material.dart';
import 'package:kirei/my_theme.dart';
import 'package:kirei/screens/order_list.dart';
import 'package:kirei/screens/stripe_screen.dart';
import 'package:kirei/screens/paypal_screen.dart';
import 'package:kirei/screens/razorpay_screen.dart';
import 'package:kirei/screens/paystack_screen.dart';
import 'package:kirei/screens/iyzico_screen.dart';
import 'package:kirei/screens/bkash_screen.dart';
import 'package:kirei/screens/nagad_screen.dart';
import 'package:kirei/screens/sslcommerz_screen.dart';
import 'package:kirei/screens/flutterwave_screen.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:kirei/helpers/shared_value_helper.dart';
import 'package:kirei/repositories/payment_repository.dart';
import 'package:kirei/repositories/cart_repository.dart';
import 'package:kirei/repositories/coupon_repository.dart';
import 'package:kirei/helpers/shimmer_helper.dart';
import 'package:kirei/app_config.dart';
import 'package:kirei/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'package:kirei/screens/offline_screen.dart';
import 'package:kirei/screens/paytm_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Checkout extends StatefulWidget {
  int order_id; // only need when making manual payment from order details
  bool
      manual_payment_from_order_details; // only need when making manual payment from order details
  String list;
  final bool isWalletRecharge;
  final double rechargeAmount;
  final String title;
  final dynamic product_ids;
  final dynamic product_quantities;
  final dynamic address;

  Checkout(
      {Key key,
      this.order_id = 0,
      this.manual_payment_from_order_details = false,
      this.product_ids,
      this.product_quantities,
      this.address,
      this.list = "both",
      this.isWalletRecharge = false,
      this.rechargeAmount = 0.0,
      this.title})
      : super(key: key);

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  var _selected_payment_method_index = 0;
  var _selected_payment_method = "";
  var _selected_payment_method_key = "";

  ScrollController _mainScrollController = ScrollController();
  TextEditingController _couponController = TextEditingController();
  var _paymentTypeList = [];
  bool _isInitial = true;
  var _totalString = ". . .";
  var _grandTotalValue = 0.00;
  var _subTotalString = ". . .";
  var _taxString = ". . .";
  var _shippingCostString = ". . .";
  var _discountString = ". . .";
  var _used_coupon_code = "";
  var _coupon_applied = false;
  BuildContext loadingcontext;
  String payment_type = "cart_payment";
  String _title;
  bool _shippingOptionIsAddress = true;
  List<dynamic> _shippingAddressList = [];
  String _orderNote = '';
  int _seleted_shipping_address = 0;
  int _seleted_shipping_pickup_point = 0;
  List<PickupPoint> _pickupList = [];
  List<City> _cityList = [];
  List<Country> _countryList = [];
  bool isVisible = true;

  //double variables
  double mWidth = 0;
  double mHeight = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /*print("user data");
    print(is_logged_in.$);
    print(access_token.value);
    print(user_id.$);
    print(user_name.$);*/
    print(widget.address);
    print(widget.product_ids);
    print(widget.product_quantities);
    // if (is_logged_in.$ == true) {
    //   fetchAll();
    // }

    fetchAll();
  }

  @override
  void dispose() {
    super.dispose();
    _mainScrollController.dispose();
  }

  fetchAll() {
    if (is_logged_in.$ == true) {
      fetchShippingAddressList();

      if (pick_up_status.$) {
        fetchPickupPoints();
      }
      //fetchPickupPoints();
    }
    setState(() {});

    fetchList();

    if (is_logged_in.$ == true) {
      if (widget.isWalletRecharge || widget.manual_payment_from_order_details) {
        _grandTotalValue = widget.rechargeAmount;
        payment_type = "wallet_payment";
      } else {
        fetchSummary();
        //payment_type = payment_type;
      }
    }
  }

  fetchShippingAddressList() async {
    var addressResponse = await AddressRepository().getAddressList();
    print(addressResponse);
    for (var address in addressResponse.data) {
      if (address.set_default == 1) {
        _shippingAddressList.add(address);
        break;
      }
    }
    print(_shippingAddressList);

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

    //getSetShippingCost();
  }

  getSetShippingCost() async {
    var shippingCostResponse;
    if (_shippingOptionIsAddress) {
      // shippingCostResponse = await AddressRepository().getShippingCostResponse(
      //     user_id: user_id.$, address_id: _seleted_shipping_address);
    } else {
      // shippingCostResponse = await AddressRepository().getShippingCostResponse(
      //     user_id: user_id.$,
      //     pick_up_id: _seleted_shipping_pickup_point,
      //     shipping_type: "pickup_point");
    }

    if (shippingCostResponse.result == true) {
      // _shipping_cost_string = shippingCostResponse.value_string;
      setState(() {});
    }
  }

  fetchList() async {
    var paymentTypeResponseList =
        await PaymentRepository().getPaymentResponseList(list: widget.list);
    _paymentTypeList
        .add(paymentTypeResponseList[paymentTypeResponseList.length - 1]);
    print(_paymentTypeList);
    if (_paymentTypeList.length > 0) {
      _selected_payment_method = _paymentTypeList[0].payment_type;
      _selected_payment_method_key = _paymentTypeList[0].payment_type_key;
    }

    ;
    _isInitial = false;
    setState(() {});
  }

  fetchPickupPoints() async {
    var pickupPointsResponse =
        await PickupPointRepository().getPickupPointListResponse();
    _pickupList.addAll(pickupPointsResponse.data);
    if (!_shippingOptionIsAddress) {
      _seleted_shipping_pickup_point = _pickupList.first.id;
    }
    // getSetShippingCost();
  }

  fetchSummary() async {
    var cartSummaryResponse = await CartRepository().getCartSummaryResponse();

    if (cartSummaryResponse != null) {
      _subTotalString = cartSummaryResponse.sub_total;
      _taxString = cartSummaryResponse.tax;
      _shippingCostString = cartSummaryResponse.shipping_cost;
      _discountString = cartSummaryResponse.discount;
      _totalString = cartSummaryResponse.grand_total;
      _grandTotalValue = cartSummaryResponse.grand_total_value;
      _used_coupon_code = cartSummaryResponse.coupon_code;
      _couponController.text = _used_coupon_code;
      _coupon_applied = cartSummaryResponse.coupon_applied;
      setState(() {});
    }
  }

  reset() {
    _paymentTypeList.clear();
    _isInitial = true;
    _selected_payment_method_index = 0;
    _selected_payment_method = "";
    _selected_payment_method_key = "";
    setState(() {});

    reset_summary();
  }

  reset_summary() {
    _totalString = ". . .";
    _grandTotalValue = 0.00;
    _subTotalString = ". . .";
    _taxString = ". . .";
    _shippingCostString = ". . .";
    _discountString = ". . .";
    _used_coupon_code = "";
    _couponController.text = _used_coupon_code;
    _coupon_applied = false;
    _shippingAddressList.clear();
    _cityList.clear();
    _pickupList.clear();
    _countryList.clear();
    // _shipping_cost_string = ". . .";
    // _shipping_cost_string = ". . .";
    _isInitial = true;
    _shippingOptionIsAddress = true;
    _seleted_shipping_pickup_point = 0;
    _seleted_shipping_address = 0;

    setState(() {});
  }

  Future<void> _onRefresh() async {
    reset();
    fetchAll();
    reset();
    if (is_logged_in.$ == true) {
      fetchAll();
    }
  }

  onAddressSwitch() async {
    //_shipping_cost_string = ". . .";
    setState(() {});
    //getSetShippingCost();
  }

  onPopped(value) {
    reset();
    fetchAll();
  }

  afterAddingAnAddress() {
    reset();
    fetchAll();
  }

// onAddressSwitch() async {
//     _shipping_cost_string = ". . .";
//     setState(() {});
//     getSetShippingCost();
//   }

//   changeShippingOption(bool option) {
//     if (option) {
//       _seleted_shipping_pickup_point = 0;

//       _shippingAddressList.length > 0
//           ? _seleted_shipping_address = _shippingAddressList.first.id
//           : _seleted_shipping_address = 0;
//     } else {
//       _seleted_shipping_address = 0;
//       _pickupList.length > 0
//           ? _seleted_shipping_pickup_point = _pickupList.first.id
//           : _seleted_shipping_pickup_point = 0;
//     }
//     _shippingOptionIsAddress = option;
//     getSetShippingCost();
//     setState(() {});
//   }

  onPressProceed() async {
    if (_shippingOptionIsAddress && _seleted_shipping_address == 0) {
      ToastComponent.showDialog("Please select a shipping address", context);
      return;
    }

    if (!_shippingOptionIsAddress && _seleted_shipping_pickup_point == 0) {
      ToastComponent.showDialog("Please select a pickup point", context);
      return;
    }
    print(_shippingAddressList[0]);
    // Prepare request body
    List<String> productIdsStrings = widget.product_ids.split(',');
    List<int> productIds = productIdsStrings.map(int.parse).toList();

    List<String> productQuantitiesStrings =
        widget.product_quantities.split(',');
    List<int> productQuantities =
        productQuantitiesStrings.map(int.parse).toList();

    String productIdsJsonArray = "[${productIds.join(',')}]";
    String productQuantitiesJsonArray = "[${productQuantities.join(',')}]";
    var coupon_code = _couponController.text.toString();

    Map<String, dynamic> requestBody = {
      "api_key": "vXrAne",
      "api_secret": "k7t2G2j3RFBI",
      "product_ids_arr": productIdsJsonArray,
      "product_quantities_arr": productQuantitiesJsonArray,
    };
    if (_shippingOptionIsAddress) {
      requestBody["shipping_address"] = _shippingAddressList[0].address;
    } else {
      requestBody["shipping_pickup_point"] = _seleted_shipping_pickup_point;
    }

    requestBody["shipping_name"] = user_name.$ ?? '';
    requestBody["shipping_phone"] =
        user_email.$ != null ? user_email.$ : _shippingAddressList[0].phone;
    requestBody["shipping_city"] = _shippingAddressList[0].city;
    requestBody["shipping_zone"] = _shippingAddressList[0].zone;
    requestBody["shipping_area"] = _shippingAddressList[0].area;
    requestBody["is_preorder"] = 0;
    requestBody["payment_type"] = "cash_on_delivery";
    if (coupon_code != "") {
      requestBody["coupon_code"] = coupon_code;
    }

    try {
      // Call API
      print(requestBody);
      loading();

      var orderCreateResponse =
          await PaymentRepository().getOrderCreateResponseFromCod(requestBody);

      // Check if the widget is mounted before updating the UI
      if (mounted) {
        Navigator.of(loadingcontext).pop();

        if (orderCreateResponse.result == false) {
          ToastComponent.showDialog(
            orderCreateResponse.message,
            context,
            gravity: Toast.CENTER,
            duration: Toast.LENGTH_LONG,
          );
          Navigator.of(context).pop();
          return;
        }

        ToastComponent.showDialog(
          orderCreateResponse.message,
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG,
        );
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return OrderList(from_checkout: true);
        }));
      }
    } catch (e) {
      print('Error in onPressProceed: $e');
      // Handle the error appropriately, e.g., show a dialog or log it.
    }
  }

  onCouponApply() async {
    var coupon_code = _couponController.text.toString();
    if (coupon_code == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context).checkout_screen_coupon_code_warning,
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
      return;
    }

    var couponApplyResponse =
        await CouponRepository().getCouponApplyResponse(coupon_code);
    if (couponApplyResponse.result == false) {
      ToastComponent.showDialog(couponApplyResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    reset_summary();
    fetchSummary();
  }

  onCouponRemove() async {
    var couponRemoveResponse =
        await CouponRepository().getCouponRemoveResponse();

    if (couponRemoveResponse.result == false) {
      ToastComponent.showDialog(couponRemoveResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    reset_summary();
    fetchSummary();
  }

  onPressPlaceOrderOrProceed() {
    if (_selected_payment_method == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context).common_payment_choice_warning, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    if (_selected_payment_method == "stripe_payment") {
      if (_grandTotalValue == 0.00) {
        ToastComponent.showDialog(
            AppLocalizations.of(context).common_nothing_to_pay, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return StripeScreen(
          amount: _grandTotalValue,
          payment_type: payment_type,
          payment_method_key: _selected_payment_method_key,
        );
      })).then((value) {
        onPopped(value);
      });
    } else if (_selected_payment_method == "paypal_payment") {
      if (_grandTotalValue == 0.00) {
        ToastComponent.showDialog(
            AppLocalizations.of(context).common_nothing_to_pay, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return PaypalScreen(
          amount: _grandTotalValue,
          payment_type: payment_type,
          payment_method_key: _selected_payment_method_key,
        );
      })).then((value) {
        onPopped(value);
      });
      ;
    } else if (_selected_payment_method == "razorpay") {
      if (_grandTotalValue == 0.00) {
        ToastComponent.showDialog(
            AppLocalizations.of(context).common_nothing_to_pay, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return RazorpayScreen(
          amount: _grandTotalValue,
          payment_type: payment_type,
          payment_method_key: _selected_payment_method_key,
        );
      })).then((value) {
        onPopped(value);
      });
    } else if (_selected_payment_method == "paystack") {
      if (_grandTotalValue == 0.00) {
        ToastComponent.showDialog(
            AppLocalizations.of(context).common_nothing_to_pay, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return PaystackScreen(
          amount: _grandTotalValue,
          payment_type: payment_type,
          payment_method_key: _selected_payment_method_key,
        );
      })).then((value) {
        onPopped(value);
      });
    } else if (_selected_payment_method == "iyzico") {
      if (_grandTotalValue == 0.00) {
        ToastComponent.showDialog(
            AppLocalizations.of(context).common_nothing_to_pay, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return BkashScreen(
          amount: _grandTotalValue,
          payment_type: payment_type,
          payment_method_key: _selected_payment_method_key,
        );
      })).then((value) {
        onPopped(value);
      });

      // Navigator.push(context, MaterialPageRoute(builder: (context) {
      //   return IyzicoScreen(
      //     amount: _grandTotalValue,
      //     payment_type: payment_type,
      //     payment_method_key: _selected_payment_method_key,
      //   );
      // })).then((value) {
      //   onPopped(value);
      // });
    } else if (_selected_payment_method == "bkash") {
      if (_grandTotalValue == 0.00) {
        ToastComponent.showDialog(
            AppLocalizations.of(context).common_nothing_to_pay, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return BkashScreen(
          amount: _grandTotalValue,
          payment_type: "bkash",
          payment_method_key: "bkash",
        );
      })).then((value) {
        onPopped(value);
      });
    } else if (_selected_payment_method == "nagad") {
      if (_grandTotalValue == 0.00) {
        ToastComponent.showDialog(
            AppLocalizations.of(context).common_nothing_to_pay, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return NagadScreen(
          amount: _grandTotalValue,
          payment_type: payment_type,
          payment_method_key: _selected_payment_method_key,
        );
      })).then((value) {
        onPopped(value);
      });
    } else if (_selected_payment_method == "sslcommerz_payment") {
      if (_grandTotalValue == 0.00) {
        ToastComponent.showDialog(
            AppLocalizations.of(context).common_nothing_to_pay, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return SslCommerzScreen(
          amount: _grandTotalValue,
          payment_type: payment_type,
          payment_method_key: _selected_payment_method_key,
        );
      })).then((value) {
        onPopped(value);
      });
    } else if (_selected_payment_method == "flutterwave") {
      if (_grandTotalValue == 0.00) {
        ToastComponent.showDialog(
            AppLocalizations.of(context).common_nothing_to_pay, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return FlutterwaveScreen(
          amount: _grandTotalValue,
          payment_type: payment_type,
          payment_method_key: _selected_payment_method_key,
        );
      })).then((value) {
        onPopped(value);
      });
    } else if (_selected_payment_method == "paytm") {
      if (_grandTotalValue == 0.00) {
        ToastComponent.showDialog(
            AppLocalizations.of(context).common_nothing_to_pay, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return PaytmScreen(
          amount: _grandTotalValue,
          payment_type: payment_type,
          payment_method_key: _selected_payment_method_key,
        );
      })).then((value) {
        onPopped(value);
      });
    } else if (_selected_payment_method == "wallet_system") {
      pay_by_wallet();
    } else if (_selected_payment_method == "cash_payment") {
      pay_by_cod();
    } else if (_selected_payment_method == "manual_payment" &&
        widget.manual_payment_from_order_details == false) {
      pay_by_manual_payment();
    } else if (_selected_payment_method == "manual_payment" &&
        widget.manual_payment_from_order_details == true) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return OfflineScreen(
          order_id: widget.order_id,
          payment_type: "manual_payment",
          details: _paymentTypeList[_selected_payment_method_index].details,
          offline_payment_id: _paymentTypeList[_selected_payment_method_index]
              .offline_payment_id,
          isWalletRecharge: widget.isWalletRecharge,
          rechargeAmount: widget.rechargeAmount,
        );
      })).then((value) {
        onPopped(value);
      });
    }
  }

  pay_by_wallet() async {
    var orderCreateResponse = await PaymentRepository()
        .getOrderCreateResponseFromWallet(
            _selected_payment_method_key, _grandTotalValue);

    if (orderCreateResponse.result == false) {
      ToastComponent.showDialog(orderCreateResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return OrderList(from_checkout: true);
    }));
  }

  pay_by_cod() async {
    loading();
    // var orderCreateResponse = await PaymentRepository()
    //     .getOrderCreateResponseFromCod(_selected_payment_method_key);
    // Navigator.of(loadingcontext).pop();
    // if (orderCreateResponse.result == false) {
    //   ToastComponent.showDialog(orderCreateResponse.message, context,
    //       gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    //   Navigator.of(context).pop();
    //   return;
    // }

    // Navigator.push(context, MaterialPageRoute(builder: (context) {
    //   return OrderList(from_checkout: true);
    // }));
  }

  pay_by_manual_payment() async {
    loading();
    var orderCreateResponse = await PaymentRepository()
        .getOrderCreateResponseFromManualPayment(_selected_payment_method_key);
    Navigator.pop(loadingcontext);
    if (orderCreateResponse.result == false) {
      ToastComponent.showDialog(orderCreateResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      Navigator.of(context).pop();
      return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return OrderList(from_checkout: true);
    }));
  }

  onPaymentMethodItemTap(index) {
    if (_selected_payment_method_key !=
        _paymentTypeList[index].payment_type_key) {
      setState(() {
        _selected_payment_method_index = index;
        _selected_payment_method = _paymentTypeList[index].payment_type;
        _selected_payment_method_key = _paymentTypeList[index].payment_type_key;
      });
    }

    //print(_selected_payment_method);
    //print(_selected_payment_method_key);
  }

  onPressDetails() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding:
            EdgeInsets.only(top: 16.0, left: 2.0, right: 2.0, bottom: 2.0),
        content: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 16.0),
          child: Container(
            height: 150,
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 120,
                          child: Text(
                            AppLocalizations.of(context)
                                .checkout_screen_subtotal,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Text(
                          _subTotalString ?? '',
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 120,
                          child: Text(
                            AppLocalizations.of(context).checkout_screen_tax,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Text(
                          _taxString ?? '',
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 120,
                          child: Text(
                            AppLocalizations.of(context)
                                .checkout_screen_shipping_cost,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Text(
                          _shippingCostString ?? '',
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 120,
                          child: Text(
                            AppLocalizations.of(context)
                                .checkout_screen_discount,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Text(
                          _discountString ?? '',
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
                Divider(),
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 120,
                          child: Text(
                            AppLocalizations.of(context)
                                .checkout_screen_grand_total,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Text(
                          _totalString ?? '',
                          style: TextStyle(
                              color: MyTheme.accent_color,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
        actions: [
          FlatButton(
            child: Text(
              AppLocalizations.of(context).common_close_in_all_lower,
              style: TextStyle(color: MyTheme.medium_grey),
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    mHeight = MediaQuery.of(context).size.height;
    mWidth = MediaQuery.of(context).size.width;

    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(context),
        bottomNavigationBar: buildBottomAppBar(context),
        body: Stack(
          children: [
            RefreshIndicator(
              color: MyTheme.accent_color,
              backgroundColor: Colors.white,
              onRefresh: _onRefresh,
              displacement: 0,
              child: Container(
                child: CustomScrollView(
                  controller: _mainScrollController,
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 16.0),
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
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return Address(
                                              from_shipping_info: true,
                                            );
                                          },
                                        ),
                                      ).then((value) {
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
                                            color: MyTheme.accent_color,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: buildPaymentMethodList(),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
            // Positioned(top: 0.0, child: customAppBar(context)),

            Align(
              alignment: Alignment.bottomCenter,
              child: widget.isWalletRecharge
                  ? Container()
                  : Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        /*border: Border(
                      top: BorderSide(color: MyTheme.light_grey,width: 1.0),
                    )*/
                      ),
                      height:
                          widget.manual_payment_from_order_details ? 80 : 180,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16.0, bottom: 10.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Order Note',
                                  hintText:
                                      'Add a note to your order (optional)',
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _orderNote = value;
                                  });
                                },
                              ),
                            ),
                            widget.manual_payment_from_order_details == false
                                ? Padding(
                                    padding: const EdgeInsets.only(bottom: 0.0),
                                    child: buildApplyCouponRow(context),
                                  )
                                : Container(),
                            grandTotalSection(),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Row buildApplyCouponRow(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 42,
          width: (MediaQuery.of(context).size.width - 32) * (2 / 3),
          child: TextFormField(
            controller: _couponController,
            readOnly: _coupon_applied,
            autofocus: false,
            decoration: InputDecoration(
                hintText: AppLocalizations.of(context)
                    .checkout_screen_enter_coupon_code,
                hintStyle:
                    TextStyle(fontSize: 14.0, color: MyTheme.textfield_grey),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: MyTheme.textfield_grey, width: 0.5),
                  borderRadius: const BorderRadius.only(
                    topLeft: const Radius.circular(8.0),
                    bottomLeft: const Radius.circular(8.0),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: MyTheme.medium_grey, width: 0.5),
                  borderRadius: const BorderRadius.only(
                    topLeft: const Radius.circular(8.0),
                    bottomLeft: const Radius.circular(8.0),
                  ),
                ),
                contentPadding: EdgeInsets.only(left: 16.0)),
          ),
        ),
        !_coupon_applied
            ? Container(
                width: (MediaQuery.of(context).size.width - 32) * (1 / 3),
                height: 42,
                child: FlatButton(
                  minWidth: MediaQuery.of(context).size.width,
                  //height: 50,
                  color: MyTheme.accent_color,
                  shape: RoundedRectangleBorder(
                      borderRadius: const BorderRadius.only(
                    topRight: const Radius.circular(8.0),
                    bottomRight: const Radius.circular(8.0),
                  )),
                  child: Text(
                    AppLocalizations.of(context).checkout_screen_apply_coupon,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    onCouponApply();
                  },
                ),
              )
            : Container(
                width: (MediaQuery.of(context).size.width - 32) * (1 / 3),
                height: 42,
                child: FlatButton(
                  minWidth: MediaQuery.of(context).size.width,
                  //height: 50,
                  color: MyTheme.accent_color,
                  shape: RoundedRectangleBorder(
                      borderRadius: const BorderRadius.only(
                    topRight: const Radius.circular(8.0),
                    bottomRight: const Radius.circular(8.0),
                  )),
                  child: Text(
                    AppLocalizations.of(context).checkout_screen_remove,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    onCouponRemove();
                  },
                ),
              )
      ],
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
        widget.title ?? '',
        style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
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
            style: TextStyle(color: MyTheme.font_grey),
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
            style: TextStyle(color: MyTheme.font_grey),
          )));
    }
  }

  GestureDetector buildShippingInfoItemCard(index) {
    return GestureDetector(
      onTap: () {
        // if (_seleted_shipping_address != _shippingAddressList[index].id) {
        //   _seleted_shipping_address = _shippingAddressList[index].id;

        //   onAddressSwitch();
        // }
        // //detectShippingOption();
        // setState(() {});
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Address()), // Replace AddressScreen with the actual screen you want to navigate to
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: _seleted_shipping_address == _shippingAddressList[index].id
              ? BorderSide(color: MyTheme.accent_color, width: 2.0)
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
                          color: MyTheme.grey_153,
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
                          color: MyTheme.grey_153,
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
                        "Zone",
                        style: TextStyle(
                          color: MyTheme.grey_153,
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
                        "Area",
                        style: TextStyle(
                          color: MyTheme.grey_153,
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
                          color: MyTheme.grey_153,
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
                          color: MyTheme.grey_153,
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

  Container buildShippingOptionsCheckContainer(bool check) {
    return Container(
      height: 16,
      width: 16,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Colors.green,
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(3),
            child: Icon(
              FontAwesome.check,
              color: Colors.white,
              size: 10,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Address()), // Replace AddressScreen with the actual screen you want to navigate to
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(
                top: 30.0,
                left: 0.0,
                right: 16.0,
                bottom: 12.0,
              ),
              child: Icon(
                Icons.edit,
                color: MyTheme.dark_grey,
                size: 16,
              ),
            ),
          ),
        ],
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
            style: TextStyle(color: MyTheme.font_grey),
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
            style: TextStyle(color: MyTheme.font_grey),
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
        //detectShippingOption();
        setState(() {});
      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: _seleted_shipping_pickup_point == _pickupList[index].id
              ? BorderSide(color: MyTheme.accent_color, width: 2.0)
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
                          color: MyTheme.grey_153,
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
                          color: MyTheme.grey_153,
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

  buildPaymentMethodList() {
    if (_isInitial && _paymentTypeList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildListShimmer(item_count: 5, item_height: 100.0));
    } else if (_paymentTypeList.length > 0) {
      return SingleChildScrollView(
        child: ListView.builder(
          itemCount: _paymentTypeList.length,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: buildPaymentMethodItemCard(index),
            );
          },
        ),
      );
    } else if (!_isInitial && _paymentTypeList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            AppLocalizations.of(context).common_no_payment_method_added,
            style: TextStyle(color: MyTheme.font_grey),
          )));
    }
  }

  GestureDetector buildPaymentMethodItemCard(index) {
    return widget.isWalletRecharge &&
            (_paymentTypeList[index].payment_type == "wallet_system" ||
                _paymentTypeList[index].payment_type == "cash_payment")
        ? GestureDetector(
            child: Container(),
            onDoubleTap: () {},
          )
        : GestureDetector(
            onTap: () {
              onPaymentMethodItemTap(index);
            },
            child: Stack(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    side: _selected_payment_method_key ==
                            _paymentTypeList[index].payment_type_key
                        ? BorderSide(color: MyTheme.accent_color, width: 2.0)
                        : BorderSide(color: MyTheme.light_grey, width: 1.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  elevation: 0.0,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            width: 100,
                            height: 100,
                            child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child:
                                    /*Image.asset(
                          _paymentTypeList[index].image,
                          fit: BoxFit.fitWidth,
                        ),*/
                                    FadeInImage.assetNetwork(
                                  placeholder: 'assets/placeholder.png',
                                  image: _paymentTypeList[index].payment_type ==
                                          "manual_payment"
                                      ? _paymentTypeList[index].image
                                      : _paymentTypeList[index].image,
                                  fit: BoxFit.fitWidth,
                                ))),
                        Container(
                          width: 150,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text(
                                  _paymentTypeList[index].title,
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: MyTheme.font_grey,
                                      fontSize: 14,
                                      height: 1.6,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                ),
                Positioned(
                  right: 16,
                  top: 16,
                  child: buildPaymentMethodCheckContainer(
                      _selected_payment_method_key ==
                          _paymentTypeList[index].payment_type_key),
                )
              ],
            ),
          );
  }

  Widget buildPaymentMethodCheckContainer(bool check) {
    return Visibility(
      visible: check,
      child: Container(
        height: 16,
        width: 16,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0), color: Colors.green),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Icon(FontAwesome.check, color: Colors.white, size: 10),
        ),
      ),
    );
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
              color: MyTheme.accent_color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
              child: Text(
                widget.isWalletRecharge
                    ? AppLocalizations.of(context)
                        .recharge_wallet_screen_recharge_wallet
                    : widget.manual_payment_from_order_details
                        ? AppLocalizations.of(context)
                            .common_proceed_in_all_caps
                        : AppLocalizations.of(context)
                            .checkout_screen_place_my_order,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                // onPressPlaceOrderOrProceed();
                onPressProceed();
              },
            )
          ],
        ),
      ),
    );
  }

  Widget grandTotalSection() {
    return Container(
      height: 40,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: MyTheme.soft_accent_color),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                AppLocalizations.of(context).checkout_screen_total_amount,
                style: TextStyle(color: MyTheme.font_grey, fontSize: 14),
              ),
            ),
            Visibility(
              visible: !widget.manual_payment_from_order_details,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: InkWell(
                  onTap: () {
                    onPressDetails();
                  },
                  child: Text(
                    AppLocalizations.of(context).common_see_details,
                    style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                  widget.manual_payment_from_order_details
                      ? widget.rechargeAmount.toString()
                      : _totalString,
                  style: TextStyle(
                      color: MyTheme.accent_color,
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  loading() {
    showDialog(
        context: context,
        builder: (context) {
          loadingcontext = context;
          return AlertDialog(
              content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(
                width: 10,
              ),
              Text("${AppLocalizations.of(context).loading_text}"),
            ],
          ));
        });
  }
}
