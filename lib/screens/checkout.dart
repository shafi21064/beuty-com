
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kirei/data_model/city_response.dart';
import 'package:kirei/data_model/country_response.dart';
import 'package:kirei/data_model/pickup_points_response.dart';
import 'package:kirei/data_model/state_response.dart';
import 'package:kirei/providers/cart_count_update.dart';
import 'package:kirei/providers/version_change.dart';
import 'package:kirei/repositories/address_repository.dart';
import 'package:kirei/repositories/pickup_points_repository.dart';
import 'package:kirei/screens/address.dart';
import 'package:flutter/material.dart';
import 'package:kirei/my_theme.dart';
import 'package:kirei/screens/order_failed_page.dart';
import 'package:kirei/screens/order_list.dart';
import 'package:kirei/screens/order_success_page.dart';
import 'package:kirei/screens/bkash_screen.dart';
import 'package:kirei/screens/nagad_screen.dart';
import 'package:kirei/screens/sslcommerz_screen.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:kirei/helpers/shared_value_helper.dart';
import 'package:kirei/repositories/payment_repository.dart';
import 'package:kirei/repositories/cart_repository.dart';
import 'package:kirei/repositories/coupon_repository.dart';
import 'package:kirei/helpers/shimmer_helper.dart';
import 'package:kirei/custom/toast_component.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
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
  List allCartProductList;
  var pName;
  var pQuantity;
  var pPrice;
  var pLength;
  int isPreorder=0;


  Checkout(
      {Key key,
        this.order_id = 0,
        this.manual_payment_from_order_details = false,
        this.product_ids,
        this.product_quantities,
        this.address,
        this.isPreorder,
        this.list = "both",
        this.isWalletRecharge = false,
        this.rechargeAmount = 0.0,
        this.title,
        this.allCartProductList,
      })
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

  //controllers for add purpose
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _postalCodeController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  TextEditingController _orderNoteController = TextEditingController();

  var _paymentTypeList = [];
  bool _isInitial = true;
  var _totalString = ". . .";
  var _discountedPrice  ;
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
  bool success = false;
  String _orderNote = '';
  int _seleted_shipping_address = 0;
  int _seleted_shipping_pickup_point = 0;
  List<PickupPoint> _pickupList = [];
  List<City> _cityList = [];
  List<Country> _countryList = [];
  bool isVisible = true;
  bool _termsChecked = false;

  int _selectedCity_id;
  int _selectedZone_id;
  int _selectedArea_id;
  //double variables
  double mWidth = 0;
  double mHeight = 0;

  bool viseVersaValue = true;
  changeValue(){
    viseVersaValue = !viseVersaValue;
    setState(() {
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


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

    }
    setState(() {});

    fetchList();

    if (is_logged_in.$ == true) {
      if (widget.isWalletRecharge || widget.manual_payment_from_order_details) {
        _grandTotalValue = widget.rechargeAmount;
        payment_type = "wallet_payment";
      } else {
        fetchSummary();

      }
    }
  }


  fetchShippingAddressList() async {


    var addressResponse = await AddressRepository().getAddressList();

    success = addressResponse['success'];


    _shippingAddressList.addAll(addressResponse['data']);







    if (success == true) {
      _phoneController.text = _shippingAddressList[0]['phone'];
      _nameController.text = _shippingAddressList[0]['name'];
      _emailController.text = _shippingAddressList[0]["email"];
      _seleted_shipping_address = _shippingAddressList[0]['id'];
      _addressController.text = _shippingAddressList[0]['address'];
      _stateController.text = _shippingAddressList[0]['city_name'];
      _cityController.text = _shippingAddressList[0]['zone_name'];
      _countryController.text = _shippingAddressList[0]['area_name'];
      _selectedCity_id = _shippingAddressList[0]['city_id'];
      _selectedZone_id = _shippingAddressList[0]['zone_id'];
      _selectedArea_id = _shippingAddressList[0]['area_id'];


    }
    _isInitial = false;
    setState(() {});


  }

  getSetShippingCost() async {
    var shippingCostResponse;
    if (_shippingOptionIsAddress) {
;
    } else {

    }

    if (shippingCostResponse.result == true) {

      setState(() {});
    }
  }

  fetchList() async {
    var paymentTypeResponseList =
    await PaymentRepository().getPaymentResponseList(list: widget.list);
    _paymentTypeList
        .addAll(paymentTypeResponseList);

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

  }

  fetchSummary() async {

    var cartSummaryResponse = await CartRepository().getCartSummaryResponse();

    if (cartSummaryResponse != null) {
      _subTotalString = cartSummaryResponse.sub_total;
      _taxString = cartSummaryResponse.tax;
      _shippingCostString = cartSummaryResponse.shipping_cost;
      _discountString = cartSummaryResponse.discount;
      _discountedPrice = cartSummaryResponse.discount;
      _totalString = cartSummaryResponse.grand_total;
      _grandTotalValue = cartSummaryResponse.grand_total_value;
      _used_coupon_code = cartSummaryResponse.coupon_code;
      _couponController.text = cartSummaryResponse.coupon_applied  == true ? _used_coupon_code : "";
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

    _isInitial = true;
    _shippingOptionIsAddress = true;
    _seleted_shipping_pickup_point = 0;
    _seleted_shipping_address = 0;

    setState(() {});
  }

  Future<void> _onRefresh() async {
    reset();
    if (is_logged_in.$ == true) {
      fetchAll();
    }
  }

  onAddressSwitch() async {
    setState(() {});
  }

  onPopped(value) {
    reset();
    fetchAll();
  }

  afterAddingAnAddress() {
    reset();
    fetchAll();
  }


  onPressProceed() async {



    if (_grandTotalValue == 0.00) {
      ToastComponent.showDialog(
          AppLocalizations.of(context).common_nothing_to_pay, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    if (_selected_payment_method == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context).common_payment_choice_warning, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }



    if(!_termsChecked){
      ToastComponent.showDialog("Please agree to the terms and conditions", context,   gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    };

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
      "product_ids_arr": productIdsJsonArray,
      "product_quantities_arr": productQuantitiesJsonArray,
    };
    if (_shippingOptionIsAddress) {
      //requestBody["shipping_address"] = _shippingAddressList[0].address;
      requestBody["shipping_address"] = _addressController.text;
    } else {
      requestBody["shipping_pickup_point"] = _seleted_shipping_pickup_point;
    }

    //requestBody["shipping_name"] = user_name.$ ?? '';
    requestBody["shipping_name"] = _nameController.text;
    requestBody["shipping_phone"] = _phoneController.text;
    //user_email.$ != null ? user_email.$ : _phoneController.text;
    //requestBody["shipping_city"] = _stateController.text;
    requestBody["shipping_city_id"] = _selectedCity_id;
    //requestBody["shipping_zone"] = _cityController.text;
    requestBody["shipping_zone_id"] =_selectedZone_id;
    //requestBody["shipping_area"] = _countryController.text;
    requestBody["shipping_area_id"] = _selectedArea_id;
    requestBody["is_preorder"] = widget.isPreorder;
    requestBody["payment_type"] = _selected_payment_method;
    requestBody["note"] = _orderNoteController.text;
    requestBody["type"] = 'app';
    requestBody["version"] = "${Provider.of<VersionChange>(context, listen: false).latestVersion}";

    if (_nameController.text == "" || requestBody["shipping_name"] == "") {
      ToastComponent.showDialog(

          "Name  is required", context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    if (_phoneController.text == "" || requestBody["shipping_phone"] == "") {
      ToastComponent.showDialog(
          "Phone is required", context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    } else if(_phoneController.text.length > 11){
      ToastComponent.showDialog(
          "Invalid Phone", context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    } else if(_phoneController.text.length < 11){
      ToastComponent.showDialog(
          "Invalid Phone", context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }else if(!_phoneController.text.startsWith("0")){
      ToastComponent.showDialog(
          "Invalid Phone", context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    if (_addressController.text == "" || requestBody["shipping_address"] == "") {
      ToastComponent.showDialog(
          "Address is required", context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }
        if (_couponController.text != "" && _coupon_applied == false) {
      ToastComponent.showDialog(
          "Apply Your Coupon First or Clear", context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    if ( _stateController.text == "" || requestBody["shipping_city_id"] == "") {
      ToastComponent.showDialog(
          "City is required", context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    if (_cityController.text == "" || requestBody["shipping_zone_id"] == "") {
      ToastComponent.showDialog(
          "Zone is required", context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    if (_used_coupon_code != "") {
      requestBody["coupon_code"] = _used_coupon_code;
    }

    try {
      print('_selected_payment_method ${_selected_payment_method}');

        print('this is my Order request' +requestBody.toString());
        loading();

        var orderCreateResponse =
        await PaymentRepository().getOrderCreateResponseFromCod(requestBody);
        // Check if the widget is mounted before updating the UI
        if (mounted) {
          Navigator.of(loadingcontext).pop();
          Provider.of<CartCountUpdate>(context, listen: false).getReset();
          if (orderCreateResponse.result == false) {
            ToastComponent.showDialog(
              orderCreateResponse.message,
              context,
              gravity: Toast.CENTER,
              duration: Toast.LENGTH_LONG,
            );
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (_)=> OrderFailedPage()), (route) => false);
            return;
          } else{
            if (_selected_payment_method == "bkash") {
              print('bkash_initial_url ${orderCreateResponse.data.paymentUrl}');
              if(orderCreateResponse.data?.paymentUrl != null) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return BkashScreen(
                      amount: _grandTotalValue,
                      payment_type: payment_type,
                      payment_method_key: "bkash",
                      order_id: orderCreateResponse.data.order.id,
                      bkash_initial_url: orderCreateResponse.data.paymentUrl
                  );
                })).then((value) {
                  //onPopped(value);
                  print('Return back from bkash');
                });
              }else{
                ToastComponent.showDialog(
                    AppLocalizations
                        .of(context)
                        .common_nothing_to_pay, context,
                    gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (_)=> OrderSuccessPage(
                      orderId: orderCreateResponse.data?.order.id,
                      message:"Something went wrong.",
                      type: "danger",
                    )), (route) => false);
                return;
              }
            } else if (_selected_payment_method == "nagad") {

              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return NagadScreen(
                  amount: _grandTotalValue,
                  payment_type: payment_type,
                  payment_method_key: _selected_payment_method_key,
                );
              })).then((value) {
                onPopped(value);
              });
            } else if (_selected_payment_method == "ssl") {
              print('ssl_initial_url ${orderCreateResponse.data?.paymentUrl}');

              if (orderCreateResponse.data?.paymentUrl != null) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SslCommerzScreen(
                      amount: _grandTotalValue,
                      payment_type: payment_type,
                      payment_method_key: _selected_payment_method_key,
                      order_id: orderCreateResponse.data?.order.id,
                      ssl_initial_url: orderCreateResponse.data?.paymentUrl
                  );
                })).then((value) {
                  onPopped(value);
                });
              }else{
                  ToastComponent.showDialog(
                      AppLocalizations
                          .of(context)
                          .common_nothing_to_pay, context,
                      gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);

                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (_)=> OrderSuccessPage(
                        orderId: orderCreateResponse.data?.order.id,
                        message:"Something went wrong.",
                        type: "danger",
                      )), (route) => false);
                  return;
              }
            }


            else{
              ToastComponent.showDialog(
                orderCreateResponse.message,
                context,
                gravity: Toast.CENTER,
                duration: Toast.LENGTH_LONG,
              );
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (_)=> OrderSuccessPage(
                    orderId: orderCreateResponse.data.order.id,
                    type: 'success',
                    message: 'Order Successful',
                  )), (route) => false);
            }

          }
      } else{
          ToastComponent.showDialog(
            "Something went wrong",
            context,
            gravity: Toast.CENTER,
            duration: Toast.LENGTH_LONG,
          );
        }
      // Call API
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

    fetchSummary();

    if (couponApplyResponse.result == true) {
      ToastComponent.showDialog(couponApplyResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      setState(() {});
      return;
    }else{
      ToastComponent.showDialog(couponApplyResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

  }

  onCouponRemove() async {
    var couponRemoveResponse =
    await CouponRepository().getCouponRemoveResponse();
    reset_summary();
    fetchSummary();

    if (couponRemoveResponse.result == false) {
      ToastComponent.showDialog(couponRemoveResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
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
    var orderCreateResponse = await PaymentRepository()
        .getOrderCreateResponseFromCod(_selected_payment_method_key);
    // Navigator.of(loadingcontext).pop();
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
            height: 162,
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
                                color: MyTheme.secondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Text(
                          _subTotalString ?? '',
                          style: TextStyle(
                              color: MyTheme.secondary,
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
                                color: MyTheme.secondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Text(
                          _taxString ?? '',
                          style: TextStyle(
                              color: MyTheme.secondary,
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
                                color: MyTheme.secondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Text(
                          _shippingCostString ?? '',
                          style: TextStyle(
                              color: MyTheme.secondary,
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
                                color: MyTheme.secondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Text(
                          _discountString ?? '',
                          style: TextStyle(
                              color: MyTheme.secondary,
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
                                color: MyTheme.secondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Text(
                          _totalString ?? '',
                          style: TextStyle(
                              color: MyTheme.primary,
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
              style: TextStyle(color: MyTheme.dark_grey),
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
        ],
      ),
    );
  }

  City _selected_city;
  Country _selected_country;
  MyState _selected_state;
  List<City> _selected_city_list_for_update = [];
  List<MyState> _selected_state_list_for_update = [];
  List<Country> _selected_country_list_for_update = [];
  List<TextEditingController> _addressControllerListForUpdate = [];
  List<TextEditingController> _postalCodeControllerListForUpdate = [];
  List<TextEditingController> _phoneControllerListForUpdate = [];
  List<TextEditingController> _cityControllerListForUpdate = [];
  List<TextEditingController> _stateControllerListForUpdate = [];
  List<TextEditingController> _countryControllerListForUpdate = [];

  onSelectCountryDuringUpdate(index, country, setModalState) {
    if (_selected_country_list_for_update[index] != null &&
        country.id == _selected_country_list_for_update[index].id) {
      setModalState(() {
        _countryControllerListForUpdate[index].text = country.name;
      });
      return;
    }
    _selected_country_list_for_update[index] = country;
    _selected_state_list_for_update[index] = null;
    _selected_city_list_for_update[index] = null;
    setState(() {});

    setModalState(() {
      _countryControllerListForUpdate[index].text = country.name;
      _stateControllerListForUpdate[index].text = "";
      _cityControllerListForUpdate[index].text = "";
    });
  }

  onSelectStateDuringUpdate(index, state, setModalState) {
    if (_selected_state_list_for_update[index] != null &&
        state.id == _selected_state_list_for_update[index].id) {
      setModalState(() {
        _stateControllerListForUpdate[index].text = state.name;
      });
      return;
    }
    _selected_state_list_for_update[index] = state;
    _selected_city_list_for_update[index] = null;
    setState(() {});
    setModalState(() {
      _stateControllerListForUpdate[index].text = state.name;
      _cityControllerListForUpdate[index].text = "";
    });
  }

  onSelectCityDuringUpdate(index, city, setModalState) {
    if (_selected_city_list_for_update[index] != null &&
        city.id == _selected_city_list_for_update[index].id) {
      setModalState(() {
        _cityControllerListForUpdate[index].text = city.name;
      });
      return;
    }
    _selected_city_list_for_update[index] = city;
    setModalState(() {
      _cityControllerListForUpdate[index].text = city.name;
    });
  }

  onSelectZoneDuringAdd(city, setModalState) {
    if (_selected_city != null && city.id == _selected_city.id) {
      setModalState(() {

        _selectedZone_id = city.id;
        _cityController.text = city.name;
      });
      return;
    }
    _selected_city = city;
    setState(() {
      _selectedZone_id = city.id;
    });
    setModalState(() {
      _cityController.text = city.name;
      _selectedZone_id = city.id;
    });
  }

  onSelectAreaDuringAdd(country, setModalState) {
    if (_selected_country != null && country.id == _selected_country.id) {
      setModalState(() {
        _selectedArea_id = country.id;
        _countryController.text = country.name;
      });
      return;
    }
    _selected_country = country;
    _selectedArea_id = country.id;

    setState(() {});

    setModalState(() {
      _countryController.text = country.name;
      _selectedArea_id = country.id;

    });
  }

  onSelectCityDuringAdd(state, setModalState) {
    if (_selected_state != null && state.id == _selected_state.id) {
      setModalState(() {
        _selectedCity_id = state.id;
        _stateController.text = state.name;
      });
      return;
    }
    _selected_state = state;

    _selectedCity_id = state.id;
    _selected_city = null;
    setState(() {});
    setModalState(() {
      _stateController.text = state.name;
      _selectedCity_id = state.id;
      _cityController.text = "";
    });
  }

  onAddressAdd(context) async {
    var address = _addressController.text.toString();
    var postal_code = _postalCodeController.text.toString();
    var phone = _phoneController.text.toString();
    var city = _stateController.text.toString();
    var area = _countryController.text.toString();
    var zone = _cityController.text.toString();
    var name = _nameController.text.toString();
    var email = _emailController.text.toString();
    var note = _orderNoteController.text.toString();


    if (address == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context).address_screen_address_warning, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    if (_selected_country == null) {
      ToastComponent.showDialog(
          AppLocalizations.of(context).address_screen_country_warning, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    if (_selected_state == null) {
      ToastComponent.showDialog(
          AppLocalizations.of(context).address_screen_state_warning, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    if (_selected_city == null) {
      ToastComponent.showDialog(
          AppLocalizations.of(context).address_screen_city_warning, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    var addressAddResponse = await AddressRepository().getAddressAddResponse(
      address: address,
      area: area,
      zone: zone,
      city: city,
      postal_code: postal_code,
      phone: phone,
      name: name,
      email: email,
      note: note,
    );

    if (addressAddResponse.result == false) {
      ToastComponent.showDialog(addressAddResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    ToastComponent.showDialog(addressAddResponse.message, context,
        gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);

    Navigator.of(context, rootNavigator: true).pop();
    afterAddingAnAddress();
  }


  GestureDetector buildAddressItemCard(index){
    return GestureDetector(
      onDoubleTap: () {

      },
      child: Card(
        elevation: 0.0,
        child: Stack(
          children: [
            Padding(
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
                            AppLocalizations.of(context).address_screen_address,
                            style: TextStyle(
                              color: MyTheme.secondary,
                            ),
                          ),
                        ),
                        Container(
                          width: 175,
                          child: Text(
                            _shippingAddressList[index]['address'] ?? '',
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
                            AppLocalizations.of(context).address_screen_city,
                            style: TextStyle(
                              color: MyTheme.secondary,
                            ),
                          ),
                        ),
                        Container(
                          width: 200,
                          child: Text(
                            _shippingAddressList[index]['city_name'] ?? '',
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
                            AppLocalizations.of(context).address_screen_state,
                            style: TextStyle(
                              color: MyTheme.secondary,
                            ),
                          ),
                        ),
                        Container(
                          width: 200,
                          child: Text(
                            _shippingAddressList[index]['zone_name'] ?? '',
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
                            AppLocalizations.of(context).address_screen_country,
                            style: TextStyle(
                              color: MyTheme.secondary,
                            ),
                          ),
                        ),
                        Container(
                          width: 200,
                          child: Text(
                            _shippingAddressList[index]['area_name'] ?? '',
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
                            AppLocalizations.of(context).address_screen_phone,
                            style: TextStyle(
                              color: MyTheme.secondary,
                            ),
                          ),
                        ),
                        Container(
                          width: 200,
                          child: Text(
                            _shippingAddressList[index]['phone'] ?? '',
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
            app_language_rtl.$
                ? Positioned(
                left: 0,
                top: 0.0,
                child: InkWell(
                  onTap: () {
                    //onPressDelete(_shippingAddressList[index].id);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 12.0, left: 16.0, right: 16.0, bottom: 16.0),
                    child: Icon(
                      Icons.delete_forever_outlined,
                      color: MyTheme.dark_grey,
                      size: 16,
                    ),
                  ),
                ))
                : Positioned(
                right: 0,
                top: 40.0,
                child: InkWell(
                  onTap: () {
                    // onPressDelete(_shippingAddressList[index].id);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 12.0, left: 16.0, right: 16.0, bottom: 16.0),
                    child: Icon(
                      Icons.delete_forever_outlined,
                      color: MyTheme.dark_grey,
                      size: 16,
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  buildShowAddFormDialog(BuildContext context,) {
    return StatefulBuilder(builder: (BuildContext context,
        StateSetter setModalState /*You can rename this!*/) {
      return ListView(
        shrinkWrap: true,

        physics: NeverScrollableScrollPhysics(),
        children: [

          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
                AppLocalizations
                    .of(context)
                    .address_screen_name + ' *',
                style: TextStyle(
                    color: MyTheme.secondary, fontSize: 12)),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Container(
              height: 40,
              child: TextField(
                controller: _nameController,
                autofocus: false,
                decoration: InputDecoration(
                    hintText: "Enter Name",
                    hintStyle: TextStyle(
                        fontSize: 12.0, color: MyTheme.light_grey),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: BorderSide(
                          color: MyTheme.light_grey, width: 2),

                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: BorderSide(
                          color: MyTheme.light_grey, width: 2.0),
                    ),
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 8.0)),
              ),
            ),
          ),


          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
                AppLocalizations
                    .of(context)
                    .address_screen_phone +' *',
                style: TextStyle(
                    color: MyTheme.secondary, fontSize: 12)),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Container(
              height: 40,
              child: TextField(
                controller: _phoneController,
                autofocus: false,
                decoration: InputDecoration(
                    hintText: AppLocalizations
                        .of(context)
                        .address_screen_enter_phone ,
                    hintStyle: TextStyle(
                        fontSize: 12.0, color: MyTheme.light_grey),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: BorderSide(
                          color: MyTheme.light_grey, width: 2.0),

                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: BorderSide(
                          color: MyTheme.light_grey, width: 2.0),
                    ),
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 8.0)),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
                AppLocalizations
                    .of(context)
                    .address_screen_email,
                style: TextStyle(
                    color: MyTheme.secondary, fontSize: 12)),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Container(
              height: 40,
              child: TextField(
                controller: _emailController,
                autofocus: false,
                decoration: InputDecoration(
                    hintText: "Enter Email",
                    hintStyle: TextStyle(
                        fontSize: 12.0, color: MyTheme.light_grey),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: BorderSide(
                          color: MyTheme.light_grey, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: BorderSide(
                          color: MyTheme.light_grey, width: 2.0),
                    ),
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 8.0)),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
                "${AppLocalizations
                    .of(context)
                    .address_screen_address} *",
                style: TextStyle(
                    color: MyTheme.secondary, fontSize: 12)),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Container(
              height: 55,
              child: TextField(
                controller: _addressController,
                autofocus: false,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                    hintText: AppLocalizations
                        .of(context)
                        .address_screen_enter_address,
                    hintStyle: TextStyle(
                        fontSize: 12.0, color: MyTheme.light_grey),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: BorderSide(
                          color: MyTheme.light_grey, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: BorderSide(
                          color: MyTheme.light_grey, width: 2.0),
                    ),
                    contentPadding: EdgeInsets.only(
                        left: 8.0, top: 16.0, bottom: 16.0)),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text("City *",
                style: TextStyle(
                    color: MyTheme.secondary, fontSize: 12)),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Container(
              height: 40,
              child: TypeAheadField(
                suggestionsCallback: (pattern) async {
                  var stateResponse = await AddressRepository()
                      .getCityByCountry(country_id: "3069");
                  return stateResponse.states.where((state) =>
                      state.name.toLowerCase().contains(pattern.toLowerCase())
                  );
                },
                loadingBuilder: (context) {
                  return Container(
                    height: 50,
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context).address_screen_loading_states,
                        style: TextStyle(color: MyTheme.dark_grey),
                      ),
                    ),
                  );
                },
                itemBuilder: (context, state) {
                  return ListTile(
                    dense: true,
                    title: Text(
                      state.name,
                      style: TextStyle(color: MyTheme.secondary),
                    ),
                  );
                },
                noItemsFoundBuilder: (context) {
                  return Container(
                    height: 50,
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context).address_screen_no_state_available,
                        style: TextStyle(color: MyTheme.dark_grey),
                      ),
                    ),
                  );
                },
                onSuggestionSelected: (state) {
                  onSelectCityDuringAdd(state, setModalState);
                },
                textFieldConfiguration: TextFieldConfiguration(
                  onTap: () {},
                  controller: _stateController,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context).address_screen_enter_state,
                    hintStyle: TextStyle(fontSize: 12.0, color: MyTheme.light_grey),
                    suffixIcon: Icon(Icons.arrow_drop_down_sharp),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: BorderSide(color: MyTheme.light_grey, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: BorderSide(color: MyTheme.light_grey, width: 2.0),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
                "Zone *",
                style: TextStyle(
                    color: MyTheme.secondary, fontSize: 12)),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Container(
              height: 40,
              child: TypeAheadField(
                suggestionsCallback: (name) async {
                  var cityResponse = await AddressRepository()
                      .getZoneByCity(
                      state_id: _selected_state.id);
                  return cityResponse.cities.where((element) =>
                      element.name.toLowerCase().contains(name.toLowerCase())
                  );
                },
                loadingBuilder: (context) {
                  return Container(
                    height: 50,
                    child: Center(
                        child: Text(
                            AppLocalizations
                                .of(context)
                                .address_screen_loading_cities,
                            style: TextStyle(
                                color: MyTheme.dark_grey))),
                  );
                },
                itemBuilder: (context, city) {
                  return ListTile(
                    dense: true,
                    title: Text(
                      city.name,
                      style: TextStyle(color: MyTheme.secondary),
                    ),
                  );
                },
                noItemsFoundBuilder: (context) {
                  return Container(
                    height: 50,
                    child: Center(
                        child: Text(
                            AppLocalizations
                                .of(context)
                                .address_screen_no_city_available,
                            style: TextStyle(
                                color: MyTheme.dark_grey))),
                  );
                },
                onSuggestionSelected: (city) {
                  onSelectZoneDuringAdd(city, setModalState);
                },
                textFieldConfiguration: TextFieldConfiguration(
                  onTap: () {},
                  controller: _cityController,
                  onSubmitted: (txt) {
                    // keep blank
                  },
                  decoration: InputDecoration(
                      hintText: "Select Zone",
                      hintStyle: TextStyle(
                          fontSize: 12.0,
                          color: MyTheme.light_grey),
                      suffixIcon: Icon(Icons.arrow_drop_down_sharp),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        borderSide: BorderSide(
                            color: MyTheme.light_grey, width: 2.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        borderSide: BorderSide(
                            color: MyTheme.light_grey, width: 2.0),
                      ),
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 8.0)),
                ),
              ),

            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text("Area ",
                style: TextStyle(
                    color: MyTheme.secondary, fontSize: 12)),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Container(
              height: 40,
              child: TypeAheadField(
                suggestionsCallback: (name) async {
                  var countryResponse = await AddressRepository()
                      .getAreaByZone(id: _selected_city.id);
                  return countryResponse.countries.where((element) =>
                      element.name.toLowerCase().contains(name.toLowerCase())
                  );
                },
                loadingBuilder: (context) {
                  return Container(
                    height: 50,
                    child: Center(
                        child: Text(
                            AppLocalizations
                                .of(context)
                                .address_screen_loading_cities,
                            style: TextStyle(
                                color: MyTheme.dark_grey))),
                  );
                },
                itemBuilder: (context, city) {
                  return ListTile(
                    dense: true,
                    title: Text(
                      city.name,
                      style: TextStyle(color: MyTheme.secondary),
                    ),
                  );
                },
                noItemsFoundBuilder: (context) {
                  return Container(
                    height: 50,
                    child: Center(
                        child: Text(
                            AppLocalizations
                                .of(context)
                                .address_screen_no_city_available,
                            style: TextStyle(
                                color: MyTheme.dark_grey))),
                  );
                },
                onSuggestionSelected: (city) {
                  onSelectAreaDuringAdd(city, setModalState);
                },
                textFieldConfiguration: TextFieldConfiguration(
                  onTap: () {},
                  //autofocus: true,
                  controller: _countryController,
                  onSubmitted: (txt) {
                    // keep blank
                  },
                  decoration: InputDecoration(
                      hintText: "Select Area",
                      hintStyle: TextStyle(
                          fontSize: 12.0,
                          color: MyTheme.light_grey),
                      suffixIcon: Icon(Icons.arrow_drop_down_sharp),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        borderSide: BorderSide(
                            color: MyTheme.light_grey, width: 2.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        borderSide: BorderSide(
                            color: MyTheme.light_grey, width: 2.0),
                      ),
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 8.0)),
                ),
              ),
            ),
          ),

        ],
      );
    });
  }

  buildDetails(){
    return Container(
      color: MyTheme.white,
      margin: EdgeInsets.symmetric(horizontal: 5),
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context).cart_screen_total_amount,
                    style: TextStyle(
                        color: MyTheme.secondary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _subTotalString ?? '',
                    style: TextStyle(
                        color: MyTheme.secondary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),

          Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Shipping Cost",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        color: MyTheme.secondary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),

                  Text(
                    _shippingCostString ?? '',
                    style: TextStyle(
                        color: MyTheme.secondary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),

          _discountedPrice == '৳0.00' ?
          Container() : Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Discount",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        color: MyTheme.secondary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),

                  Text(
                    _discountedPrice ?? '',
                    style: TextStyle(
                        color: MyTheme.secondary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )) ,

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total",
                textAlign: TextAlign.end,
                style: TextStyle(
                    color: MyTheme.secondary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                _totalString ?? '',
                style: TextStyle(
                    color: MyTheme.secondary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  buildCartSellerItemCard() {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.allCartProductList.length,
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: MyTheme.light_grey, width: 1.0),
              borderRadius: BorderRadius.circular(0.0),
            ),
            elevation: 0.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width * .23,
                        //height: 100,
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/placeholder.png',
                          image: widget.allCartProductList[index]
                              .product_thumbnail_image,
                          fit: BoxFit.fitWidth,
                        )),
                    Container(
                      width: MediaQuery.of(context).size.width * .47,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.allCartProductList[index]
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
                                      '${widget.allCartProductList[index].quantity}'
                                          ' x ${widget.allCartProductList[index].currency_symbol}'
                                          '${widget.allCartProductList[index].price.toStringAsFixed(2)}',
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                          color: MyTheme.dark_grey,
                                          fontSize: 14,
                                          height: 1.6,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),

                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Container(
                      child: Text(
                        '${widget.allCartProductList[index].currency_symbol}'
                            '${(widget.allCartProductList[index].quantity *
                            widget.allCartProductList[index].price).toStringAsFixed(2)}',
                        style: TextStyle(
                            color: MyTheme.secondary,
                            fontSize: 14,
                            height: 1.6,
                            fontWeight: FontWeight.w600),
                      ),
                    )
                  ]),
            ),
          );
        }
    );
  }




  buildAddressExpandedTile() {
    return Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: MyTheme.light_grey, width: 0.0),
          borderRadius: BorderRadius.circular(0.0),

        ),
        elevation: 0.0,
        child: Padding(
          padding:  EdgeInsets.only(
              top: 8.0, bottom: 8.0),
          child: success == false || _nameController.text == 'Guest'? Container(
            margin: EdgeInsets.only(
                top: 10
            ),
            padding: EdgeInsets.all( 8),
            decoration: BoxDecoration(
              //color: MyTheme.primary,
            ),
            child: buildShowAddFormDialog(context),
          ) : ExpansionTile(


            title: RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                  children: [
                    TextSpan(text: "Delivering to",
                      style: TextStyle(
                        color: MyTheme.secondary,
                      ),
                    ),
                    TextSpan(text: _addressController.text.toString().length > 20 ? " ${_addressController.text.toString().substring(0,20).toUpperCase()}..." :" ${_addressController.text.toString()}" ,
                      style: TextStyle(
                          color: MyTheme.secondary,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ]
              ),


            ),


            subtitle: Column(
              children: [

                SizedBox(
                  height: mHeight * 0.02,
                ),

                 Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(_nameController.text.toString(),
                      style: TextStyle(
                          color: MyTheme.secondary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                      ),
                    ),

                    SizedBox(
                      width: mWidth * 0.02,
                    ),

                    Text( "|",
                      style: TextStyle(
                          color: MyTheme.secondary,
                          fontWeight: FontWeight.bold
                      ),
                    ),


                    SizedBox(
                      width: mWidth * 0.02,
                    ),

                    Text(_phoneController.text.toString(),
                      style: TextStyle(
                          color: MyTheme.secondary,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),

                Container(
                    margin: EdgeInsets.only(
                        left: 32, top: 16, bottom: 8
                    ),
                    height: 36,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 1,
                          color: Colors.grey
                      ),
                      //color: Colors.grey[300]
                    ),
                    child: Center(child:
                    Text('Change Delivery Address' , style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),)
                    )),
              ],
            ),

            trailing: SizedBox(
              width: 0,
            ),


            children: [

              SizedBox(
                height: mHeight * 0.01,
                child: Container(
                  height: 0.5,
                  color: MyTheme.light_grey,
                ),
              ),

              Container(
                margin: EdgeInsets.only(
                    top: 10
                ),
                padding: EdgeInsets.all( 8),
                decoration: BoxDecoration(
                  //color: MyTheme.primary,
                ),
                child: buildShowAddFormDialog(context),
              )
            ],
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    mHeight = MediaQuery.of(context).size.height;
    mWidth = MediaQuery.of(context).size.width;

    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          //resizeToAvoidBottomInset: false,
          backgroundColor: Colors.grey[200],
          appBar: buildAppBar(context),
          bottomNavigationBar: buildBottomAppBar(context),
          body: Stack(
            children: [
              RefreshIndicator(
                color: MyTheme.primary,
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
                        delegate: SliverChildListDelegate(
                            [


                            ]
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Positioned(top: 0.0, child: customAppBar(context)),



              Container(
                padding: EdgeInsets.all(8),
                //height: 550,
                child: ListView(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  children: [

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text("Shipping Details",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: MyTheme.secondary,
                        ),
                      ),
                    ),


                    SizedBox(
                      height: mHeight * 0.008,
                    ),

                    success == null? ShimmerHelper().buildAddressLoadingShimmer(height: 80, ) :Container(
                      child: buildAddressExpandedTile(),
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text("Your Order",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: MyTheme.secondary,
                            ),
                          ),
                        ),

                        SizedBox(
                          height: mHeight * 0.008,
                        ),

                        Container(
                          child: buildCartSellerItemCard(),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    Container(
                      child: buildDetails(),
                    ),

                    SizedBox(
                      height: 16,
                    ),

                    widget.manual_payment_from_order_details == false
                        ? buildApplyCouponRow(context)
                        : Container(),

                    SizedBox(
                      height: 14,
                    ),
                    Container(
                      //color: MyTheme.white,
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0, left: 2, top: 8),
                            child: Text("Order Notes",
                                style: TextStyle(
                                    color: MyTheme.secondary, fontSize: 14)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0, left: 2, right: 4),
                            child: Container(
                              height: 55,
                              child: TextField(
                                controller: _orderNoteController,
                                autofocus: false,
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                decoration: InputDecoration(
                                    hintText: "Notes about your order, e.g. special notes for delivery.",
                                    hintStyle: TextStyle(
                                        fontSize: 12.0, color: MyTheme.dark_grey),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(0),
                                      borderSide: BorderSide(
                                          color: MyTheme.dark_grey, width: 1.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(0),
                                      borderSide: BorderSide(
                                          color: MyTheme.dark_grey, width: 1.0),
                                    ),
                                    contentPadding: EdgeInsets.only(
                                        left: 8.0, top: 16.0, bottom: 16.0)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: 8
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          Container(
                            color: MyTheme.white,
                            padding: EdgeInsets.all(5),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                  const EdgeInsets.only(left: 16.0, right: 16.0),
                                  child: buildPaymentMethodList(),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(top: 0.0, bottom:10),
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        value: _termsChecked,
                                        onChanged: (value) {
                                          setState(() {
                                            _termsChecked = value;
                                          });
                                        },
                                      ),
                                      Flexible(
                                        child: Text(
                                          "I HAVE READ AND AGREE TO THE KIREI'S TERMS AND CONDITIONS, PRIVACY POLICY, AND REFUND POLICY.",
                                          maxLines: 3,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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

  Container buildApplyCouponRow(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      // padding: EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width,
      // color: MyTheme.white,
      child: Row(
        children: [
          Container(
            height: 42,
            width: MediaQuery.of(context).size.width  * 0.56,
            alignment: Alignment.center,
            child: TextFormField(
              controller: _couponController,
              readOnly: _coupon_applied,
              autofocus: false,
              decoration: InputDecoration(
                border: OutlineInputBorder( // Add border
                  borderSide: BorderSide(color: Colors.black), // Set border color
                  borderRadius: BorderRadius.circular(0), // Set border radius
                ),
                focusedBorder: OutlineInputBorder( // Add border
                  borderSide: BorderSide(color: Colors.black), // Set border color
                  borderRadius: BorderRadius.circular(0), // Set border radius
                ),
                contentPadding: EdgeInsets.only(left: 16),
                hintText: AppLocalizations.of(context)
                    .checkout_screen_enter_coupon_code,
                hintStyle: TextStyle(fontSize: 14.0, color: MyTheme.secondary),

              ),
            ),
          ),
          !_coupon_applied
              ? Container(
            width: MediaQuery.of(context).size.width * 0.366,
            height: 42,
            child: FlatButton(
              minWidth: MediaQuery.of(context).size.width,
              color: MyTheme.secondary,
              shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.only(
                    topRight: const Radius.circular(0),
                    bottomRight: const Radius.circular(0),
                  )
              ),
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
            width: MediaQuery.of(context).size.width * 0.366,
            height: 42,
            child: FlatButton(

              color: MyTheme.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.only(
                    topRight: const Radius.circular(0),
                    bottomRight: const Radius.circular(0),
                  )
              ),
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
        widget.title ?? '',
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
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Address()), // Replace AddressScreen with the actual screen you want to navigate to
        );

      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: _seleted_shipping_address == _shippingAddressList[index]['id']
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
                        _shippingAddressList[index]['address'] ?? '',
                        maxLines: 2,
                        style: TextStyle(
                            color: MyTheme.dark_grey,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Spacer(),
                    buildShippingOptionsCheckContainer(
                        _seleted_shipping_address ==
                            _shippingAddressList[index]['id'])
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
                        _shippingAddressList[index]['city_name'] ?? '',
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
                          color: MyTheme.secondary,
                        ),
                      ),
                    ),
                    Container(
                      width: 200,
                      child: Text(
                        _shippingAddressList[index]['zone_name'] ?? '',
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
                          color: MyTheme.secondary,
                        ),
                      ),
                    ),
                    Container(
                      width: 200,
                      child: Text(
                        _shippingAddressList[index]['area_name'] ?? '',
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
                        _shippingAddressList[index]['postal_code'] ?? '',
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
                        _shippingAddressList[index]['phone'] ?? '',
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

  buildPaymentMethodList() {
    if (_isInitial && _paymentTypeList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildListShimmer(item_count: 5, item_height: 100.0));
    } else if (_paymentTypeList.length > 0) {

      return Container(
        height: 50,
        width: double.infinity,
        // color: Colors.grey,
        child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: _paymentTypeList.length,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,
            childAspectRatio: 2.3,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
          ),
          itemBuilder: (context, index){
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
                style: TextStyle(color: MyTheme.secondary),
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
            elevation: 0.0,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    //width: 100,
                      height: 50,
                      child: Padding(
                          padding: const EdgeInsets.only(left: 30.0, right: 5, top: 5,bottom: 5),
                          child:
                          FadeInImage.assetNetwork(
                            placeholder: 'assets/placeholder.png',
                            image: _paymentTypeList[index].payment_type ==
                                "manual_payment"
                                ? _paymentTypeList[index].image
                                : _paymentTypeList[index].image,
                            fit: BoxFit.fitWidth,
                          ))),
                ]),
          ),
          Positioned(
            left: 0,
            top: 13,
            child: buildPaymentMethodCheckContainer(
                _selected_payment_method_key ==
                    _paymentTypeList[index].payment_type_key),
          )
        ],
      ),
    );
  }

  Widget buildPaymentMethodCheckContainer(bool check) {
    return check == true ? Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0), color: Colors.green),
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Icon(FontAwesome.check, color: Colors.white, size: 10),
      ),
    )
        :
    Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0), color: MyTheme.white, border: Border.all(
        color: MyTheme.secondary,
        width: 2,
      )),
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Icon(FontAwesome.check, color: Colors.white, size: 10),
      ),
    )
    ;
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
                _shippingAddressList == null ? onAddressAdd(context) : Container();
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
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: 45,
      width: double.infinity,
      decoration: BoxDecoration(
          color: MyTheme.secondary
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              "${AppLocalizations.of(context).checkout_screen_total_amount} : ",
              style: TextStyle(color: MyTheme.white, fontSize: 14),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(
              _totalString,
              style: TextStyle(color: MyTheme.white, fontSize: 14),
            ),
          ),
        ],
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
