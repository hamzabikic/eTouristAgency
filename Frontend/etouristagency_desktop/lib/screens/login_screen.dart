import 'package:etouristagency_desktop/consts/app_colors.dart';
import 'package:etouristagency_desktop/consts/roles.dart';
import 'package:etouristagency_desktop/helpers/auth_navigation_helper.dart';
import 'package:etouristagency_desktop/helpers/dialog_helper.dart';
import 'package:etouristagency_desktop/models/user/user.dart';
import 'package:etouristagency_desktop/providers/user_provider.dart';
import 'package:etouristagency_desktop/screens/forgot_password.screen.dart';
import 'package:etouristagency_desktop/screens/offer/offer_list_screen.dart';
import 'package:etouristagency_desktop/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class LoginScreen extends StatefulWidget {
  final bool isLoggedOut;

  const LoginScreen({super.key, this.isLoggedOut = false});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? operationErrorMessage;
  final formBuilderKey = GlobalKey<FormBuilderState>();
  late final UserProvider userProvider;
  late final AuthService authService;
  bool _isLoggedIn = true;

  @override
  void initState() {
    userProvider = UserProvider();
    authService = AuthService();
    checkIsUserLoged();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDisplayMessage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: !_isLoggedIn
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 300,
                    color: AppColors.primary,
                    child: Center(
                      child: Image.asset("lib/assets/images/logo.png"),
                    ),
                  ),
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusGeometry.all(
                          Radius.circular(20),
                        ),
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
                                      style: TextStyle(
                                        color: AppColors.darkRed,
                                      ),
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
                                decoration: InputDecoration(
                                  labelText: "Lozinka",
                                ),
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
                      "Zaboravili ste lozinku?",
                      style: TextStyle(
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.primary,
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
            )
          : DialogHelper.openSpinner(context, ""),
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
      if (!user.roles!.any((x) => x.name == Roles.admin)) {
        await authService.clearCredentials();
        throw Exception("Uneseno korisničko ime ili lozinka su netačni.");
      }

      authService.storeData(user);
      AuthNavigationHelper.resetRedirectFlag();

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => OfferListScreen()),
      );
    } on Exception catch (e) {
      operationErrorMessage = e.toString();

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
        ),
      ),
    );
  }
}
