import 'package:etouristagency_desktop/consts/app_colors.dart';
import 'package:etouristagency_desktop/consts/screen_names.dart';
import 'package:etouristagency_desktop/helpers/dialog_helper.dart';
import 'package:etouristagency_desktop/models/country/country.dart';
import 'package:etouristagency_desktop/models/paginated_list.dart';
import 'package:etouristagency_desktop/providers/country_provider.dart';
import 'package:etouristagency_desktop/screens/city/add_update_city_dialog.dart';
import 'package:etouristagency_desktop/screens/country/add_update_country_dialog.dart';
import 'package:etouristagency_desktop/screens/master_screen.dart';
import 'package:flutter/material.dart';

class CountryListScreen extends StatefulWidget {
  const CountryListScreen({super.key});

  @override
  State<CountryListScreen> createState() => _CountryListScreenState();
}

class _CountryListScreenState extends State<CountryListScreen> {
  PaginatedList<Country>? paginatedList;
  late final CountryProvider countryProvider;
  ScrollController horizontalScrollController = ScrollController();
  Map<String, dynamic> queryStrings = {"page": 1, "searchText": ""};

  @override
  void initState() {
    countryProvider = CountryProvider();
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      ScreenNames.entityCodeScreen,
      SingleChildScrollView(
        child: paginatedList != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      top: 16,
                      right: 16,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Šifarnici -> Države",
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Wrap(
                                children: [
                                  SizedBox(
                                    width: 250,
                                    child: TextField(
                                      decoration: InputDecoration(
                                        labelText: "Pretraga",
                                        helperText: "Naziv države",
                                        suffixIcon: Icon(
                                          Icons.search,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      onSubmitted: (value) async {
                                        queryStrings["searchText"] = value;
                                        queryStrings["page"] = 1;
                                        await fetchData();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                child: Text("Dodaj"),
                                onPressed: () async {
                                  await showDialog(
                                    context: context,
                                    builder: (context) =>
                                        AddUpdateCountryDialog(),
                                  );

                                  await fetchData();
                                },
                              ),
                            ],
                          ),
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
                              DataColumn(label: Text("Naziv države")),
                              DataColumn(label: SizedBox()),
                            ],
                            rows: paginatedList!.listOfRecords!
                                .map(
                                  (x) => DataRow(
                                    cells: [
                                      DataCell(
                                        Text(x.name?.toString() ?? ""),
                                      ),
                                      DataCell(
                                        ElevatedButton(
                                          child: Text("Uredi"),
                                          onPressed: () async {
                                            var country = await countryProvider
                                                .getById(x.id ?? "");
                                            await showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  AddUpdateCountryDialog(
                                                    country: country,
                                                  ),
                                            );
                                            await fetchData();
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
                  SizedBox(height: 20),
                  buildPaginationButtons(),
                ],
              )
            : DialogHelper.openSpinner(context, "Dohvatam države..."),
      ),
    );
  }

  Future fetchData() async {
    paginatedList = await countryProvider.getAll(queryStrings);

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
}
