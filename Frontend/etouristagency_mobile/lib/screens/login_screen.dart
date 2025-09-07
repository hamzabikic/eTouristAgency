import 'package:etouristagency_mobile/consts/app_colors.dart';
import 'package:etouristagency_mobile/consts/roles.dart';
import 'package:etouristagency_mobile/helpers/auth_navigation_helper.dart';
import 'package:etouristagency_mobile/helpers/dialog_helper.dart';
import 'package:etouristagency_mobile/main.dart';
import 'package:etouristagency_mobile/models/user/user.dart';
import 'package:etouristagency_mobile/providers/user_firebase_token_provider.dart';
import 'package:etouristagency_mobile/providers/user_provider.dart';
import 'package:etouristagency_mobile/screens/forgot_password_screen.dart';
import 'package:etouristagency_mobile/screens/offer/offer_list_screen.dart';
import 'package:etouristagency_mobile/screens/registration_screen.dart';
import 'package:etouristagency_mobile/services/auth_service.dart';
import 'package:etouristagency_mobile/services/firebase_token_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class LoginScreen extends StatefulWidget {
  final bool isLoggedOut;
  const LoginScreen({this.isLoggedOut = false, super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? operationErrorMessage;
  final formBuilderKey = GlobalKey<FormBuilderState>();
  late final AuthService authService;
  late final UserProvider userProvider;
  late final FirebaseTokenService firebaseTokenService;
  late final UserFirebaseTokenProvider userFirebaseTokenProvider;
  bool _isLoggedIn = true;

  @override
  void initState() {
    userProvider = UserProvider();
    authService = AuthService();
    firebaseTokenService = FirebaseTokenService();
    userFirebaseTokenProvider = UserFirebaseTokenProvider();
    checkIsUserLoged();
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDisplayMessage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoggedIn
        ? DialogHelper.openSpinner(context, "")
        : Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 300.h,
                    color: AppColors.primary,
                    child: Center(
                      child: Image.asset("lib/assets/images/logo.png"),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusGeometry.all(
                          Radius.circular(20.r),
                        ),
                        color: AppColors.primaryTransparent,
                      ),
                      width: 500.w,
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: FormBuilder(
                          key: formBuilderKey,
                          child: Column(
                            children: [
                              operationErrorMessage != null
                                  ? Text(
                                      operationErrorMessage!,
                                      style: TextStyle(
                                        color: AppColors.darkRed,
                                        fontSize: 14.sp,
                                      ),
                                    )
                                  : SizedBox(),
                              FormBuilderTextField(
                                decoration: InputDecoration(
                                  labelText: "Korisničko ime",
                                  labelStyle: TextStyle(fontSize: 14.sp),
                                ),
                                style: TextStyle(fontSize: 14.sp),
                                name: "username",
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                    errorText: "Ovo polje je obavezno",
                                  ),
                                ]),
                              ),
                              SizedBox(height: 10.h),
                              FormBuilderTextField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: "Lozinka",
                                  labelStyle: TextStyle(fontSize: 14.sp),
                                ),
                                style: TextStyle(fontSize: 14.sp),
                                name: "password",
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                    errorText: "Ovo polje je obavezno",
                                  ),
                                ]),
                              ),
                              SizedBox(height: 20.h),
                              ElevatedButton(
                                onPressed: _authorize,
                                style: ElevatedButton.styleFrom(
                                  textStyle: TextStyle(fontSize: 14.sp),
                                ),
                                child: Text("Prijavi se"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    child: Text(
                      "Nemate korisnički nalog?",
                      style: TextStyle(
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                        fontSize: 14.sp,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => RegistrationScreen(),
                        ),
                      );
                    },
                  ),
                  InkWell(
                    child: Text(
                      "Zaboravili ste lozinku?",
                      style: TextStyle(
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                        fontSize: 14.sp,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => ForgotPasswordScreen(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          );
  }

  Future _authorize() async {
    var validation = formBuilderKey.currentState!.validate();

    if (!validation) return;

    formBuilderKey.currentState!.save();
    var formObject = formBuilderKey.currentState!.value;

    await authService.storeCredetials(
      formObject["username"],
      formObject["password"],
    );

    try {
      var userJson = await userProvider.getMe();
      var user = User.fromJson(userJson);
      if (!user.roles!.any((x) => x.name == Roles.client)) {
        throw Exception("Uneseno korisničko ime ili lozinka su netačni.");
      }

      authService.storeUserId(user.id!);

      AuthNavigationHelper.resetRedirectFlag();

      if (isFirebaseInitialized) {
        String? token = await FirebaseMessaging.instance.getToken();

        if (token != null) {
          String? oldToken = await firebaseTokenService.getToken();

          if (oldToken != null) {
            userFirebaseTokenProvider.update({
              "oldFirebaseToken": oldToken,
              "newFirebaseToken": token,
            });
          } else {
            userFirebaseTokenProvider.add({"firebaseToken": token});
          }

          firebaseTokenService.storeToken(token);
        } else {
          await firebaseTokenService.removeToken();
        }
      } else {
        await initializeFirebase();
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => OfferListScreen()),
      );
    } on Exception catch (e) {
      operationErrorMessage = e.toString().replaceFirst("Exception: ", "");

      await authService.clearCredentials();
      setState(() {});
    }
  }

  Future checkIsUserLoged() async {
    _isLoggedIn = await authService.areCredentialsValid();

    if (_isLoggedIn == false) {
      setState(() {});

      return;
    }

    if (remoteMessage != null) {
      var message = remoteMessage;
      remoteMessage = null;

      while (navigatorKey.currentState == null) {}
      navigateOnNotification(message);
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (builder) => OfferListScreen()),
    );
  }

  void showDisplayMessage() {
    if (!widget.isLoggedOut) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Vaš uređaj je odjavljen sa korisničkog naloga. Molimo Vas da se opet prijavite.",
          style: TextStyle(fontSize: 14.sp),
        ),
      ),
    );
  }
}
