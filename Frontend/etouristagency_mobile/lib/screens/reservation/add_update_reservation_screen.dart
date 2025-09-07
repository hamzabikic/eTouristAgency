import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:accordion/accordion.dart';
import 'package:etouristagency_mobile/consts/app_colors.dart';
import 'package:etouristagency_mobile/consts/app_constants.dart';
import 'package:etouristagency_mobile/helpers/dialog_helper.dart';
import 'package:etouristagency_mobile/helpers/format_helper.dart';
import 'package:etouristagency_mobile/models/offer/offer.dart';
import 'package:etouristagency_mobile/models/offer/offer_document_info.dart';
import 'package:etouristagency_mobile/models/offer/offer_image_info.dart';
import 'package:etouristagency_mobile/models/passenger/passenger_document.dart';
import 'package:etouristagency_mobile/models/reservation/reservation.dart';
import 'package:etouristagency_mobile/models/reservation/reservation_payment_info.dart';
import 'package:etouristagency_mobile/models/room/room.dart';
import 'package:etouristagency_mobile/models/user/user.dart';
import 'package:etouristagency_mobile/providers/offer_provider.dart';
import 'package:etouristagency_mobile/providers/passenger_provider.dart';
import 'package:etouristagency_mobile/providers/reservation_provider.dart';
import 'package:etouristagency_mobile/providers/reservation_review_provider.dart';
import 'package:etouristagency_mobile/providers/user_provider.dart';
import 'package:etouristagency_mobile/screens/hotel/hotel_images_dialog.dart';
import 'package:etouristagency_mobile/screens/master_screen.dart';
import 'package:etouristagency_mobile/screens/offer/offer_details_screen.dart';
import 'package:etouristagency_mobile/screens/reservation/my_reservations_list_screen.dart';
import 'package:etouristagency_mobile/services/auth_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class AddUpdateReservationScreen extends StatefulWidget {
  final String offerId;
  final String? roomId;
  final String? reservationId;
  final String? previousScreenName;

  const AddUpdateReservationScreen(
    this.offerId,
    this.roomId,
    this.reservationId, {
    this.previousScreenName,
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
  OfferImageInfo? offerImageInfo;
  OfferDocumentInfo? offerDocumentInfo;
  late final OfferProvider offerProvider;
  final List<GlobalKey<FormBuilderState>> formBuilderKeys = [];
  final TextEditingController noteEditingController = TextEditingController();
  late final ReservationProvider reservationProvider;
  late final UserProvider userProvider;
  late final AuthService authService;
  late final PassengerProvider passengerProvider;
  Reservation? reservation;
  List<Map<String, dynamic>> initialValues = [];
  List<ReservationPaymentInfo> loadedPayments = [];
  List<ReservationPaymentInfo> addedPayments = [];
  List<PassengerDocument> passengerDocuments = [];
  bool _isProcessStarted = false;
  late final ReservationReviewProvider reservationReviewProvider;
  Map<String, dynamic> reviewRequestModel = {};
  bool _isEditable = false;
  bool _isReviewable = false;

  @override
  void initState() {
    if (widget.reservationId == null) {
      addNewPassenger();
    }
    userProvider = UserProvider();
    offerProvider = OfferProvider();
    reservationProvider = ReservationProvider();
    reservationReviewProvider = ReservationReviewProvider();
    authService = AuthService();
    passengerProvider = PassengerProvider();
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
            builder: (context) => OfferDetailsScreen(
              widget.previousScreenName ?? "",
              widget.offerId,
            ),
          ),
        );
      },
      widget.reservationId == null
          ? "Kreiranje rezervacije"
          : "Pregled rezervacije",
      offer != null
          ? SingleChildScrollView(
              child: Padding(
                padding: EdgeInsetsGeometry.all(32.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      color: AppColors.lighterBlue,
                      child: Padding(
                        padding: EdgeInsetsGeometry.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            offerImageInfo != null
                                ? Image.memory(
                                    offerImageInfo!.imageBytes!,
                                    height: 200.h,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  )
                                : SizedBox(),
                            SizedBox(height: 10.h),
                            Center(
                              child: Text(
                                "${offer!.hotel?.name ?? ""}",
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17.sp,
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
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              "Datum polaska: ${offer!.formattedStartDateTime}",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.sp,
                              ),
                            ),
                            Text(
                              "Datum povratka: ${offer!.formatedEndDateTime}",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.sp,
                              ),
                            ),
                            Text(
                              "Tip usluge: ${offer!.boardType!.name}",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.sp,
                              ),
                            ),
                            Text(
                              "Broj noćenja: ${offer!.numberOfNights?.toString() ?? ""}",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.sp,
                              ),
                            ),
                            Text(
                              "Mjesto polaska: ${offer!.departurePlace ?? ""}",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.sp,
                              ),
                            ),
                            Text(
                              "Prevoznik: ${offer!.carriers ?? ""}",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.sp,
                              ),
                            ),
                            (offer!.offerStatusId!.toLowerCase() ==
                                    AppConstants.inactiveOfferGuid
                                        .toLowerCase())
                                ? Text(
                                    "Ova ponuda je otkazana!",
                                    style: TextStyle(
                                      color: AppColors.darkRed,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.sp,
                                    ),
                                  )
                                : SizedBox(),
                            reservation != null
                                ? Text(
                                    "ID rezervacije: ${reservation!.reservationNo}",
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.sp,
                                    ),
                                  )
                                : SizedBox(),
                            reservation != null
                                ? Row(
                                    spacing: 5.w,
                                    children: [
                                      Text(
                                        "Status rezervacije:",
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.sp,
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
                                          fontSize: 15.sp,
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox(),
                            reservation != null
                                ? Row(
                                    spacing: 5.w,
                                    children: [
                                      Text(
                                        "Rok za prvu ratu (30%):",
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.sp,
                                        ),
                                      ),
                                      Text(
                                        offer!.formatedFirstPaymentDeadline,
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.sp,
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox(),
                            reservation != null
                                ? Row(
                                    spacing: 5.w,
                                    children: [
                                      Text(
                                        "Krajnji rok za uplatu:",
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.sp,
                                        ),
                                      ),
                                      Text(
                                        offer!.formatedLastPaymentDeadline,
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.sp,
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox(),
                            SizedBox(height: 10.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                offerDocumentInfo != null
                                    ? IconButton(
                                        padding: EdgeInsets.all(0),
                                        icon: Icon(
                                          Icons.description,
                                          color: AppColors.primary,
                                          size: 40.sp,
                                        ),
                                        onPressed: () async {
                                          await saveAndOpenDocument(
                                            context,
                                            offerDocumentInfo!.documentName!,
                                            offerDocumentInfo!.documentBytes!,
                                          );
                                        },
                                      )
                                    : SizedBox(width: 40.w),
                                reservation != null
                                    ? Column(
                                        children: [
                                          Text(
                                            "Uplaćeno",
                                            style: TextStyle(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.sp,
                                            ),
                                          ),
                                          Text(
                                            "${FormatHelper.formatNumber(reservation!.paidAmount!)} KM / ${FormatHelper.formatNumber(reservation!.totalCost!)} KM",
                                            style: TextStyle(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.sp,
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
                                    size: 40.sp,
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
                    SizedBox(height: 20.h),
                    Text(
                      "Opis putovanja",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: 15.sp,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        color: AppColors.lighterBlue,
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                offer!.description!,
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "Odabrana soba",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: 15.sp,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Card(
                      color: AppColors.lighterBlue,
                      child: SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    room!.roomType!.name!,
                                    style: TextStyle(fontSize: 14.sp),
                                  ),
                                  SizedBox(width: 5.w),
                                  Row(
                                    children: getPersonIconsForRoom(
                                      room!.roomType!.roomCapacity!,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                room!.shortDescription ?? "",
                                style: TextStyle(fontSize: 14.sp),
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                "Cijena po osobi: ${FormatHelper.formatNumber(room!.discountedPrice!)} KM",
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "Putnici",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: 15.sp,
                      ),
                    ),
                    Accordion(
                      contentBackgroundColor: AppColors.lighterBlue,
                      contentBorderColor: AppColors.lighterBlue,
                      headerBackgroundColor: AppColors.primary,
                      maxOpenSections: 1,
                      children: getAccordionItems(),
                    ),
                    _isEditable &&
                            room!.roomType!.roomCapacity! >
                                formBuilderKeys.length
                        ? Center(
                            child: ElevatedButton(
                              onPressed: addNewPassenger,
                              style: ElevatedButton.styleFrom(
                                textStyle: TextStyle(fontSize: 14.sp),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Dodaj putnika"),
                                  SizedBox(width: 2.w),
                                  Icon(
                                    Icons.add,
                                    color: const Color.fromARGB(
                                      255,
                                      59,
                                      103,
                                      179,
                                    ),
                                    weight: 100,
                                    size: 23.sp,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : SizedBox(),
                    SizedBox(height: 10.h),
                    widget.reservationId != null
                        ? Text(
                            "Uplate",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                              fontSize: 15.sp,
                            ),
                          )
                        : SizedBox(),
                    widget.reservationId != null
                        ? SizedBox(height: 10.h)
                        : SizedBox(),
                    widget.reservationId != null
                        ? Wrap(
                            spacing: 10.w,
                            runSpacing: 10.h,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: getDocumentElements(),
                          )
                        : SizedBox(),
                    widget.reservationId != null
                        ? SizedBox(height: 10.h)
                        : SizedBox(),
                    TextField(
                      minLines: 3,
                      maxLines: 6,
                      enabled: _isEditable,
                      controller: noteEditingController,
                      decoration: InputDecoration(
                        labelText: "Napomena",
                        labelStyle: TextStyle(fontSize: 14.sp),
                      ),
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        !_isEditable || widget.reservationId == null
                            ? SizedBox()
                            : ElevatedButton(
                                onPressed: cancelReservation,
                                style: ElevatedButton.styleFrom(
                                  textStyle: TextStyle(fontSize: 14.sp),
                                ),
                                child: Text(
                                  "Otkaži",
                                  style: TextStyle(color: AppColors.darkRed),
                                ),
                              ),
                        _isEditable
                            ? ElevatedButton(
                                onPressed: !_isProcessStarted
                                    ? createUpdateReservation
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  textStyle: TextStyle(fontSize: 14.sp),
                                ),
                                child: _isProcessStarted == false
                                    ? Text(
                                        widget.reservationId == null
                                            ? "Kreiraj rezervaciju"
                                            : "Sačuvaj promjene",
                                      )
                                    : SizedBox(
                                        height: 20.h,
                                        width: 20.w,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.w,
                                          color: AppColors.primary,
                                        ),
                                      ),
                              )
                            : SizedBox(),
                      ],
                    ),
                    _isReviewable
                        ? Row(
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  textStyle: TextStyle(fontSize: 14.sp),
                                ),
                                child: Text("Ostavi recenziju"),
                                onPressed: openReservationReviewDialog,
                              ),
                            ],
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            )
          : DialogHelper.openSpinner(context, "Učitavam podatke..."),
    );
  }

  Future fetchOfferData() async {
    var offerJson = await offerProvider.getById(widget.offerId);
    if (!mounted) return;

    offer = Offer.fromJson(offerJson);
    room = offer!.rooms!.firstWhere((element) => element.id == widget.roomId);

    try {
      offerImageInfo = await offerProvider.getOfferImage(widget.offerId);
    } on Exception catch (ex) {}

    try {
      offerDocumentInfo = await offerProvider.getOfferDocument(widget.offerId);
    } on Exception catch (ex) {}

    setState(() {});
  }

  List<Widget> getPersonIconsForRoom(int numberOfPerson) {
    List<Widget> list = [];

    for (int i = 0; i < numberOfPerson; i++) {
      list.add(Icon(Icons.person, color: AppColors.primary, size: 24.w));
    }

    return list;
  }

  List<Widget> getStarIconsOnHotel(int numberOfStars) {
    List<Widget> list = [];

    for (int i = 0; i < numberOfStars; i++) {
      list.add(Icon(Icons.star, color: Colors.amber, size: 24.w));
    }

    return list;
  }

  List<AccordionSection> getAccordionItems() {
    List<AccordionSection> list = [];

    int counter = 1;
    for (var item in formBuilderKeys) {
      final int index = counter - 1;

      list.add(
        AccordionSection(
          header: SizedBox(
            height: 55.h,
            child: Padding(
              padding: EdgeInsets.only(left: 16.w, right: 8.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Putnik ${counter}",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                  formBuilderKeys.length > 1 && _isEditable
                      ? IconButton(
                          icon: Icon(
                            Icons.delete_forever,
                            color: AppColors.darkRed,
                            size: 25.sp,
                          ),
                          onPressed: () {
                            formBuilderKeys.removeAt(index);
                            initialValues.removeAt(index);
                            passengerDocuments.removeAt(index);
                            setState(() {});
                          },
                        )
                      : SizedBox(),
                ],
              ),
            ),
          ),
          content: FormBuilder(
            key: item,
            initialValue: initialValues[counter - 1],
            child: Padding(
              padding: EdgeInsets.only(left: 8.w, right: 8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: false,
                    child: FormBuilderTextField(name: "id"),
                  ),
                  FormBuilderTextField(
                    enabled: _isEditable,
                    name: "fullName",
                    decoration: InputDecoration(
                      labelText: "Ime i prezime",
                      labelStyle: TextStyle(fontSize: 14.sp),
                    ),
                    style: TextStyle(fontSize: 14.sp),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                        errorText: "Ovo polje je obavezno",
                      ),
                    ]),
                  ),
                  FormBuilderDateTimePicker(
                    enabled: _isEditable,
                    name: "dateOfBirth",
                    decoration: InputDecoration(
                      labelText: "Datum rođenja",
                      labelStyle: TextStyle(fontSize: 14.sp),
                    ),
                    style: TextStyle(fontSize: 14.sp),
                    format: DateFormat("dd.MM.yyyy"),
                    inputType: InputType.date,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                        errorText: "Ovo polje je obavezno",
                      ),
                    ]),
                  ),
                  FormBuilderTextField(
                    enabled: _isEditable,
                    name: "phoneNumber",
                    decoration: InputDecoration(
                      labelText: "Broj telefona",
                      labelStyle: TextStyle(fontSize: 14.sp),
                    ),
                    style: TextStyle(fontSize: 14.sp),
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
                  SizedBox(height: 5.h),
                  Text("Pasoš/lična karta", style: TextStyle(fontSize: 14.sp)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.description,
                              color: AppColors.primary,
                              size: 24.w,
                            ),
                            onPressed: () async {
                              await openPassengerDocument(index);
                            },
                          ),
                          SizedBox(width: 20.w),
                          _isEditable
                              ? ElevatedButton(
                                  onPressed: () async {
                                    await pickAndUploadPassengerDocument(index);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(8.w),
                                    textStyle: TextStyle(fontSize: 14.sp),
                                  ),
                                  child: Icon(
                                    Icons.upload,
                                    color: AppColors.primary,
                                    size: 24.w,
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ],
                  ),
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
    passengerDocuments.add(PassengerDocument(null, null));

    setState(() {});
  }

  Future createUpdateReservation() async {
    bool passengersValidations = validatePassengers();

    if (!passengersValidations) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Neuspješna validacija: Neka od obaveznih polja nisu unesena ili su unesena u neispravnom formatu.",
            style: TextStyle(fontSize: 14.sp),
          ),
        ),
      );

      return;
    }

    _isProcessStarted = true;
    setState(() {});

    var json = {
      "note": noteEditingController.text,
      "roomId": room!.id,
      "passengerList": [],
      "reservationPaymentList": [],
    };

    var listOfPassengers = [];

    int counter = 0;
    for (var item in formBuilderKeys) {
      item.currentState!.save();
      var passenger = item.currentState!.value;
      var passengerJson = Map<String, dynamic>.from(passenger);
      passengerJson["dateOfBirth"] = (passengerJson["dateOfBirth"] as DateTime)
          .toIso8601String();
      passengerJson["passengerDocument"] = passengerDocuments[counter].toJson();

      listOfPassengers.add(passengerJson);

      counter++;
    }

    json["passengerList"] = listOfPassengers;
    json["reservationPaymentList"] = addedPayments
        .map((e) => e.toJson())
        .toList();

    if (widget.reservationId == null) {
      try {
        await reservationProvider.add(json);
        if (!mounted) return;

        DialogHelper.openDialog(context, "Uspješno dodavanje rezervacije", () {
          Navigator.of(context).pop();
        });
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MyReservationsListScreen()),
        );
      } on Exception catch (ex) {
        _isProcessStarted = false;
        setState(() {});

        DialogHelper.openDialog(
          context,
          ex.toString().replaceFirst("Exception: ", ""),
          () {
            Navigator.of(context).pop();
          },
          type: DialogType.error,
        );
      }
    } else {
      try {
        await reservationProvider.update(widget.reservationId!, json);
        if (!mounted) return;

        DialogHelper.openDialog(context, "Uspješno sačuvane promjene", () {
          Navigator.of(context).pop();
        });
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MyReservationsListScreen()),
        );
      } on Exception catch (ex) {
        _isProcessStarted = false;
        setState(() {});

        DialogHelper.openDialog(
          context,
          ex.toString().replaceFirst("Exception: ", ""),
          () {
            Navigator.of(context).pop();
          },
          type: DialogType.error,
        );
      }
    }
  }

  Future<bool> verifyUser() async {
    var userId = await authService.getUserId();

    if (userId == null) return false;

    var userJson = await userProvider.getById(userId);
    if (!mounted) return false;

    var user = User.fromJson(userJson);

    if (!user.isVerified!) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.reservationId != null
                ? "Da biste mogli uređivati podatke o rezervaciji, Vaš e-mail nalog mora biti verifikovan."
                : "Da biste mogli kreirati rezervaciju, Vaš e-mail nalog mora biti verifikovan.",
            style: TextStyle(fontSize: 14.sp),
          ),
        ),
      );

      return false;
    }

    return true;
  }

  bool validatePassengers() {
    bool isValid = true;

    for (var item in formBuilderKeys) {
      if (!item.currentState!.validate()) {
        isValid = false;
      }
    }

    for (var passengerDocument in passengerDocuments) {
      if (passengerDocument.documentBytes == null ||
          passengerDocument.documentName == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Upload putovnice putnika je obavezan.",
              style: TextStyle(fontSize: 14.sp),
            ),
          ),
        );

        return false;
      }
    }

    return isValid;
  }

  Future fetchReservationData() async {
    bool isUserVerified = await verifyUser();

    if (widget.reservationId == null) {
      _isEditable = isUserVerified;
      setState(() {});

      return;
    }

    var reservationJson = await reservationProvider.getById(
      widget.reservationId!,
    );

    if (!mounted) return;

    reservation = Reservation.fromJson(reservationJson);

    noteEditingController.text = reservation!.note ?? "";

    for (var passenger in reservation!.passengers!) {
      try {
        var passengerDocument = await passengerProvider.getDocumentById(
          passenger.id!,
        );

        if (!mounted) return;

        passengerDocuments.add(passengerDocument);
      } on Exception catch (ex) {
        passengerDocuments.add(PassengerDocument(null, null));
      }
    }

    initialValues = reservation!.passengers!.map((e) => e.toJson(e)).toList();
    for (int i = 0; i < reservation!.passengers!.length; i++) {
      formBuilderKeys.add(GlobalKey<FormBuilderState>());
    }

    _isEditable = reservation!.isEditable! && isUserVerified;
    _isReviewable = reservation!.isReviewable! && isUserVerified;

    await loadReservationPayments();

    setState(() {});
  }

  Future loadReservationPayments() async {
    if (reservation == null ||
        reservation!.reservationPayments == null ||
        reservation!.reservationPayments!.isEmpty)
      return;

    for (var item in reservation!.reservationPayments!) {
      var reservationPaymentInfo = await reservationProvider
          .getReservationPaymentDocument(item.id!);
      if (!mounted) return;

      loadedPayments.add(reservationPaymentInfo);
    }
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
    Uint8List fileBytes,
  ) async {
    try {
      Directory dir = await getTemporaryDirectory();
      String savePath = "${dir.path}/$fileName";

      File file = File(savePath);
      await file.writeAsBytes(fileBytes);

      await OpenFile.open(savePath);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Greška pri radu sa fajlom: $e",
            style: TextStyle(fontSize: 14.sp),
          ),
        ),
      );
    }
  }

  Future<void> openPassengerDocument(int index) async {
    var passengerDocument = passengerDocuments[index];

    if (passengerDocument.documentBytes == null ||
        passengerDocument.documentName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Ovaj putnik nema dokument.",
            style: TextStyle(fontSize: 14.sp),
          ),
        ),
      );

      return;
    }

    await saveAndOpenDocument(
      context,
      passengerDocument.documentName!,
      passengerDocument.documentBytes!,
    );
  }

  List<Widget> getDocumentElements() {
    List<Widget> documents = [];

    if (loadedPayments.isNotEmpty) {
      for (var item in loadedPayments) {
        documents.add(
          InkWell(
            child: Column(
              children: [
                Icon(Icons.receipt, color: AppColors.primary, size: 30.sp),
                Text(
                  item.documentName?.substring(
                        0,
                        min(15, item.documentName!.length),
                      ) ??
                      "",
                  style: TextStyle(fontSize: 12.sp),
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
                  Icon(Icons.receipt, color: AppColors.primary, size: 30.sp),
                  Text(
                    item.documentName?.substring(
                          0,
                          min(15, item.documentName!.length),
                        ) ??
                        "",
                    style: TextStyle(fontSize: 12.sp),
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
            SizedBox(height: 5.h),
            InkWell(
              child: Icon(Icons.clear, size: 15.sp, color: AppColors.darkRed),
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

    if (_isEditable) {
      documents.add(
        IconButton(
          icon: Icon(Icons.add_circle, color: AppColors.primary, size: 40.w),
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

      addedPayments.add(ReservationPaymentInfo(bytes, fileName));

      setState(() {});
    }
  }

  Future<void> pickAndUploadPassengerDocument(int index) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);

      var bytes = await file.readAsBytes();
      var fileName = result.files.single.name;

      passengerDocuments[index] = PassengerDocument(fileName, bytes);

      setState(() {});
    }
  }

  Future cancelReservation() async {
    DialogHelper.openConfirmationDialog(
      context,
      "Jeste li sigurni da želite otkazati ovu rezervaciju?",
      "Otkazivanjem ove rezervacije moguće je da nećete ostvariti povrat novca.",
      () async {
        try {
          await reservationProvider.cancelReservation(widget.reservationId!);

          if (!mounted) return;
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
        } on Exception catch (ex) {
          DialogHelper.openDialog(
            context,
            ex.toString().replaceFirst("Exception: ", ""),
            () {
              Navigator.of(context).pop();
            },
            type: DialogType.error,
          );
        }
      },
    );
  }

  void openReservationReviewDialog() {
    showDialog(
      context: context,
      builder: (context) {
        var errorMessage = "";
        bool isReviewInProcess = false;

        return StatefulBuilder(
          builder: (context, setStateDialog) => Dialog(
            child: IntrinsicHeight(
              child: Padding(
                padding: EdgeInsets.all(15.w),
                child: Column(
                  children: [
                    Text(
                      "Recenzija",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.blueGrey,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    errorMessage.isNotEmpty
                        ? Text(
                            errorMessage,
                            style: TextStyle(
                              color: AppColors.darkRed,
                              fontSize: 14.sp,
                            ),
                          )
                        : SizedBox(),
                    SizedBox(height: 10.h),
                    Text(
                      "Ocjena za smještaj",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 14.sp,
                      ),
                    ),
                    RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemSize: 40.w,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.w),
                      itemBuilder: (context, _) =>
                          Icon(Icons.star, color: Colors.amber),
                      onRatingUpdate: (rating) {
                        reviewRequestModel["accommodationRating"] = rating
                            .toInt();
                      },
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "Ocjena za uslugu",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 14.sp,
                      ),
                    ),
                    RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemSize: 40.w,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.w),
                      itemBuilder: (context, _) =>
                          Icon(Icons.star, color: Colors.amber),
                      onRatingUpdate: (rating) {
                        reviewRequestModel["serviceRating"] = rating.toInt();
                      },
                    ),
                    SizedBox(height: 10.h),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Ukratko opišite Vaše iskustvo",
                        labelStyle: TextStyle(fontSize: 14.sp),
                      ),
                      style: TextStyle(fontSize: 14.sp),
                      minLines: 5,
                      maxLines: 5,
                      onChanged: (value) {
                        reviewRequestModel["description"] = value;
                      },
                    ),
                    SizedBox(height: 20.h),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(fontSize: 14.sp),
                      ),
                      child: !isReviewInProcess
                          ? Text("Pošalji")
                          : SizedBox(
                              height: 20.h,
                              width: 20.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.w,
                                color: AppColors.primary,
                              ),
                            ),
                      onPressed: () async {
                        if (reviewRequestModel["accommodationRating"] == null ||
                            reviewRequestModel["serviceRating"] == null ||
                            reviewRequestModel["description"] == null) {
                          setStateDialog(() {
                            errorMessage = "Sva polja su obavezna.";
                          });

                          return;
                        } else {
                          errorMessage = "";
                        }

                        isReviewInProcess = true;
                        setStateDialog(() {});

                        reviewRequestModel["id"] = reservation!.id!;

                        try {
                          await reservationReviewProvider.add(
                            reviewRequestModel,
                          );
                          if (!mounted) return;

                          DialogHelper.openDialog(
                            context,
                            "Uspješno ste poslali recenziju",
                            () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AddUpdateReservationScreen(
                                        widget.offerId,
                                        widget.roomId,
                                        widget.reservationId,
                                      ),
                                ),
                              );
                            },
                          );
                        } on Exception catch (ex) {
                          DialogHelper.openDialog(
                            context,
                            ex.toString().replaceFirst("Exception: ", ""),
                            () {
                              Navigator.of(context).pop();
                            },
                            type: DialogType.error,
                          );
                        }

                        isReviewInProcess = false;
                        setStateDialog(() {});
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
