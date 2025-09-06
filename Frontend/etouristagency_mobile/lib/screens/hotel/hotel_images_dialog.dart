import 'package:etouristagency_mobile/consts/app_colors.dart';
import 'package:etouristagency_mobile/helpers/dialog_helper.dart';
import 'package:etouristagency_mobile/models/hotel/hotel.dart';
import 'package:etouristagency_mobile/providers/hotel_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          height: 350.h,
          decoration: BoxDecoration(
            color: AppColors.lighterBlue,
            borderRadius: BorderRadiusGeometry.circular(20.r),
          ),
          child: Padding(
            padding: EdgeInsetsGeometry.all(16.w),
            child: hotel != null && hotel!.hotelImages != null
                ? hotel!.hotelImages!.isEmpty == false
                      ? PhotoViewGallery.builder(
                          itemCount: hotel!.hotelImages!.length,
                          builder: (BuildContext context, int index) {
                            return PhotoViewGalleryPageOptions.customChild(
                              child: Container(
                                height: 300.h,
                                child: PhotoView(
                                  backgroundDecoration: BoxDecoration(
                                    color: AppColors.lighterBlue,
                                  ),
                                  imageProvider: NetworkImage(
                                    "${hotelProvider.controllerUrl}/${hotel!.hotelImages![index].id}/image",
                                  ),
                                ),
                              ),
                            );
                          },
                          scrollPhysics: const BouncingScrollPhysics(),
                        )
                      : Center(
                          child: Text(
                            "Trenutno nema dostupnih fotografija za ovaj hotel.",
                            style: TextStyle(fontSize: 15.sp),
                            textAlign: TextAlign.center,
                          ),
                        )
                : DialogHelper.openSpinner(context, "Učitavam fotografije..."),
          ),
        ),
      ),
    );
  }

  Future fetchHotelData() async {
    hotel = Hotel.fromJson(await hotelProvider.getById(widget.hotelId));

    if(!mounted) return;
    setState(() {});
  }
}