import 'package:etouristagency_mobile/consts/app_colors.dart';
import 'package:etouristagency_mobile/helpers/dialog_helper.dart';
import 'package:etouristagency_mobile/models/user/user.dart';
import 'package:etouristagency_mobile/providers/user_provider.dart';
import 'package:etouristagency_mobile/providers/verification_code_provider.dart';
import 'package:etouristagency_mobile/screens/login_screen.dart';
import 'package:etouristagency_mobile/screens/master_screen.dart';
import 'package:etouristagency_mobile/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  User? user;
  final updateUserFormBuilder = GlobalKey<FormBuilderState>();
  late final UserProvider userProvider;
  late final VerificationCodeProvider verificationCodeProvider;
  late final AuthService authService;
  final TextEditingController verificationCodeController =
      TextEditingController();
  String? operationErrorMessage;
  bool usernameIsValid = true;
  bool emailIsValid = true;
  bool buttonEnabled = true;

  @override
  void initState() {
    verificationCodeProvider = VerificationCodeProvider();
    userProvider = UserProvider();
    authService = AuthService();
    fetchUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      "Moj nalog",
      Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsGeometry.all(16.0),
            child: user != null
                ? Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryTransparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: FormBuilder(
                          key: updateUserFormBuilder,
                          initialValue: user!.toJson(),
                          autovalidateMode: AutovalidateMode.onUnfocus,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    "Izmjena podataka",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                ),
                                operationErrorMessage != null
                                    ? Text(
                                        operationErrorMessage!,
                                        style: TextStyle(
                                          color: AppColors.darkRed,
                                        ),
                                      )
                                    : SizedBox(),
                                FormBuilderTextField(
                                  name: "firstName",
                                  decoration: InputDecoration(labelText: "Ime"),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(
                                      errorText: "Ovo polje je obavezno.",
                                    ),
                                  ]),
                                ),
                                FormBuilderTextField(
                                  name: "lastName",
                                  decoration: InputDecoration(
                                    labelText: "Prezime",
                                  ),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(
                                      errorText: "Ovo polje je obavezno.",
                                    ),
                                  ]),
                                ),
                                FormBuilderTextField(
                                  name: "username",
                                  decoration: InputDecoration(
                                    labelText: "Korisničko ime",
                                  ),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(
                                      errorText: "Ovo polje je obavezno.",
                                    ),
                                    FormBuilderValidators.conditional(
                                      (value) {
                                        return !usernameIsValid;
                                      },
                                      (value) {
                                        return "Uneseno korisničko ime se već koristi.";
                                      },
                                    ),
                                  ]),
                                ),
                                FormBuilderTextField(
                                  name: "email",
                                  decoration: InputDecoration(
                                    labelText: "Email",
                                    suffixIcon: Icon(
                                      Icons.verified_user,
                                      color: !user!.isVerified!
                                          ? AppColors.darkRed
                                          : AppColors.primary,
                                    ),
                                    helperText: !user!.isVerified!
                                        ? "Email nije verifikovan."
                                        : "Email je verifikovan.",
                                    helperStyle: TextStyle(
                                      color: !user!.isVerified!
                                          ? AppColors.darkRed
                                          : Colors.blueAccent,
                                    ),
                                  ),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(
                                      errorText: "Ovo polje je obavezno.",
                                    ),
                                    FormBuilderValidators.email(
                                      errorText:
                                          "Email unesen u neispravnom formatu.",
                                    ),
                                    FormBuilderValidators.conditional(
                                      (value) {
                                        return !emailIsValid;
                                      },
                                      (value) {
                                        return "Uneseni email se već koristi.";
                                      },
                                    ),
                                  ]),
                                ),
                                user!.isVerified!
                                    ? SizedBox()
                                    : ElevatedButton(
                                        onPressed: () async {
                                          await verify();
                                        },
                                        child: Text("Verifikuj"),
                                      ),
                                FormBuilderTextField(
                                  name: "phoneNumber",
                                  decoration: InputDecoration(
                                    labelText: "Broj telefona",
                                  ),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.minLength(
                                      6,
                                      errorText:
                                          "Broj telefona treba biti u formatu: 061000000",
                                    ),
                                    FormBuilderValidators.numeric(
                                      errorText:
                                          "Broj telefona treba biti u formatu: 061000000",
                                    ),
                                  ]),
                                ),
                                FormBuilderTextField(
                                  name: "password",
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    labelText: "Lozinka",
                                  ),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.minLength(
                                      8,
                                      errorText:
                                          "Lozinka mora sadržavati minimalno 8 karaktera.",
                                    ),
                                  ]),
                                ),
                                FormBuilderTextField(
                                  name: "confirmPassword",
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    labelText: "Potvrda lozinke",
                                  ),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.minLength(
                                      8,
                                      errorText:
                                          "Lozinka mora sadržavati minimalno 8 karaktera.",
                                    ),
                                    FormBuilderValidators.conditional(
                                      (value) =>
                                          value !=
                                          updateUserFormBuilder
                                              .currentState!
                                              .fields["password"]!
                                              .value,
                                      (value) => "Lozinke nisu podudarne.",
                                    ),
                                  ]),
                                ),
                                SizedBox(height: 20),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: buttonEnabled
                                        ? updateUser
                                        : () {},
                                    child: Text("Sačuvaj promjene"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        child: Text("Odjavi se"),
                        onPressed: () async {
                          await authService.clearCredentials();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: deactivateAccount,
                        child: Text("Deaktiviraj nalog")
                      )
                    ],
                  )
                : DialogHelper.openSpinner(context, "Dohvatam podatke..."),
          ),
        ),
      ),
    );
  }

  Future updateUser() async {
    buttonEnabled = false;
    setState(() {});

    emailIsValid = true;
    if (updateUserFormBuilder.currentState!.fields["email"]!.value !=
        user!.email) {
      await validateEmail();
    }

    usernameIsValid = true;
    if (updateUserFormBuilder.currentState!.fields["username"]!.value !=
        user!.username) {
      await validateUsername();
    }

    bool isValid = updateUserFormBuilder.currentState!.validate();

    if (!isValid) {
      buttonEnabled = true;
      setState(() {});
      return;
    }

    updateUserFormBuilder.currentState!.save();
    var insertModel = Map<String, dynamic>.from(
      updateUserFormBuilder.currentState!.value,
    );
    insertModel["roleIds"] = [insertModel["role"]];

    try {
      var response = await userProvider.update(user!.id!, insertModel);
      await authService.clearCredentials();
      await authService.storeCredentials(insertModel["username"], insertModel["password"]);
      await fetchUserData();

      DialogHelper.openDialog(context, "Uspješno sačuvane promjene", () {
        Navigator.of(context).pop();
      });
    } on Exception catch (ex) {
      operationErrorMessage = ex.toString();
      setState(() {});
    }

    buttonEnabled = true;
    setState(() {});
    return;
  }

  Future validateUsername() async {
    usernameIsValid = !(await checkEmailAndUsername(
      "",
      updateUserFormBuilder.currentState!.fields["username"]!.value ?? "",
    ));
    setState(() {});
  }

  Future validateEmail() async {
    emailIsValid = !(await checkEmailAndUsername(
      updateUserFormBuilder.currentState!.fields["email"]!.value ?? "",
      "",
    ));
    setState(() {});
  }

  Future checkEmailAndUsername(String email, String username) async {
    if (email.isEmpty && username.isEmpty) return true;

    var response = await userProvider.exists(email, username);

    return response;
  }

  Future fetchUserData() async {
    user = User.fromJson(await userProvider.getMe());

    setState(() {});
  }

  Future verify() async {
    try {
      await verificationCodeProvider.addEmailVerification();
      openVerificationDialog();
    } on Exception catch (ex) {
      DialogHelper.openDialog(context, ex.toString(), () {
        Navigator.of(context).pop();
      }, type: DialogType.error);
      return;
    }
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
                  "Verifikacija email naloga",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueGrey,
                  ),
                ),
                SizedBox(height: 50),
                Text(
                  "Verifikacijski kod je poslan na Vašu email adresu. Ovdje ga unesite.",
                  style: TextStyle(color: Colors.blueGrey),
                  textAlign: TextAlign.center,
                ),
                TextField(
                  controller: verificationCodeController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(labelText: "Verifikacijski kod"),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await userProvider.verify(
                        verificationCodeController.text,
                      );
                      DialogHelper.openDialog(
                        context,
                        "Uspješna verifikacije email naloga",
                        () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                      );

                      await fetchUserData();
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

  void deactivateAccount() {
    DialogHelper.openConfirmationDialog(
      context,
      "Da li ste sigurni da želite deaktivirati korisnika?",
      "Ovom akcijom ćete trajno obrisati korisnički nalog i isti će postati nepovratan.",
      () async {
        await userProvider.deactivate(user!.id!);
        Navigator.of(context).pop();
        DialogHelper.openDialog(
          context,
          "Uspješno deaktiviran korisnički nalog",
          () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>LoginScreen()));
          },
        );
      },
    );
  }
}
