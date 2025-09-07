import 'package:etouristagency_desktop/helpers/dialog_helper.dart';
import 'package:etouristagency_desktop/models/country/country.dart';
import 'package:etouristagency_desktop/providers/country_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AddUpdateCountryDialog extends StatefulWidget {
  final Country? country;
  const AddUpdateCountryDialog({super.key, this.country});

  @override
  State<AddUpdateCountryDialog> createState() => _AddUpdateCountryDialogState();
}

class _AddUpdateCountryDialogState extends State<AddUpdateCountryDialog> {
  final GlobalKey<FormBuilderState> formBuilderKey =
      GlobalKey<FormBuilderState>();
  late final CountryProvider countryProvider;

  @override
  void initState() {
    countryProvider = CountryProvider();
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
                child: FormBuilder(
                  key: formBuilderKey,
                  initialValue: widget.country?.toJson() ?? {},
                  child: Column(
                    children: [
                      Text(
                        widget.country != null
                            ? "Izmjena države"
                            : "Nova država",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 20),
                      FormBuilderTextField(
                        decoration: InputDecoration(labelText: "Naziv"),
                        name: "name",
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                            errorText: "Ovo polje je obavezno.",
                          ),
                        ]),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              await addUpdateCountry();
                            },
                            child: Text(
                              widget.country == null
                                  ? "Sačuvaj"
                                  : "Sačuvaj promjene",
                            ),
                          ),
                        ],
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

  Future addUpdateCountry() async {
    bool isValid = formBuilderKey.currentState!.validate();

    if (!isValid) return;

    formBuilderKey.currentState!.save();
    var json = Map<String, dynamic>.from(formBuilderKey.currentState!.value);
    json["id"] = widget.country?.id ?? "";

    if (widget.country == null) {
      try {
        await countryProvider.add(json);
        DialogHelper.openDialog(context, "Uspješno dodana država", () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }, type: DialogType.success);
      } on Exception catch (ex) {
        DialogHelper.openDialog(context, ex.toString(), () {
          Navigator.of(context).pop();
        }, type: DialogType.error);
      }
    } else {
      try {
        await countryProvider.update(widget.country!.id!, json);
        DialogHelper.openDialog(context, "Uspješno sačuvane izmjene", () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }, type: DialogType.success);
      } on Exception catch (ex) {
        DialogHelper.openDialog(context, ex.toString(), () {
          Navigator.of(context).pop();
        }, type: DialogType.error);
      }
    }
  }
}
