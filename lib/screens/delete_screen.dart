import 'package:flutter/material.dart';
import 'package:kirei/custom/toast_component.dart';
import 'package:kirei/data_model/extra/deactive_account_model.dart';
import 'package:kirei/helpers/auth_helper.dart';
import 'package:kirei/my_theme.dart';
import 'package:kirei/repositories/extra_repository.dart';
import 'package:kirei/screens/main.dart';
import 'package:toast/toast.dart';

class DeleteScreen extends StatefulWidget {
  const DeleteScreen({Key key}) : super(key: key);

  @override
  State<DeleteScreen> createState() => _DeleteScreenState();
}

class _DeleteScreenState extends State<DeleteScreen> {
  bool isChecked = false;
  bool isLoading = false;
  DeactivationResponse deActiveResponse = DeactivationResponse();

  Future<void> deActiveAccount() async {
    setState(() {
      isLoading = true;
    });
    try {
      deActiveResponse = await ExtraRepository().deActiveUserAccount();
      setState(() {
        isLoading = false;
      });
      buildFinalStatusMessage(
          status: deActiveResponse.result ? 'User has deactivated.' : 'Failed to deactivate account.');
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ToastComponent.showDialog('Error: $error', context, gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    }
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: MyTheme.primary,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: MyTheme.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        'Account Deletion and Data Retention',
        style: TextStyle(fontSize: 16, color: MyTheme.white),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  Widget buildWidgetForTextContent({String title, String subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 5),
        Text(
          subtitle ?? '',
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  void buildFinalStatusMessage({String status}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding: EdgeInsets.only(top: 16.0, left: 2.0, right: 2.0, bottom: 2.0),
        title: Text(
          status,
          maxLines: 3,
          style: TextStyle(color: MyTheme.secondary, fontSize: 14),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const BeveledRectangleBorder(),
              primary: Colors.green,
            ),
            child:Text(
              'Ok',
              style: TextStyle(color: MyTheme.white),
            ),
            onPressed: () {
              AuthHelper().clearUserData();
              Navigator.of(context, rootNavigator: true).pop();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => Main()),
                    (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  ElevatedButton largeFlatFilledButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (isChecked) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              contentPadding: EdgeInsets.only(top: 16.0, left: 2.0, right: 2.0, bottom: 2.0),
              content: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(
                  'Are you sure you want to delete your account?',
                  maxLines: 3,
                  style: TextStyle(color: MyTheme.secondary, fontSize: 14),
                ),
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const BeveledRectangleBorder(),
                    primary: Colors.green,
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: MyTheme.white),
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const BeveledRectangleBorder(),
                    primary: MyTheme.primary,
                  ),
                  child: Text(
                    'Delete',
                    style: TextStyle(color: MyTheme.white),
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    setState(() {
                      isLoading = true;
                    });
                    deActiveAccount().then((value) => {
                      setState(() {
                        isLoading = false;
                      }),
                      buildFinalStatusMessage(status: deActiveResponse.result==true? 'Account Deleted' : 'Deletion Failed'),
                    });
                  },
                ),
              ],
            ),
          );
        } else {
          ToastComponent.showDialog('You must agree to the terms to delete', context, gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        }
      },
      style: ElevatedButton.styleFrom(
        shape: const BeveledRectangleBorder(),
        primary: isChecked ? MyTheme.primary : MyTheme.dark_grey,
      ),
      child: Text('DELETE ACCOUNT'),
    );
  }

  Widget accountDeletionTermsCondition(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView(
      children: [
        buildWidgetForTextContent(
            title: '1. Account Deletion',
            subtitle: 'You have the right to delete your account at any time. Upon deletion, your account and associated data will be deactivated and inaccessible to you.'),
        buildWidgetForTextContent(
            title: '2. Data Retention',
            subtitle: 'For security and legal purposes, we may retain your data for a period of 15 days following your account deletion request. This retention period allows us to address any potential issues or requests you may have before permanent deletion.'),
        buildWidgetForTextContent(
            title: '3. Data Deletion',
            subtitle: 'After the 15-day retention period, your data will be securely and permanently deleted. This includes any content, messages, preferences, and other information associated with your account.'),
        buildWidgetForTextContent(
            title: '4. Data Recovery',
            subtitle: 'Please note that once your account and data are deleted, you will not be able to recover them. There is no option to restore your account or data after deletion.'),
        buildWidgetForTextContent(
            title: '5. Anonymized or Aggregated Data',
            subtitle: 'We may retain anonymized or aggregated data that does not directly identify you for our analytics or legal compliance purposes. This data will not be used to track or profile individual users'),
        buildWidgetForTextContent(
            title: '6. Changes to this Policy',
            subtitle: 'We reserve the right to modify this policy at any time. We will notify you of any changes by posting the revised policy on our app or website. Your continued use of the app after the revised policy is posted constitutes your acceptance of the changes.'),
        buildWidgetForTextContent(
            title: '7. Contact Us',
            subtitle: 'If you have any questions regarding account deletion or data retention, please contact us at 09666-791110 (10 AM- 10 PM)'),
        Row(
          children: [
            Checkbox(
                value: isChecked,
                onChanged: (value) {
                  setState(() {
                    isChecked = value;
                  });
                }),
            SizedBox(
                width: 300,
                child: Text(
                  'By using our app, you agree to these terms and conditions regarding account deletion and data retention.',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ))
          ],
        ),
        largeFlatFilledButton(context)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: accountDeletionTermsCondition(context),
      ),
    );
  }
}
