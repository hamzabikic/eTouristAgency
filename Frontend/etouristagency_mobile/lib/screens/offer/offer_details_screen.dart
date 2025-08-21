import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:etouristagency_mobile/consts/app_colors.dart';
import 'package:etouristagency_mobile/helpers/dialog_helper.dart';
import 'package:etouristagency_mobile/helpers/format_helper.dart';
import 'package:etouristagency_mobile/models/offer/offer.dart';
import 'package:etouristagency_mobile/providers/offer_provider.dart';
import 'package:etouristagency_mobile/screens/hotel/hotel_images_dialog.dart';
import 'package:etouristagency_mobile/screens/master_screen.dart';
import 'package:etouristagency_mobile/screens/offer/offer_list_screen.dart';
import 'package:etouristagency_mobile/screens/reservation/add_update_reservation_screen.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class OfferDetailsScreen extends StatefulWidget {
  final String offerId;
  const OfferDetailsScreen(this.offerId, {super.key});

  @override
  State<OfferDetailsScreen> createState() => _OfferDetailsScreenState();
}

class _OfferDetailsScreenState extends State<OfferDetailsScreen> {
  Offer? offer;
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
      onClickMethod: (){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> OfferListScreen()));
      },
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
                                          await saveAndOpenDocument(context);
                                        }
                                      : null,
                                ),
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
                      "Odaberite sobu...",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 10),
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

    var avalibleRooms = offer!.rooms!
        .where((element) => element.isAvalible == true)
        .toList();

    if (avalibleRooms.isEmpty) {
      list.add(
        Center(
          child: Text(
            "Trenutno nema dostupnih soba za ovu ponudu.",
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      );
      return list;
    }

    for (var item in avalibleRooms) {
      var card = SizedBox(
        width: double.infinity,
        child: Card(
          color: AppColors.lighterBlue,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(item.roomType!.name ?? ""),
                    SizedBox(width: 10),
                    Row(
                      children: getPersonIconsForRoom(
                        item.roomType!.roomCapacity!,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Text(item.shortDescription ?? ""),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Cijena po osobi: ${FormatHelper.formatNumber(item.discountedPrice ?? 0)} KM",
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => AddUpdateReservationScreen(
                              widget.offerId,
                              item.id,
                              null,
                            ),
                          ),
                        );
                      },
                      child: Text("Odaberi"),
                    ),
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
      String fileName = offer!.offerDocument!.documentName!;
      String base64Bytes = offer!.offerDocument!.documentBytes!;

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
}
