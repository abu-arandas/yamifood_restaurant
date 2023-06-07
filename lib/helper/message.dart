// ignore_for_file: depend_on_referenced_packages

import '/exports.dart';
import 'package:http/http.dart' as http;

class MessageServices extends GetxController {
  static MessageServices instance = Get.find();

  @override
  void onInit() {
    super.onInit();

    permission();
  }

  /* ====== Permission ====== */
  permission() async {
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    while (settings.authorizationStatus != AuthorizationStatus.authorized) {
      settings;
    }

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    DarwinInitializationSettings iosInitializationSettings = const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await FlutterLocalNotificationsPlugin().initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(),
        htmlFormatContentTitle: true,
      );

      AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        'mychanel',
        'mychanel',
        styleInformation: bigTextStyleInformation,
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
      );

      NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: const DarwinNotificationDetails(),
      );

      await FlutterLocalNotificationsPlugin()
          .show(0, message.notification!.title, message.notification!.body, notificationDetails);
    });

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      token();
    }
  }

  /* ====== Send ====== */
  Future<void> sendMessage(
      {required String token, required String title, required String body}) async {
    try {
      http.Response response = await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':
                'key=AAAAUKPDG4w:APA91bEqJoQmbmgpkYaXxYSU18UDoeLrnqXHnUicTdALuc62mVvlxZ5uGCcOdQ6IU_kaJFEO8c4-d3KRduuD8ZCANbHoEa1jWFvesAcp6PfO9k1hf9wn2Cm7dA8qiSZQe8j3BZ6GTH9R'
          },
          body: jsonEncode(<String, dynamic>{
            'to': token,
            'notification': <String, dynamic>{'title': title, 'body': body},
            'priority': 'high',
            'data': {
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done',
              'message': title,
            }
          }));

      if (response.statusCode == 200) {
      } else {
        errorSnackBar('Somethig is Wrong');
      }
    } catch (error) {
      errorSnackBar('Somethig is Wrong');
    }
  }

  /* ====== Token ====== */
  token() {
    auth.authStateChanges().listen((event) async {
      if (event != null) {
        await usersCollection.doc(event.email).update({
          'token': await FirebaseMessaging.instance.getToken(),
        });
      }
    });
  }
}
