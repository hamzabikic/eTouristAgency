import 'dart:io';

import 'package:etouristagency_desktop/consts/app_colors.dart';
import 'package:etouristagency_desktop/consts/screen_names.dart';
import 'package:etouristagency_desktop/helpers/dialog_helper.dart';
import 'package:etouristagency_desktop/helpers/format_helper.dart';
import 'package:etouristagency_desktop/models/entity_code_value/entity_code_value.dart';
import 'package:etouristagency_desktop/models/offer/offer.dart';
import 'package:etouristagency_desktop/models/paginated_list.dart';
import 'package:etouristagency_desktop/models/reservation/reservation.dart';
import 'package:etouristagency_desktop/providers/entity_code_value_provider.dart';
import 'package:etouristagency_desktop/providers/passenger_provider.dart';
import 'package:etouristagency_desktop/providers/reservation_provider.dart';
import 'package:etouristagency_desktop/screens/master_screen.dart';
import 'package:etouristagency_desktop/screens/offer/offer_list_screen.dart';
import 'package:etouristagency_desktop/screens/reservation/update_reservation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class ReservationListScreen extends StatefulWidget {
  final Offer offer;
  const ReservationListScreen(this.offer, {super.key});

  @override
  State<ReservationListScreen> createState() => _ReservationListScreenState();
}

class _ReservationListScreenState extends State<ReservationListScreen> {
  late final ReservationProvider reservationProvider;
  late final EntityCodeValueProvider entityCodeValueProvider;
  late final PassengerProvider passengerProvider;
  final ScrollController horizontalScrollController = ScrollController();
  Map<String, dynamic> queryStrings = {
    "page": 1,
    "reservationNoSearchText": "",
    "reservationStatusId": "",
    "offerId": "",
  };
  PaginatedList<Reservation>? paginatedList;
  List<EntityCodeValue>? reservationStatusList;

