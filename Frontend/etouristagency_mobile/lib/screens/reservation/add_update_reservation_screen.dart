import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:accordion/accordion.dart';
import 'package:etouristagency_mobile/consts/app_colors.dart';
import 'package:etouristagency_mobile/consts/app_constants.dart';
import 'package:etouristagency_mobile/helpers/dialog_helper.dart';
import 'package:etouristagency_mobile/helpers/format_helper.dart';
import 'package:etouristagency_mobile/models/offer/offer.dart';
import 'package:etouristagency_mobile/models/reservation/reservation.dart';
import 'package:etouristagency_mobile/models/reservation/reservation_payment.dart';
import 'package:etouristagency_mobile/models/room/room.dart';
import 'package:etouristagency_mobile/providers/offer_provider.dart';
import 'package:etouristagency_mobile/providers/reservation_provider.dart';
import 'package:etouristagency_mobile/screens/hotel/hotel_images_dialog.dart';
import 'package:etouristagency_mobile/screens/master_screen.dart';
import 'package:etouristagency_mobile/screens/offer/offer_details_screen.dart';
import 'package:etouristagency_mobile/screens/reservation/my_reservations_list_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class AddUpdateReservationScreen extends StatefulWidget {
  final String offerId;
  final String? roomId;
  final String? reservationId;
  const AddUpdateReservationScreen(
    this.offerId,
    this.roomId,
    this.reservationId, {
    super.key,
  });

  @override
  State<AddUpdateReservationScreen> createState() =>
      _AddUpdateReservationScreenState();
}

