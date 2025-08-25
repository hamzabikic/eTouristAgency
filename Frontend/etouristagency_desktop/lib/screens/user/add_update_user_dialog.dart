import 'package:etouristagency_desktop/consts/app_colors.dart';
import 'package:etouristagency_desktop/helpers/dialog_helper.dart';
import 'package:etouristagency_desktop/models/role/role.dart';
import 'package:etouristagency_desktop/models/user/user.dart';
import 'package:etouristagency_desktop/providers/role_provider.dart';
import 'package:etouristagency_desktop/providers/user_provider.dart';
import 'package:etouristagency_desktop/screens/user/user_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AddUpdateUserDialog extends StatefulWidget {
  final User? user;
  const AddUpdateUserDialog({this.user, super.key});

  @override
  State<AddUpdateUserDialog> createState() => _AddUpdateUserDialogState();
}

class _AddUpdateUserDialogState extends State<AddUpdateUserDialog> {
  final addUserFormBuilderKey = GlobalKey<FormBuilderState>();
  late final UserProvider userProvider;
  late final RoleProvider roleProvider;
  List<Role>? roleList;
  bool buttonEnabled = true;
  bool emailIsValid = true;
  bool usernameIsValid = true;
  String? operationErrorMessage;

  @override
  void initState() {
    userProvider = UserProvider();
    roleProvider = RoleProvider();
    fetchRoleData();
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
              child: FormBuilder(
                key: addUserFormBuilderKey,
                initialValue: widget.user == null ? {} : widget.user!.toJson(),
                autovalidateMode: AutovalidateMode.onUnfocus,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.user == null
                            ? "Novi korisnik"
                            : "Izmjena korisnika",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
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
                            if (value == widget.user?.username || usernameIsValid) {
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
                            errorText: "Email unesen u neispravnom formatu.",
                          ),
                          (value) {
                            if (value == widget.user?.email || emailIsValid) {
                              return null;
                            } else {
                              return "Uneseni email se već koristi.";
                            }
                          },
                        ]),
                      ),
                      FormBuilderTextField(
                        name: "phoneNumber",
                        decoration: InputDecoration(labelText: "Broj telefona"),
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
                                addUserFormBuilderKey
                                    .currentState!
                                    .fields["password"]!
                                    .value,
                            (value) => "Lozinke nisu podudarne.",
                          ),
                        ]),
                      ),
                      widget.user == null
                          ? FormBuilderDropdown(
                              name: "role",
                              initialValue: "",
                              items: getDropdownItemList(),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "Ovo polje je obavezno.",
                                ),
                              ]),
                            )
                          : SizedBox(),
                      SizedBox(height: 20),
                      widget.user != null
                          ? ElevatedButton(
                              onPressed: deactivateAccount,
                              child: Text("Deaktiviraj nalog"),
                            )
                          : SizedBox(),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: buttonEnabled ? addUpdateUser : () {},
                        child: Text(widget.user == null ? "Dodaj" : "Sačuvaj"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future addUpdateUser() async {
    buttonEnabled = false;
    setState(() {});
    await validateEmail();
    await validateUsername();
    bool isValid = addUserFormBuilderKey.currentState!.validate();

    if (!isValid) {
      buttonEnabled = true;
      setState(() {});
      return;
    }

    addUserFormBuilderKey.currentState!.save();
    var insertModel = Map<String, dynamic>.from(
      addUserFormBuilderKey.currentState!.value,
    );
    insertModel["roleIds"] = [insertModel["role"]];

    try {
      var response = widget.user == null
          ? await userProvider.add(insertModel)
          : await userProvider.update(widget.user!.id!, insertModel);

      DialogHelper.openDialog(
        context,
        widget.user == null
            ? "Uspješno dodavanje korisnika"
            : "Uspješno sačuvane promjene",
        () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => UserListScreen()),
          );
        },
      );

      return;
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
      addUserFormBuilderKey.currentState!.fields["username"]!.value ?? "",
    ));
    setState(() {});
  }

  Future validateEmail() async {
    emailIsValid = !(await checkEmailAndUsername(
      addUserFormBuilderKey.currentState!.fields["email"]!.value ?? "",
      "",
    ));
    setState(() {});
  }

  Future checkEmailAndUsername(String email, String username) async {
    if (email.isEmpty && username.isEmpty) return true;

    var response = await userProvider.exists(email, username);

    return response;
  }

  List<DropdownMenuItem> getDropdownItemList() {
    var listOfItems = [DropdownMenuItem(child: Text("-- Uloga --"), value: "")];

    if (roleList == null || roleList!.isEmpty) return listOfItems;

    for (var role in roleList!) {
      listOfItems.add(
        DropdownMenuItem(child: Text(role.name ?? ""), value: role.id),
      );
    }

    return listOfItems;
  }

  Future fetchRoleData() async {
    roleList = (await roleProvider.getAll({})).listOfRecords;

    setState(() {});
  }

  void deactivateAccount() {
    DialogHelper.openConfirmationDialog(
      context,
      "Da li ste sigurni da želite deaktivirati korisnika?",
      "Ovom akcijom ćete trajno obrisati korisnički nalog i isti će postati nepovratan.",
      () async {
        await userProvider.deactivate(widget.user!.id!);
        Navigator.of(context).pop();
        DialogHelper.openDialog(
          context,
          "Uspješno deaktiviran korisnički nalog",
          () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => UserListScreen()),
            );
          },
        );
      },
    );
  }
}
