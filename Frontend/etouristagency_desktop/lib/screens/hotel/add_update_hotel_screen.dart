import 'dart:convert';
import 'dart:io';

import 'package:etouristagency_desktop/consts/app_colors.dart';
import 'package:etouristagency_desktop/helpers/dialog_helper.dart';
import 'package:etouristagency_desktop/models/city/city.dart';
import 'package:etouristagency_desktop/models/hotel/hotel.dart';
import 'package:etouristagency_desktop/models/hotel/hotel_image.dart';
import 'package:etouristagency_desktop/providers/city_provider.dart';
import 'package:etouristagency_desktop/providers/hotel_provider.dart';
import 'package:etouristagency_desktop/screens/hotel/hotel_list_screen.dart';
import 'package:etouristagency_desktop/screens/master_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AddUpdateHotelScreen extends StatefulWidget {
  final Hotel? hotel;
  const AddUpdateHotelScreen({super.key, this.hotel});

  @override
  State<AddUpdateHotelScreen> createState() => _AddUpdateHotelScreenState();
}

class _AddUpdateHotelScreenState extends State<AddUpdateHotelScreen> {
  List<City>? cityData;
  late final CityProvider cityProvider;
  late final HotelProvider hotelProvider;
  List<HotelImage>? images;
  GlobalKey<FormBuilderState> addHotelFormBuilder =
      GlobalKey<FormBuilderState>();

  @override
  void initState() {
    images = widget.hotel?.hotelImages;
    cityProvider = CityProvider();
    hotelProvider = HotelProvider();
    fetchCityData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadiusGeometry.all(Radius.circular(16)),
                color: AppColors.primaryTransparent,
              ),
              width: 700,
              child: Padding(
                padding: EdgeInsetsGeometry.all(16.0),
                child: FormBuilder(
                  initialValue: widget.hotel?.toJson() ?? {},
                  key: addHotelFormBuilder,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 700,
                        child: Center(
                          child: Text(
                            widget.hotel == null
                                ? "Novi hotel"
                                : "Izmjena hotela",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ),
                      ),
                      FormBuilderTextField(
                        name: "name",
                        decoration: InputDecoration(labelText: "Naziv hotela"),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                            errorText: "Ovo polje je obavezno.",
                          ),
                        ]),
                      ),
                      FormBuilderDropdown(
                        name: "cityId",
                        initialValue: widget.hotel?.cityId ?? "",
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                            errorText: "Ovo polje je obavezno.",
                          ),
                        ]),
                        items: getCityDropdownItems(),
                      ),
                      FormBuilderTextField(
                        name: "starRating",
                        decoration: InputDecoration(
                          labelText: "Broj zvjezdica",
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                            errorText: "Ovo polje je obavezno.",
                          ),
                          (value) {
                            int? number = int.tryParse(value ?? "");
                            if (number == null || number < 2 || number > 10) {
                              return "Dozvoljen unos broja između 2 i 10";
                            }

                            return null;
                          },
                        ]),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: addHotel,
                            child: Text(
                              widget.hotel == null
                                  ? "Sačuvaj"
                                  : "Sačuvaj promjene",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text("Fotografije", style: TextStyle(fontSize: 18)),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ElevatedButton(
                            onPressed: uploadPhoto,
                            child: Row(
                              children: [
                                Icon(Icons.upload, size: 15),
                                SizedBox(width: 10),
                                Text("Učitaj sliku"),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      getWrapOfImages(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem> getCityDropdownItems() {
    var items = [DropdownMenuItem(value: "", child: Text("-- Grad --"))];

    if (cityData != null) {
      for (var item in cityData!) {
        var dropdownItem = DropdownMenuItem(
          value: item.id,
          child: Text(item.name ?? ""),
        );

        items.add(dropdownItem);
      }
    }

    return items;
  }

  Future fetchCityData() async {
    cityData = (await cityProvider.getAll({
      "recordsPerPage": 1000,
    })).listOfRecords;

    setState(() {});
  }

  Widget getWrapOfImages() {
    if (images == null || images!.length == 0) return SizedBox();

    return Center(
      child: Wrap(
        spacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: 10,
        children: images!
            .map(
              (x) => Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryTransparent,
                      border: Border.all(color: AppColors.primary, width: 1.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.all(4),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.memory(
                        base64Decode(x.imageBytes ?? ""),
                        fit: BoxFit.fill,
                        height: 200,
                        width: 300,
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(130, -200),
                    child: IconButton(
                      icon: Icon(Icons.remove_circle, color: AppColors.darkRed),
                      onPressed: () {
                        images!.remove(x);
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  Future uploadPhoto() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result == null || result.files.single.path == null) {
      setState(() {});
      return;
    }

    File file = File(result.files.single.path!);
    var photoBytes = file.readAsBytesSync();
    var photo = base64Encode(photoBytes);

    if (images != null) {
      images!.add(HotelImage(null, photo));
    } else {
      images = [HotelImage(null, photo)];
    }

    setState(() {});
  }

  Future addHotel() async {
    bool isValid = addHotelFormBuilder.currentState!.validate();

    if (!isValid) return;

    addHotelFormBuilder.currentState!.save();
    var formBuilderModel = addHotelFormBuilder.currentState!.value;
    var jsonModel = Map<String, dynamic>.from(formBuilderModel);

    try {
      if (widget.hotel == null) {
        jsonModel["images"] = images?.map((e) => e.imageBytes).toList();
        await hotelProvider.add(jsonModel);
      } else {
        jsonModel["images"] = images?.map((e) => e.toJson()).toList();
        await hotelProvider.update(widget.hotel!.id!, jsonModel);
      }

      DialogHelper.openDialog(
        context,
        widget.hotel == null
            ? "Uspješno dodavanje novog hotela"
            : "Uspješno sačuvane promjene",
        () {
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HotelListScreen()),
          );
        },
        type: DialogType.success,
      );
    } on Exception catch (ex) {
      DialogHelper.openDialog(context, ex.toString(), () {
        Navigator.of(context).pop();
      }, type: DialogType.error);
    }
  }
}