class _AddUpdateReservationScreenState
    extends State<AddUpdateReservationScreen> {
  Offer? offer;
  Room? room;
  late final OfferProvider offerProvider;
  final List<GlobalKey<FormBuilderState>> formBuilderKeys = [];
  final TextEditingController noteEditingController = TextEditingController();
  late final ReservationProvider reservationProvider;
  Reservation? reservation;
  List<Map<String, dynamic>> initialValues = [];
  List<ReservationPayment> addedPayments = [];
  bool _isProcessStarted = false;
  bool _isEditingEnabled = true;

  @override
  void initState() {
    if (widget.reservationId == null) {
      addNewPassenger();
    }
    offerProvider = OfferProvider();
    reservationProvider = ReservationProvider();
    fetchOfferData();
    fetchReservationData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      isBackButtonVisible: widget.reservationId == null,
      onClickMethod: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => OfferDetailsScreen(widget.offerId),
          ),
        );
      },
      widget.reservationId == null
          ? "Kreiranje rezervacije"
          : "Pregled rezervacije",
      offer != null
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsetsGeometry.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      color: AppColors.lighterBlue,
                      child: Padding(
                        padding: EdgeInsetsGeometry.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            offer!.offerImage != null
                                ? Image.memory(
                                    base64Decode(
                                      offer!.offerImage!.imageBytes!,
                                    ),
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  )
                                : SizedBox(),
                            SizedBox(height: 10),
                            Center(
                              child: Text(
                                "${offer!.hotel?.name ?? ""}",
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: getStarIconsOnHotel(
                                offer!.hotel!.starRating!,
                              ),
                            ),
                            Center(
                              child: Text(
                                "${offer!.hotel!.city!.name}, ${offer!.hotel!.city!.country!.name}",
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Datum polaska: ${offer!.formattedStartDateTime}",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              "Datum povratka: ${offer!.formatedEndDateTime}",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              "Tip usluge: ${offer!.boardType!.name}",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              "Broj noćenja: ${offer!.numberOfNights?.toString() ?? ""}",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              "Mjesto polaska: ${offer!.departurePlace ?? ""}",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              "Prevoznik: ${offer!.carriers ?? ""}",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            reservation != null
                                ? Text(
                                    "ID rezervacije: ${reservation!.reservationNo}",
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  )
                                : SizedBox(),
                            reservation != null
                                ? Row(
                                    spacing: 5,
                                    children: [
                                      Text(
                                        "Status rezervacije:",
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(
                                        reservation!.reservationStatus!.name ??
                                            "",
                                        style: TextStyle(
                                          color: getColorForReservationStatus(
                                            reservation!.reservationStatusId!
                                                .toUpperCase(),
                                          ),
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox(),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  padding: EdgeInsets.all(0),
                                  icon: Icon(
                                    Icons.description,
                                    color: AppColors.primary,
                                    size: 40,
                                  ),
                                  onPressed: offer?.offerDocument != null
                                      ? () async {
                                          await saveAndOpenDocument(
                                            context,
                                            offer!.offerDocument!.documentName!,
                                            offer!
                                                .offerDocument!
                                                .documentBytes!,
                                          );
                                        }
                                      : null,
                                ),
                                reservation != null
                                    ? Column(
                                        children: [
                                          Text(
                                            "Uplaćeno",
                                            style: TextStyle(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            "${FormatHelper.formatNumber(reservation!.paidAmount!)} KM / ${FormatHelper.formatNumber(reservation!.totalCost!)} KM",
                                            style: TextStyle(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      )
                                    : SizedBox(),
                                IconButton(
                                  padding: EdgeInsets.all(0),
                                  icon: Icon(
                                    Icons.image,
                                    color: AppColors.primary,
                                    size: 40,
                                  ),
                                  onPressed: () async {
                                    await showDialog(
                                      context: context,
                                      builder: (context) =>
                                          HotelImageDialog(offer!.hotelId!),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Odabrana soba",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 10),
                    Card(
                      color: AppColors.lighterBlue,
                      child: SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(room!.roomType!.name!),
                                  SizedBox(width: 5),
                                  Row(
                                    children: getPersonIconsForRoom(
                                      room!.roomType!.roomCapacity!,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Text(room!.shortDescription ?? ""),
                              SizedBox(height: 5),
                              Text(
                                "Cijena po osobi: ${FormatHelper.formatNumber(room!.discountedPrice!)} KM",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Putnici",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    Accordion(
                      contentBackgroundColor: AppColors.lighterBlue,
                      contentBorderColor: AppColors.lighterBlue,
                      headerBackgroundColor: AppColors.primary,
                      maxOpenSections: 1,
                      children: getAccordionItems(),
                    ),
                    _isEditingEnabled &&
                            room!.roomType!.roomCapacity! >
                                formBuilderKeys.length
                        ? Center(
                            child: ElevatedButton(
                              onPressed: addNewPassenger,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Dodaj putnika"),
                                  SizedBox(width: 2),
                                  Icon(
                                    Icons.add,
                                    color: const Color.fromARGB(
                                      255,
                                      59,
                                      103,
                                      179,
                                    ),
                                    weight: 100,
                                    size: 23,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : SizedBox(),
                    SizedBox(height: 10),
                    widget.reservationId != null
                        ? Text(
                            "Uplate",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          )
                        : SizedBox(),
                    widget.reservationId != null
                        ? SizedBox(height: 10)
                        : SizedBox(),
                    widget.reservationId != null
                        ? Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: getDocumentElements(),
                          )
                        : SizedBox(),
                    widget.reservationId != null
                        ? SizedBox(height: 10)
                        : SizedBox(),
                    TextField(
                      minLines: 3,
                      maxLines: 6,
                      enabled: _isEditingEnabled,
                      controller: noteEditingController,
                      decoration: InputDecoration(labelText: "Napomena"),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        widget.reservationId == null || !_isEditingEnabled
                            ? SizedBox()
                            : ElevatedButton(
                                onPressed: cancelReservation,
                                child: Text(
                                  "Otkaži",
                                  style: TextStyle(color: AppColors.darkRed),
                                ),
                              ),
                        _isEditingEnabled
                            ? ElevatedButton(
                                onPressed: !_isProcessStarted
                                    ? createUpdateReservation
                                    : null,
                                child: _isProcessStarted == false
                                    ? Text(
                                        widget.reservationId == null
                                            ? "Kreiraj rezervaciju"
                                            : "Sačuvaj promjene",
                                      )
                                    : SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.primary,
                                        ),
                                      ),
                              )
                            : SizedBox(),
                      ],
                    ),
                  ],
                ),
              ),
            )
          : DialogHelper.openSpinner(context, "Učitavam podatke..."),
    );
  }

  Future fetchOfferData() async {
    offer = Offer.fromJson(await offerProvider.getById(widget.offerId));
    room = offer!.rooms!.firstWhere((element) => element.id == widget.roomId);

    setState(() {});
  }

  List<Widget> getPersonIconsForRoom(int numberOfPerson) {
    List<Widget> list = [];

    for (int i = 0; i < numberOfPerson; i++) {
      list.add(Icon(Icons.person, color: AppColors.primary));
    }

    return list;
  }

  List<Widget> getStarIconsOnHotel(int numberOfStars) {
    List<Widget> list = [];

    for (int i = 0; i < numberOfStars; i++) {
      list.add(Icon(Icons.star, color: Colors.amber));
    }

    return list;
  }

  List<AccordionSection> getAccordionItems() {
    List<AccordionSection> list = [];

    int counter = 1;
    for (var item in formBuilderKeys) {
      list.add(
        AccordionSection(
          header: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Putnik ${counter}",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: FormBuilder(
            key: item,
            initialValue: initialValues[counter - 1],
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Column(
                children: [
                  Visibility(
                    visible: false,
                    child: FormBuilderTextField(name: "id"),
                  ),
                  FormBuilderTextField(
                    enabled: _isEditingEnabled,
                    name: "fullName",
                    decoration: InputDecoration(labelText: "Ime i prezime"),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                        errorText: "Ovo polje je obavezno",
                      ),
                    ]),
                  ),
                  FormBuilderDateTimePicker(
                    enabled: _isEditingEnabled,
                    name: "dateOfBirth",
                    decoration: InputDecoration(labelText: "Datum rođenja"),
                    format: DateFormat("dd.MM.yyyy"),
                    inputType: InputType.date,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                        errorText: "Ovo polje je obavezno",
                      ),
                    ]),
                  ),
                  FormBuilderTextField(
                    enabled: _isEditingEnabled,
                    name: "phoneNumber",
                    decoration: InputDecoration(labelText: "Broj telefona"),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                        errorText: "Ovo polje je obavezno",
                      ),
                      FormBuilderValidators.numeric(
                        errorText: "Ovo polje smije samo sadržavati brojeve.",
                      ),
                      FormBuilderValidators.minLength(
                        6,
                        errorText: "Ovo polje mora sadržavati barem 6 cifara.",
                      ),
                    ]),
                  ),
                  SizedBox(height: 5),
                  formBuilderKeys.length > 1 && _isEditingEnabled
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.delete_forever,
                                color: AppColors.darkRed,
                                size: 30,
                              ),
                              onPressed: () {
                                var indexToRemove = formBuilderKeys.indexOf(
                                  item,
                                );
                                formBuilderKeys.removeAt(indexToRemove);
                                initialValues.removeAt(indexToRemove);
                                setState(() {});
                              },
                            ),
                          ],
                        )
                      : SizedBox(),
                ],
              ),
            ),
          ),
        ),
      );

      counter++;
    }

    return list;
  }

  void addNewPassenger() {
    var key = GlobalKey<FormBuilderState>();
    formBuilderKeys.add(key);
    initialValues.add({});

    setState(() {});
  }

  Future createUpdateReservation() async {
    bool passengersValidations = validatePassengers();

    if (!passengersValidations) return;

    _isProcessStarted = true;
    setState(() {});

    var json = {
      "note": noteEditingController.text,
      "roomId": room!.id,
      "passengerList": [],
      "reservationPaymentList": [],
    };

    var listOfPassengers = [];

    for (var item in formBuilderKeys) {
      item.currentState!.save();
      var passenger = item.currentState!.value;
      var passengerJson = Map<String, dynamic>.from(passenger);
      passengerJson["dateOfBirth"] = (passengerJson["dateOfBirth"] as DateTime)
          .toIso8601String();

      listOfPassengers.add(passengerJson);
    }

    json["passengerList"] = listOfPassengers;
    json["reservationPaymentList"] = addedPayments
        .map((e) => e.toJson())
        .toList();

    if (widget.reservationId == null) {
      try {
        await reservationProvider.add(json);

        DialogHelper.openDialog(context, "Uspješno dodavanje rezervacije", () {
          Navigator.of(context).pop();
        });
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MyReservationsListScreen()),
        );
      } on Exception catch (ex) {
        _isProcessStarted = false;
        setState(() {});

        DialogHelper.openDialog(context, ex.toString(), () {
          Navigator.of(context).pop();
        }, type: DialogType.error);
      }
    } else {
      try {
        await reservationProvider.update(widget.reservationId!, json);

        DialogHelper.openDialog(context, "Uspješno sačuvane promjene", () {
          Navigator.of(context).pop();
        });
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MyReservationsListScreen()),
        );
      } on Exception catch (ex) {
        _isProcessStarted = false;
        setState(() {});

        DialogHelper.openDialog(context, ex.toString(), () {
          Navigator.of(context).pop();
        }, type: DialogType.error);
      }
    }
  }

  bool validatePassengers() {
    bool isValid = true;

    for (var item in formBuilderKeys) {
      if (!item.currentState!.validate()) {
        isValid = false;
      }
    }

    return isValid;
  }

  Future fetchReservationData() async {
    if (widget.reservationId == null) return;

    reservation = Reservation.fromJson(
      await reservationProvider.getById(widget.reservationId!),
    );

    noteEditingController.text = reservation!.note ?? "";

    initialValues = reservation!.passengers!.map((e) => e.toJson(e)).toList();
    for (int i = 0; i < reservation!.passengers!.length; i++) {
      formBuilderKeys.add(GlobalKey<FormBuilderState>());
    }

    _isEditingEnabled =
        reservation!.reservationStatusId!.toLowerCase() !=
        AppConstants.reservationCancelledGuid.toLowerCase();

    setState(() {});
  }

  Color getColorForReservationStatus(String? reservationStatusId) {
    switch (reservationStatusId) {
      case AppConstants.reservationNotPaidGuid:
        return Colors.black;
      case AppConstants.reservationPartiallyPaidGuid:
        return Colors.amber;
      case AppConstants.reservationPaidGuid:
        return Colors.green;
      case AppConstants.reservationCancelledGuid:
        return AppColors.darkRed;
      default:
        return AppColors.primary;
    }
  }

  Future<void> saveAndOpenDocument(
    BuildContext context,
    String fileName,
    String base64Bytes,
  ) async {
    try {
      Uint8List bytes = base64Decode(base64Bytes);

      Directory dir = await getTemporaryDirectory();
      String savePath = "${dir.path}/$fileName";

      File file = File(savePath);
      await file.writeAsBytes(bytes);

      await OpenFile.open(savePath);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Greška pri radu sa fajlom: $e")));
    }
  }

  List<Widget> getDocumentElements() {
    List<Widget> documents = [];

    if (reservation?.reservationPayments != null &&
        !reservation!.reservationPayments!.isEmpty) {
      for (var item in reservation!.reservationPayments!) {
        documents.add(
          InkWell(
            child: Column(
              children: [
                Icon(Icons.receipt, color: AppColors.primary, size: 30),
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
              await saveAndOpenDocument(
                context,
                item.documentName!,
                item.documentBytes!,
              );
            },
          ),
        );
      }
    }

    for (var item in addedPayments) {
      documents.add(
        Column(
          children: [
            InkWell(
              child: Column(
                children: [
                  Icon(Icons.receipt, color: AppColors.primary, size: 30),
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
                await saveAndOpenDocument(
                  context,
                  item.documentName!,
                  item.documentBytes!,
                );
              },
            ),
            SizedBox(height: 5),
            InkWell(
              child: Icon(Icons.clear, size: 15, color: AppColors.darkRed),
              onTap: () {
                var indexToRemove = addedPayments.indexOf(item);
                addedPayments.removeAt(indexToRemove);
                setState(() {});
              },
            ),
          ],
        ),
      );
    }

    if (_isEditingEnabled) {
      documents.add(
        IconButton(
          icon: Icon(Icons.add_circle, color: AppColors.primary),
          onPressed: pickAndUploadFile,
        ),
      );
    }

    return documents;
  }

  Future<void> pickAndUploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);

      var bytes = await file.readAsBytes();
      var fileName = result.files.single.name;

      addedPayments.add(
        ReservationPayment(null, base64Encode(bytes), fileName),
      );

      setState(() {});
    }
  }

  Future cancelReservation() async {
    DialogHelper.openConfirmationDialog(
      context,
      "Jeste li sigurni da želite otkazati ovu rezervaciju?",
      "Otkazivanjem ove rezervacije moguće je da nećete ostvariti povrat novca.",
      () async {
        await reservationProvider.cancelReservation(widget.reservationId!);
        Navigator.of(context).pop();
        DialogHelper.openDialog(context, "Uspješno otkazana rezervacija", () {
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => AddUpdateReservationScreen(
                widget.offerId,
                widget.roomId,
                widget.reservationId,
              ),
            ),
          );
        });
      },
    );
  }
}
