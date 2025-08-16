import 'package:etouristagency_desktop/consts/entity_code.dart';
import 'package:etouristagency_desktop/helpers/dialog_helper.dart'
    show DialogHelper;
import 'package:etouristagency_desktop/models/entity_code_value/entity_code_value.dart';
import 'package:etouristagency_desktop/providers/entity_code_value_provider.dart';
import 'package:etouristagency_desktop/screens/entity_code_value/add_update_entity_code_value_dialog.dart';
import 'package:etouristagency_desktop/screens/master_screen.dart';
import 'package:flutter/material.dart';

class EntityCodeValueListScreen extends StatefulWidget {
  final EntityCode entityCode;
  const EntityCodeValueListScreen(this.entityCode, {super.key});

  @override
  State<EntityCodeValueListScreen> createState() =>
      _EntityCodeValueListScreenState();
}

class _EntityCodeValueListScreenState extends State<EntityCodeValueListScreen> {
  List<EntityCodeValue>? entityCodeValues;
  ScrollController horizontalScrollController = ScrollController();
  late final EntityCodeValueProvider entityCodeValueProvider;
  late String title;

  @override
  void initState() {
    title = getTitle();
    entityCodeValueProvider = EntityCodeValueProvider();
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      SingleChildScrollView(
        child: entityCodeValues != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(title, style: TextStyle(fontSize: 18)),
                        ElevatedButton(
                          child: Text("Dodaj"),
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (context) =>
                                  AddUpdateEntityCodeValueDialog(
                                    entityCode: widget.entityCode,
                                  ),
                            );

                            await fetchData();
                          },
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
                              DataColumn(label: Text("Naziv")),
                              DataColumn(label: SizedBox()),
                            ],
                            rows: entityCodeValues!
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
                                            await showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  AddUpdateEntityCodeValueDialog(
                                                    entityCodeValue: x,
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
                ],
              )
            : DialogHelper.openSpinner(context, "Dohvatam šifarnike..."),
      ),
    );
  }

  Future fetchData() async {
    if (widget.entityCode == EntityCode.boardType) {
      entityCodeValues = await entityCodeValueProvider.GetBoardTypeList();
    }

    setState(() {});
  }

  String getTitle() {
    if (widget.entityCode == EntityCode.boardType) {
      return "Šifarnici -> Tipovi usluga";
    }

    return "";
  }
}
