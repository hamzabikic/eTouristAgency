import 'dart:convert';

import 'package:etouristagency_mobile/consts/app_colors.dart';
import 'package:etouristagency_mobile/helpers/dialog_helper.dart';
import 'package:etouristagency_mobile/models/hotel/hotel.dart';
import 'package:etouristagency_mobile/providers/hotel_provider.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class HotelImageDialog extends StatefulWidget {
  final String hotelId;
  const HotelImageDialog(this.hotelId, {super.key});

  @override
  State<HotelImageDialog> createState() => _HotelImageDialogState();
}

class _HotelImageDialogState extends State<HotelImageDialog> {
  Hotel? hotel;
  late final HotelProvider hotelProvider;

  @override
  void initState() {
    hotelProvider = HotelProvider();
    fetchHotelData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: IntrinsicHeight(
        child: Container(
          height: 350,
          decoration: BoxDecoration(
            color: AppColors.lighterBlue,
            borderRadius: BorderRadiusGeometry.circular(20),
          ),
          child: Padding(
            padding: EdgeInsetsGeometry.all(16),
            child: hotel != null && hotel!.hotelImages != null
                ? PhotoViewGallery.builder(
                    itemCount: hotel!.hotelImages!.length,
                    builder: (BuildContext context, int index) {
                      return PhotoViewGalleryPageOptions.customChild(
                        child: Container(
                          height: 300,
                          child: PhotoView(
                            backgroundDecoration: BoxDecoration(color: AppColors.lighterBlue),
                            imageProvider: MemoryImage(
                              base64Decode(
                                hotel!.hotelImages![index].imageBytes!,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    scrollPhysics: const BouncingScrollPhysics(),
                    // Možeš dodati i PageController ako ti treba navigacija strelicama
                    // pageController: _pageController,
                  )
                : DialogHelper.openSpinner(context, "Učitavam fotografije..."),
          ),
        ),
      ),
    );
  }

  Future fetchHotelData() async {
    hotel = Hotel.fromJson(await hotelProvider.getById(widget.hotelId));

    setState(() {});
  }
}
