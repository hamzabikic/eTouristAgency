import 'dart:collection';

import 'package:etouristagency_desktop/consts/app_colors.dart';
import 'package:etouristagency_desktop/consts/screen_names.dart';
import 'package:etouristagency_desktop/helpers/dialog_helper.dart';
import 'package:etouristagency_desktop/models/city/city.dart';
import 'package:etouristagency_desktop/models/country/country.dart';
import 'package:etouristagency_desktop/models/paginated_list.dart';
import 'package:etouristagency_desktop/providers/city_provider.dart';
import 'package:etouristagency_desktop/providers/country_provider.dart';
import 'package:etouristagency_desktop/screens/city/add_update_city_dialog.dart';
import 'package:etouristagency_desktop/screens/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CityListScreen extends StatefulWidget {
  const CityListScreen({super.key});

  @override
  State<CityListScreen> createState() => _CityListScreenState();
}

class _CityListScreenState extends State<CityListScreen> {
  late final CityProvider cityProvider;
  late final CountryProvider countryProvider;
  final ScrollController horizontalScrollController = ScrollController();
  Map<String, dynamic> queryStrings = {
    "page": 1,
    "searchText": "",
    "countryId": "",
  };
  PaginatedList<City>? paginatedList;
  List<Country>? countries;

  @override
  void initState() {
    cityProvider = CityProvider();
    countryProvider = CountryProvider();
    fetchData();
    fetchCountries();
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
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Šifarnici -> Gradovi",
                              style: TextStyle(fontSize: 18),
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
                                    initialValue: queryStrings["searchText"],
                                    decoration: InputDecoration(
                                      labelText: "Pretraga",
                                      helperText: "Naziv grada",
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
                                SizedBox(
                                  width: 250,
                                  child: DropdownButtonFormField(
                                    decoration: InputDecoration(
                                      suffixIcon: Icon(
                                        Icons.map,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    value: "",
                                    items: getCountryDropdownItems(),
                                    onChanged: (value) async {
                                      queryStrings["countryId"] = value;
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
                                  builder: (context) => AddUpdateCityDialog(),
                                );

                                await fetchData();
                              },
                            ),
                          ],
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
                              DataColumn(label: Text("Naziv grada")),
                              DataColumn(label: Text("Država")),
                              DataColumn(label: SizedBox()),
                            ],
                            rows: paginatedList!.listOfRecords!
                                .map(
                                  (x) => DataRow(
                                    cells: [
                                      DataCell(Text(x.name?.toString() ?? "")),
                                      DataCell(Text(x.country?.name ?? "")),
                                      DataCell(
                                        ElevatedButton(
                                          child: Text("Uredi"),
                                          onPressed: () async {
                                            var city = await cityProvider
                                                .getById(x.id ?? "");

                                            await showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  AddUpdateCityDialog(
                                                    city: city,
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
                  buildPaginationButtons(),
                ],
              )
            : DialogHelper.openSpinner(context, "Dohvatam gradove..."),
      ),
    );
  }

  Future fetchData() async {
    paginatedList = null;
    setState((){});

    paginatedList = await cityProvider.getAll(queryStrings);
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

  Future fetchCountries() async {
    countries = (await countryProvider.getAll({
      "recordsPerPage": 1000,
    })).listOfRecords;

    setState(() {});
  }

  List<DropdownMenuItem> getCountryDropdownItems() {
    var list = [DropdownMenuItem(value: "", child: Text("-- Država --"))];

    if (countries == null) return list;

    for (var country in countries!) {
      var dropdownItem = DropdownMenuItem(
        value: country.id!,
        child: Text(country.name ?? ""),
      );
      list.add(dropdownItem);
    }

    return list;
  }
}
