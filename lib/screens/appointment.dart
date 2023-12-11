import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/repositories/appointment_repository.dart';
import 'package:active_ecommerce_flutter/ui_sections/drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Appointment extends StatefulWidget {
  @override
  _AppointmentState createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController whatsappNumberController = TextEditingController();
  TextEditingController problemController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String paymentMethod = 'bkash';

  onTapSubmit(context) async {
    String age = ageController.text.toString();
    String name = fullNameController.text.toString();
    String contactNumber = contactNumberController.text.toString();
    String whatsappNumber = contactNumberController.text.toString();
    String problem = problemController.text.toString();
    String paymentType = paymentMethod;

    var reviewSubmitResponse = await AppointmentRepository().submitAppointment(
        age: age,
        contactNumber: contactNumber,
        name: name,
        paymentType: paymentType,
        problem: problem,
        whatsappNumber: whatsappNumber);

    // if (reviewSubmitResponse.result == false) {
    //   ToastComponent.showDialog(reviewSubmitResponse.message, context,
    //       gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    //   return;
    // }

    // ToastComponent.showDialog(reviewSubmitResponse.message, context,
    //     gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);

    reset();
  }

  void reset() {
    fullNameController.clear();
    ageController.clear();
    contactNumberController.clear();
    whatsappNumberController.clear();
    problemController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: MainDrawer(),
        appBar: buildAppBar(context),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  buildStarTextFormField(
                    controller: fullNameController,
                    label: 'Full Name',
                  ),
                  buildStarTextFormField(
                    controller: ageController,
                    label: 'Age',
                  ),
                  buildStarTextFormField(
                    controller: contactNumberController,
                    label: 'Contact Number',
                  ),
                  buildStarTextFormField(
                    controller: whatsappNumberController,
                    label: 'WhatsApp Number',
                  ),
                  buildStarTextFormField(
                    controller: problemController,
                    label: 'Problem',
                    isTextArea: true,
                    placeholder: 'Describe your problem here...',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Appointment Fee: 499 BDT',
                    style: TextStyle(color: Colors.red),
                  ),
                  RadioListTile(
                    title: Text('Bkash'),
                    value: 'bkash',
                    groupValue: paymentMethod,
                    activeColor: Colors.black,
                    // Set the active color
                    onChanged: null,
                    selected: true,
                    controlAffinity: ListTileControlAffinity
                        .leading, // Align the icon to the left
                    contentPadding: EdgeInsets.zero, // Remove any padding
                    secondary: Icon(
                      Icons
                          .payment, // Add the payment icon or any other icon you prefer
                      color: Colors.black,
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          onTapSubmit(context);
                        },
                        child: Container(
                          height: 40,
                          margin: EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 2.0),
                          decoration: BoxDecoration(
                            color: MyTheme.dark_grey,
                            borderRadius: BorderRadius.circular(2),
                            border: Border.all(
                                color: Color.fromRGBO(112, 112, 112, .3),
                                width: 1),
                            //shape: BoxShape.rectangle,
                          ),
                          child: Center(
                            child: Text("MAKE PAYMENT"),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: GestureDetector(
        onTap: () {
          _scaffoldKey.currentState.openDrawer();
        },
        child: Builder(
          builder: (context) => Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 18.0, horizontal: 0.0),
            child: Container(
              child: Image.asset(
                'assets/hamburger.png',
                height: 16,
                color: MyTheme.dark_grey,
              ),
            ),
          ),
        ),
      ),
      title: Text(
        getAppBarTitle(),
        style: GoogleFonts.ubuntu(fontSize: 18, color: Colors.blueGrey),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  String getAppBarTitle() {
    String name = "Appointment";

    return name;
  }

  // void printFormValues() {
  //   print('Full Name: ${fullNameController.text}');
  //   print('Age: ${ageController.text}');
  //   print('Contact Number: ${contactNumberController.text}');
  //   print('WhatsApp Number: ${whatsappNumberController.text}');
  //   print('Problem: ${problemController.text}');
  //   print('Payment Method: $paymentMethod');
  // }

  Widget buildStarTextFormField({
    TextEditingController controller,
    String label,
    bool isTextArea = false,
    String placeholder,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: '$label *',
        hintText: placeholder,
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter your $label';
        }
        return null;
      },
      maxLines: isTextArea ? 4 : 1,
    );
  }
}
