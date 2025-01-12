import 'package:flutter/cupertino.dart';
import 'package:kirei/custom/toast_component.dart';
import 'package:kirei/providers/cart_count_update.dart';
import 'package:kirei/screens/order_details.dart';
import 'package:kirei/screens/main.dart';
import 'package:flutter/material.dart';
import 'package:kirei/my_theme.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:kirei/repositories/order_repository.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:kirei/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:one_context/one_context.dart';
import 'package:toast/toast.dart';

class PaymentStatus {
  String option_key;
  String name;

  PaymentStatus(this.option_key, this.name);

  static List<PaymentStatus> getPaymentStatusList() {
    return <PaymentStatus>[
      PaymentStatus(
          '', AppLocalizations.of(OneContext().context).order_list_screen_all),
      PaymentStatus('paid',
          AppLocalizations.of(OneContext().context).order_list_screen_paid),
      PaymentStatus('unpaid',
          AppLocalizations.of(OneContext().context).order_list_screen_unpaid),
    ];
  }
}

class DeliveryStatus {
  String option_key;
  String name;

  DeliveryStatus(this.option_key, this.name);

  static List<DeliveryStatus> getDeliveryStatusList() {
    return <DeliveryStatus>[
      DeliveryStatus(
          '', AppLocalizations.of(OneContext().context).order_list_screen_all),
      DeliveryStatus(
          'confirmed',
          AppLocalizations.of(OneContext().context)
              .order_list_screen_confirmed),
      DeliveryStatus(
          'on_delivery',
          AppLocalizations.of(OneContext().context)
              .order_list_screen_on_delivery),
      DeliveryStatus(
          'delivered',
          AppLocalizations.of(OneContext().context)
              .order_list_screen_delivered),
    ];
  }
}

class OrderList extends StatefulWidget {
  OrderList({Key key, this.from_checkout = false}) : super(key: key);
  final bool from_checkout;

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  ScrollController _scrollController = ScrollController();
  ScrollController _xcrollController = ScrollController();

  List<PaymentStatus> _paymentStatusList = PaymentStatus.getPaymentStatusList();
  List<DeliveryStatus> _deliveryStatusList =
      DeliveryStatus.getDeliveryStatusList();

  PaymentStatus _selectedPaymentStatus;
  DeliveryStatus _selectedDeliveryStatus;

  List<DropdownMenuItem<PaymentStatus>> _dropdownPaymentStatusItems;
  List<DropdownMenuItem<DeliveryStatus>> _dropdownDeliveryStatusItems;

  //------------------------------------
  List<dynamic> _orderList = [];
  Map<int, bool> _isLoadingMap = {};
  bool _isInitial = true;
  int _page = 1;
  int _totalData = 0;
  bool _showLoadingContainer = false;
  String _defaultPaymentStatusKey = '';
  String _defaultDeliveryStatusKey = '';

  @override
  void initState() {
    init();
    super.initState();

    fetchData();

    _xcrollController.addListener(() {

      if (_xcrollController.position.pixels ==
          _xcrollController.position.maxScrollExtent) {
        setState(() {
          _page++;
        });
        _showLoadingContainer = true;
        fetchData();
      }
    });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    _xcrollController.dispose();
    super.dispose();
  }

  init() {
    _dropdownPaymentStatusItems =
        buildDropdownPaymentStatusItems(_paymentStatusList);

    _dropdownDeliveryStatusItems =
        buildDropdownDeliveryStatusItems(_deliveryStatusList);

    for (int x = 0; x < _dropdownPaymentStatusItems.length; x++) {
      if (_dropdownPaymentStatusItems[x].value.option_key ==
          _defaultPaymentStatusKey) {
        _selectedPaymentStatus = _dropdownPaymentStatusItems[x].value;
      }
    }

    for (int x = 0; x < _dropdownDeliveryStatusItems.length; x++) {
      if (_dropdownDeliveryStatusItems[x].value.option_key ==
          _defaultDeliveryStatusKey) {
        _selectedDeliveryStatus = _dropdownDeliveryStatusItems[x].value;
      }
    }
  }

  reset() {
    _orderList.clear();
    _isInitial = true;
    _page = 1;
    _totalData = 0;
    _showLoadingContainer = false;
  }

  resetFilterKeys() {
    _defaultPaymentStatusKey = '';
    _defaultDeliveryStatusKey = '';

    setState(() {});
  }

  Future<void> _onRefresh() async {
    reset();
    resetFilterKeys();
    for (int x = 0; x < _dropdownPaymentStatusItems.length; x++) {
      if (_dropdownPaymentStatusItems[x].value.option_key ==
          _defaultPaymentStatusKey) {
        _selectedPaymentStatus = _dropdownPaymentStatusItems[x].value;
      }
    }

    for (int x = 0; x < _dropdownDeliveryStatusItems.length; x++) {
      if (_dropdownDeliveryStatusItems[x].value.option_key ==
          _defaultDeliveryStatusKey) {
        _selectedDeliveryStatus = _dropdownDeliveryStatusItems[x].value;
      }
    }
    setState(() {});
    fetchData();
  }

