import 'package:etouristagency_mobile/consts/app_colors.dart';
import 'package:etouristagency_mobile/consts/screen_names.dart';
import 'package:etouristagency_mobile/helpers/dialog_helper.dart';
import 'package:etouristagency_mobile/helpers/format_helper.dart';
import 'package:etouristagency_mobile/models/country/country.dart';
import 'package:etouristagency_mobile/models/entity_code_value/entity_code_value.dart';
import 'package:etouristagency_mobile/models/offer/offer.dart';
import 'package:etouristagency_mobile/models/paginated_list.dart';
import 'package:etouristagency_mobile/providers/country_provider.dart';
import 'package:etouristagency_mobile/providers/entity_code_value_provider.dart';
import 'package:etouristagency_mobile/providers/offer_provider.dart';
import 'package:etouristagency_mobile/screens/master_screen.dart';
import 'package:etouristagency_mobile/screens/offer/offer_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class OfferListScreen extends StatefulWidget {
  const OfferListScreen({super.key});

  @override
  State<OfferListScreen> createState() => _OfferListScreenState();
}

class _OfferListScreenState extends State<OfferListScreen> {
  late final OfferProvider offerProvider;
  late final CountryProvider countryProvider;
  late final EntityCodeValueProvider entityCodeValueProvider;
  PaginatedList<Offer>? paginatedList;
  List<Country>? countries;
  List<EntityCodeValue>? boardTypes;
  Map<String, dynamic> queryStrings = {
    "page": 1,
    "recordsPerPage": 5,
    "isBookableNow": true,
  };
  bool isFiltersWidgetOpen = false;
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    offerProvider = OfferProvider();
    countryProvider = CountryProvider();
    entityCodeValueProvider = EntityCodeValueProvider();
    _scrollController.addListener(_onScroll);
    fetchData();
    fetchCountries();
    fetchBoardTypes();
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
      "Ponude",
      paginatedList != null
          ? Stack(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.filter_list,
                          color: AppColors.primary,
                          size: 35.w,
                        ),
                        onPressed: () {
                          isFiltersWidgetOpen = !isFiltersWidgetOpen;
                          setState(() {});
                        },
                      ),
                      Expanded(
                        child: paginatedList!.listOfRecords.isNotEmpty
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
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: 15.h),
                                itemBuilder: (context, index) {
                                  if (index ==
                                      paginatedList!.listOfRecords.length) {
                                    return SizedBox(
                                      height: 100.h,
                                      child: DialogHelper.openSpinner(
                                        context,
                                        "",
                                      ),
                                    );
                                  }

                                  var offer =
                                      paginatedList!.listOfRecords[index];

                                  return Card(
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
                                              offer.isFirstMinuteDiscountActive!
                                                  ? Positioned(
                                                      right: 7.w,
                                                      top: 7.h,
                                                      child: Container(
                                                        color:
                                                            const Color.fromARGB(
                                                              188,
                                                              76,
                                                              175,
                                                              79,
                                                            ),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                8.w,
                                                              ),
                                                          child: Text(
                                                            "FIRST MINUTE",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14.sp,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : offer
                                                        .isLastMinuteDiscountActive!
                                                  ? Positioned(
                                                      right: 7.w,
                                                      top: 7.h,
                                                      child: Container(
                                                        color: Color.fromARGB(
                                                          186,
                                                          255,
                                                          153,
                                                          0,
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                8.w,
                                                              ),
                                                          child: Text(
                                                            "LAST MINUTE",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14.sp,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : SizedBox(),
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
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: getStarIconsOnHotel(
                                              offer.hotel!.starRating!,
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
                                                  ? const Color.fromARGB(
                                                      255,
                                                      76,
                                                      175,
                                                      79,
                                                    )
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
                                                    Navigator.of(
                                                      context,
                                                    ).pushReplacement(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            OfferDetailsScreen(
                                                              ScreenNames
                                                                  .offerListScreen,
                                                              offer.id!,
                                                            ),
                                                      ),
                                                    );
                                                  },
                                            style: ElevatedButton.styleFrom(
                                              textStyle: TextStyle(fontSize: 14.sp),
                                            ),
                                            child: Text(
                                              "Pregledaj i rezerviši",
                                            ),
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
                                    Text("🙁", style: TextStyle(fontSize: 40.sp)),
                                    Text(
                                      "Nema dostupnih ponuda.",
                                      style: TextStyle(fontSize: 15.sp),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                isFiltersWidgetOpen
                    ? Positioned(
                        top: 65.h,
                        left: 0,
                        right: 0,
                        child: SizedBox(
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 16.w,
                              right: 16.w,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xFFF0F4F8),
                                borderRadius: BorderRadiusGeometry.circular(20.r),
                                border: Border(
                                  top: BorderSide(
                                    color: Color.fromARGB(255, 228, 228, 228),
                                    width: 1.w,
                                  ),
                                  right: BorderSide(
                                    color: Color.fromARGB(255, 228, 228, 228),
                                    width: 1.w,
                                  ),
                                  bottom: BorderSide(
                                    color: Color.fromARGB(255, 228, 228, 228),
                                    width: 1.w,
                                  ),
                                  left: BorderSide(
                                    color: Color.fromARGB(255, 228, 228, 228),
                                    width: 1.5.w,
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(16.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DropdownButtonFormField(
                                      value: queryStrings["countryId"] ?? "",
                                      items: getCountryDropdownItems(),
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.black,
                                      ),
                                      onChanged: (value) async {
                                        queryStrings["page"] = 1;
                                        queryStrings["countryId"] = value;
                                      },
                                    ),
                                    DropdownButtonFormField(
                                      value: queryStrings["boardTypeId"] ?? "",
                                      items: getBoardTypes(),
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.black,
                                      ),
                                      onChanged: (value) async {
                                        queryStrings["page"] = 1;
                                        queryStrings["boardTypeId"] = value;
                                      },
                                    ),
                                    FormBuilderDateTimePicker(
                                      name: "",
                                      inputType: InputType.date,
                                      initialValue:
                                          queryStrings["offerDateFrom"] != null
                                          ? DateTime.parse(
                                              queryStrings["offerDateFrom"],
                                            )
                                          : null,
                                      format: DateFormat("dd.MM.yyyy"),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.sp,
                                      ),
                                      decoration: InputDecoration(
                                        labelStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.sp,
                                        ),
                                        labelText: "Od datuma",
                                        suffixIcon: Icon(
                                          Icons.date_range,
                                          color: AppColors.primary,
                                          size: 24.w,
                                        ),
                                      ),
                                      onChanged: (value) {
                                        if (value == null) return;
                                        queryStrings["page"] = 1;
                                        queryStrings["offerDateFrom"] =
                                            (value as DateTime)
                                                .toIso8601String();
                                      },
                                    ),
                                    FormBuilderDateTimePicker(
                                      name: "",
                                      inputType: InputType.date,
                                      initialValue:
                                          queryStrings["offerDateTo"] != null
                                          ? DateTime.parse(
                                              queryStrings["offerDateTo"]!,
                                            )
                                          : null,
                                      format: DateFormat("dd.MM.yyyy"),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.sp,
                                      ),
                                      decoration: InputDecoration(
                                        labelStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.sp,
                                        ),
                                        labelText: "Do datuma",
                                        suffixIcon: Icon(
                                          Icons.date_range,
                                          color: AppColors.primary,
                                          size: 24.w,
                                        ),
                                      ),
                                      onChanged: (value) {
                                        if (value == null) return;
                                        queryStrings["page"] = 1;
                                        queryStrings["offerDateTo"] =
                                            (value as DateTime)
                                                .toIso8601String();
                                      },
                                    ),
                                    TextFormField(
                                      initialValue:
                                          queryStrings["offerPriceFrom"] ?? "",
                                      keyboardType:
                                          TextInputType.numberWithOptions(),
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]'),
                                        ),
                                      ],
                                      style: TextStyle(fontSize: 14.sp),
                                      decoration: InputDecoration(
                                        labelText: "Od cijene",
                                        labelStyle: TextStyle(fontSize: 14.sp),
                                      ),
                                      onChanged: (value) {
                                        queryStrings["page"] = 1;
                                        queryStrings["offerPriceFrom"] = value;
                                      },
                                    ),
                                    TextFormField(
                                      initialValue:
                                          queryStrings["offerPriceTo"] ?? "",
                                      keyboardType:
                                          TextInputType.numberWithOptions(),
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]'),
                                        ),
                                      ],
                                      style: TextStyle(fontSize: 14.sp),
                                      decoration: InputDecoration(
                                        labelText: "Do cijene",
                                        labelStyle: TextStyle(fontSize: 14.sp),
                                      ),
                                      onChanged: (value) {
                                        queryStrings["page"] = 1;
                                        queryStrings["offerPriceTo"] = value;
                                      },
                                    ),
                                    SizedBox(height: 10.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            textStyle: TextStyle(fontSize: 14.sp),
                                          ),
                                          child: Text("Primijeni"),
                                          onPressed: fetchData,
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            textStyle: TextStyle(fontSize: 14.sp),
                                          ),
                                          child: Text("Poništi"),
                                          onPressed: removeFilters,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(width: 1.w, height: 1.h),
              ],
            )
          : DialogHelper.openSpinner(context, "Učitavam ponude..."),
    );
  }

  Future fetchData() async {
    paginatedList = null;

    paginatedList = await offerProvider.getAll(queryStrings);
    if (!mounted) return;
    setState(() {});
  }

  Future fetchCountries() async {
    countries = (await countryProvider.getAll({
      "recordsPerPage": 1000,
    })).listOfRecords;

    if (!mounted) return;
    setState(() {});
  }

  List<DropdownMenuItem> getCountryDropdownItems() {
    var list = [DropdownMenuItem(
      value: "", 
      child: Text(
        "-- Destinacija --",
        style: TextStyle(fontSize: 14.sp),
      ),
    )];

    if (countries == null) return list;

    for (var country in countries!) {
      var dropdownItem = DropdownMenuItem(
        value: country.id,
        child: Text(
          country.name ?? "",
          style: TextStyle(fontSize: 14.sp),
        ),
      );
      list.add(dropdownItem);
    }

    return list;
  }

  List<DropdownMenuItem> getBoardTypes() {
    var list = [
      DropdownMenuItem(
        value: "", 
        child: Text(
          "-- Vrsta pansiona --",
          style: TextStyle(fontSize: 14.sp),
        ),
      ),
    ];

    if (boardTypes == null) return list;

    for (var boardType in boardTypes!) {
      var dropdownItem = DropdownMenuItem(
        value: boardType.id,
        child: Text(
          boardType.name ?? "",
          style: TextStyle(fontSize: 14.sp),
        ),
      );
      list.add(dropdownItem);
    }

    return list;
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

  Future fetchBoardTypes() async {
    boardTypes = await entityCodeValueProvider.getBoardTypes();

    if (!mounted) return;
    setState(() {});
  }

  Future removeFilters() async {
    queryStrings.remove("countryId");
    queryStrings.remove("boardTypeId");
    queryStrings.remove("offerDateFrom");
    queryStrings.remove("offerDateTo");
    queryStrings.remove("offerPriceFrom");
    queryStrings.remove("offerPriceTo");

    queryStrings["page"] = 1;

    setState((){});
    await fetchData();
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
}