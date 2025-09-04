import 'package:etouristagency_mobile/consts/app_colors.dart';
import 'package:etouristagency_mobile/consts/screen_names.dart';
import 'package:etouristagency_mobile/providers/user_firebase_token_provider.dart';
import 'package:etouristagency_mobile/screens/login_screen.dart';
import 'package:etouristagency_mobile/screens/offer/offer_details_screen.dart';
import 'package:etouristagency_mobile/screens/reservation/add_update_reservation_screen.dart';
import 'package:etouristagency_mobile/services/auth_service.dart';
import 'package:etouristagency_mobile/services/firebase_token_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

RemoteMessage? remoteMessage;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
bool isFirebaseInitialized = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();
  if (message != null) {
    remoteMessage = message;
  }

  await initializeFirebase();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(
        448,
        998,
      ),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        navigatorKey: navigatorKey,
        title: 'eTouristAgency',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        ),
        home: LoginScreen(),
      ),
    );
  }
}

Future initializeFirebase() async {
  var authService = AuthService();

  if (!(await authService.areCredentialsValid())) {
    return;
  }

  var firebaseTokenService = FirebaseTokenService();

  String? token = await FirebaseMessaging.instance.getToken();

  if (token == null) {
    await firebaseTokenService.removeToken();
    return;
  }

  var userFirebaseProvider = UserFirebaseTokenProvider();
  String? oldToken = await firebaseTokenService.getToken();

  if (oldToken != null) {
    await userFirebaseProvider.update({
      "oldFirebaseToken": oldToken,
      "newFirebaseToken": token,
    });
  } else {
    await userFirebaseProvider.add({"firebaseToken": token});
  }

  await firebaseTokenService.storeToken(token);

  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
    var authServ = AuthService();
    if (!(await authServ.areCredentialsValid())) {
      return;
    }

    var firebaseTokenServ = FirebaseTokenService();
    var userFirebaseProv = UserFirebaseTokenProvider();
    String? oldToken = await firebaseTokenServ.getToken();

    if (oldToken != null) {
      await userFirebaseProv.update({
        "newFirebaseToken": newToken,
        "oldFirebaseToken": oldToken,
      });
    } else {
      await userFirebaseProvider.add({"firebaseToken": token});
    }

    await firebaseTokenServ.storeToken(newToken);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    navigateOnNotification(message);
  });

  isFirebaseInitialized = true;
}

void navigateOnNotification(message) {
  final data = message.data;
  final screenName = data['ScreenName'];
  final offerId = data['OfferId'];
  final roomId = data['RoomId'];
  final reservationId = data['ReservationId'];

  if (screenName == ScreenNames.offerDetailsScreen) {
    navigatorKey.currentState?.pushReplacement(
      MaterialPageRoute(
        builder: (context) =>
            OfferDetailsScreen(ScreenNames.offerListScreen, offerId),
      ),
    );
  }

  if (screenName == ScreenNames.addUpdateReservationScreen) {
    navigatorKey.currentState?.pushReplacement(
      MaterialPageRoute(
        builder: (context) =>
            AddUpdateReservationScreen(offerId, roomId, reservationId),
      ),
    );
  }
}