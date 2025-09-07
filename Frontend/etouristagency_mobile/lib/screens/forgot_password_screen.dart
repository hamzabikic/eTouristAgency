import 'package:etouristagency_mobile/consts/app_colors.dart';
import 'package:etouristagency_mobile/helpers/dialog_helper.dart';
import 'package:etouristagency_mobile/providers/verification_code_provider.dart';
import 'package:etouristagency_mobile/screens/login_screen.dart';
import 'package:etouristagency_mobile/screens/reset_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
              height: 300.h,
              color: AppColors.primary,
              child: Center(child: Image.asset("lib/assets/images/logo.png")),
            ),
            SizedBox(height: 20.h),
            Text(
              "Zahtjev za promjenu lozinke",
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
                  child: Column(
                    children: [
                      operationErrorMessage == null
                          ? SizedBox()
                          : Text(
                              operationErrorMessage!,
                              style: TextStyle(
                                color: AppColors.darkRed,
                                fontSize: 14.sp,
                              ),
                            ),
                      operationErrorMessage != null
                          ? SizedBox(height: 20.h)
                          : SizedBox(),
                      TextField(
                        controller: emailEditingController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(fontSize: 14.sp),
                        ),
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      SizedBox(height: 20.h),
                      ElevatedButton(
                        onPressed: !_isProcessing
                            ? sendResetPasswordVerificationCode
                            : null,
                        style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(fontSize: 14.sp),
                        ),
                        child: !_isProcessing
                            ? Text("Pošalji zahtjev")
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
            InkWell(
              child: Text(
                "Povratak na prijavu",
                style: TextStyle(
                  color: AppColors.primary,
                  decoration: TextDecoration.underline,
                  fontSize: 14.sp,
                ),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (x) => LoginScreen()),
                );
              },
            ),
            SizedBox(height: 20.h),
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

    _isProcessing = true;
    setState(() {});

    try {
      await verificationCodeProvider.addResetPasswordVerification(
        emailEditingController.text,
      );

      openVerificationDialog();
    } on Exception catch (ex) {
      operationErrorMessage = ex.toString();
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
            child: IntrinsicHeight(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Zahtjev za promjenu lozinke",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.blueGrey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 50.h),
                    localErrorMessage != null
                        ? Text(
                            localErrorMessage!,
                            style: TextStyle(
                              color: AppColors.darkRed,
                              fontSize: 14.sp,
                            ),
                          )
                        : Text(
                            "Verifikacijski kod je poslan na Vašu email adresu. Ovdje ga unesite.",
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 14.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                    TextField(
                      controller: verificationCodeEditingController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        labelText: "Verifikacijski kod",
                        labelStyle: TextStyle(fontSize: 14.sp),
                      ),
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    SizedBox(height: 20.h),
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
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(fontSize: 14.sp),
                      ),
                      child: isActionInProcess
                          ? SizedBox(
                              height: 20.h,
                              width: 20.w,
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