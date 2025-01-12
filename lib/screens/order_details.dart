import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kirei/data_model/city_response.dart';
import 'package:kirei/data_model/country_response.dart';
import 'package:kirei/data_model/state_response.dart';
import 'package:kirei/my_theme.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:kirei/providers/cart_count_update.dart';
import 'package:kirei/repositories/address_repository.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:kirei/repositories/order_repository.dart';
import 'package:kirei/helpers/shimmer_helper.dart';
import 'package:kirei/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'package:kirei/screens/main.dart';
import 'package:kirei/repositories/refund_request_repository.dart';
import 'package:kirei/screens/refund_request.dart';
import 'dart:async';
import 'package:kirei/screens/checkout.dart';
import 'package:kirei/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrderDetails extends StatefulWidget {
  int id;
  final bool from_notification;
  bool go_back;

  OrderDetails(
      {Key key, this.id, this.from_notification = false, this.go_back = true})
      : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  ScrollController _mainScrollController = ScrollController();
  var _steps = [
    'pending',
    'confirmed',
    'on_delivery',
    'picked_up',
    'on_the_way',
    'delivered'
  ];

  TextEditingController _refundReasonController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  bool _showReasonWarning = false;
  int _selectedCity_id;
  int _selectedZone_id;
  int _selectedArea_id;
  City _selected_city;
  Country _selected_country;
  MyState _selected_state;

  //init
  int _stepIndex = 0;
  var _orderDetails = null;
  List<dynamic> _orderedItemList = [];
  bool _orderItemsInit = false;

  @override
  void initState() {
    fetchAll();
    super.initState();

    print(widget.id);
  }

  @override
  void dispose() {
    super.dispose();
  }

  fetchAll() {
    fetchOrderDetails();
    fetchOrderedItems();
  }

  fetchOrderDetails() async {
    var orderDetailsResponse =
        await OrderRepository().getOrderDetails(id: widget.id);

    if (orderDetailsResponse.detailed_orders.length > 0) {
      _orderDetails = orderDetailsResponse.detailed_orders[0];
      setStepIndex(_orderDetails?.delivery_status);

      if(_orderDetails != null){
        _nameController.text = _orderDetails.shipping_address.name;
        _phoneController.text = _orderDetails.shipping_address.phone;
        _addressController.text = _orderDetails.shipping_address.address;
         _cityController.text = _orderDetails.shipping_address.city;
         _stateController.text = _orderDetails.shipping_address.state;
         _countryController.text = _orderDetails.shipping_address.area;
        _selectedCity_id = _orderDetails.shipping_address.city_id;
        _selectedZone_id = _orderDetails.shipping_address.zone_id;
        _selectedArea_id = _orderDetails.shipping_address.area_id;
      }
    }

    setState(() {});
  }

  setStepIndex(key) {
    _stepIndex = _steps.indexOf(key);
    setState(() {});
  }

  fetchOrderedItems() async {
    var orderItemResponse =
        await OrderRepository().getOrderItems(id: widget.id);
    _orderedItemList.addAll(orderItemResponse.ordered_items);
    _orderItemsInit = true;

    setState(() {});
  }

  reset() {
    _stepIndex = 0;
    _orderDetails = null;
    _orderedItemList.clear();
    _orderItemsInit = false;
    setState(() {});
  }

  Future<void> _onPageRefresh() async {
    reset();
    fetchAll();
  }

  onPressOfflinePaymentButton() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Checkout(
        order_id: widget.id,
        title: AppLocalizations.of(context).checkout_screen_checkout,
        list: "offline",
        manual_payment_from_order_details: true,
        rechargeAmount: double.parse(
            _orderDetails?.grand_total.toString().replaceAll('\$', '')),
      );
    })).then((value) {
      onPopped(value);
    });
  }

  onTapAskRefund(item_id, item_name, order_code) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
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
                        child: Row(
                          children: [
                            Text(
                                AppLocalizations.of(context)
                                    .order_details_screen_refund_product_name,
                                style: TextStyle(
                                    color: MyTheme.secondary, fontSize: 12)),
                            Container(
                              width: 225,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(item_name,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: MyTheme.secondary,
                                        fontSize: 13)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Text(
                                AppLocalizations.of(context)
                                    .order_details_screen_refund_order_code,
                                style: TextStyle(
                                    color: MyTheme.secondary, fontSize: 12)),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(order_code,
                                  style: TextStyle(
                                      color: MyTheme.secondary, fontSize: 13)),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Text(
                                "${AppLocalizations.of(context).order_details_screen_refund_reason} *",
                                style: TextStyle(
                                    color: MyTheme.secondary, fontSize: 12)),
                            _showReasonWarning
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                      left: 8.0,
                                    ),
                                    child: Text(
                                        AppLocalizations.of(context)
                                            .order_details_screen_refund_reason_empty_warning,
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 12)),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          height: 55,
                          child: TextField(
                            controller: _refundReasonController,
                            autofocus: false,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)
                                    .order_details_screen_refund_enter_reason,
                                hintStyle: TextStyle(
                                    fontSize: 12.0, color: MyTheme.light_grey),
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
                                    left: 8.0, top: 16.0, bottom: 16.0)),
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
                      padding: const EdgeInsets.only(right: 8.0),
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
                          _refundReasonController.clear();
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                      ),
                    ),
                    SizedBox(
                      width: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 28.0),
                      child: FlatButton(
                        minWidth: 75,
                        height: 30,
                        color: MyTheme.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                                color: MyTheme.light_grey, width: 1.0)),
                        child: Text(
                          AppLocalizations.of(context).common_submit,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        onPressed: () {
                          onPressSubmitRefund(item_id, setState);
                        },
                      ),
                    )
                  ],
                )
              ],
            );
          });
        });
  }

  shoWReasonWarning(setState) {
    setState(() {
      _showReasonWarning = true;
    });
    Timer timer = Timer(Duration(seconds: 2), () {
      setState(() {
        _showReasonWarning = false;
      });
    });
  }

  onPressSubmitRefund(item_id, setState) async {
    var reason = _refundReasonController.text.toString();

    if (reason == "") {
      shoWReasonWarning(setState);
      return;
    }

    var refundRequestSendResponse = await RefundRequestRepository()
        .getRefundRequestSendResponse(id: item_id, reason: reason);

    if (refundRequestSendResponse.result == false) {
      ToastComponent.showDialog(refundRequestSendResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    Navigator.of(context, rootNavigator: true).pop();
    _refundReasonController.clear();

    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
        refundRequestSendResponse.message,
        style: TextStyle(color: MyTheme.secondary),
      ),
      backgroundColor: MyTheme.primary,
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: AppLocalizations.of(context)
            .order_details_screen_refund_snackbar_show_request_list,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return RefundRequest();
          })).then((value) {
            onPopped(value);
          });
        },
        textColor: MyTheme.primary,
        disabledTextColor: Colors.grey,
      ),
    ));

    reset();
    fetchAll();
    setState(() {});
  }

  onPopped(value) async {
    reset();
    fetchAll();
  }

  bool loading = false;

  void reOrder(int id) async{
    setState(() {
      loading = true;
    });
    var response = await OrderRepository().getReOrder(id: id);
    setState(() {
      loading = false;
    });

    if(response["result"] == true){
      Provider.of<CartCountUpdate>(context, listen: false).getReorderCart(response["data"]["cart_quantity"].toString());
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Main(pageIndex: 2,)));
      ToastComponent.showDialog(response["message"].toString(), context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG).then((){
        setState(() {
          loading = false;
        });
      });
    } else {
      ToastComponent.showDialog(response["message"].toString(), context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG).then((){
        setState(() {
          loading = false;
        });
      });
    }

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

  buildShowUpdateFormDialog(BuildContext context,) {
    return Container(
      //height: MediaQuery.of(context).size.height * 0.75,
      width: MediaQuery.of(context).size.width,
      child: StatefulBuilder(builder: (BuildContext context,
          StateSetter setModalState /*You can rename this!*/) {
        return ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          //physics: ScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                  AppLocalizations
                      .of(context)
                      .address_screen_name ,
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
                      .address_screen_phone,
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
                  "${AppLocalizations
                      .of(context)
                      .address_screen_address}",
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
              child: Text("City ",
                  style: TextStyle(
                      color: MyTheme.secondary, fontSize: 12)),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Container(
                height: 40,
                child: TypeAheadField(
                  direction: AxisDirection.up,
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
                  "Zone",
                  style: TextStyle(
                      color: MyTheme.secondary, fontSize: 12)),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Container(
                height: 40,
                child: TypeAheadField(
                  direction: AxisDirection.up,
                  suggestionsCallback: (name) async {
                    try{
                      var cityResponse = await AddressRepository()
                          .getZoneByCity(
                          state_id: _selected_state.id);
                      return cityResponse.cities.where((element) =>
                          element.name.toLowerCase().contains(name.toLowerCase())
                      );
                    }catch(e){
                      throw ("Please Select City First");
                    }
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
                    //autofocus: true,
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
                  direction: AxisDirection.up,
                  suggestionsCallback: (name) async {
                    try{
                      var countryResponse = await AddressRepository()
                          .getAreaByZone(id: _selected_city.id);
                      return countryResponse.countries.where((element) =>
                          element.name.toLowerCase().contains(name.toLowerCase())
                      );
                    } catch(e){
                      throw ("Please Select City and Zone");
                    }
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

            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: InkWell(
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.height * 0.1,
                      decoration: BoxDecoration(
                        // border: Border.all(
                        //   width: 2,
                        //   color: MyTheme.primary
                        // )
                        color: MyTheme.primary,
                      ),
                      child: Center(child: Text("Cancel" ,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: MyTheme.white
                        ),
                      )),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: InkWell(
                    onTap: (){
                      //saveOrUpdateAddress();
                      processOrderAddressUpdate(widget.id);
                      _addressController.text.length >= 10 ? Navigator.of(context).pop() : ToastComponent.showDialog(
                          "Address have to be minimum 10 character", context,
                          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
                       //_onPageRefresh();
                      setState(() {

                      });
                      //_onPageRefresh();
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.height * 0.1,
                      decoration: BoxDecoration(
                        color: MyTheme.secondary,
                      ),
                      child: Center(child: Text("Update" ,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: MyTheme.white
                        ),
                      )),
                    ),
                  ),
                ),
              ],
            ),

          ],
        );
      }),
    );
  }

  void processOrderAddressUpdate(int oderId)async{

    try{
      if (_nameController.text == "") {
        ToastComponent.showDialog(
            "Name  is required", context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }

      if (_phoneController.text == "") {
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

      if (_addressController.text == "") {
        ToastComponent.showDialog(
            "Address is required", context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      } else if(_addressController.text.length < 10) {
        ToastComponent.showDialog(
            "Address have to be minimum 10 character", context,
            gravity: Toast.TOP, duration: Toast.LENGTH_LONG);
        return;
      }

      if ( _stateController.text == "") {
        ToastComponent.showDialog(
            "City is required", context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }

      if (_cityController.text == "") {
        ToastComponent.showDialog(
            "Zone is required", context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }

      var response = await AddressRepository().getOrderProcessAddressUpdateResponse(
        order_id: oderId,
        shipping_name: _nameController.text,
        shipping_address: _addressController.text,
        shipping_city_id: _selectedCity_id,
        shipping_zone_id: _selectedZone_id,
        shipping_area_id:_selectedArea_id ,
        shipping_phone: _phoneController.text,
      ).then((value){
        _onPageRefresh();
      });

      if(response["result"] == true){
        ToastComponent.showDialog("${response["message"]}", context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      } else{
        ToastComponent.showDialog("${response["message"]}", context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      }
    } on Exception catch(e){
      print("error is .... ${e.toString()}");
    } catch(e){
      print("e is ${e.toString()}");
    }
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (widget.from_notification || widget.go_back == false) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Main();
          }));
        }else {
           Navigator.of(context).pop();
        }
      },
      child: Directionality(
        textDirection:
            app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
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
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _orderDetails != null
                        ? buildOrderDetailsTopCard()
                        : ShimmerHelper().buildBasicShimmer(height: 150.0),
                  ),
                ])),

                SliverList(
                    delegate: SliverChildListDelegate([
                  Center(
                    child: Text(
                      AppLocalizations.of(context)
                          .order_details_screen_ordered_product,
                      style: TextStyle(
                          color: MyTheme.secondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _orderedItemList.length == 0 && _orderItemsInit
                          ? ShimmerHelper().buildBasicShimmer(height: 100.0)
                          : (_orderedItemList.length > 0
                              ? buildOrderdProductList()
                              : Container(
                                  height: 100,
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .order_details_screen_ordered_product,
                                    style: TextStyle(color: MyTheme.secondary),
                                  ),
                                )))
                ])),

                SliverList(
                    delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 75,
                        ),
                        buildBottomSection()
                      ],
                    ),
                  )
                ])),
                SliverList(
                    delegate:
                        SliverChildListDelegate([buildPaymentButtonSection()]))
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildBottomSection() {
    return Expanded(
      child: _orderDetails != null
          ? Column(
              children: [
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 120,
                          child: Text(
                            AppLocalizations.of(context)
                                .order_details_screen_sub_total,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: MyTheme.secondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Text(
                          _orderDetails?.subtotal??'',
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
                                .order_details_screen_tax,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: MyTheme.secondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Text(
                          _orderDetails?.tax??'',
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
                                .order_details_screen_shipping_cost,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: MyTheme.secondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Text(
                          _orderDetails?.shipping_cost??'',
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
                                .order_details_screen_discount,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: MyTheme.secondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Text(
                          _orderDetails?.coupon_discount??'',
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
                                .order_details_screen_grand_total,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: MyTheme.secondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Text(
                          _orderDetails?.grand_total??'',
                          style: TextStyle(
                              color: MyTheme.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
              ],
            )
          : ShimmerHelper().buildBasicShimmer(height: 100.0),
    );
  }

  buildTimeLineShimmer() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ShimmerHelper().buildBasicShimmer(height: 40, width: 40.0),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ShimmerHelper().buildBasicShimmer(height: 40, width: 40.0),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ShimmerHelper().buildBasicShimmer(height: 40, width: 40.0),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ShimmerHelper().buildBasicShimmer(height: 40, width: 40.0),
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: ShimmerHelper().buildBasicShimmer(height: 20, width: 250.0),
        )
      ],
    );
  }

  buildTimeLineTiles() {
    print(_orderDetails?.delivery_status);
    return SizedBox(
      height: 200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TimelineTile(
            axis: TimelineAxis.vertical,
            alignment: TimelineAlign.end,
            isFirst: true,
            startChild: Container(
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: _orderDetails?.delivery_status == "pending" ? 36 : 30,
                    height:
                        _orderDetails?.delivery_status == "pending" ? 36 : 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.redAccent, width: 2),

                      //shape: BoxShape.rectangle,
                    ),
                    child: Icon(
                      Icons.list_alt,
                      color: Colors.redAccent,
                      size: 18,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                        height: 1.0,
                        width: MediaQuery.of(context).size.width * .4,
                        color: MyTheme.dark_grey),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      AppLocalizations.of(context)
                          .order_details_screen_timeline_tile_order_placed,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: MyTheme.secondary, fontSize: 12),
                    ),
                  )
                ],
              ),
            ),
            indicatorStyle: IndicatorStyle(
              color: _stepIndex >= 0 ? Colors.green : MyTheme.dark_grey,
              padding: const EdgeInsets.all(0),
              iconStyle: _stepIndex >= 0
                  ? IconStyle(
                      color: Colors.white, iconData: Icons.check, fontSize: 16)
                  : null,
            ),
            afterLineStyle: _stepIndex >= 1
                ? LineStyle(
                    color: Colors.green,
                    thickness: 5,
                  )
                : LineStyle(
                    color: MyTheme.dark_grey,
                    thickness: 4,
                  ),
          ),
          TimelineTile(
            axis: TimelineAxis.vertical,
            alignment: TimelineAlign.end,
            startChild: Container(
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width:
                        _orderDetails?.delivery_status == "confirmed" ? 36 : 30,
                    height:
                        _orderDetails?.delivery_status == "confirmed" ? 36 : 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.blue, width: 2),

                      //shape: BoxShape.rectangle,
                    ),
                    child: Icon(
                      Icons.thumb_up_sharp,
                      color: Colors.blue,
                      size: 18,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                        height: 1.0,
                        width: MediaQuery.of(context).size.width * .4,
                        color: MyTheme.dark_grey),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      AppLocalizations.of(context)
                          .order_details_screen_timeline_tile_confirmed,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: MyTheme.secondary),
                    ),
                  )
                ],
              ),
            ),
            indicatorStyle: IndicatorStyle(
              color: _stepIndex >= 1 ? Colors.green : MyTheme.dark_grey,
              padding: const EdgeInsets.all(0),
              iconStyle: _stepIndex >= 1
                  ? IconStyle(
                      color: Colors.white, iconData: Icons.check, fontSize: 16)
                  : null,
            ),
            beforeLineStyle: _stepIndex >= 1
                ? LineStyle(
                    color: Colors.green,
                    thickness: 5,
                  )
                : LineStyle(
                    color: MyTheme.dark_grey,
                    thickness: 4,
                  ),
            afterLineStyle: _stepIndex >= 2
                ? LineStyle(
                    color: Colors.green,
                    thickness: 5,
                  )
                : LineStyle(
                    color: MyTheme.dark_grey,
                    thickness: 4,
                  ),
          ),
          TimelineTile(
            axis: TimelineAxis.vertical,
            alignment: TimelineAlign.end,
            startChild: Container(
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: _orderDetails?.delivery_status == "on_delivery"
                        ? 36
                        : 30,
                    height: _orderDetails?.delivery_status == "on_delivery"
                        ? 36
                        : 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.amber, width: 2),

                      //shape: BoxShape.rectangle,
                    ),
                    child: Icon(
                      Icons.local_shipping_outlined,
                      color: Colors.amber,
                      size: 18,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                        height: 1.0,
                        width: MediaQuery.of(context).size.width * .4,
                        color: MyTheme.dark_grey),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      AppLocalizations.of(context)
                          .order_details_screen_timeline_tile_on_delivery,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: MyTheme.secondary),
                    ),
                  )
                ],
              ),
            ),
            indicatorStyle: IndicatorStyle(
              color: _stepIndex >= 2 ? Colors.green : MyTheme.dark_grey,
              padding: const EdgeInsets.all(0),
              iconStyle: _stepIndex >= 2
                  ? IconStyle(
                      color: Colors.white, iconData: Icons.check, fontSize: 16)
                  : null,
            ),
            beforeLineStyle: _stepIndex >= 2
                ? LineStyle(
                    color: Colors.green,
                    thickness: 5,
                  )
                : LineStyle(
                    color: MyTheme.dark_grey,
                    thickness: 4,
                  ),
            afterLineStyle: _stepIndex >= 5
                ? LineStyle(
                    color: Colors.green,
                    thickness: 5,
                  )
                : LineStyle(
                    color: MyTheme.dark_grey,
                    thickness: 4,
                  ),
          ),
          TimelineTile(
            axis: TimelineAxis.vertical,
            alignment: TimelineAlign.end,
            isLast: true,
            startChild: Container(
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width:
                        _orderDetails?.delivery_status == "delivered" ? 36 : 30,
                    height:
                        _orderDetails?.delivery_status == "delivered" ? 36 : 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.purple, width: 2),

                      //shape: BoxShape.rectangle,
                    ),
                    child: Icon(
                      Icons.done_all,
                      color: Colors.purple,
                      size: 18,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                        height: 1.0,
                        width: MediaQuery.of(context).size.width * .4,
                        color: MyTheme.dark_grey),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      AppLocalizations.of(context)
                          .order_details_screen_timeline_tile_delivered,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: MyTheme.secondary),
                    ),
                  )
                ],
              ),
            ),
            indicatorStyle: IndicatorStyle(
              color: _stepIndex >= 5 ? Colors.green : MyTheme.dark_grey,
              padding: const EdgeInsets.all(0),
              iconStyle: _stepIndex >= 5
                  ? IconStyle(
                      color: Colors.white, iconData: Icons.check, fontSize: 16)
                  : null,
            ),
            beforeLineStyle: _stepIndex >= 5
                ? LineStyle(
                    color: Colors.green,
                    thickness: 5,
                  )
                : LineStyle(
                    color: MyTheme.dark_grey,
                    thickness: 4,
                  ),
          ),
        ],
      ),
    );
  }

  Card buildOrderDetailsTopCard() {
    return Card(
      shape: RoundedRectangleBorder(
        side: new BorderSide(color: MyTheme.light_grey, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  children: [
                    Text(
                      "Order Number",
                      style: TextStyle(
                          color: MyTheme.secondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
                    ),

                  ],
                ),
                Spacer(),
                Text(
                  "Shipping Method",
                  style: TextStyle(
                      color: MyTheme.secondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Text(
                    _orderDetails?.id.toString()??'',
                    style: TextStyle(
                        color: MyTheme.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                  Spacer(),
                  Text(
                    _orderDetails?.shipping_type_string??'',
                    style: TextStyle(
                      color: MyTheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  "Order Date",
                  style: TextStyle(
                      color: MyTheme.secondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
                Spacer(),
                Text(
                  "Payment Method",
                  style: TextStyle(
                      color: MyTheme.secondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Text(
                    _orderDetails?.date??'',
                    style: TextStyle(
                      color: MyTheme.secondary,
                    ),
                  ),
                  Spacer(),
                  Text(
                    _orderDetails?.payment_type??'',
                    style: TextStyle(
                      color: MyTheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  "Payment Status",
                  style: TextStyle(
                      color: MyTheme.secondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
                Spacer(),
                Text(
                  "Delivery Status",
                  style: TextStyle(
                      color: MyTheme.secondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      _orderDetails?.payment_status_string??'',
                      style: TextStyle(
                        color: MyTheme.secondary,
                      ),
                    ),
                  ),
                  buildPaymentStatusCheckContainer(
                      _orderDetails?.payment_status??''),
                  Spacer(),
                  Text(
                    _orderDetails?.delivery_status_string??'',
                    style: TextStyle(
                      color: MyTheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  _orderDetails?.shipping_address != null
                      ? "Shipping Address"
                      : "Pickup Point",
                  style: TextStyle(
                      color: MyTheme.secondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
                Spacer(),
                Text(
                  "Total Amount",
                  style: TextStyle(
                      color: MyTheme.secondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Container(
                    width: (MediaQuery.of(context).size.width - (32.0)) / 2,
                    // (total_screen_width - padding)/2
                    child: _orderDetails?.shipping_address != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _orderDetails?.shipping_address.name != null
                                  ? Text(
                                      "${AppLocalizations.of(context).order_details_screen_name}: ${_orderDetails?.shipping_address.name??''}",
                                      maxLines: 3,
                                      style: TextStyle(
                                        color: MyTheme.secondary,
                                      ),
                                    )
                                  : Container(),
                              _orderDetails?.shipping_address.email != null
                                  ? Text(
                                      "${AppLocalizations.of(context).order_details_screen_email}: ${_orderDetails?.shipping_address.email??''}",
                                      maxLines: 3,
                                      style: TextStyle(
                                        color: MyTheme.secondary,
                                      ),
                                    )
                                  : Container(),
                              Text(
                                "${AppLocalizations.of(context).order_details_screen_address}: ${_orderDetails?.shipping_address.address??''}",
                                maxLines: 3,
                                style: TextStyle(
                                  color: MyTheme.secondary,
                                ),
                              ),
                              Text(
                                "${AppLocalizations.of(context).order_details_screen_city}: ${_orderDetails?.shipping_address.city??''}",
                                maxLines: 3,
                                style: TextStyle(
                                  color: MyTheme.secondary,
                                ),
                              ),
                              Text(
                                "${AppLocalizations.of(context).order_details_screen_state}: ${_orderDetails?.shipping_address.state??''}",
                                maxLines: 3,
                                style: TextStyle(
                                  color: MyTheme.secondary,
                                ),
                              ),
                              Text(
                                "${AppLocalizations.of(context).order_details_screen_phone}: ${_orderDetails?.shipping_address.phone??''}",
                                maxLines: 3,
                                style: TextStyle(
                                  color: MyTheme.secondary,
                                ),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _orderDetails?.pickupPoint.name != null
                                  ? Text(
                                      "${AppLocalizations.of(context).order_details_screen_name}: ${_orderDetails?.pickupPoint.name??''}",
                                      maxLines: 3,
                                      style: TextStyle(
                                        color: MyTheme.secondary,
                                      ),
                                    )
                                  : Container(),
                              Text(
                                "${AppLocalizations.of(context).order_details_screen_address}: ${_orderDetails?.pickupPoint.address??''}",
                                maxLines: 3,
                                style: TextStyle(
                                  color: MyTheme.secondary,
                                ),
                              ),
                              Text(
                                "${AppLocalizations.of(context).address_screen_phone}: ${_orderDetails?.pickupPoint.phone??''}",
                                maxLines: 3,
                                style: TextStyle(
                                  color: MyTheme.secondary,
                                ),
                              ),
                            ],
                          ),
                  ),
                  Spacer(),
                  Text(
                    _orderDetails?.grand_total??'',
                    style: TextStyle(
                        color: MyTheme.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            InkWell(
              onTap: (){
                reOrder(_orderDetails?.id);
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  // border: Border.all(
                  //   color: Colors.red,
                  //   width: 2,
                  // ),
                  color: MyTheme.add_to_cart_button
                ),
                child: Center(
                    child: loading == true ? CircularProgressIndicator(color: MyTheme.white,): Text("Re-order",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: MyTheme.white,
                ),
                )),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Visibility(
              visible: _orderDetails?.delivery_status_string == "Processing" ? true : false,
              child: InkWell(
                onTap: (){
                  //reOrder(_orderDetails?.id);
                  _onPageRefresh();
                  showDialog(
                      context: context,
                      builder: (context){
                        return AlertDialog(
                          title: Center(child: Text("Update Info",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          )),
                          content: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child:buildShowUpdateFormDialog(context),

                          ),

                        );
                      }
                  );
                },
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      // border: Border.all(
                      //   color: MyTheme.preorder,
                      //   width: 2,
                      // )
                    color: MyTheme.preorder
                  ),
                  child: Center(
                      child: Text("Update-info",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card buildOrderedProductItemsCard(index) {
    return Card(
      shape: RoundedRectangleBorder(
        side: new BorderSide(color: MyTheme.light_grey, width: 1.0),
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
              child: Text(
                _orderedItemList[index]?.product_name??'',
                maxLines: 2,
                style: TextStyle(
                  color: MyTheme.secondary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Text(
                    _orderedItemList[index]?.quantity.toString()??'' + " x ",
                    style: TextStyle(
                        color: MyTheme.secondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                  _orderedItemList[index]?.variation != "" &&
                          _orderedItemList[index]?.variation != null
                      ? Text(
                          _orderedItemList[index]?.variation??'',
                          style: TextStyle(
                              color: MyTheme.secondary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        )
                      : Text(
                    _orderedItemList[index]?.quantity == 1 ? " item" : " items",
                          style: TextStyle(
                              color: MyTheme.secondary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                  Spacer(),
                  Text(
                    _orderedItemList[index]?.price??'',
                    style: TextStyle(
                        color: MyTheme.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            _orderedItemList[index]?.refund_section &&
                    _orderedItemList[index]?.refund_button
                ? InkWell(
                    onTap: () {
                      onTapAskRefund(
                          _orderedItemList[index]?.id,
                          _orderedItemList[index]?.product_name,
                          _orderDetails?.code);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            AppLocalizations.of(context)
                                .order_details_screen_ask_for_refund,
                            style: TextStyle(
                                color: MyTheme.primary,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 2.0),
                            child: Icon(
                              FontAwesome.rotate_left,
                              color: MyTheme.primary,
                              size: 14,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : Container(),
            _orderedItemList[index]?.refund_section &&
                    _orderedItemList[index]?.refund_label != ""
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            AppLocalizations.of(context)
                                .order_details_screen_refund_status,
                            style: TextStyle(color: MyTheme.secondary),
                          ),
                          Text(
                            _orderedItemList[index]?.refund_label??'',
                            style: TextStyle(
                                color: getRefundRequestLabelColor(
                                    _orderedItemList[index]
                                        .refund_request_status)),
                          ),
                        ],
                      ),
                    ],
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  getRefundRequestLabelColor(status) {
    if (status == 0) {
      return Colors.blue;
    } else if (status == 2) {
      return Colors.orange;
    } else if (status == 1) {
      return Colors.green;
    } else {
      return MyTheme.secondary;
    }
  }

  buildOrderdProductList() {
    return SingleChildScrollView(
      child: ListView.builder(
        itemCount: _orderedItemList.length,
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: buildOrderedProductItemsCard(index),
          );
        },
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
            onPressed: () {
              if (widget.from_notification || widget.go_back == false) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Main();
                }));
              } else {
                return Navigator.of(context).pop();
              }
            }),
      ),
      title: Text(
        AppLocalizations.of(context).order_details_screen_order_details,
        style: TextStyle(fontSize: 16, color: MyTheme.primary),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildPaymentButtonSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _orderDetails != null && _orderDetails?.manually_payable
              ? FlatButton(
                  color: MyTheme.primary,
                  child: Text(
                    AppLocalizations.of(context)
                        .order_details_screen_make_offline_payment,
                    style: TextStyle(color: MyTheme.secondary),
                  ),
                  onPressed: () {
                    onPressOfflinePaymentButton();
                  },
                )
              : Container(),
        ],
      ),
    );
  }

  Container buildPaymentStatusCheckContainer(String payment_status) {
    return Container(
      height: 16,
      width: 16,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
    color: payment_status == "paid"
    ? Colors.green
        : payment_status == "COD"
    ? Colors.orange
        : Colors.red,
      ),
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Icon(
            payment_status == "paid" || payment_status == "COD"  ? FontAwesome.check : FontAwesome.times,
            color: Colors.white,
            size: 10),
      ),
    );
  }
}
