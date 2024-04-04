import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:kirei/notification_details.dart';
import 'package:kirei/screens/order_details.dart';
import 'package:kirei/screens/login.dart';
import 'package:kirei/helpers/shared_value_helper.dart';
import 'package:kirei/repositories/profile_repository.dart';
import 'package:one_context/one_context.dart';
import 'package:kirei/custom/toast_component.dart';
import 'package:toast/toast.dart';

final FirebaseMessaging _fcm = FirebaseMessaging.instance;

// class PushNotificationService {
//   Future initialise() async {
//     await _fcm.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );
//     String fcmToken = await _fcm.getToken();
//
//     if (fcmToken != null) {
//       print("--fcm token--");
//       print(fcmToken);
//       if (is_logged_in.$ == true) {
//         // update device token
//         var deviceTokenUpdateResponse =
//             await ProfileRepository().getDeviceTokenUpdateResponse(fcmToken);
//       }
//     }
//     FirebaseMessaging.instance.getInitialMessage().then(_showMessage);
//
//     FirebaseMessaging.onMessage.listen((event) {
//       //print("onLaunch: " + event.toString());
//       _showMessage(event);
//       //(Map<String, dynamic> message) async => _showMessage(message);
//     });
//
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print("onResume: $message");
//       (Map<String, dynamic> message) async => _serialiseAndNavigate(message);
//     });
//
//   }
//
//   void _showMessage(RemoteMessage message) {
//     //print("onMessage: $message");
//
//     OneContext().showDialog(
//       // barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         content: ListTile(
//           title: Text(message.notification.title),
//           subtitle: Text(message.notification.body),
//         ),
//         actions: <Widget>[
//           FlatButton(
//             child: Text('close'),
//             onPressed: () => Navigator.of(context).pop(),
//           ),
//           FlatButton(
//             child: Text('GO'),
//             onPressed: () {
//               if (is_logged_in.$ == false) {
//                 ToastComponent.showDialog("You are not logged in", context,
//                     gravity: Toast.TOP, duration: Toast.LENGTH_LONG);
//                 return;
//               }
//               // print(message);
//               // Navigator.of(context).pop();
//               // if (message.data['item_type'] == 'order') {
//               //   OneContext().push(MaterialPageRoute(builder: (_) {
//               //     return OrderDetails(
//               //         id: int.parse(message.data['item_type_id']),
//               //         from_notification: true);
//               //   }));
//               // }
//
//               Navigator.of(context).pushAndRemoveUntil(
//                   MaterialPageRoute(builder: (context)=>
//                       NotificationDetails(
//                           message.notification.title,
//                           message.notification.body,
//                       )
//                   ), (route) => false);
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _serialiseAndNavigate(Map<String, dynamic> message) {
//     print(message.toString());
//     if (is_logged_in.$ == false) {
//       OneContext().showDialog(
//         // barrierDismissible: false,
//           builder: (context) => AlertDialog(
//             title: new Text("You are not logged in"),
//             content: new Text("Please log in"),
//             actions: <Widget>[
//               FlatButton(
//                 child: Text('close'),
//                 onPressed: () => Navigator.of(context).pop(),
//               ),
//               FlatButton(
//                   child: Text('Login'),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                     OneContext().push(MaterialPageRoute(builder: (_) {
//                       return Login();
//                     }));
//                   }),
//             ],
//           ));
//       return;
//     }
//     // if (message['data']['item_type'] == 'order') {
//     //   OneContext().push(MaterialPageRoute(builder: (_) {
//     //     return OrderDetails(
//     //         id: int.parse(message['data']['item_type_id']),
//     //         from_notification: true);
//     //   }));
//     // } // If there's no view it'll just open the app on the first view    }
//
//     OneContext().showDialog(
//       // barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         content: ListTile(
//           //title: Text(message.notification.title),
//           title: Text(message["notification"]["title"]),
//           //subtitle: Text(message.notification.body),
//           subtitle: Text(message["notification"]["body"]),
//         ),
//         actions: <Widget>[
//           FlatButton(
//             child: Text('close'),
//             onPressed: () => Navigator.of(context).pop(),
//           ),
//           FlatButton(
//             child: Text('GO'),
//             onPressed: () {
//               if (is_logged_in.$ == false) {
//                 ToastComponent.showDialog("You are not logged in", context,
//                     gravity: Toast.TOP, duration: Toast.LENGTH_LONG);
//                 return;
//               }
//               //print(message);
//               //Navigator.of(context).pop();
//               // if (message.data['item_type'] == 'order') {
//               //   OneContext().push(MaterialPageRoute(builder: (_) {
//               //     return OrderDetails(
//               //         id: int.parse(message.data['item_type_id']),
//               //         from_notification: true);
//               //   }));
//               // }
//
//               Navigator.of(context).pushAndRemoveUntil(
//                   MaterialPageRoute(builder: (context)=>
//                       NotificationDetails(
//                         //message.notification.title,
//                         //message.notification.body,
//                         message["notification"]["title"],
//                         message["notification"]["body"],
//                       )
//                   ), (route) => false);
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
// }


class PushNotificationService {
  Future initialise() async {

    await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );


    String fcmToken = await _fcm.getToken();

    if (fcmToken != null) {
      print("--fcm token--");
      print(fcmToken);
      if (is_logged_in.$ == true) {
        // Update device token
        var deviceTokenUpdateResponse =
        await ProfileRepository().getDeviceTokenUpdateResponse(fcmToken);
      }
    }


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showMessage(message);
    });


    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _serialiseAndNavigate(message);
    });


    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

  }

  // Handle background messages
  Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
    _serialiseAndNavigate(message);
  }

  // Show message in UI
  void _showMessage(RemoteMessage message) {
    OneContext().showDialog(
      builder: (context) => AlertDialog(
        content: ListTile(
          title: Text(message.notification.title),
          subtitle: Text(message.notification.body),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          FlatButton(
            child: Text('Go'),
            onPressed: () {
              if (is_logged_in.$ == false) {
                ToastComponent.showDialog("You are not logged in", context,
                    gravity: Toast.TOP, duration: Toast.LENGTH_LONG);
                return;
              }

              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => NotificationDetails(
                    message.notification.title,
                    message.notification.body,
                  )),
                      (route) => false);
            },
          ),
        ],
      ),
    );
  }

  // Navigate to appropriate screen
  void _serialiseAndNavigate(RemoteMessage message) {
    if (is_logged_in.$ == false) {
      OneContext().showDialog(
        builder: (context) => AlertDialog(
          title: Text("You are not logged in"),
          content: Text("Please log in"),
          actions: <Widget>[
            FlatButton(
              child: Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FlatButton(
              child: Text('Login'),
              onPressed: () {
                Navigator.of(context).pop();
                OneContext().push(MaterialPageRoute(builder: (_) {
                  return Login();
                }));
              },
            ),
          ],
        ),
      );
      return;
    }

    OneContext().showDialog(
      builder: (context) => AlertDialog(
        content: ListTile(
          title: Text(message.notification.title),
          subtitle: Text(message.notification.body),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          FlatButton(
            child: Text('Go'),
            onPressed: () {
              if (is_logged_in.$ == false) {
                ToastComponent.showDialog("You are not logged in", context,
                    gravity: Toast.TOP, duration: Toast.LENGTH_LONG);
                return;
              }

              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => NotificationDetails(
                    message.notification.title,
                    message.notification.body,
                  )),
                      (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
