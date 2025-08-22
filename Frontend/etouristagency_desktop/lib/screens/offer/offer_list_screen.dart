import 'package:etouristagency_desktop/consts/app_colors.dart';
import 'package:etouristagency_desktop/helpers/dialog_helper.dart';
import 'package:etouristagency_desktop/models/country/country.dart';
import 'package:etouristagency_desktop/models/entity_code_value/entity_code_value.dart';
import 'package:etouristagency_desktop/models/offer/offer.dart';
import 'package:etouristagency_desktop/models/paginated_list.dart';
import 'package:etouristagency_desktop/providers/country_provider.dart';
import 'package:etouristagency_desktop/providers/entity_code_value_provider.dart';
import 'package:etouristagency_desktop/providers/offer_provider.dart';
import 'package:etouristagency_desktop/screens/master_screen.dart';
import 'package:etouristagency_desktop/screens/offer/add_update_offer_screen.dart';
import 'package:etouristagency_desktop/screens/reservation/reservation_list_screen.dart';
import 'package:flutter/material.dart';

class OfferListScreen extends StatefulWidget {
  const OfferListScreen({super.key});

  @override
  State<OfferListScreen> createState() => _OfferListScreenState();
}

class _OfferListScreenState extends State<OfferListScreen> {
  final offerDateFromEditingController = TextEditingController();
  final offerDateToEditingController = TextEditingController();
  PaginatedList<Offer>? paginatedList;
  List<Country>? countryList;
  List<EntityCodeValue>? offerStatusList;
  final horizontalScrollController = ScrollController();
  late final OfferProvider offerProvider;
  late final CountryProvider countryProvider;
  late final EntityCodeValueProvider entityCodeValueProvider;
  Map<String, dynamic> queryStrings = {
    "page": 1,
    "offerNo": "",
    "countryId": "",
    "offerStatusId": "",
    "offerDateFrom": "",
    "offerDateTo": "",
  };

