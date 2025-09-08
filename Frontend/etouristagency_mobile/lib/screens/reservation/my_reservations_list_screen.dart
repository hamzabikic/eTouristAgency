import 'package:etouristagency_mobile/consts/app_colors.dart';
import 'package:etouristagency_mobile/consts/app_constants.dart';
import 'package:etouristagency_mobile/helpers/dialog_helper.dart';
import 'package:etouristagency_mobile/models/paginated_list.dart';
import 'package:etouristagency_mobile/models/reservation/my_reservation.dart';
import 'package:etouristagency_mobile/providers/offer_provider.dart';
import 'package:etouristagency_mobile/providers/reservation_provider.dart';
import 'package:etouristagency_mobile/screens/master_screen.dart';
import 'package:etouristagency_mobile/screens/reservation/add_update_reservation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyReservationsListScreen extends StatefulWidget {
  const MyReservationsListScreen({super.key});

  @override
  State<MyReservationsListScreen> createState() =>
      _MyReservationsListScreenState();
}

class _MyReservationsListScreenState extends State<MyReservationsListScreen> {
  final ScrollController _scrollController = ScrollController();
  late final ReservationProvider reservationProvider;
  late final OfferProvider offerProvider;
  PaginatedList<MyReservation>? paginatedList;
  bool _isLoadingMore = false;
  Map<String, dynamic> queryStrings = {"page": 1, "recordsPerPage": 5};

  @override
  void initState() {
    reservationProvider = ReservationProvider();
    offerProvider = OfferProvider();
    _scrollController.addListener(_onScroll);
    fetchData();
    super.initState();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200.h) {
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
          ? paginatedList!.listOfRecords.isNotEmpty
                ? ListView.separated(
                    controller: _scrollController,
                    itemCount:
                        paginatedList!.listOfRecords.length +
                        (_isLoadingMore ? 1 : 0),
                    padding: EdgeInsetsGeometry.only(
                      left: 46.w,
                      right: 46.w,
                      top: 16.h,
                      bottom: 16.h,
                    ),
                    separatorBuilder: (context, index) => SizedBox(height: 15.h),
                    itemBuilder: (context, index) {
                      if (index == paginatedList!.listOfRecords.length) {
                        return SizedBox(
                          height: 100.h,
                          child: DialogHelper.openSpinner(context, ""),
                        );
                      }

                      var reservation = paginatedList!.listOfRecords[index];

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 4,
                        color: AppColors.lighterBlue,
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            children: [
                              Image.network(
                                "${offerProvider.controllerUrl}/${reservation.room!.offerId!}/image",
                                height: 200.h,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                "#${reservation.reservationNo ?? ""}",
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17.sp,
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                reservation.room!.offer!.hotel!.name ?? "",
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17.sp,
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
                                  fontSize: 12.sp,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                "${reservation.room!.offer!.formattedStartDate} - ${reservation.room!.offer!.formattedEndDate}",
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17.sp,
                                ),
                              ),
                              Text(
                                reservation.room!.offer!.boardType!.name ?? "",
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.sp,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                "Status",
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.sp,
                                ),
                              ),
                              Text(
                                reservation.reservationStatus!.name ?? "",
                                style: TextStyle(
                                  color: getColorForReservationStatus(
                                    reservation.reservationStatusId!
                                        .toUpperCase(),
                                  ),
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 15.sp,
                                ),
                              ),
                              SizedBox(height: 5.h),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  textStyle: TextStyle(fontSize: 14.sp),
                                ),
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
                : Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("🙁", style: TextStyle(fontSize: 40.sp), textAlign: TextAlign.center),
                        Text(
                          "Još uvijek nemate kreiranih rezervacija.",
                          style: TextStyle(fontSize: 15.sp),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
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

    if(!mounted) return;

    setState(() {});
  }

  Future populateReservations() async {
    setState(() {
      _isLoadingMore = true;
    });

    var newRecords = await reservationProvider.getAllForCurrentUser(
      queryStrings,
    );

    if(!mounted) return;

    paginatedList!.listOfRecords.addAll(newRecords.listOfRecords);

    setState(() {
      _isLoadingMore = false;
    });
  }

  List<Widget> getStarIconsOnHotel(int numberOfStars) {
    List<Widget> list = [];

    for (int i = 0; i < numberOfStars; i++) {
      list.add(Icon(
        Icons.star, 
        color: Colors.amber,
        size: 24.w,
      ));
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
      case AppConstants.reservationCancelledGuid:
        return AppColors.darkRed;
      case AppConstants.reservationLatePaymentGuid:
        return AppColors.darkRed;
      default:
        return AppColors.primary;
    }
  }
}