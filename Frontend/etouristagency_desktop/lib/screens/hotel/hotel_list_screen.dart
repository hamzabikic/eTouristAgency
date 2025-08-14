import 'package:etouristagency_desktop/consts/app_colors.dart';
import 'package:etouristagency_desktop/helpers/dialog_helper.dart';
import 'package:etouristagency_desktop/models/city/city.dart';
import 'package:etouristagency_desktop/models/hotel/hotel.dart';
import 'package:etouristagency_desktop/models/paginated_list.dart';
import 'package:etouristagency_desktop/providers/city_provider.dart';
import 'package:etouristagency_desktop/providers/hotel_provider.dart';
import 'package:etouristagency_desktop/screens/hotel/add_update_hotel_screen.dart';
import 'package:etouristagency_desktop/screens/master_screen.dart';
import 'package:flutter/material.dart';

class HotelListScreen extends StatefulWidget {
  const HotelListScreen({super.key});

  @override
  State<HotelListScreen> createState() => _HotelListScreenState();
}

class _HotelListScreenState extends State<HotelListScreen> {
  List<City>? cityData;
  Map<String, dynamic> queryStrings = {"searchText": "", "cityId": "", "page": 1};
  PaginatedList<Hotel>? paginatedList;
  ScrollController horizontalScrollController = ScrollController();
  late final HotelProvider hotelProvider;
  late final CityProvider cityProvider;

  @override
  void initState() {
    hotelProvider = HotelProvider();
    cityProvider = CityProvider();
    fetchCityData();
    fetchHotelData();
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
                    child: Text(
                      "Šifarnici -> Hoteli",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
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
                                  decoration: InputDecoration(
                                    helperText: "Naziv hotela",
                                    hintText: "Pretraga",
                                    suffixIcon: Icon(
                                      Icons.search,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  onSubmitted: (value) async {
                                    queryStrings["searchText"] = value;
                                    queryStrings["page"] = 1;

                                    await fetchHotelData();
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 250,
                                child: DropdownButtonFormField(
                                  icon: Icon(
                                    Icons.location_city,
                                    color: AppColors.primary,
                                  ),
                                  value: "",
                                  items: getCityDropdownItems(),
                                  onChanged: (value) async {
                                    queryStrings["cityId"] = value;
                                    queryStrings["page"] = 1;

                                    await fetchHotelData();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => AddUpdateHotelScreen(),
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
                              DataColumn(label: Text("Naziv hotela")),
                              DataColumn(label: Text("Broj zvjezdica")),
                              DataColumn(label: Text("Grad")),
                              DataColumn(label: Text("Država")),
                              DataColumn(label: SizedBox()),
                            ],
                            rows: paginatedList!.listOfRecords!
                                .map(
                                  (x) => DataRow(
                                    cells: [
                                      DataCell(
                                        InkWell(
                                          child: Text(x.name?.toString() ?? ""),
                                          onTap: () async {},
                                        ),
                                      ),
                                      DataCell(
                                        Text(x.starRating?.toString() ?? ""),
                                      ),
                                      DataCell(Text(x.city?.name ?? "")),
                                      DataCell(
                                        Text(x.city?.country?.name ?? ""),
                                      ),
                                      DataCell(
                                        ElevatedButton(
                                          child: Text("Uredi"),
                                          onPressed: () async {
                                            var hotel = await hotelProvider
                                                .getById(x.id ?? "");
                                            Navigator.of(
                                              context,
                                            ).pushReplacement(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AddUpdateHotelScreen(
                                                      hotel: hotel,
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
                  ),
                  buildPaginationButtons(),
                  SizedBox(height: 20),
                ],
              )
            : DialogHelper.openSpinner(context, "Dohvatam hotele..."),
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
                    await fetchHotelData();
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
                    await fetchHotelData();
                  },
                )
              : SizedBox(width: 180),
        ],
      ),
    );
  }

  Future fetchHotelData() async {
    paginatedList = await hotelProvider.getAll(queryStrings);

    setState(() {});
  }

  Future fetchCityData() async {
    cityData = (await cityProvider.getAll({
      "recordsPerPage": 1000,
    })).listOfRecords;

    setState(() {});
  }

  List<DropdownMenuItem> getCityDropdownItems() {
    List<DropdownMenuItem> items = [
      DropdownMenuItem(value: "", child: Text("-- Grad --")),
    ];

    if (cityData != null) {
      for (var item in cityData!) {
        var dropdownItem = DropdownMenuItem(
          value: item.id,
          child: Text(item.name!),
        );

        items.add(dropdownItem);
      }
    }

    return items;
  }
}