  @override
  void initState() {
    offerProvider = OfferProvider();
    countryProvider = CountryProvider();
    entityCodeValueProvider = EntityCodeValueProvider();
    fetchOfferData();
    fetchCountryData();
    fetchOfferStatusData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      SingleChildScrollView(
        child: paginatedList != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: 16.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Wrap(
                            spacing: 20,
                            children: [
                              SizedBox(
                                width: 250,
                                child: TextField(
                                  onSubmitted: (value) async {
                                    queryStrings["offerNo"] = value;
                                    queryStrings["page"] = 1;
                                    await fetchOfferData();
                                  },
                                  decoration: InputDecoration(
                                    labelText: "Pretraga",
                                    helperText: "Broj ponude",
                                    suffixIcon: Icon(
                                      Icons.search,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 250,
                                child: DropdownButtonFormField(
                                  icon: Icon(
                                    Icons.map,
                                    color: AppColors.primary,
                                  ),
                                  value: "",
                                  items: getCountryDropdownItems(),
                                  onChanged: (value) async {
                                    queryStrings["countryId"] = value;
                                    queryStrings["page"] = 1;
                                    await fetchOfferData();
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 250,
                                child: DropdownButtonFormField(
                                  icon: Icon(
                                    Icons.check_circle,
                                    color: AppColors.primary,
                                  ),
                                  value: "",
                                  items: getOfferStatusDropdownItems(),
                                  onChanged: (value) async {
                                    queryStrings["offerStatusId"] = value;
                                    queryStrings["page"] = 1;
                                    await fetchOfferData();
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 250,
                                child: TextField(
                                  controller: offerDateFromEditingController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    labelText: "Od datuma:",
                                  ),
                                  onTap: () => selectOfferDateFrom(),
                                ),
                              ),
                              SizedBox(
                                width: 250,
                                child: TextField(
                                  controller: offerDateToEditingController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    labelText: "Do datuma:",
                                  ),
                                  onTap: () => selectOfferDateTo(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => AddUpdateOfferScreen(),
                              ),
                            );
                          },
                          child: Text("Dodaj"),
                        ),
                      ],
                    ),
                  ),
                  Scrollbar(
                    thumbVisibility: true,
                    interactive: true,
                    controller: horizontalScrollController,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: horizontalScrollController,
                      child: Container(
                        constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: DataTable(
                            columns: [
                              DataColumn(label: Text("Broj ponude")),
                              DataColumn(label: Text("Datum polaska")),
                              DataColumn(label: Text("Datum povratka")),
                              DataColumn(label: Text("Destinacija")),
                              DataColumn(label: Text("Hotel")),
                              DataColumn(label: Text("Broj noći")),
                              DataColumn(label: Text("Prevoznici")),
                              DataColumn(label: SizedBox()),
                              DataColumn(label: SizedBox()),
                            ],
                            rows: paginatedList!.listOfRecords!
                                .map(
                                  (x) => DataRow(
                                    cells: [
                                      DataCell(
                                        InkWell(
                                          child: Text(
                                            x.offerNo?.toString() ?? "",
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          "${x.tripStartDate!.day}.${x.tripStartDate!.month}.${x.tripStartDate!.year}",
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          "${x.tripEndDate!.day}.${x.tripEndDate!.month}.${x.tripEndDate!.year}",
                                        ),
                                      ),
                                      DataCell(Text(x.hotel!.city!.name ?? "")),
                                      DataCell(Text(x.hotel!.name ?? "")),
                                      DataCell(
                                        Text(
                                          x.numberOfNights?.toString() ?? "",
                                        ),
                                      ),
                                      DataCell(Text(x.carriers ?? "")),
                                      DataCell(
                                        ElevatedButton(
                                          child: Text("Uredi"),
                                          onPressed: () async {
                                            var offer = await offerProvider
                                                .getById(x.id ?? "");
                                            Navigator.of(
                                              context,
                                            ).pushReplacement(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AddUpdateOfferScreen(
                                                      offer: offer,
                                                    ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      DataCell(
                                        ElevatedButton(
                                          child: Text("Rezervacije"),
                                          onPressed: () {
                                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> ReservationListScreen(x)));
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  buildPaginationButtons(),
                  SizedBox(height: 20),
                ],
              )
            : DialogHelper.openSpinner(context, "Dohvatam ponude..."),
      ),
    );
  }

  Widget buildPaginationButtons() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          queryStrings["page"] > 1
              ? ElevatedButton(
                  child: Text("Prethodna"),
                  onPressed: () async {
                    queryStrings["page"] -= 1;
                    await fetchOfferData();
                  },
                )
              : SizedBox(width: 110),
          SizedBox(width: 10),
          Text(
            "${queryStrings["page"]} / ${paginatedList!.totalPages!}",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          SizedBox(width: 10),
          queryStrings["page"] < paginatedList!.totalPages!
              ? ElevatedButton(
                  child: Text("Sljedeća"),
                  onPressed: () async {
                    queryStrings["page"] += 1;
                    await fetchOfferData();
                  },
                )
              : SizedBox(width: 180),
        ],
      ),
    );
  }

  List<DropdownMenuItem> getCountryDropdownItems() {
    List<DropdownMenuItem> list = [
      DropdownMenuItem(value: "", child: Text("-- Država --")),
    ];

    if (countryList != null) {
      for (var country in countryList!) {
        list.add(
          DropdownMenuItem(value: country.id, child: Text(country.name!)),
        );
      }
    }

    return list;
  }

  List<DropdownMenuItem> getOfferStatusDropdownItems() {
    List<DropdownMenuItem> list = [
      DropdownMenuItem(value: "", child: Text("-- Status ponude --")),
    ];

    if (offerStatusList != null) {
      for (var offerStatus in offerStatusList!) {
        list.add(
          DropdownMenuItem(
            value: offerStatus.id,
            child: Text(offerStatus.name!),
          ),
        );
      }
    }

    return list;
  }

  Future selectOfferDateFrom() async {
    var pickedDate = await showDatePicker(
      initialDate: queryStrings["offerDateFrom"] != ""
          ? DateTime.parse(queryStrings["offerDateFrom"] as String)
          : DateTime.now(),
      context: context,
      firstDate: DateTime(1),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      offerDateFromEditingController.text =
          "${pickedDate.day}.${pickedDate.month}.${pickedDate.year}";
    }

    queryStrings["offerDateFrom"] = pickedDate?.toString() ?? "";
    queryStrings["page"] = 1;
    await fetchOfferData();
  }

  Future selectOfferDateTo() async {
    var pickedDate = await showDatePicker(
      initialDate: queryStrings["offerDateTo"] != ""
          ? DateTime.parse(queryStrings["offerDateTo"] as String)
          : DateTime.now(),
      context: context,
      firstDate: DateTime(1),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      offerDateToEditingController.text =
          "${pickedDate.day}.${pickedDate.month}.${pickedDate.year}";
    }

    queryStrings["offerDateTo"] = pickedDate?.toString() ?? "";
    queryStrings["page"] = 1;
    await fetchOfferData();
  }

  Future fetchOfferData() async {
    paginatedList = await offerProvider.getAll(queryStrings);

    setState(() {});
  }

  Future fetchCountryData() async {
    countryList = (await countryProvider.getAll({
      "recordsPerPage": 50,
    })).listOfRecords!;

    setState(() {});
  }

  Future fetchOfferStatusData() async {
    offerStatusList = await entityCodeValueProvider.GetOfferStatusList();

    setState(() {});
  }
}
