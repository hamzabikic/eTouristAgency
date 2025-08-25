import 'package:etouristagency_desktop/consts/app_colors.dart';
import 'package:etouristagency_desktop/models/reservation_review/reservation_review.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReservationReviewDialog extends StatefulWidget {
  final ReservationReview reservationReview;
  const ReservationReviewDialog(this.reservationReview, {super.key});

  @override
  State<ReservationReviewDialog> createState() =>
      _ReservationReviewDialogState();
}

class _ReservationReviewDialogState extends State<ReservationReviewDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: IntrinsicHeight(
        child: SizedBox(
          width:400,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Text(
                  "Detalji recenzije",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueGrey,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Ocjena za smještaj",
                  style: TextStyle(color: AppColors.primary),
                ),
                RatingBarIndicator(
                  rating: widget.reservationReview.accommodationRating!
                      .toDouble(),
                  itemBuilder: (context, index) =>
                      Icon(Icons.star, color: Colors.amber),
                  itemCount: 5,
                  itemSize: 40,
                  direction: Axis.horizontal,
                ),
                SizedBox(height: 10),
                Text(
                  "Ocjena za uslugu",
                  style: TextStyle(color: AppColors.primary),
                ),
                RatingBarIndicator(
                  rating: widget.reservationReview.serviceRating!.toDouble(),
                  itemBuilder: (context, index) =>
                      Icon(Icons.star, color: Colors.amber),
                  itemCount: 5,
                  itemSize: 40,
                  direction: Axis.horizontal,
                ),
                SizedBox(height: 10),
                FormBuilderTextField(
                  enabled: false,
                  name: "description",
                  initialValue: widget.reservationReview.description,
                  decoration: InputDecoration(label: Text("Komentar",style: TextStyle(color: Colors.black))),
                  style: TextStyle(color: Colors.black),
                  minLines: 5,
                  maxLines: 5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
