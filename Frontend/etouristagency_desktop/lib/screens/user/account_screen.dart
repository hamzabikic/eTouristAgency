import 'package:etouristagency_desktop/consts/app_colors.dart';
import 'package:etouristagency_desktop/consts/screen_names.dart';
import 'package:etouristagency_desktop/helpers/dialog_helper.dart';
import 'package:etouristagency_desktop/models/user/user.dart';
import 'package:etouristagency_desktop/providers/user_provider.dart';
import 'package:etouristagency_desktop/screens/master_screen.dart';
import 'package:etouristagency_desktop/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final updateUserFormBuilder = GlobalKey<FormBuilderState>();
  String? operationErrorMessage;
  bool usernameIsValid = true;
  bool emailIsValid = true;
  User? user = null;
  bool _isProcessing = false;
  late final UserProvider userProvider;
  late final AuthService authService;

  @override
  void initState() {
    userProvider = UserProvider();
    authService = AuthService();
    fetchUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      ScreenNames.adminPanelScreen,
      Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsGeometry.all(16.0),
            child: user != null
                ? Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryTransparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: 600,
                    child: FormBuilder(
                      key: updateUserFormBuilder,
                      initialValue: user!.toJson(),
                      autovalidateMode: AutovalidateMode.onUnfocus,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Izmjena podataka",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.blueGrey,
                              ),
                            ),
                            operationErrorMessage != null
                                ? Text(
                                    operationErrorMessage!,
                                    style: TextStyle(color: AppColors.darkRed),
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
                              decoration: InputDecoration(labelText: "Prezime"),
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
                                (value) {
                                  if (user!.username == value ||
                                      usernameIsValid) {
                                    return null;
                                  } else {
                                    return "Uneseno korisničko ime se već koristi.";
                                  }
                                },
                              ]),
                            ),
                            FormBuilderTextField(
                              name: "email",
                              decoration: InputDecoration(labelText: "Email"),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "Ovo polje je obavezno.",
                                ),
                                FormBuilderValidators.email(
                                  errorText:
                                      "Email unesen u neispravnom formatu.",
                                ),
                                (value) {
                                  if (value == user!.email || emailIsValid) {
                                    return null;
                                  } else {
                                    return "Uneseni email se već koristi.";
                                  }
                                },
                              ]),
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
                              decoration: InputDecoration(labelText: "Lozinka"),
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
                            ElevatedButton(
                              onPressed: !_isProcessing ? updateUser : null,
                              child: !_isProcessing
                                  ? Text("Sačuvaj promjene")
                                  : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: Transform.scale(
                                          scale: 0.6,
                                          child:
                                              const CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : DialogHelper.openSpinner(context, "Dohvatam podatke..."),
          ),
        ),
      ),
    );
  }

  Future updateUser() async {
    setState(() {});
    await validateEmail();
    await validateUsername();

    bool isValid = updateUserFormBuilder.currentState!.validate();

    if (!isValid) {
      return;
    }

    _isProcessing = true;
    setState(() {});

    updateUserFormBuilder.currentState!.save();
    var insertModel = Map<String, dynamic>.from(
      updateUserFormBuilder.currentState!.value,
    );
    insertModel["roleIds"] = [insertModel["role"]];

    try {
      var response = await userProvider.update(user!.id!, insertModel);
      await authService.storeCredentials(
        insertModel["username"],
        insertModel["password"],
      );
      await fetchUserData();

      DialogHelper.openDialog(context, "Uspješno sačuvane promjene", () {
        Navigator.of(context).pop();
      });
    } on Exception catch (ex) {
      DialogHelper.openDialog(context, ex.toString(), () {
        Navigator.of(context).pop();
      }, type: DialogType.error);
    }
    
    _isProcessing = false;
    setState(() {});
    return;
  }

  Future validateUsername() async {
    if (updateUserFormBuilder.currentState!.fields["username"]!.value == null)
      return;

    usernameIsValid = !(await checkEmailAndUsername(
      "",
      updateUserFormBuilder.currentState!.fields["username"]!.value ?? "",
    ));

    setState(() {});
  }

  Future validateEmail() async {
    if (updateUserFormBuilder.currentState!.fields["email"]!.value == null)
      return;

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
}
