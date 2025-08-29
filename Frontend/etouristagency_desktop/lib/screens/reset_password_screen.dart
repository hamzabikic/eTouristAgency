import 'package:etouristagency_desktop/consts/app_colors.dart';
import 'package:etouristagency_desktop/helpers/dialog_helper.dart';
import 'package:etouristagency_desktop/providers/user_provider.dart';
import 'package:etouristagency_desktop/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String _email;
  final String _verificationKey;

  const ResetPasswordScreen(this._email, this._verificationKey, {super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  String? operationErrorMessage;
  TextEditingController newPasswordEditingController = TextEditingController();
  TextEditingController repeatPasswordEditingController =
      TextEditingController();
  final formbuilderKey = GlobalKey<FormBuilderState>();
  late final UserProvider userProvider;
  bool isProcessing = false;

  @override
  void initState() {
    userProvider = UserProvider();
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
              "Promjena lozinke",
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
                  child: FormBuilder(
                    key: formbuilderKey,
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
                        FormBuilderTextField(
                          name: "newPassword",
                          controller: newPasswordEditingController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Nova lozinka",
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                              errorText: "Ovo polje je obavezno",
                            ),
                            FormBuilderValidators.minLength(
                              8,
                              errorText:
                                  "Lozinka mora sadržavati minimalno 8 karaktera.",
                            ),
                          ]),
                        ),
                        SizedBox(height: 20),
                        FormBuilderTextField(
                          name: "repeatPassword",
                          obscureText: true,
                          controller: repeatPasswordEditingController,
                          decoration: InputDecoration(
                            labelText: "Potvrda lozinke",
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                              errorText: "Ovo polje je obavezno",
                            ),
                            FormBuilderValidators.minLength(
                              8,
                              errorText:
                                  "Lozinka mora sadržavati minimalno 8 karaktera.",
                            ),
                            (value) {
                              if (value != newPasswordEditingController.text) {
                                return "Lozinke nisu podudarne";
                              }

                              return null;
                            },
                          ]),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: !isProcessing ? resetPassword : null,
                          child: !isProcessing
                              ? Text("Potvrdi")
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
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future resetPassword() async {
    operationErrorMessage = null;
    
    var isFormValid = formbuilderKey.currentState!.validate();

    if (!isFormValid) return;

    isProcessing = true;
    setState(() {});

    var resetPasswordRequest = {
      "password": newPasswordEditingController.text,
      "verificationKey": widget._verificationKey,
      "email": widget._email,
    };

    try {
      await userProvider.resetPassword(resetPasswordRequest);

      DialogHelper.openDialog(context, "Uspješna promjena lozinke", () {
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      });
    } on Exception catch (ex) {
      operationErrorMessage = ex.toString().replaceFirst("Exception: ", "");
    }

    isProcessing = false;
    setState(() {});
  }
}
