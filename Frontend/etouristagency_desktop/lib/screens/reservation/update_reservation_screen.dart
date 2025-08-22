import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:etouristagency_desktop/consts/app_colors.dart';
import 'package:etouristagency_desktop/helpers/dialog_helper.dart';
import 'package:etouristagency_desktop/helpers/format_helper.dart';
import 'package:etouristagency_desktop/models/entity_code_value/entity_code_value.dart';
import 'package:etouristagency_desktop/models/offer/offer.dart';
import 'package:etouristagency_desktop/models/reservation/reservation.dart';
import 'package:etouristagency_desktop/providers/entity_code_value_provider.dart';
import 'package:etouristagency_desktop/providers/reservation_provider.dart';
import 'package:etouristagency_desktop/screens/master_screen.dart';
import 'package:etouristagency_desktop/screens/offer/add_update_offer_screen.dart';
import 'package:etouristagency_desktop/screens/reservation/reservation_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class UpdateReservationScreen extends StatefulWidget {
  final Offer offer;
  final String reservationId;
  const UpdateReservationScreen(this.offer, this.reservationId, {super.key});

  @override
  State<UpdateReservationScreen> createState() =>
      _UpdateReservationScreenState();
}

class _UpdateReservationScreenState extends State<UpdateReservationScreen> {
  Reservation? reservation;
  List<EntityCodeValue>? reservationStatusList;
  late final ReservationProvider reservationProvider;
  late final EntityCodeValueProvider entityCodeValueProvider;
  ScrollController horizontalScrollController = ScrollController();
  final GlobalKey<FormBuilderState> formBuilderKey =
      GlobalKey<FormBuilderState>();
  Map<String, dynamic> reservationData = {
    "paidAmount": 0,
    "reservationStatusId": "",
  };

