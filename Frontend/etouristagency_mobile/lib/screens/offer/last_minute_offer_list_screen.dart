import 'dart:convert';

import 'package:etouristagency_mobile/consts/app_colors.dart';
import 'package:etouristagency_mobile/helpers/dialog_helper.dart';
import 'package:etouristagency_mobile/helpers/format_helper.dart';
import 'package:etouristagency_mobile/models/offer/offer.dart';
import 'package:etouristagency_mobile/models/paginated_list.dart';
import 'package:etouristagency_mobile/providers/offer_provider.dart';
import 'package:etouristagency_mobile/screens/master_screen.dart';
import 'package:flutter/material.dart';

class LastMinuteOfferListScreen extends StatefulWidget {
  const LastMinuteOfferListScreen({super.key});

  @override
  State<LastMinuteOfferListScreen> createState() =>
      _LastMinuteOfferListScreenState();
}

class _LastMinuteOfferListScreenState extends State<LastMinuteOfferListScreen> {
  late final OfferProvider offerProvider;
  PaginatedList<Offer>? paginatedList;
  Map<String, dynamic> queryStrings = {
    "page": 1,
    "isBookableNow": true,
    "isLastMinuteDiscountActive": true,
  };

  @override
  void initState() {
    offerProvider = OfferProvider();
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      "Last minute ponuda",
      paginatedList != null
          ? ListView.separated(
              itemCount: paginatedList!.listOfRecords.length,
              padding: EdgeInsetsGeometry.only(
                left: 30.0,
                right: 30.0,
                top: 16.0,
                bottom: 16.0,
              ),
              separatorBuilder: (context, index) => SizedBox(height: 15),
              itemBuilder: (context, index) {
                if (index == queryStrings["page"] * 15 - 1 &&
                    queryStrings["page"] < paginatedList!.totalPages) {
                  queryStrings["page"] = queryStrings["page"] + 1;
                  populateOffers();
                }

                var offer = paginatedList!.listOfRecords[index];

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  color: AppColors.lighterBlue,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        offer.offerImage != null
                            ? Image.memory(
                                base64Decode(
                                  paginatedList!
                                      .listOfRecords[index]
                                      .offerImage!
                                      .imageBytes!,
                                ),
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : SizedBox(
                                height: 200,
                                width: double.infinity,
                                child: Placeholder(),
                              ),
                        SizedBox(height: 10),
                        Text(
                          offer.hotel!.name ?? "",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        Text(
                          "${offer.hotel!.city!.name}, ${offer.hotel!.city!.country!.name}",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "${offer.formattedStartDate} - ${offer.formattedEndDate}",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        Text(
                          offer.boardType!.name!,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Već od ${FormatHelper.formatNumber(offer.minimumPricePerPerson!)} KM",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        Text(
                          "Preostalo još ${offer.remainingSpots!} mjesta",
                          style: TextStyle(
                            color: offer.remainingSpots! > 10
                                ? const Color.fromARGB(255, 76, 175, 79)
                                : AppColors.darkRed,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 5),
                        ElevatedButton(
                          onPressed: offer.remainingSpots! < 1 ? null : () {},
                          child: Text("Pregledaj i rezerviši"),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : DialogHelper.openSpinner(context, "Učitavam ponude..."),
    );
  }

  Future fetchData() async {
    paginatedList = null;
    setState(() {});

    paginatedList = await offerProvider.getAll(queryStrings);

    setState(() {});
  }

  Future populateOffers() async {
    var newRecords = await offerProvider.getAll(queryStrings);

    paginatedList!.listOfRecords.addAll(newRecords.listOfRecords);

    setState(() {});
  }
}
