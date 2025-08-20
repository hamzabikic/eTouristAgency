import 'dart:convert';

import 'package:etouristagency_mobile/consts/app_colors.dart';
import 'package:etouristagency_mobile/consts/app_constants.dart';
import 'package:etouristagency_mobile/helpers/dialog_helper.dart';
import 'package:etouristagency_mobile/models/paginated_list.dart';
import 'package:etouristagency_mobile/models/reservation/my_reservation.dart';
import 'package:etouristagency_mobile/models/reservation/reservation.dart';
import 'package:etouristagency_mobile/providers/reservation_provider.dart';
import 'package:etouristagency_mobile/screens/master_screen.dart';
import 'package:etouristagency_mobile/screens/reservation/add_update_reservation_screen.dart';
import 'package:flutter/material.dart';

class MyReservationsListScreen extends StatefulWidget {
  const MyReservationsListScreen({super.key});

  @override
  State<MyReservationsListScreen> createState() =>
      _MyReservationsListScreenState();
}

class _MyReservationsListScreenState extends State<MyReservationsListScreen> {
  ScrollController _scrollController = ScrollController();
  late final ReservationProvider reservationProvider;
  PaginatedList<MyReservation>? paginatedList;
  bool _isLoadingMore = false;
  Map<String, dynamic> queryStrings = {"page": 1, "recordsPerPage": 5};

  @override
  void initState() {
    reservationProvider = ReservationProvider();
    _scrollController.addListener(_onScroll);
    fetchData();
    super.initState();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore && queryStrings["page"] < paginatedList!.totalPages) {
        queryStrings["page"] += 1;
        populateReservations();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      "Moja putovanja",
      paginatedList != null
          ? ListView.separated(
              controller: _scrollController,
              itemCount:
                  paginatedList!.listOfRecords.length +
                  (_isLoadingMore ? 1 : 0),
              padding: EdgeInsetsGeometry.only(
                left: 46.0,
                right: 46.0,
                top: 16.0,
                bottom: 16.0,
              ),
              separatorBuilder: (context, index) => SizedBox(height: 15),
              itemBuilder: (context, index) {
                if (index == paginatedList!.listOfRecords.length) {
                  return DialogHelper.openSpinner(context, "");
                }

                var reservation = paginatedList!.listOfRecords[index];

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
                        reservation.room!.offer!.offerImage != null
                            ? Image.memory(
                                base64Decode(
                                  reservation
                                      .room!
                                      .offer!
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
                          "#${reservation.reservationNo ?? ""}",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          reservation.room!.offer!.hotel!.name ?? "",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: getStarIconsOnHotel(
                            reservation.room!.offer!.hotel!.starRating!,
                          ),
                        ),
                        Text(
                          "${reservation.room!.offer!.hotel!.city!.name}, ${reservation.room!.offer!.hotel!.city!.country!.name}",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "${reservation.room!.offer!.formattedStartDate} - ${reservation.room!.offer!.formattedEndDate}",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        Text(
                          reservation.room!.offer!.boardType!.name ?? "",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Status",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          reservation.reservationStatus!.name ?? "",
                          style: TextStyle(
                            color: getColorForReservationStatus(
                              reservation.reservationStatusId!.toUpperCase(),
                            ),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 5),
                        ElevatedButton(
                          child: Text("Detalji"),
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) =>
                                    AddUpdateReservationScreen(
                                      reservation.room!.offerId!,
                                      reservation.roomId!,
                                      reservation.id,
                                    ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : DialogHelper.openSpinner(context, "Učitavam putovanja..."),
    );
  }

  Future fetchData() async {
    paginatedList = null;
    setState(() {});

    paginatedList = await reservationProvider.getAllForCurrentUser(
      queryStrings,
    );

    setState(() {});
  }

  Future populateReservations() async {
    setState(() {
      _isLoadingMore = true;
    });

    var newRecords = await reservationProvider.getAllForCurrentUser(
      queryStrings,
    );

    paginatedList!.listOfRecords.addAll(newRecords.listOfRecords);

    setState(() {
      _isLoadingMore = false;
    });
  }

  List<Widget> getStarIconsOnHotel(int numberOfStars) {
    List<Widget> list = [];

    for (int i = 0; i < numberOfStars; i++) {
      list.add(Icon(Icons.star, color: Colors.amber));
    }

    return list;
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