  @override
  void initState() {
    queryStrings["offerId"] = widget.offer.id;
    reservationProvider = ReservationProvider();
    entityCodeValueProvider = EntityCodeValueProvider();
    passengerProvider = PassengerProvider();
    fetchData();
    fetchReservationStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      ScreenNames.offerScreen,
      SingleChildScrollView(
        child: paginatedList != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              color: AppColors.primary,
                              icon: Icon(Icons.arrow_back_ios),
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => OfferListScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Wrap(
                              spacing: 20,
                              children: [
                                SizedBox(
                                  width: 250,
                                  child: FormBuilderTextField(
                                    name: "",
                                    initialValue:
                                        queryStrings["reservationNoSearchText"],
                                    decoration: InputDecoration(
                                      labelText: "Pretraga",
                                      helperText: "Broj rezervacije",
                                      suffixIcon: Icon(
                                        Icons.search,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    onSubmitted: (value) async {
                                      queryStrings["reservationNoSearchText"] =
                                          value;
                                      queryStrings["page"] = 1;
                                      await fetchData();
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 250,
                                  child: DropdownButtonFormField(
                                    decoration: InputDecoration(
                                      suffixIcon: Icon(
                                        Icons.check_circle,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    value: queryStrings["reservationStatusId"],
                                    items: getReservationStatusDropdownItems(),
                                    onChanged: (value) async {
                                      queryStrings["reservationStatusId"] =
                                          value;
                                      queryStrings["page"] = 1;
                                      await fetchData();
                                    },
                                  ),
                                ),
                              ],
                            ),
                            paginatedList!.listOfRecords!.isNotEmpty
                                ? Column(
                                    children: [
                                      ElevatedButton(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          spacing: 10,
                                          children: [
                                            Icon(
                                              Icons.download,
                                              color: AppColors.primary,
                                            ),
                                            Text("Preuzmi listu putnika"),
                                          ],
                                        ),
                                        onPressed: openDocumentOfPassengers,
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "Dokument sadrži putnike sa rezervacija sa statusom 'Uplaćeno'.",
                                      ),
                                    ],
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  paginatedList!.listOfRecords!.isNotEmpty
                      ? Scrollbar(
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
                                    DataColumn(label: Text("Broj rezervacije")),
                                    DataColumn(label: Text("Broj ponude")),
                                    DataColumn(label: Text("Datum kreiranja")),
                                    DataColumn(label: Text("Kreirao/la")),
                                    DataColumn(label: Text("Vrsta sobe")),
                                    DataColumn(label: Text("Broj putnika")),
                                    DataColumn(
                                      label: Text("Iskorišten popust"),
                                    ),
                                    DataColumn(label: Text("Ukupna cijena")),
                                    DataColumn(label: Text("Uplaćeno")),
                                    DataColumn(label: SizedBox()),
                                  ],
                                  rows: paginatedList!.listOfRecords!
                                      .map(
                                        (x) => DataRow(
                                          cells: [
                                            DataCell(
                                              Text(
                                                x.reservationNo?.toString() ??
                                                    "",
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                widget.offer.offerNo
                                                        ?.toString() ??
                                                    "",
                                              ),
                                            ),
                                            DataCell(Text(x.formatedCreatedOn)),
                                            DataCell(
                                              Text(
                                                "${x.user!.firstName} ${x.user!.lastName}",
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                x.room?.roomType?.name ?? "",
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                x.passengers!.length.toString(),
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                x
                                                        .offerDiscount
                                                        ?.discountType
                                                        ?.name ??
                                                    "",
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                "${FormatHelper.formatNumber(x.totalCost!)} KM",
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                "${FormatHelper.formatNumber(x.paidAmount!)} KM",
                                              ),
                                            ),
                                            DataCell(
                                              ElevatedButton(
                                                child: Text("Detalji"),
                                                onPressed: () {
                                                  Navigator.of(
                                                    context,
                                                  ).pushReplacement(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          UpdateReservationScreen(
                                                            widget.offer,
                                                            x.id!,
                                                          ),
                                                    ),
                                                  );
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
                        )
                      : SizedBox(),
                  paginatedList!.listOfRecords!.isNotEmpty
                      ? buildPaginationButtons()
                      : SizedBox(),
                  paginatedList!.listOfRecords!.isEmpty
                      ? Center(
                          child: Text(
                            "Trenutno nema kreiranih rezervacija za ovu ponudu.",
                            style: TextStyle(fontSize: 20),
                          ),
                        )
                      : SizedBox(),
                ],
              )
            : DialogHelper.openSpinner(context, "Dohvatam rezervacije..."),
      ),
    );
  }

  Future fetchData() async {
    paginatedList = null;
    setState(() {});

    paginatedList = await reservationProvider.getAll(queryStrings);
    if (!mounted) return;
    setState(() {});
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
                    await fetchData();
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
                    await fetchData();
                  },
                )
              : SizedBox(width: 180),
        ],
      ),
    );
  }

  Future fetchReservationStatus() async {
    reservationStatusList =
        await entityCodeValueProvider.GetReservationStatusList();

    if (!mounted) return;
    setState(() {});
  }

  List<DropdownMenuItem> getReservationStatusDropdownItems() {
    var list = [
      DropdownMenuItem(value: "", child: Text("-- Status rezervacije --")),
    ];

    if (reservationStatusList == null) return list;

    for (var reservationStatus in reservationStatusList!) {
      var dropdownItem = DropdownMenuItem(
        value: reservationStatus.id!,
        child: Text(reservationStatus.name ?? ""),
      );
      list.add(dropdownItem);
    }

    return list;
  }

  Future openDocumentOfPassengers() async {
    try {
      var documentOfPassengers = await passengerProvider
          .getDocumentOfPassegersByOfferId(widget.offer.id!);
      if (!mounted) return;

      Directory dir = await getTemporaryDirectory();
      String savePath = "${dir.path}/${documentOfPassengers.documentName}";

      File file = File(savePath);
      await file.writeAsBytes(documentOfPassengers.documentBytes!);

      await OpenFile.open(savePath);
    } on Exception catch (ex) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(ex.toString())));
    }
  }
}