  fetchData() async {
    var orderResponse = await OrderRepository().getOrderList(
        page: _page,
        payment_status: _selectedPaymentStatus.option_key,
        delivery_status: _selectedDeliveryStatus.option_key);

   _orderList.addAll(orderResponse["data"]);


    print("orderResponse ${orderResponse.toString()}");


    _isInitial = false;

    _showLoadingContainer = false;
    setState(() {});
  }

  List<DropdownMenuItem<PaymentStatus>> buildDropdownPaymentStatusItems(
      List _paymentStatusList) {
    List<DropdownMenuItem<PaymentStatus>> items = List();
    for (PaymentStatus item in _paymentStatusList) {
      items.add(
        DropdownMenuItem(
          value: item,
          child: Text(item.name),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<DeliveryStatus>> buildDropdownDeliveryStatusItems(
      List _deliveryStatusList) {
    List<DropdownMenuItem<DeliveryStatus>> items = List();
    for (DeliveryStatus item in _deliveryStatusList) {
      items.add(
        DropdownMenuItem(
          value: item,
          child: Text(item.name),
        ),
      );
    }
    return items;
  }

  void reOrder(int index,int id) async{
    setState(() {
      _isLoadingMap[index] = true;
    });
    var response = await OrderRepository().getReOrder(id: id);
    setState(() {
      _isLoadingMap[index] = false;
    });
    if(response["result"] == true){
      Provider.of<CartCountUpdate>(context, listen: false).getReorderCart(response["data"]["cart_quantity"].toString());
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Main(pageIndex: 2,)));
      ToastComponent.showDialog(response["message"].toString(), context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG).then((){
        setState(() {
          _isLoadingMap[index] = false;
        });
      });
    } else {
      ToastComponent.showDialog(response["message"].toString(), context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG).then((){
        setState(() {
          _isLoadingMap[index] = false;
        });
      });
    }

  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          if (widget.from_checkout) {
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
              backgroundColor: Colors.white,
              appBar: buildAppBar(context),
              body: Stack(
                children: [
                  buildOrderListList(),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: buildLoadingContainer())
                ],
              )),
        ));
  }

  Container buildLoadingContainer() {
    return Container(
      height: _showLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(_totalData == _orderList.length
            ? AppLocalizations.of(context).order_list_screen_no_more_orders
            : AppLocalizations.of(context)
                .order_list_screen_loading_more_orders),
      ),
    );
  }

  buildBottomAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.symmetric(
                    vertical: BorderSide(color: MyTheme.light_grey, width: .5),
                    horizontal:
                        BorderSide(color: MyTheme.light_grey, width: 1))),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            height: 36,
            width: MediaQuery.of(context).size.width * .3,
            child: new DropdownButton<PaymentStatus>(
              icon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(Icons.expand_more, color: Colors.black54),
              ),
              hint: Text(
                AppLocalizations.of(context).order_list_screen_all,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                ),
              ),
              iconSize: 14,
              underline: SizedBox(),
              value: _selectedPaymentStatus,
              items: _dropdownPaymentStatusItems,
              onChanged: (PaymentStatus selectedFilter) {
                setState(() {
                  _selectedPaymentStatus = selectedFilter;
                });
                reset();
                fetchData();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(
              Icons.credit_card,
              color: MyTheme.secondary,
              size: 16,
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(
              Icons.local_shipping_outlined,
              color: MyTheme.secondary,
              size: 16,
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.symmetric(
                    vertical: BorderSide(color: MyTheme.light_grey, width: .5),
                    horizontal:
                        BorderSide(color: MyTheme.light_grey, width: 1))),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            height: 36,
            width: MediaQuery.of(context).size.width * .35,
            child: new DropdownButton<DeliveryStatus>(
              icon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(Icons.expand_more, color: Colors.black54),
              ),
              hint: Text(
                AppLocalizations.of(context).order_list_screen_all,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                ),
              ),
              iconSize: 14,
              underline: SizedBox(),
              value: _selectedDeliveryStatus,
              items: _dropdownDeliveryStatusItems,
              onChanged: (DeliveryStatus selectedFilter) {
                setState(() {
                  _selectedDeliveryStatus = selectedFilter;
                });
                reset();
                fetchData();
              },
            ),
          ),
        ],
      ),
    );
  }

  buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(60.0),

      child: AppBar(
          centerTitle: false,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          elevation: 0.0,
          titleSpacing: 0,
          flexibleSpace: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
            child: Column(
              children: [
                Padding(
                  padding: MediaQuery.of(context).viewPadding.top >
                          30 //MediaQuery.of(context).viewPadding.top is the statusbar height, with a notch phone it results almost 50, without a notch it shows 24.0.For safety we have checked if its greater than thirty
                      ? const EdgeInsets.only(top: 36.0)
                      : const EdgeInsets.only(top: 14.0),
                  child: buildTopAppBarContainer(),
                ),
                //buildBottomAppBar(context)
              ],
            ),
          )),
    );
  }

  Container buildTopAppBarContainer() {
    return Container(
      child: Row(
        children: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
              onPressed: () {
                if (widget.from_checkout) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Main();
                  }));
                } else {
                  return Navigator.of(context).pop();
                }
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> Main()), (route) => false);
              },
            ),
          ),
          Text(
            AppLocalizations.of(context).profile_screen_purchase_history,
            style: TextStyle(fontSize: 16, color: MyTheme.primary),
          ),
        ],
      ),
    );
  }

  buildOrderListList() {
    if (_isInitial && _orderList.length == 0) {
      return SingleChildScrollView(
          child: ListView.builder(
        controller: _scrollController,
        itemCount: 10,
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Shimmer.fromColors(
              baseColor: MyTheme.light_grey,
              highlightColor: MyTheme.light_grey,
              child: Container(
                height: 75,
                width: double.infinity,
                color: Colors.white,
              ),
            ),
          );
        },
      ));
    } else if (_orderList.length > 0) {
      return RefreshIndicator(
        color: MyTheme.primary,
        backgroundColor: Colors.white,
        displacement: 0,
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          //controller: _xcrollController,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: _orderList.length,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return OrderDetails(
                         //id: _orderList[index].id,
                          id: _orderList[index]["id"],
                        );
                      }));
                    },
                    child: buildOrderListItemCard(index),
                  ));
            },
          ),
        ),
      );
    } else if (_totalData == 0) {
      return Center(
          child: Text(AppLocalizations.of(context).common_no_data_available));
    } else {
      return Container(); // should never be happening
    }
  }

  Card buildOrderListItemCard(int index) {
    bool isLoading = _isLoadingMap.containsKey(index) ? _isLoadingMap[index] : false;
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
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Row(
                children: [

                  Text('Order Number : ' + _orderList[index]["id"].toString()?? '',
                      style: TextStyle(color: MyTheme.secondary, fontSize: 13)),
                  Spacer(),
                  Column(
                    children: [
                      Text(
                        '${_orderList[index]["grand_total"].toString()}' ?? '',
                        style: TextStyle(
                            color: MyTheme.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),

                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                Row(
                  children: [
                    Text(
                      "${AppLocalizations.of(context).order_list_screen_payment_status} - ",
                      style: TextStyle(color: MyTheme.secondary, fontSize: 13),
                    ),
                    Text(
                      _orderList[index]["payment_status_string"].toString() ?? '',
                      style: TextStyle(color: MyTheme.secondary, fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: app_language_rtl.$
                          ? const EdgeInsets.only(right: 8.0)
                          : const EdgeInsets.only(left: 8.0),
                      child: buildPaymentStatusCheckContainer(
                          _orderList[index]["payment_status"]
                      ),
                    ),
                  ],
                ),

                  Text(
                    _orderList[index]["date"] ?? '',
                    style: TextStyle(color: MyTheme.secondary, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [


                Row(
                  children: [

                    Text(
                      "${AppLocalizations.of(context).order_list_screen_delivery_status} - ",
                      style: TextStyle(color: MyTheme.secondary, fontSize: 13),
                    ),

                    Text(
                      _orderList[index]["delivery_status_string"] ?? '',
                      style: TextStyle(color: MyTheme.secondary, fontSize: 13),
                    ),
                  ],
                ),

                // Text(
                //   _orderList[index]["date"] ?? '',
                //   style: TextStyle(color: MyTheme.secondary, fontSize: 13, fontWeight: FontWeight.w600),
                // ),

                GestureDetector(
                  onTap: (){
                    reOrder(index, _orderList[index]["id"]);
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.028,
                    width: MediaQuery.of(context).size.height * 0.074,
                    decoration: BoxDecoration(
                      // border: Border.all(
                      //   width: 1,
                      //   color: MyTheme.primary,
                      // ),

                      color: MyTheme.add_to_cart_button
                    ),
                    child: Center(
                      child: isLoading ? CircularProgressIndicator(color: MyTheme.white,): Text("Re-order",
                      //child: Text("Re-order",
                      style: TextStyle(
                          color: MyTheme.white, fontSize: 11, fontWeight: FontWeight.w600
                      ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
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
            payment_status == "paid" || payment_status == "COD" ? FontAwesome.check : FontAwesome.times,
            color: Colors.white,
            size: 10),
      ),
    );
  }
}
