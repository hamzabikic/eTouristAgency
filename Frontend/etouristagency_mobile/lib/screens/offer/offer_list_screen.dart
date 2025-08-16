import 'dart:convert';

import 'package:etouristagency_mobile/consts/app_colors.dart';
import 'package:etouristagency_mobile/helpers/dialog_helper.dart';
import 'package:etouristagency_mobile/helpers/format_helper.dart';
import 'package:etouristagency_mobile/models/country/country.dart';
import 'package:etouristagency_mobile/models/entity_code_value/entity_code_value.dart';
import 'package:etouristagency_mobile/models/offer/offer.dart';
import 'package:etouristagency_mobile/models/paginated_list.dart';
import 'package:etouristagency_mobile/providers/countryProvider.dart';
import 'package:etouristagency_mobile/providers/entity_code_value_provider.dart';
import 'package:etouristagency_mobile/providers/offer_provider.dart';
import 'package:etouristagency_mobile/screens/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
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
  Map<String, dynamic> queryStrings = {"page": 1, "isBookableNow": true};
  bool isFiltersWidgetOpen = false;

  @override
  void initState() {
    offerProvider = OfferProvider();
    countryProvider = CountryProvider();
    entityCodeValueProvider = EntityCodeValueProvider();
    fetchData();
    fetchCountries();
    fetchBoardTypes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      "Ponude",
      paginatedList != null
          ? Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.filter_list,
                          color: AppColors.primary,
                          size: 35,
                        ),
                        onPressed: () {
                          isFiltersWidgetOpen = !isFiltersWidgetOpen;
                          setState(() {});
                        },
                      ),
                      Expanded(
                        child: ListView.separated(
                          itemCount: paginatedList!.listOfRecords.length,
                          padding: EdgeInsetsGeometry.only(
                            left: 30.0,
                            right: 30.0,
                            top: 16.0,
                            bottom: 16.0,
                          ),
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 15),
                          itemBuilder: (context, index) {
                            if (index == queryStrings["page"] * 15 - 1 &&
                                queryStrings["page"] <
                                    paginatedList!.totalPages) {
                              queryStrings["page"] = queryStrings["page"] + 1;
                              populateOffers();
                            }

                            var offer = paginatedList!.listOfRecords[index];

                            return Card(
                              color: AppColors.lighterBlue,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    offer.offerImage != null
                                        ? Stack(
                                            children: [
                                              Image.memory(
                                                base64Decode(
                                                  paginatedList!
                                                      .listOfRecords[index]
                                                      .offerImage!
                                                      .imageBytes!,
                                                ),
                                                height: 200,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                              ),
                                              offer.isFirstMinuteDiscountActive!
                                                  ? Positioned(
                                                      right: 7,
                                                      top: 7,
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
                                                              const EdgeInsets.all(
                                                                8.0,
                                                              ),
                                                          child: Text(
                                                            "FIRST MINUTE",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : offer
                                                        .isLastMinuteDiscountActive!
                                                  ? Positioned(
                                                      right: 7,
                                                      top: 7,
                                                      child: Container(
                                                        color: Color.fromARGB(
                                                          186,
                                                          255,
                                                          153,
                                                          0,
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                8.0,
                                                              ),
                                                          child: Text(
                                                            "LAST MINUTE",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : SizedBox(),
                                            ],
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
                                      onPressed: offer.remainingSpots! < 1
                                          ? null
                                          : () {},
                                      child: Text("Pregledaj i rezerviši"),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                isFiltersWidgetOpen
                    ? Positioned(
                        top: 65,
                        left: 0,
                        right: 0,
                        child: SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 16.0,
                              right: 16.0,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xFFF0F4F8),
                                borderRadius: BorderRadiusGeometry.circular(20),
                                border: Border(
                                  top: BorderSide(
                                    color: Color.fromARGB(255, 228, 228, 228),
                                    width: 1,
                                  ),
                                  right: BorderSide(
                                    color: Color.fromARGB(255, 228, 228, 228),
                                    width: 1,
                                  ),
                                  bottom: BorderSide(
                                    color: Color.fromARGB(255, 228, 228, 228),
                                    width: 1,
                                  ),
                                  left: BorderSide(
                                    color: Color.fromARGB(255, 228, 228, 228),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DropdownButtonFormField(
                                      value: queryStrings["countryId"] ?? "",
                                      items: getCountryDropdownItems(),
                                      onChanged: (value) async {
                                        queryStrings["page"] = 1;
                                        queryStrings["countryId"] = value;
                                      },
                                    ),
                                    DropdownButtonFormField(
                                      value: queryStrings["boardTypeId"] ?? "",
                                      items: getBoardTypes(),
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
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        labelStyle: TextStyle(
                                          color: Colors.black,
                                        ),
                                        labelText: "Od datuma",
                                        suffixIcon: Icon(
                                          Icons.date_range,
                                          color: AppColors.primary,
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
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        labelStyle: TextStyle(
                                          color: Colors.black,
                                        ),
                                        labelText: "Do datuma",
                                        suffixIcon: Icon(
                                          Icons.date_range,
                                          color: AppColors.primary,
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
                                      decoration: InputDecoration(
                                        labelText: "Od cijene",
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
                                      decoration: InputDecoration(
                                        labelText: "Do cijene",
                                      ),
                                      onChanged: (value) {
                                        queryStrings["page"] = 1;
                                        queryStrings["offerPriceTo"] = value;
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                          child: Text("Primijeni"),
                                          onPressed: fetchData,
                                        ),
                                        ElevatedButton(
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
                    : SizedBox(width: 1, height: 1),
              ],
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

  Future fetchCountries() async {
    countries = (await countryProvider.getAll({
      "recordsPerPage": 1000,
    })).listOfRecords;

    setState(() {});
  }

  List<DropdownMenuItem> getCountryDropdownItems() {
    var list = [DropdownMenuItem(value: "", child: Text("-- Destinacija --"))];

    if (countries == null) return list;

    for (var country in countries!) {
      var dropdownItem = DropdownMenuItem(
        value: country.id,
        child: Text(country.name ?? ""),
      );
      list.add(dropdownItem);
    }

    return list;
  }

  List<DropdownMenuItem> getBoardTypes() {
    var list = [
      DropdownMenuItem(value: "", child: Text("-- Vrsta pansiona --")),
    ];

    if (boardTypes == null) return list;

    for (var boardType in boardTypes!) {
      var dropdownItem = DropdownMenuItem(
        value: boardType.id,
        child: Text(boardType.name ?? ""),
      );
      list.add(dropdownItem);
    }

    return list;
  }

  Future populateOffers() async {
    var newRecords = await offerProvider.getAll(queryStrings);

    paginatedList!.listOfRecords.addAll(newRecords.listOfRecords);

    setState(() {});
  }

  Future fetchBoardTypes() async {
    boardTypes = await entityCodeValueProvider.getBoardTypes();

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
    await fetchData();
  }
}
