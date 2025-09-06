import 'package:etouristagency_mobile/consts/app_colors.dart';
import 'package:etouristagency_mobile/consts/screen_names.dart';
import 'package:etouristagency_mobile/helpers/dialog_helper.dart';
import 'package:etouristagency_mobile/helpers/format_helper.dart';
import 'package:etouristagency_mobile/models/offer/offer.dart';
import 'package:etouristagency_mobile/models/paginated_list.dart';
import 'package:etouristagency_mobile/providers/offer_provider.dart';
import 'package:etouristagency_mobile/screens/master_screen.dart';
import 'package:etouristagency_mobile/screens/offer/offer_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    "recordsPerPage": 5,
    "isLastMinuteDiscountActive": true,
  };
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    offerProvider = OfferProvider();
    fetchData();
    super.initState();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200.h) {
      if (!_isLoadingMore && queryStrings["page"] < paginatedList!.totalPages) {
        queryStrings["page"] += 1;
        populateOffers();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      "Last minute ponuda",
      paginatedList != null
          ? paginatedList!.listOfRecords.isEmpty == false
                ? ListView.separated(
                    controller: _scrollController,
                    itemCount:
                        paginatedList!.listOfRecords.length +
                        (_isLoadingMore ? 1 : 0),
                    padding: EdgeInsetsGeometry.only(
                      left: 30.w,
                      right: 30.w,
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

                      var offer = paginatedList!.listOfRecords[index];

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
                              Stack(
                                children: [
                                  Image.network(
                                    "${offerProvider.controllerUrl}/${offer.id}/image",
                                    height: 200.h,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    right: 7.w,
                                    top: 7.h,
                                    child: Container(
                                      color: Color.fromARGB(186, 255, 153, 0),
                                      child: Padding(
                                        padding: EdgeInsets.all(8.w),
                                        child: Text(
                                          "LAST MINUTE",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                offer.hotel!.name ?? "",
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17.sp,
                                ),
                              ),
                              Text(
                                "${offer.hotel!.city!.name}, ${offer.hotel!.city!.country!.name}",
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.sp,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                "${offer.formattedStartDate} - ${offer.formattedEndDate}",
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17.sp,
                                ),
                              ),
                              Text(
                                offer.boardType!.name!,
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.sp,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                "Već od ${FormatHelper.formatNumber(offer.minimumPricePerPerson!)} KM",
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17.sp,
                                ),
                              ),
                              Text(
                                "Preostalo još ${offer.remainingSpots!} mjesta",
                                style: TextStyle(
                                  color: offer.remainingSpots! > 10
                                      ? const Color.fromARGB(255, 76, 175, 79)
                                      : AppColors.darkRed,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.sp,
                                ),
                              ),
                              SizedBox(height: 5.h),
                              ElevatedButton(
                                onPressed: offer.remainingSpots! < 1
                                    ? null
                                    : () {
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                OfferDetailsScreen(
                                                  ScreenNames
                                                      .lastMinuteOfferListScreen,
                                                  offer.id!,
                                                ),
                                          ),
                                        );
                                      },
                                style: ElevatedButton.styleFrom(
                                  textStyle: TextStyle(fontSize: 14.sp),
                                ),
                                child: Text("Pregledaj i rezerviši"),
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
                          "Trenutno nema dostupnih last minute ponuda.",
                          style: TextStyle(fontSize: 15.sp),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
          : DialogHelper.openSpinner(context, "Učitavam ponude..."),
    );
  }

  Future fetchData() async {
    paginatedList = null;
    setState(() {});

    paginatedList = await offerProvider.getAll(queryStrings);

    if (!mounted) return;
    setState(() {});
  }

  Future populateOffers() async {
    setState(() {
      _isLoadingMore = true;
    });

    var newRecords = await offerProvider.getAll(queryStrings);
    if (!mounted) return;

    paginatedList!.listOfRecords.addAll(newRecords.listOfRecords);

    setState(() {
      _isLoadingMore = false;
    });
  }
}