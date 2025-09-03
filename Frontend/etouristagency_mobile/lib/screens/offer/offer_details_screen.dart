import 'dart:io';
import 'dart:typed_data';
import 'package:etouristagency_mobile/consts/app_colors.dart';
import 'package:etouristagency_mobile/consts/screen_names.dart';
import 'package:etouristagency_mobile/helpers/dialog_helper.dart';
import 'package:etouristagency_mobile/helpers/format_helper.dart';
import 'package:etouristagency_mobile/models/offer/offer.dart';
import 'package:etouristagency_mobile/models/offer/offer_document_info.dart';
import 'package:etouristagency_mobile/models/offer/offer_image_info.dart';
import 'package:etouristagency_mobile/providers/offer_provider.dart';
import 'package:etouristagency_mobile/screens/hotel/hotel_images_dialog.dart';
import 'package:etouristagency_mobile/screens/master_screen.dart';
import 'package:etouristagency_mobile/screens/offer/last_minute_offer_list_screen.dart';
import 'package:etouristagency_mobile/screens/offer/offer_list_screen.dart';
import 'package:etouristagency_mobile/screens/reservation/add_update_reservation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class OfferDetailsScreen extends StatefulWidget {
  final String offerId;
  final String previousScreenName;
  const OfferDetailsScreen(this.previousScreenName, this.offerId, {super.key});

  @override
  State<OfferDetailsScreen> createState() => _OfferDetailsScreenState();
}

class _OfferDetailsScreenState extends State<OfferDetailsScreen> {
  Offer? offer;
  OfferDocumentInfo? offerDocumentInfo;
  OfferImageInfo? offerImageInfo;
  late final OfferProvider offerProvider;

  @override
  void initState() {
    offerProvider = OfferProvider();
    fetchOfferData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      "Kreiranje rezervacije",
      isBackButtonVisible: true,
      onClickMethod: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                widget.previousScreenName == ScreenNames.offerListScreen
                ? OfferListScreen()
                : LastMinuteOfferListScreen(),
          ),
        );
      },
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
                                offer?.hotel?.name ?? "",
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
                                          await saveAndOpenDocument(context);
                                        },
                                      )
                                    : SizedBox(width: 40.w),
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
                            children: [Text(offer!.description!)],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "Odaberite sobu...",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: 15.sp,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Column(children: getRoomElements()),
                  ],
                ),
              ),
            )
          : DialogHelper.openSpinner(context, "Učitavam podatke..."),
    );
  }

  List<Widget> getRoomElements() {
    List<Widget> list = [];

    if (offer == null) return list;

    for (var item in offer!.rooms!) {
      var card = SizedBox(
        width: double.infinity,
        child: Card(
          color: AppColors.lighterBlue,
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(item.roomType!.name ?? ""),
                    SizedBox(width: 10.w),
                    Row(
                      children: getPersonIconsForRoom(
                        item.roomType!.roomCapacity!,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                Text(item.shortDescription ?? ""),
                SizedBox(height: 5.h),
                Text(
                  "Cijena po osobi: ${FormatHelper.formatNumber(item.discountedPrice ?? 0)} KM",
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      getTextForRoomCard(item.remainingQuantity!),
                      style: TextStyle(
                        color: item.remainingQuantity! > 2
                            ? const Color.fromARGB(255, 76, 175, 79)
                            : AppColors.darkRed,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    item.isAvalible!
                        ? ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AddUpdateReservationScreen(
                                        widget.offerId,
                                        item.id,
                                        null,
                                        previousScreenName:
                                            widget.previousScreenName,
                                      ),
                                ),
                              );
                            },
                            child: Text("Odaberi"),
                          )
                        : SizedBox(),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
      list.add(card);
    }

    return list;
  }

  Future fetchOfferData() async {
    offer = Offer.fromJson(await offerProvider.getById(widget.offerId));
    if (!mounted) return;

    try {
      offerImageInfo = await offerProvider.getOfferImage(widget.offerId);
      if (!mounted) return;
    } on Exception catch (ex) {}

    try {
      offerDocumentInfo = await offerProvider.getOfferDocument(widget.offerId);
      if (!mounted) return;
    } on Exception catch (ex) {}

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

  Future<void> saveAndOpenDocument(BuildContext context) async {
    try {
      String fileName = offerDocumentInfo!.documentName!;
      Uint8List fileBytes = offerDocumentInfo!.documentBytes!;

      Directory dir = await getTemporaryDirectory();
      String savePath = "${dir.path}/$fileName";

      File file = File(savePath);
      await file.writeAsBytes(fileBytes);

      await OpenFile.open(savePath);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Greška pri radu sa fajlom: $e")));
    }
  }

  String getTextForRoomCard(int remainingQuantity) {
    if (remainingQuantity == 0) {
      return "Kapacitet je popunjen!";
    }

    if (remainingQuantity < 5) {
      return "Preostale još ${remainingQuantity} sobe!";
    }

    if (remainingQuantity >= 5) {
      return "Preostalo još ${remainingQuantity} soba!";
    }

    return "";
  }
}
