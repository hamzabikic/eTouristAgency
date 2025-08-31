import 'package:etouristagency_desktop/consts/app_colors.dart';
import 'package:etouristagency_desktop/helpers/dialog_helper.dart';
import 'package:etouristagency_desktop/models/user/user.dart';
import 'package:etouristagency_desktop/providers/user_provider.dart';
import 'package:flutter/material.dart';

class UpdateClientUserDialog extends StatefulWidget {
  User _user;
  UpdateClientUserDialog(this._user, {super.key});

  @override
  State<UpdateClientUserDialog> createState() => _UpdateClientUserDialogState();
}

class _UpdateClientUserDialogState extends State<UpdateClientUserDialog> {
  late final UserProvider userProvider;
  bool _isVerificationInProcess = false;
  bool _isResetPasswordInProcess = false;

  @override
  void initState() {
    userProvider = UserProvider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "Izmjena korisnika ${widget._user.username}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      readOnly: true,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(labelText: "Lozinka"),
                      controller: TextEditingController.fromValue(
                        TextEditingValue(text: "********"),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: !_isResetPasswordInProcess
                          ? () async {
                              _isResetPasswordInProcess = true;
                              setState(() {});

                              await userProvider.resetPasswordByUserId(
                                widget._user.id!,
                              );

                              if (!mounted) return;

                              DialogHelper.openDialog(
                                context,
                                "Uspješno resetovanje lozinke",
                                () {
                                  Navigator.of(context).pop();
                                },
                              );

                              _isResetPasswordInProcess = false;
                              setState(() {});
                            }
                          : null,
                      child: !_isResetPasswordInProcess
                          ? Text("Resetuj lozinku")
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
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
                    ),
                    SizedBox(height: 20),
                    TextField(
                      readOnly: true,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        suffixIcon: widget._user.isVerified!
                            ? Icon(Icons.verified, color: AppColors.primary)
                            : null,
                        helperText: widget._user.isVerified!
                            ? "Ovaj korisnik je verifikovan."
                            : "",
                        labelText: "Email",
                      ),
                      controller: TextEditingController.fromValue(
                        TextEditingValue(text: widget._user.email!),
                      ),
                    ),
                    SizedBox(height: 20),
                    !widget._user.isVerified!
                        ? ElevatedButton(
                            onPressed: !_isVerificationInProcess
                                ? () async {
                                    _isVerificationInProcess = true;
                                    setState(() {});

                                    await userProvider.verify(widget._user.id!);
                                    if (!mounted) return;

                                    await updateUserData();
                                    DialogHelper.openDialog(
                                      context,
                                      "Uspješna verifikacija korisnika",
                                      () {
                                        Navigator.of(context).pop();
                                      },
                                    );

                                    _isVerificationInProcess = false;
                                    setState(() {});
                                  }
                                : null,
                            child: !_isVerificationInProcess
                                ? Text("Verifikuj email")
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
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
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future updateUserData() async {
    widget._user = await userProvider.getById(widget._user.id!);

    if (!mounted) return;

    setState(() {});
  }
}
