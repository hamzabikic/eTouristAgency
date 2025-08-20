import 'dart:convert';

import 'package:accordion/accordion.dart';
import 'package:etouristagency_mobile/consts/app_colors.dart';
import 'package:etouristagency_mobile/consts/app_constants.dart';
import 'package:etouristagency_mobile/helpers/dialog_helper.dart';
import 'package:etouristagency_mobile/helpers/format_helper.dart';
import 'package:etouristagency_mobile/models/offer/offer.dart';
import 'package:etouristagency_mobile/models/reservation/reservation.dart';
import 'package:etouristagency_mobile/models/room/room.dart';
import 'package:etouristagency_mobile/providers/offer_provider.dart';
import 'package:etouristagency_mobile/providers/reservation_provider.dart';
import 'package:etouristagency_mobile/screens/hotel/hotel_images_dialog.dart';
import 'package:etouristagency_mobile/screens/master_screen.dart';
import 'package:etouristagency_mobile/screens/offer/offer_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

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

  @override
  void initState() {
    addNewPassenger();
    offerProvider = OfferProvider();
    reservationProvider = ReservationProvider();
    fetchOfferData();
    fetchReservationData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
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
                                  onPressed: () {},
                                ),
                                reservation != null ?
                                Column(
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
                                ) : SizedBox(),
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
                    Accordion(
                      contentBackgroundColor: AppColors.lighterBlue,
                      contentBorderColor: AppColors.lighterBlue,
                      headerBackgroundColor: AppColors.primary,
                      maxOpenSections: 1,
                      children: getAccordionItems(),
                    ),
                    room!.roomType!.roomCapacity! > formBuilderKeys.length
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
                    TextField(
                      minLines: 3,
                      maxLines: 6,
                      controller: noteEditingController,
                      decoration: InputDecoration(labelText: "Napomena"),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: createUpdateReservation,
                          child: Text("Kreiraj rezervaciju"),
                        ),
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
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Column(
                children: [
                  FormBuilderTextField(
                    name: "fullName",
                    decoration: InputDecoration(labelText: "Ime i prezime"),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                        errorText: "Ovo polje je obavezno",
                      ),
                    ]),
                  ),
                  FormBuilderDateTimePicker(
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
                  formBuilderKeys.length > 1
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                formBuilderKeys.remove(item);
                                setState(() {});
                              },
                              child: Text(
                                "Ukloni",
                                style: TextStyle(color: AppColors.darkRed),
                              ),
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

    setState(() {});
  }

  Future createUpdateReservation() async {
    bool passengersValidations = validatePassengers();

    if (!passengersValidations) return;

    var json = {
      "note": noteEditingController.text,
      "roomId": room!.id,
      "passengerList": [],
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

    if (widget.reservationId == null) {
      await reservationProvider.add(json);

      DialogHelper.openDialog(context, "Uspješno dodavanje rezervacije", () {
        Navigator.of(context).pop();
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => OfferListScreen()),
      );
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
      case AppConstants.reservationCancelled:
        return AppColors.darkRed;
      default:
        return AppColors.primary;
    }
  }
}
