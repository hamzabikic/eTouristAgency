import 'package:etouristagency_desktop/consts/entity_code.dart';
import 'package:etouristagency_desktop/helpers/dialog_helper.dart';
import 'package:etouristagency_desktop/models/entity_code_value/entity_code_value.dart';
import 'package:etouristagency_desktop/providers/entity_code_value_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AddUpdateEntityCodeValueDialog extends StatefulWidget {
  final EntityCodeValue? entityCodeValue;
  final EntityCode? entityCode;
  const AddUpdateEntityCodeValueDialog({
    this.entityCode,
    super.key,
    this.entityCodeValue,
  });

  @override
  State<AddUpdateEntityCodeValueDialog> createState() =>
      _AddUpdateEntityCodeValueDialogState();
}

class _AddUpdateEntityCodeValueDialogState
    extends State<AddUpdateEntityCodeValueDialog> {
  GlobalKey<FormBuilderState> formBuilderKey = GlobalKey<FormBuilderState>();
  late final EntityCodeValueProvider entityCodeValueProvider;

  @override
  void initState() {
    entityCodeValueProvider = EntityCodeValueProvider();
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
                  initialValue: widget.entityCodeValue?.toJson() ?? {},
                  child: Column(
                    children: [
                      Text(
                        widget.entityCodeValue != null
                            ? "Izmjena šifarnika ${widget.entityCodeValue?.name ?? ""}"
                            : "Nova vrijednost šifarnika",
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
                              if (widget.entityCodeValue == null) {
                                await addEntityCodeValue();
                              } else {
                                await updateEntityCodeValue();
                              }
                            },
                            child: Text(
                              widget.entityCodeValue == null
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

  Future addEntityCodeValue() async {
    try {
      bool isValid = formBuilderKey.currentState!.validate();

      if (!isValid) return;

      formBuilderKey.currentState!.save();
      var json = formBuilderKey.currentState!.value;

      if (widget.entityCode == EntityCode.boardType) {
        await entityCodeValueProvider.addBoardType(json);
      } else if (widget.entityCode == EntityCode.reservationStatus) {
        await entityCodeValueProvider.addReservationStatus(json);
      }

      if (!mounted) {
        return;
      }

      DialogHelper.openDialog(context, "Uspješno dodavanje tipa usluge", () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }, type: DialogType.success);
    } on Exception catch (ex) {
      DialogHelper.openDialog(context, ex.toString(), () {
        Navigator.of(context).pop();
      }, type: DialogType.error);
    }
  }

  Future updateEntityCodeValue() async {
    try {
      bool isValid = formBuilderKey.currentState!.validate();
      if (!isValid) return;

      formBuilderKey.currentState!.save();
      await entityCodeValueProvider.update(
        widget.entityCodeValue!.id!,
        formBuilderKey.currentState!.value,
      );

      if (!mounted) {
        return;
      }

      DialogHelper.openDialog(context, "Uspješno sačuvane promjene", () {
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
