import 'package:etouristagency_desktop/models/paginated_list.dart';
import 'package:etouristagency_desktop/models/user/user.dart';
import 'package:etouristagency_desktop/providers/user_provider.dart';
import 'package:etouristagency_desktop/screens/master_screen.dart';
import 'package:flutter/material.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  PaginatedList<User>? paginatedList;
  late final UserProvider userProvider;
  late ScrollController horizontalScrollController;

  @override
  void initState() {
    userProvider = UserProvider();
    fetchUserData();
    horizontalScrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      paginatedList != null
          ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: SizedBox(width:200, child: TextField(decoration: InputDecoration(labelText: "Pretraži..."),)),
              ),
              Scrollbar(
              thumbVisibility: true,
              interactive: true,
              controller: horizontalScrollController,
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: horizontalScrollController,
                  child: Container(
                    constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
                    child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: DataTable(
                          columns: [
                            DataColumn(label: Text("Ime")),
                            DataColumn(label: Text("Prezime")),
                            DataColumn(label: Text("Korisničko ime")),
                            DataColumn(label: Text("Email")),
                            DataColumn(label: Text("Broj telefona")),
                            DataColumn(label: Text("Aktivan")),
                            DataColumn(label: Text("Verifikovan")),
                          ],
                          rows: paginatedList!.listOfRecords!
                              .map(
                                (x) => DataRow(
                                  cells: [
                                    DataCell(Text(x.firstName ?? "")),
                                    DataCell(Text(x.lastName ?? "")),
                                    DataCell(Text(x.username ?? "")),
                                    DataCell(Text(x.email ?? "")),
                                    DataCell(Text(x.phoneNumber ?? "")),
                                    DataCell(
                                      Text(
                                        (x.isActive != null
                                            ? (x.isActive! ? "DA" : "NE")
                                            : ""),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        (x.isVerified != null
                                            ? (x.isVerified! ? "DA" : "NE")
                                            : ""),
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
          ])
          : SizedBox(
              height: MediaQuery.of(context).size.height - 70,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text("Dohvatam korisnike..."),
                  ],
                ),
              ),
            ),
    );
  }

  Future fetchUserData() async{
    paginatedList = await userProvider.getAll({});

    setState((){});
  }
}