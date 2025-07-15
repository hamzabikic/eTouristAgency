import 'package:etouristagency_mobile/consts/app_colors.dart';
import 'package:etouristagency_mobile/helpers/dialog_helper.dart';
import 'package:etouristagency_mobile/providers/verification_code_provider.dart';
import 'package:etouristagency_mobile/screens/login_screen.dart';
import 'package:etouristagency_mobile/screens/reset_password_screen.dart';
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
                        onPressed: sendResetPasswordVerificationCode,
                        child: Text("Pošalji zahtjev"),
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
    if (emailEditingController.text.isEmpty) {
      operationErrorMessage = "Polje za unos email naloga je obavezno";
      setState(() {});

      return;
    }

    try {
      await verificationCodeProvider.addResetPasswordVerification(
        emailEditingController.text,
      );

      openVerificationDialog();
    } on Exception catch (ex) {
      operationErrorMessage = ex.toString();
    }

    setState(() {});
  }

  void openVerificationDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: SizedBox(
          height: 300,
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
                SizedBox(height: 50),
                dialogOperationErrorMessage != null
                    ? Text(
                        dialogOperationErrorMessage!,
                        style: TextStyle(color: AppColors.darkRed),
                      )
                    : Text(
                        "Verifikacijski kod je poslan na Vašu email adresu. Ovdje ga unesite.",
                        style: TextStyle(color: Colors.blueGrey),
                        textAlign: TextAlign.center,
                      ),
                TextField(
                  controller: verificationCodeEditingController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(labelText: "Verifikacijski kod"),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (verificationCodeEditingController.text.isEmpty) {
                      dialogOperationErrorMessage =
                          "Polje za unos verifikacijskog koda je obavezan.";

                      setState(() {});
                    }
                    try {
                      var verificationKeyExists = await verificationCodeProvider
                          .resetPasswordVerificationCodeExists(
                            verificationCodeEditingController.text,
                          );

                      if (!verificationKeyExists) {
                        dialogOperationErrorMessage =
                            "Uneseni verifikacijski kod nije validan.";
                        setState(() {});
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
                      DialogHelper.openDialog(context, ex.toString(), () {
                        Navigator.of(context).pop();
                      }, type: DialogType.error);
                    }
                  },
                  child: Text("Potvrdi"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
