import 'package:etouristagency_desktop/consts/app_colors.dart';
import 'package:etouristagency_desktop/consts/screen_names.dart';
import 'package:etouristagency_desktop/helpers/dialog_helper.dart';
import 'package:etouristagency_desktop/models/offer/offer.dart';
import 'package:etouristagency_desktop/models/paginated_list.dart';
import 'package:etouristagency_desktop/models/reservation_review/reservation_review.dart';
import 'package:etouristagency_desktop/providers/reservation_review_provider.dart';
import 'package:etouristagency_desktop/screens/master_screen.dart';
import 'package:etouristagency_desktop/screens/offer/offer_list_screen.dart';
import 'package:etouristagency_desktop/screens/reservation_review/reservation_review_dialog.dart';
import 'package:flutter/material.dart';

class ReservationReviewListScreen extends StatefulWidget {
  final Offer offer;
  const ReservationReviewListScreen(this.offer, {super.key});

  @override
  State<ReservationReviewListScreen> createState() =>
      _ReservationReviewListScreenState();
}

class _ReservationReviewListScreenState
    extends State<ReservationReviewListScreen> {
  PaginatedList<ReservationReview>? paginatedList;
  ScrollController horizontalScrollController = ScrollController();
  late final ReservationReviewProvider reservationReviewProvider;
  Map<String, dynamic> queryStrings = {"page": 1, "offerId": ""};

  @override
  void initState() {
    queryStrings["offerId"] = widget.offer.id!;
    reservationReviewProvider = ReservationReviewProvider();
    fetchData();
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
                                    DataColumn(label: Text("Ocjena smještaja")),
                                    DataColumn(label: Text("Ocjena usluge")),
                                    DataColumn(label: Text("Datum kreiranja")),
                                    DataColumn(label: Text("Kreirao/la")),
                                    DataColumn(label: SizedBox()),
                                  ],
                                  rows: paginatedList!.listOfRecords!
                                      .map(
                                        (x) => DataRow(
                                          cells: [
                                            DataCell(
                                              Text(
                                                x.reservation?.reservationNo
                                                        .toString() ??
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
                                            DataCell(
                                              Text(
                                                x.accommodationRating
                                                        ?.toString() ??
                                                    "",
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                x.serviceRating?.toString() ??
                                                    "",
                                              ),
                                            ),
                                            DataCell(Text(x.formatedCreatedOn)),
                                            DataCell(
                                              Text(
                                                "${x.reservation?.user?.firstName ?? ""} ${x.reservation?.user?.lastName ?? ""}",
                                              ),
                                            ),
                                            DataCell(
                                              ElevatedButton(
                                                child: Text("Detalji"),
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        ReservationReviewDialog(
                                                          x,
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
                            "Trenutno nema kreiranih recenzija za ovu ponudu.",
                            style: TextStyle(fontSize: 20),
                          ),
                        )
                      : SizedBox(),
                ],
              )
            : DialogHelper.openSpinner(context, "Dohvatam recenzije..."),
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

  Future fetchData() async {
    paginatedList = null;
    setState(() {});

    paginatedList = await reservationReviewProvider.getAll(queryStrings);
    setState(() {});
  }
}
