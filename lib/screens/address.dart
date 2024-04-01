import 'package:flutter/material.dart';
import 'package:kirei/my_theme.dart';
import 'package:kirei/helpers/shared_value_helper.dart';
import 'package:kirei/repositories/address_repository.dart';
import 'package:kirei/helpers/shimmer_helper.dart';
import 'package:kirei/data_model/city_response.dart';
import 'package:kirei/data_model/state_response.dart';
import 'package:kirei/data_model/country_response.dart';
import 'package:kirei/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class Address extends StatefulWidget {
  Address({Key key, this.from_shipping_info = false}) : super(key: key);
  bool from_shipping_info;


  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  ScrollController _mainScrollController = ScrollController();

  int _default_shipping_address = 0;
  City _selected_city;
  Country _selected_country;
  MyState _selected_state;

  bool _isInitial = true;
  List<dynamic> _shippingAddressList = [];



  //controllers for add purpose
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _postalCodeController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _countryController = TextEditingController();

  //for update purpose
  List<TextEditingController> _addressControllerListForUpdate = [];
  List<TextEditingController> _postalCodeControllerListForUpdate = [];
  List<TextEditingController> _phoneControllerListForUpdate = [];
  List<TextEditingController> _cityControllerListForUpdate = [];
  List<TextEditingController> _stateControllerListForUpdate = [];
  List<TextEditingController> _countryControllerListForUpdate = [];
  List<City> _selected_city_list_for_update = [];
  List<MyState> _selected_state_list_for_update = [];
  List<Country> _selected_country_list_for_update = [];
  int _selectedCity_id;
  int _selectedZone_id;
  int _selectedArea_id;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (is_logged_in.$ == true) {
      fetchAll();
    }
  }

  fetchAll() {
    fetchShippingAddressList();

    setState(() {});
  }

  fetchShippingAddressList() async {
    var addressResponse = await AddressRepository().getAddressList();
    print(addressResponse);
    _shippingAddressList.addAll(addressResponse['data']);
    print(_shippingAddressList);
    setState(() {
      _isInitial = false;
    });
    if (_shippingAddressList.length > 0) {


      var count = 0;

      if (_shippingAddressList != null) {
        _phoneController.text = _shippingAddressList[0]['phone'];
        _nameController.text = _shippingAddressList[0]['name'];
        _addressController.text = _shippingAddressList[0]['address'];
        _stateController.text = _shippingAddressList[0]['city_name'];
        _cityController.text = _shippingAddressList[0]['zone_name'];
        _countryController.text = _shippingAddressList[0]['area_name'];
        _selectedCity_id = _shippingAddressList[0]['city_id'];
        _selectedZone_id = _shippingAddressList[0]['zone_id'];
        _selectedArea_id = _shippingAddressList[0]['area_id'];


      } else {
        _phoneController.text = user_name.$ ;
      }

    }

    if (mounted) {
      setState(() {});
    }
  }

  reset() {
    _default_shipping_address = 0;
    _shippingAddressList.clear();
    _isInitial = true;

    _addressController.clear();
    _postalCodeController.clear();
    _phoneController.clear();

    _countryController.clear();
    _stateController.clear();
    _cityController.clear();

    //update-ables
    _addressControllerListForUpdate.clear();
    _postalCodeControllerListForUpdate.clear();
    _phoneControllerListForUpdate.clear();
    _countryControllerListForUpdate.clear();
    _stateControllerListForUpdate.clear();
    _cityControllerListForUpdate.clear();
    _selected_city_list_for_update.clear();
    _selected_state_list_for_update.clear();
    _selected_country_list_for_update.clear();
    setState(() {});
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

  afterDeletingAnAddress() {
    reset();
    fetchAll();
  }

  afterUpdatingAnAddress() {
    reset();
    fetchAll();
  }

  onAddressSwitch(index) async {
    var addressMakeDefaultResponse = await AddressRepository()
        .getAddressMakeDefaultResponse(_default_shipping_address);

    if (addressMakeDefaultResponse.result == false) {
      ToastComponent.showDialog(addressMakeDefaultResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    ToastComponent.showDialog(addressMakeDefaultResponse.message, context,
        gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);

    setState(() {
      _default_shipping_address = _shippingAddressList[index]['id'];
    });
  }

  onPressDelete(id) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: EdgeInsets.only(
                  top: 16.0, left: 2.0, right: 2.0, bottom: 2.0),
              content: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(
                  AppLocalizations.of(context)
                      .address_screen_address_remove_warning,
                  maxLines: 3,
                  style: TextStyle(color: MyTheme.secondary, fontSize: 14),
                ),
              ),
              actions: [
                FlatButton(
                  child: Text(
                    AppLocalizations.of(context).common_cancel_ucfirst,
                    style: TextStyle(color: MyTheme.dark_grey),
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
                FlatButton(
                  color: MyTheme.primary,
                  child: Text(
                    AppLocalizations.of(context).common_confirm_ucfirst,
                    style: TextStyle(color: MyTheme.white),
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    confirmDelete(id);
                  },
                ),
              ],
            ));
  }

  confirmDelete(id) async {
    var addressDeleteResponse =
        await AddressRepository().getAddressDeleteResponse(id);

    if (addressDeleteResponse.result == false) {
      ToastComponent.showDialog(addressDeleteResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    ToastComponent.showDialog(addressDeleteResponse.message, context,
        gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);

    afterDeletingAnAddress();
  }

  onAddressAdd(context) async {
    var address = _addressController.text.toString();
    var postal_code = _postalCodeController.text.toString();
    var phone = _phoneController.text.toString();
    var city = _stateController.text.toString();
    var area = _countryController.text.toString();
    var zone = _cityController.text.toString();


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
        phone: phone);

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

  onAddressUpdate(context, index, id) async {
    var address = _addressControllerListForUpdate[index].text.toString();
    var postal_code = _postalCodeControllerListForUpdate[index].text.toString();
    var phone = _phoneControllerListForUpdate[index].text.toString();

    if (address == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context).address_screen_address_warning, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    if (_selected_state_list_for_update[index] == null) {
      ToastComponent.showDialog(
          AppLocalizations.of(context).address_screen_country_warning, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    if (_selected_country_list_for_update[index] == null) {
      ToastComponent.showDialog(
          AppLocalizations.of(context).address_screen_state_warning, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    if (_selected_city_list_for_update[index] == null) {
      ToastComponent.showDialog(
          AppLocalizations.of(context).address_screen_city_warning, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    var addressUpdateResponse = await AddressRepository()
        .getAddressUpdateResponse(
            id: id,
            address: address,
            country_id: _selected_country_list_for_update[index].id,
            state_id: _selected_state_list_for_update[index].id,
            city_id: _selected_city_list_for_update[index].id,
            postal_code: postal_code,
            phone: phone);

    if (addressUpdateResponse.result == false) {
      ToastComponent.showDialog(addressUpdateResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    ToastComponent.showDialog(addressUpdateResponse.message, context,
        gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);

    Navigator.of(context, rootNavigator: true).pop();
    afterUpdatingAnAddress();
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

  @override
  void dispose() {
    super.dispose();
    _mainScrollController.dispose();
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
          Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: InkWell(
              onTap: (){
                saveOrUpdateAddress();
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.05,
                width: double.infinity,
                color: MyTheme.secondary,
                child: Center(child: Text("SAVE" ,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: MyTheme.white
                ),
                )),
              ),
            ),
          ),

          SizedBox(
            height: 150,
          ),
        ],
      );
    });
  }

  var loading = false;

  saveOrUpdateAddress() async{

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

    var addressUpdateResponse = await AddressRepository()
        .getAddressUpdateAddResponse(
      name: _nameController.text,
      phone: _phoneController.text,
      email: _emailController.text,
      address: _addressController.text,
      city: _selectedCity_id,
      zone: _selectedZone_id,
      area: _selectedArea_id,
    );

    if (addressUpdateResponse.result == false) {
      ToastComponent.showDialog(addressUpdateResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    ToastComponent.showDialog(addressUpdateResponse.message, context,
        gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);


    afterUpdatingAnAddress();



  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(context),
        bottomNavigationBar: buildBottomAppBar(context),
        body: RefreshIndicator(
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
                  //child: buildAddressList(),
                  child: buildShowAddFormDialog(context),
                ),

                SizedBox(
                  height: 100,
                )
              ]))
            ],
          ),
        ));
  }

  Future buildShowUpdateFormDialog(BuildContext context, index) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setModalState /*You can rename this!*/) {
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
                        child: Text(
                            AppLocalizations.of(context).address_screen_phone,
                            style: TextStyle(
                                color: MyTheme.secondary, fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Container(
                          height: 40,
                          child: TextField(
                            controller: _phoneControllerListForUpdate[index],
                            autofocus: false,
                            decoration: InputDecoration(
                                hintText: user_phone.$ != null
                                    ? user_phone.$
                                    : AppLocalizations.of(context)
                                    .address_screen_enter_phone,
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
                                contentPadding:
                                EdgeInsets.symmetric(horizontal: 8.0)),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                            "${AppLocalizations.of(context).address_screen_address} *",
                            style: TextStyle(
                                color: MyTheme.secondary, fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          height: 55,
                          child: TextField(
                            controller: _addressControllerListForUpdate[index],
                            autofocus: false,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)
                                    .address_screen_enter_address,
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
                            suggestionsCallback: (name) async {
                              var stateResponse = await AddressRepository()
                                  .getCityByCountry(
                                country_id: "3069",
                              );
                              return stateResponse.states;
                            },
                            loadingBuilder: (context) {
                              return Container(
                                height: 50,
                                child: Center(
                                    child: Text(
                                        AppLocalizations.of(context)
                                            .address_screen_loading_states,
                                        style: TextStyle(
                                            color: MyTheme.dark_grey))),
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
                                        AppLocalizations.of(context)
                                            .address_screen_no_state_available,
                                        style: TextStyle(
                                            color: MyTheme.dark_grey))),
                              );
                            },
                            onSuggestionSelected: (state) {
                              onSelectStateDuringUpdate(
                                  index, state, setModalState);
                            },
                            textFieldConfiguration: TextFieldConfiguration(
                              onTap: () {},
                              controller: _stateControllerListForUpdate[index],
                              onSubmitted: (txt) {
                              },
                              decoration: InputDecoration(
                                  hintText: AppLocalizations.of(context)
                                      .address_screen_enter_state,
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
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text("Zone *",
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
                                      state_id:
                                          _selected_state_list_for_update[index]
                                              .id,
                                      name: name);
                              return cityResponse.cities;
                            },
                            loadingBuilder: (context) {
                              return Container(
                                height: 50,
                                child: Center(
                                    child: Text(
                                        AppLocalizations.of(context)
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
                                        AppLocalizations.of(context)
                                            .address_screen_no_city_available,
                                        style: TextStyle(
                                            color: MyTheme.dark_grey))),
                              );
                            },
                            onSuggestionSelected: (city) {
                              onSelectCityDuringUpdate(
                                  index, city, setModalState);
                            },
                            textFieldConfiguration: TextFieldConfiguration(
                              onTap: () {},
                              controller: _cityControllerListForUpdate[index],
                              onSubmitted: (txt) {
                              },
                              decoration: InputDecoration(
                                  hintText: AppLocalizations.of(context)
                                      .address_screen_enter_zone,
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
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text("Area *",
                            style: TextStyle(
                                color: MyTheme.secondary, fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          height: 40,
                          child: TypeAheadField(
                            suggestionsCallback: (name) async {
                            },
                            loadingBuilder: (context) {
                              return Container(
                                height: 50,
                                child: Center(
                                    child: Text(
                                        AppLocalizations.of(context)
                                            .address_screen_loading_countries,
                                        style: TextStyle(
                                            color: MyTheme.dark_grey))),
                              );
                            },
                            itemBuilder: (context, country) {
                              return ListTile(
                                dense: true,
                                title: Text(
                                  country.name,
                                  style: TextStyle(color: MyTheme.secondary),
                                ),
                              );
                            },
                            noItemsFoundBuilder: (context) {
                              return Container(
                                height: 50,
                                child: Center(
                                    child: Text(
                                        AppLocalizations.of(context)
                                            .address_screen_no_country_available,
                                        style: TextStyle(
                                            color: MyTheme.dark_grey))),
                              );
                            },
                            onSuggestionSelected: (country) {
                              onSelectCountryDuringUpdate(
                                  index, country, setModalState);
                            },
                            textFieldConfiguration: TextFieldConfiguration(
                              onTap: () {},
                              controller:
                                  _countryControllerListForUpdate[index],
                              onSubmitted: (txt) {
                                // keep this blank
                              },
                              decoration: InputDecoration(
                                  hintText: AppLocalizations.of(context)
                                      .address_screen_enter_country,
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
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                            AppLocalizations.of(context)
                                .address_screen_postal_code,
                            style: TextStyle(
                                color: MyTheme.secondary, fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          height: 40,
                          child: TextField(
                            controller:
                                _postalCodeControllerListForUpdate[index],
                            autofocus: false,
                            decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)
                                    .address_screen_enter_postal_code,
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
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 8.0)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                            AppLocalizations.of(context).address_screen_phone,
                            style: TextStyle(
                                color: MyTheme.secondary, fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Container(
                          height: 40,
                          child: TextField(
                            controller: _phoneControllerListForUpdate[index],
                            autofocus: false,
                            decoration: InputDecoration(
                                hintText: user_phone.$ != null
                                    ? user_phone.$
                                    : AppLocalizations.of(context)
                                        .address_screen_enter_phone,
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
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 8.0)),
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
                          AppLocalizations.of(context)
                              .common_update_in_all_capital,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        onPressed: () {
                          onAddressUpdate(
                              context, index, _shippingAddressList[index]['id']);
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
      title: Column(
        children: [
          Text(
            AppLocalizations.of(context).address_screen_addresses_of_user,
            style: TextStyle(fontSize: 16, color: MyTheme.primary),
          ),
          Text(
            "* ${AppLocalizations.of(context).address_screen_addresses_to_make_default}",
            style: TextStyle(fontSize: 10, color: MyTheme.dark_grey),
          ),
        ],
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildAddressList() {
    if (is_logged_in == false) {
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
              child: buildAddressItemCard(index),
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

  GestureDetector buildAddressItemCard(index) {
    return GestureDetector(
      onDoubleTap: () {
        if (_default_shipping_address != _shippingAddressList[index]['id']) {
          onAddressSwitch(index);
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: _default_shipping_address == _shippingAddressList[index]['id']
              ? BorderSide(color: MyTheme.primary, width: 2.0)
              : BorderSide(color: MyTheme.light_grey, width: 1.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
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
                        onPressDelete(_shippingAddressList[index]['id']);
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
                        onPressDelete(_shippingAddressList[index]['id']);
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

  buildBottomAppBar(BuildContext context) {
    return Visibility(
      visible: widget.from_shipping_info,
      child: BottomAppBar(
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
                      .address_screen_back_to_shipping_info,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  return Navigator.of(context).pop();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
