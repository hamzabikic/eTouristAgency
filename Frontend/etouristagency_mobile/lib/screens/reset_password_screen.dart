import 'package:etouristagency_mobile/consts/app_colors.dart';
import 'package:etouristagency_mobile/helpers/dialog_helper.dart';
import 'package:etouristagency_mobile/providers/user_provider.dart';
import 'package:etouristagency_mobile/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
              height: 300.h,
              color: AppColors.primary,
              child: Center(child: Image.asset("lib/assets/images/logo.png")),
            ),
            SizedBox(height: 20.h),
            Text(
              "Promjena lozinke",
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 17.sp,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusGeometry.all(Radius.circular(20.r)),
                  color: AppColors.primaryTransparent,
                ),
                width: 500.w,
                child: Padding(
                  padding: EdgeInsets.all(16.w),
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
                            ? SizedBox(height: 20.h)
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
                        SizedBox(height: 20.h),
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
                        SizedBox(height: 20.h),
                        ElevatedButton(
                          onPressed: !isProcessing ? resetPassword : null,
                          child: !isProcessing
                              ? Text("Potvrdi")
                              : SizedBox(
                                  height: 20.h,
                                  width: 20.w,
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
                ),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (x) => LoginScreen()),
                );
              },
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Future resetPassword() async {
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
      DialogHelper.openDialog(context, ex.toString(), () {
        Navigator.of(context).pop();
      }, type: DialogType.error);
    }

    isProcessing = false;
    setState(() {});
  }
}