  @override
  void initState() {
    reservationProvider = ReservationProvider();
    entityCodeValueProvider = EntityCodeValueProvider();
    fetchReservationData();
    fetchReservationStatusData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      reservation != null
          ? SingleChildScrollView(
              child: Stack(
                children: [
                  Positioned(
                    top:8,
                    left:16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          color: AppColors.primary,
                          icon: Icon(Icons.arrow_back_ios),
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) =>
                                    ReservationListScreen(widget.offer),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Scrollbar(
                        controller: horizontalScrollController,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          controller: horizontalScrollController,
                          child: Container(
                            width: 750,
                            decoration: BoxDecoration(
                              color: AppColors.primaryTransparent,
                              borderRadius: BorderRadiusGeometry.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 16,
                                left: 50,
                                right: 50,
                                bottom: 16,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Detalji rezervacije",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                  SizedBox(height: 30),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.memory(
                                            base64Decode(
                                              widget
                                                  .offer
                                                  .offerImage!
                                                  .imageBytes!,
                                            ),
                                            width: 250,
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: 300,
                                            child: InkWell(
                                              child: FormBuilderTextField(
                                                enabled: false,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                initialValue:
                                                    widget.offer.offerNo
                                                        ?.toString() ??
                                                    "",
                                                name: "",
                                                decoration: InputDecoration(
                                                  labelText: "Broj ponude",
                                                  labelStyle: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                Navigator.of(
                                                  context,
                                                ).pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddUpdateOfferScreen(
                                                          offer: widget.offer,
                                                        ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            width: 300,
                                            child: FormBuilderTextField(
                                              enabled: false,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                              initialValue:
                                                  widget.offer.hotel?.name ??
                                                  "",
                                              name: "",
                                              decoration: InputDecoration(
                                                labelText: "Hotel",
                                                labelStyle: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 300,
                                            child: FormBuilderTextField(
                                              enabled: false,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                              initialValue:
                                                  "${widget.offer.hotel?.city?.name ?? ""}, ${widget.offer.hotel?.city?.country?.name ?? ""}",
                                              name: "",
                                              decoration: InputDecoration(
                                                labelText: "Destinacija",
                                                labelStyle: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 300,
                                            child: FormBuilderTextField(
                                              enabled: false,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                              initialValue:
                                                  DateFormat(
                                                    "dd.MM.yyyy HH:mm",
                                                  ).format(
                                                    widget.offer.tripStartDate!,
                                                  ),
                                              name: "",
                                              decoration: InputDecoration(
                                                labelText:
                                                    "Datum i vrijeme polaska",
                                                labelStyle: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 300,
                                            child: FormBuilderTextField(
                                              enabled: false,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                              initialValue:
                                                  DateFormat(
                                                    "dd.MM.yyyy HH:mm",
                                                  ).format(
                                                    widget.offer.tripEndDate!,
                                                  ),
                                              name: "",
                                              decoration: InputDecoration(
                                                labelText:
                                                    "Datum i vrijeme povratka",
                                                labelStyle: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          SizedBox(
                                            width: 300,
                                            child: FormBuilderTextField(
                                              enabled: false,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                              initialValue:
                                                  reservation?.reservationNo
                                                      ?.toString() ??
                                                  "",
                                              name: "",
                                              decoration: InputDecoration(
                                                labelText: "Broj rezervacije",
                                                labelStyle: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 300,
                                            child: FormBuilderTextField(
                                              enabled: false,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                              initialValue:
                                                  "${reservation?.user?.firstName ?? ""} ${reservation?.user?.lastName ?? ""}",
                                              name: "",
                                              decoration: InputDecoration(
                                                labelText: "Kreirao/la",
                                                labelStyle: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 300,
                                            child: FormBuilderTextField(
                                              enabled: false,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                              initialValue: reservation
                                                  ?.room
                                                  ?.roomType
                                                  ?.name,
                                              name: "",
                                              decoration: InputDecoration(
                                                labelText: "Vrsta sobe",
                                                labelStyle: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          SizedBox(
                                            width: 300,
                                            child: FormBuilderTextField(
                                              enabled: false,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                              initialValue: reservation!
                                                  .formatedCreatedOn,
                                              name: "",
                                              decoration: InputDecoration(
                                                labelText:
                                                    "Datum i vrijeme kreiranja rezervacije",
                                                labelStyle: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 300,
                                            child: FormBuilderTextField(
                                              enabled: false,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                              initialValue: reservation!
                                                  .offerDiscount
                                                  ?.discountType
                                                  ?.name,
                                              name: "",
                                              decoration: InputDecoration(
                                                labelText: "Iskorišten popust",
                                                labelStyle: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 300,
                                            child: FormBuilderTextField(
                                              enabled: false,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                              initialValue:
                                                  "${FormatHelper.formatNumber(reservation!.totalCost!)} KM",
                                              name: "",
                                              decoration: InputDecoration(
                                                labelText:
                                                    "Ukupni iznos za plaćanje",
                                                labelStyle: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  FormBuilder(
                                    initialValue: reservationData,
                                    key: formBuilderKey,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 300,
                                          child: FormBuilderTextField(
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(
                                                RegExp(r'^\d+\.?\d{0,2}'),
                                              ),
                                            ],
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                            name: "paidAmount",
                                            decoration: InputDecoration(
                                              labelText: "Uplaćeni iznos",
                                              labelStyle: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                            validator:
                                                FormBuilderValidators.compose([
                                                  FormBuilderValidators.required(
                                                    errorText:
                                                        "Ovo polje je obavezno",
                                                  ),
                                                ]),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 300,
                                          child: FormBuilderDropdown(
                                            items:
                                                getReservationStatusDropdownItems(),
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                            name: "reservationStatusId",
                                            decoration: InputDecoration(
                                              labelText: "Status rezervacije",
                                              labelStyle: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                            validator:
                                                FormBuilderValidators.compose([
                                                  FormBuilderValidators.required(
                                                    errorText:
                                                        "Ovo polje je obavezno",
                                                  ),
                                                ]),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        child: Text("Sačuvaj promjene"),
                                        onPressed: saveChanges,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text(
                                        "Putnici",
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.blueGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Column(
                                    children: reservation!.passengers!
                                        .map(
                                          (x) => Card(
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                16.0,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                spacing: 10,
                                                children: [
                                                  SizedBox(
                                                    width: 250,
                                                    child: FormBuilderTextField(
                                                      enabled: false,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                      initialValue: x.fullName,
                                                      name: "",
                                                      decoration:
                                                          InputDecoration(
                                                            labelText:
                                                                "Ime i prezime",
                                                            labelStyle:
                                                                TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                          ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 150,
                                                    child: FormBuilderTextField(
                                                      enabled: false,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                      initialValue: DateFormat(
                                                        "dd.MM.yyyy",
                                                      ).format(x.dateOfBirth!),
                                                      name: "",
                                                      decoration:
                                                          InputDecoration(
                                                            labelText:
                                                                "Datum rođenja",
                                                            labelStyle:
                                                                TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                          ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 190,
                                                    child: FormBuilderTextField(
                                                      enabled: false,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                      initialValue:
                                                          x.phoneNumber,
                                                      name: "",
                                                      decoration:
                                                          InputDecoration(
                                                            labelText:
                                                                "Broj telefona",
                                                            labelStyle:
                                                                TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text(
                                        "Dokazi o uplati",
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.blueGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Wrap(
                                      spacing: 20,
                                      children: getReservationPaymentList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : DialogHelper.openSpinner(
              context,
              "Učitavam podatke o rezervaciji...",
            ),
    );
  }

  Future fetchReservationData() async {
    reservation = await reservationProvider.getById(widget.reservationId);

    reservationData["paidAmount"] = FormatHelper.formatNumber(
      reservation!.paidAmount!,
    );
    reservationData["reservationStatusId"] = reservation!.reservationStatusId;

    setState(() {});
  }

  Future fetchReservationStatusData() async {
    reservationStatusList =
        await entityCodeValueProvider.GetReservationStatusList();

    setState(() {});
  }

  List<DropdownMenuItem> getReservationStatusDropdownItems() {
    var list = [
      DropdownMenuItem(value: "", child: Text("-- Status rezervacije --")),
    ];

    if (reservationStatusList == null) return list;

    for (var reservationStatus in reservationStatusList!) {
      var dropdownItem = DropdownMenuItem(
        value: reservationStatus.id!,
        child: Text(reservationStatus.name ?? ""),
      );
      list.add(dropdownItem);
    }

    return list;
  }

  List<Widget> getReservationPaymentList() {
    List<Widget> list = [];

    if (reservation == null ||
        reservation!.reservationPayments == null ||
        reservation!.reservationPayments!.isEmpty) {
      return list;
    }

    for (var item in reservation!.reservationPayments!) {
      list.add(
        InkWell(
          child: Column(
            children: [
              Icon(Icons.receipt, color: AppColors.primary, size: 40),
              Text(
                item.documentName?.substring(
                      0,
                      min(15, item.documentName!.length),
                    ) ??
                    "",
              ),
            ],
          ),
          onTap: () async {
            await openFile(item.documentBytes!, item.documentName!);
          },
        ),
      );
    }

    return list;
  }

  Future openFile(String base64String, String fileName) async {
    Uint8List bytes = base64Decode(base64String);

    Directory dir = await getTemporaryDirectory();
    String savePath = "${dir.path}/$fileName";

    File file = File(savePath);
    await file.writeAsBytes(bytes);

    await OpenFile.open(savePath);
  }

  Future saveChanges() async {
    bool isValidForm = formBuilderKey.currentState!.validate();

    if (isValidForm == false) return;

    formBuilderKey.currentState!.save();
    var json = formBuilderKey.currentState!.value;

    try {
      await reservationProvider.addPayment(widget.reservationId, json);

      DialogHelper.openDialog(context, "Uspješno sačuvane promjene", () {
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                UpdateReservationScreen(widget.offer, widget.reservationId),
          ),
        );
      });
    } on Exception catch (ex) {
      DialogHelper.openDialog(context, ex.toString(), () {
        Navigator.of(context).pop();
      });
    }
  }
}
