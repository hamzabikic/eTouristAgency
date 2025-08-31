import 'dart:convert';
import 'dart:io';
import 'package:accordion/accordion.dart';
import 'package:etouristagency_desktop/consts/app_colors.dart';
import 'package:etouristagency_desktop/consts/app_constants.dart';
import 'package:etouristagency_desktop/consts/screen_names.dart';
import 'package:etouristagency_desktop/helpers/dialog_helper.dart';
import 'package:etouristagency_desktop/models/entity_code_value/entity_code_value.dart';
import 'package:etouristagency_desktop/models/hotel/hotel.dart';
import 'package:etouristagency_desktop/models/offer/offer.dart';
import 'package:etouristagency_desktop/models/room_type/room_type.dart';
import 'package:etouristagency_desktop/providers/entity_code_value_provider.dart';
import 'package:etouristagency_desktop/providers/hotel_provider.dart';
import 'package:etouristagency_desktop/providers/offer_provider.dart';
import 'package:etouristagency_desktop/providers/passenger_provider.dart';
import 'package:etouristagency_desktop/providers/room_type_provider.dart';
import 'package:etouristagency_desktop/screens/master_screen.dart';
import 'package:etouristagency_desktop/screens/offer/models/discount_accordion_item.dart';
import 'package:etouristagency_desktop/screens/offer/models/room_accordion_item.dart';
import 'package:etouristagency_desktop/screens/offer/offer_list_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class AddUpdateOfferScreen extends StatefulWidget {
  final String? offerId;
  const AddUpdateOfferScreen({super.key, this.offerId});

  @override
  State<AddUpdateOfferScreen> createState() => _AddUpdateOfferScreenState();
}

class _AddUpdateOfferScreenState extends State<AddUpdateOfferScreen> {
  ScrollController horizontalScrollController = ScrollController();
  final formBuilderKey = GlobalKey<FormBuilderState>();
  List<GlobalKey<FormBuilderState>> formBuilderRoomsKey = [];
  List<GlobalKey<FormBuilderState>> formBuilderDiscountsKey = [];
  late final HotelProvider hotelProvider;
  late final EntityCodeValueProvider entityCodeValueProvider;
  late final RoomTypeProvider roomTypeProvider;
  late final OfferProvider offerProvider;
  Offer? offer;
  Uint8List? photo;
  String? photoName;
  Uint8List? document;
  String? documentName;
  List<Hotel>? hotelList;
  List<EntityCodeValue>? boardTypeList;
  List<RoomType>? roomTypeList;
  List<RoomAccordionItem> rooms = [];
  List<DiscountAccordionItem> offerDiscounts = [];
  bool isFirstMinuteEnabled = true;
  bool isLastMinuteEnabled = true;
  bool isRoomUpdateEnabled = false;
  bool _isEditable = false;
  String photoErrorMessage = "";
  bool _isProcessing = false;
  bool _isActivationInProcess = false;
  bool _isDeactivationInProcess = false;
  String globalErrorMessage = "";

