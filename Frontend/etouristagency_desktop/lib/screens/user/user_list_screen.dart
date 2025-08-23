import 'package:etouristagency_desktop/consts/app_colors.dart';
import 'package:etouristagency_desktop/consts/roles.dart';
import 'package:etouristagency_desktop/consts/screen_names.dart';
import 'package:etouristagency_desktop/helpers/dialog_helper.dart';
import 'package:etouristagency_desktop/models/paginated_list.dart';
import 'package:etouristagency_desktop/models/role/role.dart';
import 'package:etouristagency_desktop/models/user/user.dart';
import 'package:etouristagency_desktop/providers/role_provider.dart';
import 'package:etouristagency_desktop/providers/user_provider.dart';
import 'package:etouristagency_desktop/screens/master_screen.dart';
import 'package:etouristagency_desktop/screens/user/add_update_user_dialog.dart';
import 'package:etouristagency_desktop/screens/user/update_client_user.dialog.dart';
import 'package:etouristagency_desktop/services/auth_service.dart';
import 'package:flutter/material.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  PaginatedList<User>? paginatedList;
  List<Role>? roleList;
  late final UserProvider userProvider;
  late final RoleProvider roleProvider;
  late final AuthService authService;
  late ScrollController horizontalScrollController;
  String? username;
  Map<String, dynamic> queryStrings = {
    "page": 1,
    "roleId": "",
    "isActive": "",
    "searchText": "",
  };

  @override
  void initState() {
    userProvider = UserProvider();
    roleProvider = RoleProvider();
    authService = AuthService();
    fetchRoleData();
    fetchUserData();
    setUsername();
    horizontalScrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      ScreenNames.userScreen,
      SingleChildScrollView(
        child: paginatedList != null && username !=null
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
                                    queryStrings["searchText"] = value;
                                    await fetchUserData();
                                  },
                                  decoration: InputDecoration(
                                    labelText: "Pretraga",
                                    helperText:
                                        "Ime i prezime | Korisničko ime | Email",
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
                                    Icons.person,
                                    color: AppColors.primary,
                                  ),
                                  value: "",
                                  items: getDropdownItemList(),
                                  onChanged: (value) async {
                                    queryStrings["roleId"] = value;
                                    await fetchUserData();
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
                                  items: [
                                    DropdownMenuItem(
                                      value: "",
                                      child: Text("-- Status --"),
                                    ),
                                    DropdownMenuItem(
                                      value: "true",
                                      child: Text("Aktivan"),
                                    ),
                                    DropdownMenuItem(
                                      value: "false",
                                      child: Text("Neaktivan"),
                                    ),
                                  ],
                                  onChanged: (value) async {
                                    queryStrings["isActive"] = value;
                                    await fetchUserData();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AddUpdateUserDialog(),
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
                              DataColumn(label: Text("Ime")),
                              DataColumn(label: Text("Prezime")),
                              DataColumn(label: Text("Korisničko ime")),
                              DataColumn(label: Text("Email")),
                              DataColumn(label: Text("Broj telefona")),
                              DataColumn(label: Text("Uloga")),
                              DataColumn(label: Text("Aktivan")),
                              DataColumn(label: Text("Verifikovan")),
                              DataColumn(label: SizedBox()),
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
                                        Text(x.roles?.firstOrNull?.name ?? ""),
                                      ),
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
                                      DataCell(
                                        x.username != username
                                            ? ElevatedButton(
                                                onPressed: () {
                                                  if (x.roles != null &&
                                                      x.roles!.any(
                                                        (x) =>
                                                            x.name ==
                                                            Roles.admin,
                                                      )) {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          AddUpdateUserDialog(
                                                            user: x,
                                                          ),
                                                    );
                                                  }

                                                  if (x.roles != null &&
                                                      x.roles!.any(
                                                        (x) =>
                                                            x.name ==
                                                            Roles.client,
                                                      )) {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          UpdateClientUserDialog(
                                                            x,
                                                          ),
                                                    ).then(
                                                      (value) async =>
                                                          await fetchUserData(),
                                                    );
                                                  }
                                                },
                                                child: Text("Uredi"),
                                              )
                                            : SizedBox(),
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
                  SizedBox(height:20)
                ],
              )
            : DialogHelper.openSpinner(context, "Dohvatam korisnike..."),
      ),
    );
  }

  Future fetchUserData() async {
    paginatedList = await userProvider.getAll(queryStrings);

    setState(() {});
  }

  Future setUsername() async {
    username = await authService.getUsername();
  }

  Future fetchRoleData() async {
    roleList = (await roleProvider.getAll({})).listOfRecords;

    setState(() {});
  }

  List<DropdownMenuItem> getDropdownItemList() {
    var listOfItems = [DropdownMenuItem(child: Text("-- Uloga --"), value: "")];

    if (roleList == null || roleList!.isEmpty) return listOfItems;

    for (var role in roleList!) {
      listOfItems.add(
        DropdownMenuItem(child: Text(role.name ?? ""), value: role.id),
      );
    }

    return listOfItems;
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
                    await fetchUserData();
                  },
                )
              : SizedBox(width:110),
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
                    await fetchUserData();
                  },
                )
              : SizedBox(width:180),
        ],
      ),
    );
  }
}
