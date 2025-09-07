import 'package:etouristagency_desktop/consts/app_colors.dart';
import 'package:etouristagency_desktop/helpers/dialog_helper.dart';
import 'package:etouristagency_desktop/providers/verification_code_provider.dart';
import 'package:etouristagency_desktop/screens/login_screen.dart';
import 'package:etouristagency_desktop/screens/reset_password_screen.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailEditingController = TextEditingController();
  final TextEditingController verificationCodeEditingController =
      TextEditingController();
  late final VerificationCodeProvider verificationCodeProvider;
  String? operationErrorMessage;
  String? dialogOperationErrorMessage;
  bool _isProcessing = false;

  @override
  void initState() {
    verificationCodeProvider = VerificationCodeProvider();
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
            SizedBox(height: 20),
            Text(
              "Zahtjev za promjenu lozinke",
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
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
                  child: Column(
                    children: [
                      operationErrorMessage == null
                          ? SizedBox()
                          : Text(
                              operationErrorMessage!,
                              style: TextStyle(color: AppColors.darkRed),
                            ),
                      operationErrorMessage != null
                          ? SizedBox(height: 20)
                          : SizedBox(),
                      TextField(
                        controller: emailEditingController,
                        decoration: InputDecoration(labelText: "Email"),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: !_isProcessing
                            ? sendResetPasswordVerificationCode
                            : null,
                        child: !_isProcessing
                            ? Text("Pošalji zahtjev")
                            : SizedBox(
                                height: 20,
                                width: 20,
                                child: Transform.scale(
                                  scale: 0.6,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              child: Text(
                "Povratak na prijavu",
                style: TextStyle(
                  color: AppColors.primary,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.primary,
                ),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (x) => LoginScreen()),
                );
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future sendResetPasswordVerificationCode() async {
    operationErrorMessage = null;

    if (emailEditingController.text.isEmpty) {
      operationErrorMessage = "Polje za unos email naloga je obavezno";
      setState(() {});

      return;
    }

    _isProcessing = true;
    setState(() {});

    try {
      await verificationCodeProvider.addResetPasswordVerification(
        emailEditingController.text,
      );

      openVerificationDialog();
    } on Exception catch (ex) {
      operationErrorMessage = ex.toString().replaceFirst("Exception: ", "");
    }

    _isProcessing = false;
    setState(() {});
  }

  void openVerificationDialog() {
    verificationCodeEditingController.text = "";

    showDialog(
      context: context,
      builder: (context) {
        String? localErrorMessage = dialogOperationErrorMessage;
        bool isActionInProcess = false;
        return StatefulBuilder(
          builder: (context, setStateDialog) => Dialog(
            child: SizedBox(
              height: 300,
              width: 400,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Zahtjev za promjenu lozinke",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.blueGrey,
                      ),
                    ),
                    SizedBox(height: 20),
                    localErrorMessage != null
                        ? Text(
                            localErrorMessage!,
                            style: TextStyle(color: AppColors.darkRed),
                          )
                        : SizedBox(),
                    SizedBox(height: 20),
                    Text(
                      "Verifikacijski kod je poslan na Vašu email adresu. Ovdje ga unesite.",
                      style: TextStyle(color: Colors.blueGrey),
                      textAlign: TextAlign.center,
                    ),
                    TextField(
                      controller: verificationCodeEditingController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        labelText: "Verifikacijski kod",
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: !isActionInProcess
                          ? () async {
                              if (verificationCodeEditingController
                                  .text
                                  .isEmpty) {
                                setStateDialog(() {
                                  localErrorMessage =
                                      "Polje za unos verifikacijskog koda je obavezan.";
                                });
                                return;
                              }

                              setStateDialog(() {
                                isActionInProcess = true;
                              });

                              try {
                                var exists = await verificationCodeProvider
                                    .resetPasswordVerificationCodeExists(
                                      verificationCodeEditingController.text,
                                    );

                                if (!exists) {
                                  setStateDialog(() {
                                    isActionInProcess = false;
                                    localErrorMessage =
                                        "Uneseni verifikacijski kod nije validan.";
                                  });
                                  return;
                                }

                                Navigator.of(context).pop();
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => ResetPasswordScreen(
                                      emailEditingController.text,
                                      verificationCodeEditingController.text,
                                    ),
                                  ),
                                );
                              } on Exception catch (ex) {
                                DialogHelper.openDialog(
                                  context,
                                  ex.toString(),
                                  () {
                                    Navigator.of(context).pop();
                                  },
                                  type: DialogType.error,
                                );

                                setStateDialog(() {
                                  isActionInProcess = false;
                                });
                              }
                            }
                          : null,
                      child: isActionInProcess
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: Transform.scale(
                                scale: 0.6,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : Text("Potvrdi"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