  @override
  void initState() {
    hotelProvider = HotelProvider();
    entityCodeValueProvider = EntityCodeValueProvider();
    roomTypeProvider = RoomTypeProvider();
    offerProvider = OfferProvider();
    fetchOfferData();
    fetchHotelData();
    fetchBoardTypeData();
    fetchRoomTypeData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      ScreenNames.offerScreen,
      widget.offerId != null && offer == null
          ? DialogHelper.openSpinner(context, "Učitavam podatke...")
          : SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Scrollbar(
                    controller: horizontalScrollController,
                    child: SingleChildScrollView(
                      controller: horizontalScrollController,
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryTransparent,
                          borderRadius: BorderRadiusGeometry.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 16,
                            left: 50,
                            right: 50,
                            bottom: 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 700,
                                child: Center(
                                  child: Text(
                                    widget.offerId == null
                                        ? "Nova ponuda"
                                        : "Izmjena ponude",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                width: 700,
                                child: Center(
                                  child: Text(
                                    globalErrorMessage,
                                    softWrap: true,
                                    maxLines: null,
                                    style: TextStyle(color: AppColors.darkRed),
                                  ),
                                ),
                              ),
                              FormBuilder(
                                initialValue: offer?.toJson() ?? {},
                                key: formBuilderKey,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      spacing: 100,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            photo == null
                                                ? Icon(
                                                    Icons.image,
                                                    size: 200,
                                                    color: AppColors.primary,
                                                  )
                                                : Image.memory(
                                                    photo!,
                                                    height: 200,
                                                    width: 200,
                                                  ),
                                            SizedBox(height: 10),
                                            _isEditable
                                                ? ElevatedButton(
                                                    onPressed: uploadPhoto,
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.upload,
                                                          size: 15,
                                                        ),
                                                        SizedBox(width: 10),
                                                        Text("Učitaj sliku"),
                                                      ],
                                                    ),
                                                  )
                                                : SizedBox(),
                                            Text(
                                              photoErrorMessage,
                                              style: TextStyle(
                                                color: AppColors.darkRed,
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            SizedBox(
                                              width: 300,
                                              child: FormBuilderDateTimePicker(
                                                validator: FormBuilderValidators.compose([
                                                  FormBuilderValidators.required(
                                                    errorText:
                                                        "Ovo polje je obavezno.",
                                                  ),
                                                ]),
                                                name: "firstPaymentDeadline",
                                                inputType: InputType.date,
                                                format: DateFormat(
                                                  "dd.MM.yyyy",
                                                ),
                                                enabled: _isEditable,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                decoration: InputDecoration(
                                                  labelStyle: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                  labelText:
                                                      "Krajnji datum za uplatu prve rate",
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 300,
                                              child: FormBuilderDateTimePicker(
                                                validator: FormBuilderValidators.compose([
                                                  FormBuilderValidators.required(
                                                    errorText:
                                                        "Ovo polje je obavezno.",
                                                  ),
                                                ]),
                                                name: "lastPaymentDeadline",
                                                inputType: InputType.date,
                                                format: DateFormat(
                                                  "dd.MM.yyyy",
                                                ),
                                                enabled: _isEditable,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                decoration: InputDecoration(
                                                  labelStyle: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                  labelText:
                                                      "Krajnji datum za uplatu zadnje rate",
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text("Opis putovanja"),
                                            SizedBox(
                                              width: 300,
                                              child: FormBuilderTextField(
                                                name: "description",
                                                maxLines: 5,
                                                enabled: _isEditable,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                validator: FormBuilderValidators.compose([
                                                  FormBuilderValidators.required(
                                                    errorText:
                                                        "Ovo polje je obavezno.",
                                                  ),
                                                ]),
                                                decoration: InputDecoration(
                                                  labelStyle: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                  labelText: "Unesite opis",
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              width: 300,
                                              child: IntrinsicWidth(
                                                child: FormBuilderDropdown(
                                                  validator: FormBuilderValidators.compose([
                                                    FormBuilderValidators.required(
                                                      errorText:
                                                          "Ovo polje je obavezno.",
                                                    ),
                                                  ]),
                                                  initialValue:
                                                      hotelList != null
                                                      ? offer?.hotelId ?? ""
                                                      : "",
                                                  name: "hotelId",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                  enabled: _isEditable,
                                                  items:
                                                      getHotelDropdownMenuItems(),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 300,
                                              child: FormBuilderDateTimePicker(
                                                validator: FormBuilderValidators.compose([
                                                  FormBuilderValidators.required(
                                                    errorText:
                                                        "Ovo polje je obavezno.",
                                                  ),
                                                ]),
                                                name: "tripStartDate",
                                                inputType: InputType.both,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                format: DateFormat(
                                                  "dd.MM.yyyy HH:mm:ss",
                                                ),
                                                enabled: _isEditable,
                                                decoration: InputDecoration(
                                                  labelStyle: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                  labelText: "Datum polaska",
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 300,
                                              child: FormBuilderDateTimePicker(
                                                validator: FormBuilderValidators.compose([
                                                  FormBuilderValidators.required(
                                                    errorText:
                                                        "Ovo polje je obavezno.",
                                                  ),
                                                ]),
                                                name: "tripEndDate",
                                                inputType: InputType.both,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                format: DateFormat(
                                                  "dd.MM.yyyy HH:mm:ss",
                                                ),
                                                enabled: _isEditable,
                                                decoration: InputDecoration(
                                                  labelStyle: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                  labelText: "Datum povratka",
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 300,
                                              child: IntrinsicWidth(
                                                child: FormBuilderDropdown(
                                                  validator: FormBuilderValidators.compose([
                                                    FormBuilderValidators.required(
                                                      errorText:
                                                          "Ovo polje je obavezno.",
                                                    ),
                                                  ]),
                                                  initialValue:
                                                      boardTypeList != null
                                                      ? offer?.boardTypeId ?? ""
                                                      : "",
                                                  name: "boardTypeId",
                                                  enabled: _isEditable,
                                                  items:
                                                      getBoardTypeDropdownMenuItems(),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 300,
                                              child: FormBuilderTextField(
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                ],
                                                name: "numberOfNights",
                                                enabled: _isEditable,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                validator: FormBuilderValidators.compose([
                                                  FormBuilderValidators.required(
                                                    errorText:
                                                        "Ovo polje je obavezno.",
                                                  ),
                                                ]),
                                                decoration: InputDecoration(
                                                  labelStyle: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                  labelText: "Broj noćenja",
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 300,
                                              child: FormBuilderTextField(
                                                name: "departurePlace",
                                                enabled: _isEditable,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                validator: FormBuilderValidators.compose([
                                                  FormBuilderValidators.required(
                                                    errorText:
                                                        "Ovo polje je obavezno.",
                                                  ),
                                                ]),
                                                decoration: InputDecoration(
                                                  labelStyle: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                  labelText: "Mjesto polaska",
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 300,
                                              child: FormBuilderTextField(
                                                name: "carriers",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                enabled: _isEditable,
                                                validator: FormBuilderValidators.compose([
                                                  FormBuilderValidators.required(
                                                    errorText:
                                                        "Ovo polje je obavezno.",
                                                  ),
                                                ]),
                                                decoration: InputDecoration(
                                                  labelStyle: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                  labelText: "Prevoznici",
                                                ),
                                              ),
                                            ),
                                            widget.offerId != null
                                                ? SizedBox(
                                                    width: 300,
                                                    child: FormBuilderTextField(
                                                      name: "OfferStatus",
                                                      decoration:
                                                          InputDecoration(
                                                            labelText:
                                                                "Status ponude",
                                                          ),
                                                      initialValue: offer
                                                          ?.offerStatus!
                                                          .name,
                                                      readOnly: true,
                                                    ),
                                                  )
                                                : SizedBox(height: 40),
                                            SizedBox(height: 55),
                                            _isEditable
                                                ? ElevatedButton(
                                                    onPressed: uploadDocument,
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.upload,
                                                          size: 15,
                                                        ),
                                                        SizedBox(width: 10),
                                                        Text(
                                                          "Učitaj dokument (PDF)",
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : SizedBox(),
                                            SizedBox(height: 10),
                                            document != null
                                                ? ElevatedButton(
                                                    onPressed: openDocument,
                                                    child: Text(
                                                      "Preuzmi dokument",
                                                    ),
                                                  )
                                                : SizedBox(),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 30),
                              Text("Popusti", style: TextStyle(fontSize: 18)),
                              SizedBox(
                                width: 700,
                                child: Accordion(
                                  headerBackgroundColor: AppColors.primary,
                                  contentBorderColor: AppColors.primary,
                                  maxOpenSections: 1,
                                  children: getDiscountAccordionSectionList(),
                                ),
                              ),
                              SizedBox(
                                width: 700,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed:
                                          isFirstMinuteEnabled && _isEditable
                                          ? () {
                                              offerDiscounts.add(
                                                DiscountAccordionItem(
                                                  discountTypeId: AppConstants
                                                      .firstMinuteDiscountGuid,
                                                  isEditable: true,
                                                  isRemovable: true,
                                                ),
                                              );

                                              setState(() {});
                                            }
                                          : null,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.add,
                                            color: Colors.blueGrey,
                                            size: 15,
                                          ),
                                          SizedBox(width: 2),
                                          Text("Dodaj First Minute"),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 30),
                                    ElevatedButton(
                                      onPressed:
                                          isLastMinuteEnabled && _isEditable
                                          ? () {
                                              offerDiscounts.add(
                                                DiscountAccordionItem(
                                                  discountTypeId: AppConstants
                                                      .lastMinuteDiscountGuid,
                                                  isEditable: true,
                                                  isRemovable: true,
                                                ),
                                              );

                                              setState(() {});
                                            }
                                          : null,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.add,
                                            color: Colors.blueGrey,
                                            size: 15,
                                          ),
                                          SizedBox(width: 2),
                                          Text("Dodaj Last Minute"),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 30),
                              Text("Sobe", style: TextStyle(fontSize: 18)),
                              SizedBox(
                                width: 700,
                                child: Accordion(
                                  headerBackgroundColor: AppColors.primary,
                                  contentBorderColor: AppColors.primary,
                                  maxOpenSections: 1,
                                  children: getRoomAccordionSectionList(),
                                ),
                              ),
                              isRoomUpdateEnabled
                                  ? SizedBox(
                                      width: 700,
                                      child: Center(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            rooms.add(RoomAccordionItem());
                                            setState(() {});
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.add,
                                                color: Colors.blueGrey,
                                                size: 15,
                                              ),
                                              SizedBox(width: 2),
                                              Text("Dodaj"),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                              SizedBox(height: 20),
                              SizedBox(
                                width: 700,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    (offer?.offerStatusId?.toLowerCase() ==
                                                AppConstants.draftOfferGuid
                                                    .toLowerCase() &&
                                            _isEditable)
                                        ? ElevatedButton(
                                            onPressed: !_isActivationInProcess
                                                ? () async {
                                                    await activateOffer();
                                                  }
                                                : null,
                                            child: !_isActivationInProcess
                                                ? Text("Aktiviraj ponudu")
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          8.0,
                                                        ),
                                                    child: SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                      child: Transform.scale(
                                                        scale: 0.6,
                                                        child:
                                                            const CircularProgressIndicator(
                                                              strokeWidth: 2,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                          )
                                        : SizedBox(),
                                    (offer?.offerStatusId?.toLowerCase() ==
                                                AppConstants.activeOfferGuid
                                                    .toLowerCase() &&
                                            _isEditable)
                                        ? ElevatedButton(
                                            onPressed: !_isDeactivationInProcess
                                                ? () async {
                                                    await deactivateOffer();
                                                  }
                                                : null,
                                            child: !_isDeactivationInProcess
                                                ? Text("Deaktiviraj ponudu")
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          8.0,
                                                        ),
                                                    child: SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                      child: Transform.scale(
                                                        scale: 0.6,
                                                        child:
                                                            const CircularProgressIndicator(
                                                              strokeWidth: 2,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                          )
                                        : SizedBox(),
                                    SizedBox(width: 20),
                                    _isEditable
                                        ? ElevatedButton(
                                            onPressed: _isProcessing
                                                ? null
                                                : () async {
                                                    await addUpdateOffer();
                                                  },
                                            child: !_isProcessing
                                                ? Text(
                                                    widget.offerId == null
                                                        ? "Sačuvaj kao skicu"
                                                        : "Sačuvaj promjene",
                                                  )
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          8.0,
                                                        ),
                                                    child: SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                      child: Transform.scale(
                                                        scale: 0.6,
                                                        child:
                                                            const CircularProgressIndicator(
                                                              strokeWidth: 2,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                          )
                                        : SizedBox(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Future openDocument() async {
    Directory tempDir = await getTemporaryDirectory();

    String filePath = '${tempDir.path}/${documentName}';

    File file = File(filePath);
    await file.writeAsBytes(document!);

    final result = await OpenFile.open(filePath);
  }

  Future uploadDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result == null || result.files.single.path == null) {
      document = null;
      documentName = null;
      setState(() {});
      return;
    }

    File file = File(result.files.single.path!);

    if (!file.path.toLowerCase().endsWith('.pdf')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Dokument mora biti u PDF formatu.")),
      );
      return;
    }

    var documentBytes = await file.readAsBytes();
    document = documentBytes;
    documentName = result.files.first.name;

    setState(() {});
  }

  Future uploadPhoto() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result == null || result.files.single.path == null) {
      photo = null;
      photoName = null;
      setState(() {});
      return;
    }

    File file = File(result.files.single.path!);

    final validImageExtensions = [
      '.jpg',
      '.jpeg',
      '.png',
      '.gif',
      '.bmp',
      '.webp',
    ];
    if (!validImageExtensions.any(
      (ext) => file.path.toLowerCase().endsWith(ext),
    )) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Odabrani fajl mora biti slika.")),
      );
      return;
    }

    var photoBytes = await file.readAsBytes();
    photo = photoBytes;
    photoName = result.files.first.name;

    setState(() {});
  }

  Future fetchHotelData() async {
    hotelList = (await hotelProvider.getAll({
      "recordsPerPage": 50,
    })).listOfRecords;

    if (!mounted) return;
    setState(() {});
  }

  Future fetchBoardTypeData() async {
    boardTypeList = await entityCodeValueProvider.GetBoardTypeList();

    if (!mounted) return;
    setState(() {});
  }

  Future fetchRoomTypeData() async {
    roomTypeList = (await roomTypeProvider.getAll({
      "recordsPerPage": 50,
    })).listOfRecords;

    if (!mounted) return;
    setState(() {});
  }

  List<AccordionSection> getRoomAccordionSectionList() {
    List<AccordionSection> accordionSectionList = [];
    formBuilderRoomsKey.clear();

    for (int i = 0; i < rooms.length; i++) {
      var globalKey = GlobalKey<FormBuilderState>();
      formBuilderRoomsKey.add(globalKey);

      var accordionSection = AccordionSection(
        header: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Tip sobe ${(i + 1).toString()}",
            style: TextStyle(color: Colors.white),
          ),
        ),
        content: FormBuilder(
          initialValue: rooms[i].toJson(),
          key: globalKey,
          child: Column(
            children: [
              Visibility(
                visible: false,
                maintainAnimation: false,
                maintainSize: false,
                maintainState: true,
                child: FormBuilderTextField(name: "id"),
              ),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 20,
                children: [
                  SizedBox(
                    width: 200,
                    child: FormBuilderDropdown(
                      onChanged: (value) {
                        rooms[i].roomTypeId = value;
                      },
                      enabled: isRoomUpdateEnabled,
                      name: "roomTypeId",
                      initialValue: roomTypeList != null
                          ? rooms[i].roomTypeId
                          : "",
                      items: getRoomTypeDropdownMenuItems(),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: "Ovo polje je obavezno.",
                        ),
                      ]),
                    ),
                  ),
                  SizedBox(
                    width: 420,
                    child: FormBuilderTextField(
                      onChanged: (value) {
                        rooms[i].shortDescription = value;
                      },
                      enabled: isRoomUpdateEnabled,
                      style: TextStyle(color: Colors.black),
                      name: "shortDescription",
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.black),
                        labelText: "Kratki opis",
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: "Ovo polje je obavezno.",
                        ),
                      ]),
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    child: FormBuilderTextField(
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
                      onChanged: (value) {
                        rooms[i].pricePerPerson = value;
                      },
                      enabled: isRoomUpdateEnabled,
                      name: "pricePerPerson",
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.black),
                        labelText: "Cijena po osobi (KM)",
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: "Ovo polje je obavezno.",
                        ),
                      ]),
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    child: FormBuilderTextField(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) {
                        globalKey.currentState!.save();
                        rooms[i].childDiscount = value;
                      },
                      enabled: isRoomUpdateEnabled,
                      name: "childDiscount",
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.black),
                        labelText: "Dječiji popust (%)",
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: "Ovo polje je obavezno.",
                        ),
                      ]),
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    child: FormBuilderTextField(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) {
                        globalKey.currentState!.save();
                        rooms[i].quantity = value;
                      },
                      enabled: isRoomUpdateEnabled,
                      name: "quantity",
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.black),
                        labelText: "Broj soba",
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: "Ovo polje je obavezno.",
                        ),
                      ]),
                    ),
                  ),
                  isRoomUpdateEnabled && i != 0
                      ? Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: IconButton(
                            icon: Icon(Icons.delete),
                            color: AppColors.darkRed,
                            onPressed: () {
                              formBuilderRoomsKey.remove(globalKey);
                              rooms.remove(rooms[i]);
                              setState(() {});
                            },
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ],
          ),
        ),
      );

      accordionSectionList.add(accordionSection);
    }

    return accordionSectionList;
  }

  List<AccordionSection> getDiscountAccordionSectionList() {
    List<AccordionSection> offerDiscountAccordionSections = [];
    formBuilderDiscountsKey.clear();

    for (int i = 0; i < offerDiscounts.length; i++) {
      var globalKey = GlobalKey<FormBuilderState>();
      formBuilderDiscountsKey.add(globalKey);
      bool isUpdateEnabled = offerDiscounts[i].isEditable!;
      bool isRemovable = offerDiscounts[i].isRemovable!;

      if (offerDiscounts[i].discountTypeId?.toUpperCase() ==
          AppConstants.firstMinuteDiscountGuid) {
        isFirstMinuteEnabled = false;
      } else {
        isLastMinuteEnabled = false;
      }

      var accordionSection = AccordionSection(
        header: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            offerDiscounts[i].discountTypeId?.toUpperCase() ==
                    AppConstants.lastMinuteDiscountGuid
                ? "Last minute popust"
                : "First minute popust",
            style: TextStyle(color: Colors.white),
          ),
        ),
        content: FormBuilder(
          initialValue: offerDiscounts[i].toJson(),
          key: globalKey,
          child: Column(
            children: [
              Visibility(
                visible: false,
                maintainAnimation: false,
                maintainSize: false,
                maintainState: true,
                child: FormBuilderTextField(name: "id"),
              ),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 20,
                children: [
                  Visibility(
                    visible: false,
                    maintainAnimation: false,
                    maintainSize: false,
                    maintainState: true,
                    child: FormBuilderTextField(name: "discountTypeId"),
                  ),
                  SizedBox(
                    width: 150,
                    child: FormBuilderTextField(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) {
                        offerDiscounts[i].discount = value;
                      },
                      enabled: isUpdateEnabled,
                      name: "discount",
                      decoration: InputDecoration(
                        labelText: "Iznos popusta(%)",
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: "Ovo polje je obavezno.",
                        ),
                      ]),
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: FormBuilderDateTimePicker(
                      onChanged: (value) {
                        offerDiscounts[i].validFrom = value;
                      },
                      enabled: isUpdateEnabled,
                      name: "validFrom",
                      format: DateFormat("dd.MM.yyyy"),
                      decoration: InputDecoration(labelText: "Datum početka"),
                      inputType: InputType.date,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: "Ovo polje je obavezno",
                        ),
                      ]),
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: FormBuilderDateTimePicker(
                      onChanged: (value) {
                        offerDiscounts[i].validTo = value;
                      },
                      enabled: isUpdateEnabled,
                      name: "validTo",
                      format: DateFormat("dd.MM.yyyy"),
                      decoration: InputDecoration(labelText: "Datum završetka"),
                      inputType: InputType.date,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: "Ovo polje je obavezno",
                        ),
                      ]),
                    ),
                  ),
                  isRemovable
                      ? IconButton(
                          icon: Icon(Icons.delete),
                          color: AppColors.darkRed,
                          onPressed: () {
                            if (offerDiscounts[i].discountTypeId
                                    ?.toUpperCase() ==
                                AppConstants.lastMinuteDiscountGuid) {
                              isLastMinuteEnabled = true;
                            } else {
                              isFirstMinuteEnabled = true;
                            }

                            formBuilderDiscountsKey.remove(globalKey);
                            offerDiscounts.remove(offerDiscounts[i]);
                            setState(() {});
                          },
                        )
                      : SizedBox(),
                ],
              ),
            ],
          ),
        ),
      );

      offerDiscountAccordionSections.add(accordionSection);
    }

    return offerDiscountAccordionSections;
  }

  List<DropdownMenuItem> getHotelDropdownMenuItems() {
    List<DropdownMenuItem> dropdownMenuList = [
      DropdownMenuItem(value: "", child: Text("--Hotel--")),
    ];

    if (hotelList != null) {
      for (var hotel in hotelList!) {
        dropdownMenuList.add(
          DropdownMenuItem(value: hotel.id!, child: Text(hotel.name ?? "")),
        );
      }
    }

    return dropdownMenuList;
  }

  List<DropdownMenuItem> getBoardTypeDropdownMenuItems() {
    List<DropdownMenuItem> dropdownMenuList = [
      DropdownMenuItem(value: "", child: Text("--Tip usluge--")),
    ];

    if (boardTypeList != null) {
      for (var boardType in boardTypeList!) {
        dropdownMenuList.add(
          DropdownMenuItem(
            value: boardType.id!,
            child: Text(boardType.name ?? ""),
          ),
        );
      }
    }

    return dropdownMenuList;
  }

  List<DropdownMenuItem> getRoomTypeDropdownMenuItems() {
    List<DropdownMenuItem> dropdownMenuList = [
      DropdownMenuItem(value: "", child: Text("--Tip sobe--")),
    ];

    if (roomTypeList != null) {
      for (var roomType in roomTypeList!) {
        dropdownMenuList.add(
          DropdownMenuItem(
            value: roomType.id!,
            child: Text(roomType.name ?? ""),
          ),
        );
      }
    }

    return dropdownMenuList;
  }

  Future addUpdateOffer() async {
    if (!(await validateOfferForm())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Neuspješna validacija: Neka od obaveznih polja nisu unesena ili su unesena u neispravnom formatu.",
          ),
        ),
      );

      return;
    }

    _isProcessing = true;
    setState(() {});

    formBuilderKey.currentState!.save();

    List<Map<String, dynamic>> roomJsons = [];
    List<Map<String, dynamic>> discountJsons = [];

    for (var roomFormBuilder in formBuilderRoomsKey) {
      roomFormBuilder.currentState!.save();
      var roomJson = roomFormBuilder.currentState!.value;
      roomJsons.add(roomJson);
    }

    for (var discountFormBuilder in formBuilderDiscountsKey) {
      discountFormBuilder.currentState!.save();
      var discountJson = Map<String, dynamic>.from(
        discountFormBuilder.currentState!.value,
      );
      discountJson["validFrom"] = (discountJson["validFrom"] as DateTime)
          .toIso8601String();
      discountJson["validTo"] = (discountJson["validTo"] as DateTime)
          .toIso8601String();

      discountJsons.add(discountJson);
    }

    var offerJson = Map<String, dynamic>.from(
      formBuilderKey.currentState!.value,
    );

    offerJson["roomList"] = roomJsons;
    offerJson["discountList"] = discountJsons;
    offerJson["offerImageBytes"] = photo != null ? base64Encode(photo!) : null;
    offerJson["offerImageName"] = photoName;
    offerJson["offerDocumentBytes"] = document != null
        ? base64Encode(document!)
        : null;
    offerJson["offerDocumentName"] = documentName;
    offerJson["firstPaymentDeadline"] =
        (offerJson["firstPaymentDeadline"] as DateTime).toIso8601String();
    offerJson["lastPaymentDeadline"] =
        (offerJson["lastPaymentDeadline"] as DateTime).toIso8601String();
    offerJson["tripStartDate"] = (offerJson["tripStartDate"] as DateTime)
        .toIso8601String();
    offerJson["tripEndDate"] = (offerJson["tripEndDate"] as DateTime)
        .toIso8601String();

    try {
      if (widget.offerId == null) {
        await offerProvider.add(offerJson);

        if (!mounted) return;

        DialogHelper.openDialog(context, "Uspješno kreirana rezervacija", () {
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => OfferListScreen()),
          );
        });
      } else {
        await offerProvider.update(widget.offerId!, offerJson);

        if (!mounted) return;

        DialogHelper.openDialog(context, "Uspješno sačuvane promjene", () {
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => OfferListScreen()),
          );
        });
      }
    } on Exception catch (ex) {
      globalErrorMessage = ex.toString().replaceFirst("Exception: ", "");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Neuspješna validacija: Neka od obaveznih polja nisu unesena ili su unesena u neispravnom formatu.",
          ),
        ),
      );
    }

    _isProcessing = false;
    setState(() {});
  }

  Future<bool> validateOfferForm() async {
    bool isValidForm = true;
    globalErrorMessage = "";
    setState(() {});

    if (photo == null || photoName == null) {
      photoErrorMessage = "Upload slike je obavezan.";
      isValidForm = false;
      setState(() {});
    } else {
      photoErrorMessage = "";
    }

    await WidgetsBinding.instance.endOfFrame;

    if (!formBuilderKey.currentState!.validate()) {
      isValidForm = false;
    }

    for (var x in formBuilderRoomsKey) {
      if (!x.currentState!.validate()) {
        isValidForm = false;
      }
    }

    for (var x in formBuilderDiscountsKey) {
      if (!x.currentState!.validate()) {
        isValidForm = false;
      }
    }

    return isValidForm;
  }

  Future loadImage() async {
    if (widget.offerId == null) return;

    try {
      var offerImageInfo = await offerProvider.getOfferImage(widget.offerId!);

      if (!mounted) return;

      photo = offerImageInfo.imageBytes;
      photoName = offerImageInfo.imageName;
    } on Exception catch (ex) {}

    setState(() {});
  }

  Future loadDocument() async {
    if (widget.offerId == null) return;

    try {
      var documentInfo = await offerProvider.getOfferDocument(offer!.id!);

      if (!mounted) return;

      document = documentInfo.documentBytes;
      documentName = documentInfo.documentName;
    } on Exception catch (ex) {}

    setState(() {});
  }

  Future activateOffer() async {
    _isActivationInProcess = true;
    setState(() {});

    try {
      await offerProvider.activate(offer!.id!);

      if (!mounted) return;

      DialogHelper.openDialog(context, "Uspješno aktiviranje ponude", () async {
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => AddUpdateOfferScreen(offerId: widget.offerId),
          ),
        );
      });
    } on Exception catch (ex) {
      DialogHelper.openDialog(context, ex.toString(), () {
        Navigator.of(context).pop();
      }, type: DialogType.error);
    }

    _isActivationInProcess = false;
    setState(() {});
  }

  Future deactivateOffer() async {
    _isDeactivationInProcess = true;
    setState(() {});

    try {
      await offerProvider.deactivate(offer!.id!);

      if (!mounted) return;

      DialogHelper.openDialog(context, "Uspješno otkazana ponuda", () async {
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => AddUpdateOfferScreen(offerId: widget.offerId),
          ),
        );
      });
    } on Exception catch (ex) {
      DialogHelper.openDialog(context, ex.toString(), () {
        Navigator.of(context).pop();
      }, type: DialogType.error);
    }

    _isDeactivationInProcess = false;
    setState(() {});
  }

  Future fetchOfferData() async {
    if (widget.offerId == null) {
      _isEditable = true;
      isRoomUpdateEnabled = true;
      rooms.add(RoomAccordionItem());

      setState(() {});
      return;
    }

    offer = await offerProvider.getById(widget.offerId!);

    if (!mounted) return;

    _isEditable = offer!.isEditable!;
    isRoomUpdateEnabled =
        offer!.offerStatusId?.toLowerCase() ==
        AppConstants.draftOfferGuid.toLowerCase();

    await loadDocument();
    await loadImage();

    rooms = offer!.rooms!.map((x) => RoomAccordionItem.fromRoom(x)).toList();
    offerDiscounts = offer!.offerDiscounts!
        .map((x) => DiscountAccordionItem.fromOfferDiscount(x))
        .toList();

    setState(() {});
  }
}
