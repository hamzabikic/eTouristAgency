import 'package:etouristagency_desktop/helpers/dialog_helper.dart';
import 'package:etouristagency_desktop/models/city/city.dart';
import 'package:etouristagency_desktop/models/country/country.dart';
import 'package:etouristagency_desktop/providers/city_provider.dart';
import 'package:etouristagency_desktop/providers/country_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AddUpdateCityDialog extends StatefulWidget {
  final City? city;
  const AddUpdateCityDialog({this.city, super.key});

  @override
  State<AddUpdateCityDialog> createState() => _AddUpdateCityDialogState();
}

class _AddUpdateCityDialogState extends State<AddUpdateCityDialog> {
  final GlobalKey<FormBuilderState> formBuilderKey =
      GlobalKey<FormBuilderState>();
  late final CountryProvider countryProvider;
  late final CityProvider cityProvider;
  List<Country>? countries;

  @override
  void initState() {
    countryProvider = CountryProvider();
    cityProvider = CityProvider();
    fetchCountryData();
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
                  initialValue: widget.city?.toJson() ?? {},
                  child: Column(
                    children: [
                      Text(
                        widget.city != null ? "Izmjena grada" : "Novi grad",
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
                      FormBuilderDropdown(
                        name: "countryId",
                        initialValue: (widget.city?.countryId ?? ""),
                        items: getCountryDropdownItems(),
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
                              await addUpdateCity();
                            },
                            child: Text(
                              widget.city == null
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

  Future fetchCountryData() async {
    countries = (await countryProvider.getAll({
      "recordsPerPage": 1000,
    })).listOfRecords;

    if (!mounted) {
      return;
    }

    setState(() {});
  }

  List<DropdownMenuItem> getCountryDropdownItems() {
    var list = [DropdownMenuItem(value: "", child: Text("-- Država --"))];

    if (countries == null) return list;

    for (var country in countries!) {
      var dropdownItem = DropdownMenuItem(
        value: country.id,
        child: Text(country.name ?? ""),
      );
      list.add(dropdownItem);
    }

    return list;
  }

  Future addUpdateCity() async {
    bool isValid = formBuilderKey.currentState!.validate();

    if (!isValid) return;

    formBuilderKey.currentState!.save();
    var json = Map<String, dynamic>.from(formBuilderKey.currentState!.value);
    json["id"] = widget.city?.id ?? "";

    if (widget.city == null) {
      try {
        await cityProvider.add(json);

        if (!mounted) {
          return;
        }

        DialogHelper.openDialog(context, "Uspješno dodan grad", () {
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
        await cityProvider.update(widget.city!.id!, json);

        if (!mounted) {
          return;
        }

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
