import 'package:etouristagency_mobile/consts/app_colors.dart';
import 'package:etouristagency_mobile/consts/roles.dart';
import 'package:etouristagency_mobile/models/user/user.dart';
import 'package:etouristagency_mobile/providers/user_provider.dart';
import 'package:etouristagency_mobile/screens/account_screen.dart';
import 'package:etouristagency_mobile/screens/forgot_password_screen.dart';
import 'package:etouristagency_mobile/screens/offer/offer_list_screen.dart';
import 'package:etouristagency_mobile/screens/registration_screen.dart';
import 'package:etouristagency_mobile/services/auth_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? operationErrorMessage;
  final formBuilderKey = GlobalKey<FormBuilderState>();
  late final AuthService authService;
  late final UserProvider userProvider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      bool isLoggedIn = await authService.isLoged();

      if (!mounted) return;

      if (isLoggedIn) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (builder) => OfferListScreen()),
        );
      }
    });

    userProvider = UserProvider();
    authService = AuthService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              color: AppColors.primary,
              child: Center(child: Image.asset("lib/assets/images/logo.png")),
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusGeometry.all(Radius.circular(20)),
                  color: AppColors.primaryTransparent,
                ),
                width: 500,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FormBuilder(
                    key: formBuilderKey,
                    child: Column(
                      children: [
                        operationErrorMessage != null
                            ? Text(
                                operationErrorMessage!,
                                style: TextStyle(color: AppColors.darkRed),
                              )
                            : SizedBox(),
                        FormBuilderTextField(
                          decoration: InputDecoration(
                            labelText: "Korisničko ime",
                          ),
                          name: "username",
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                              errorText: "Ovo polje je obavezno",
                            ),
                          ]),
                        ),
                        SizedBox(height: 10),
                        FormBuilderTextField(
                          obscureText: true,
                          decoration: InputDecoration(labelText: "Lozinka"),
                          name: "password",
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                              errorText: "Ovo polje je obavezno",
                            ),
                          ]),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _authorize,
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
                ),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => RegistrationScreen()),
                );
              },
            ),
            InkWell(
              child: Text(
                "Zaboravili ste lozinku?",
                style: TextStyle(
                  color: AppColors.primary,
                  decoration: TextDecoration.underline,
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
            SizedBox(height: 40),
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

    await authService.storeCredentials(
      formObject["username"],
      formObject["password"],
    );

    try {
      var userJson = await userProvider.getMe();
      var user = User.fromJson(userJson);
      if (!user.roles!.any((x) => x.name == Roles.client)) {
        await authService.clearCredentials();
        throw Exception("Uneseno korisničko ime ili lozinka su netačni.");
      }

      await setFirebaseConfig();

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => AccountScreen()),
      );
    } on Exception catch (e) {
      operationErrorMessage = e.toString();

      await authService.clearCredentials();
      setState(() {});
    }
  }

  Future setFirebaseConfig() async {
    String? token = await FirebaseMessaging.instance.getToken();
    await userProvider.updateFirebaseToken({"firebaseToken": token});

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      if (!(await authService.isLoged())) return;

      await userProvider.updateFirebaseToken({"firebaseToken": newToken});
    });

    FirebaseMessaging.onMessage.listen((message) {});

    FirebaseMessaging.onMessageOpenedApp.listen((message) {});
  }
}
