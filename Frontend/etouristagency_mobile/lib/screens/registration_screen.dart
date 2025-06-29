import 'package:etouristagency_mobile/consts/app_colors.dart';
import 'package:etouristagency_mobile/providers/user_provider.dart';
import 'package:etouristagency_mobile/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool buttonEnabled = true;
  bool emailIsValid = true;
  bool usernameIsValid = true;
  String? operationErrorMessage;
  final formBuilderKey = GlobalKey<FormBuilderState>();
  late final UserProvider userProvider;

  @override
  void initState() {
    userProvider = UserProvider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
    body: SingleChildScrollView(
      child: Column(children: [
        Container(height:300,
                  color: AppColors.primary,
                  child: Center(child: Image.asset("lib/assets/images/logo.png")),
                   ),
        SizedBox(height:20),
        Text("Registracija korisnika", style: TextStyle(color: AppColors.primary, fontSize: 17, fontWeight: FontWeight.bold )),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: FormBuilder(
              key: formBuilderKey,
              autovalidateMode: AutovalidateMode.onUnfocus,
              child:  Container(
              decoration: BoxDecoration(borderRadius: BorderRadiusGeometry.all(Radius.circular(20)), color:AppColors.primaryTransparent),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  operationErrorMessage !=null ? Text(operationErrorMessage!, style: TextStyle(color: AppColors.darkRed)) : SizedBox(),
                  FormBuilderTextField(name: "firstName", decoration: InputDecoration(labelText: "Ime"),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "Ovo polje je obavezno.")
                  ]),),
                  FormBuilderTextField(name: "lastName",  decoration: InputDecoration(labelText: "Prezime"),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "Ovo polje je obavezno.")
                  ])),
                  FormBuilderTextField(name: "username", decoration: InputDecoration(labelText: "Korisničko ime"),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "Ovo polje je obavezno."),
                    FormBuilderValidators.conditional((value){
                      return !usernameIsValid;
                    }, (value){
                      return "Uneseno korisničko ime se već koristi.";
                    })
                  ])),
                  FormBuilderTextField(name: "email",  decoration: InputDecoration(labelText: "Email"),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "Ovo polje je obavezno."),
                    FormBuilderValidators.email(errorText: "Email unesen u neispravnom formatu."),
                    FormBuilderValidators.conditional((value){
                      return !emailIsValid;
                    }, (value){
                      return "Uneseni email se već koristi.";
                    })
                  ])),
                  FormBuilderTextField(name: "phoneNumber",  decoration: InputDecoration(labelText: "Broj telefona"),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.minLength(6, errorText: "Broj telefona treba biti u formatu: 061000000"),
                    FormBuilderValidators.numeric(errorText: "Broj telefona treba biti u formatu: 061000000")
                  ])),
                  FormBuilderTextField(name: "password", obscureText: true, decoration: InputDecoration(labelText: "Lozinka"),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.minLength(8, errorText: "Lozinka mora sadržavati minimalno 8 karaktera.")
                  ]),
                  ),
                  FormBuilderTextField(name: "confirmPassword", obscureText: true, decoration: InputDecoration(labelText: "Potvrda lozinke"),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.minLength(8, errorText: "Lozinka mora sadržavati minimalno 8 karaktera."),
                    FormBuilderValidators.conditional((value)=> value != formBuilderKey.currentState!.fields["password"]!.value, (value)=> "Lozinke nisu podudarne.")
                  ])),
                  SizedBox(height:20),
                  ElevatedButton(onPressed: buttonEnabled? registration : (){}, child: Text("Registruj se"))
                ],),
              ),
            ),
          ),
        ),
        InkWell(child: Text("Povratak na prijavu",style: TextStyle(color:AppColors.primary, decoration: TextDecoration.underline)), onTap: (){
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (x)=> LoginScreen()));
        }),
        SizedBox(height:20)
      ],)
    ));
  }

  Future registration() async{
    buttonEnabled = false;
    setState((){});
    await validateEmail();
    await validateUsername();
    bool isValid = formBuilderKey.currentState!.validate();

    if(!isValid){
       buttonEnabled = true;
       setState((){});
       return;
    }

    formBuilderKey.currentState!.save();
    var inserModel = formBuilderKey.currentState!.value;

    try{
    var response = await userProvider.add(inserModel);
    showDialog(context: context, barrierDismissible: false, builder:(context) => AlertDialog(title: Text("Uspješna registracija", style: TextStyle(fontSize: 18)), icon: Icon(Icons.check_circle, color: AppColors.primary), actions:[
      Center(
        child: ElevatedButton(onPressed: (){
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> LoginScreen()));
        }, child: Text("Idi na prijavu")),
      )
    ]));

    return;
    } on Exception catch(ex){
        operationErrorMessage = ex.toString();
        setState((){});
    }

    buttonEnabled = true;
    setState((){});
    return;
  }

  Future validateUsername() async {
    usernameIsValid = !(await checkEmailAndUsername("", formBuilderKey.currentState!.fields["username"]!.value ?? ""));
    setState((){});
  }

  Future validateEmail() async {
    emailIsValid = !(await checkEmailAndUsername(formBuilderKey.currentState!.fields["email"]!.value ?? "", ""));
    setState((){});
  }

  Future checkEmailAndUsername(String email, String username)async{
    if(email.isEmpty && username.isEmpty) return true;

    var response = await userProvider.exists(email, username);

    return response;
  }
}