import 'package:etouristagency_mobile/consts/app_colors.dart';
import 'package:etouristagency_mobile/screens/account_screen.dart';
import 'package:etouristagency_mobile/screens/offer/last_minute_offer_list_screen.dart';
import 'package:etouristagency_mobile/screens/offer/offer_list_screen.dart';
import 'package:etouristagency_mobile/screens/reservation/my_reservations_list_screen.dart';
import 'package:flutter/material.dart';

class MasterScreen extends StatefulWidget {
  final Widget _widget;
  final String _screenTitle;

  const MasterScreen(this._screenTitle, this._widget, {super.key});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildScreenTitle(),
          Expanded(child: widget._widget),
          buildMobileNavbar(),
        ],
      ),
    );
  }

  Widget buildMobileNavbar() {
    return Container(
      height: 70,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: AppColors.primary),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            child: buildNavbarItem(Icons.hourglass_bottom, "Last Minute"),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => LastMinuteOfferListScreen(),
                ),
              );
            },
          ),
          InkWell(
            child: buildNavbarItem(Icons.airplanemode_active, "Ponude"),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => OfferListScreen()),
              );
            },
          ),
          InkWell(
            child: buildNavbarItem(Icons.calendar_month, "Moja putovanja"),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => MyReservationsListScreen()),
              );
            },
          ),
          InkWell(
            child: buildNavbarItem(Icons.person, "Moj nalog"),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => AccountScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildNavbarItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 25),
          Text(
            text,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  Widget buildScreenTitle() {
    return Container(
      color: AppColors.primary,
      height: 70,
      child: Center(
        child: Row(
          children: [
            Image.asset("lib/assets/images/logo.png", width: 70, height: 70),
            SizedBox(
              width: MediaQuery.of(context).size.width - 70,
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        widget._screenTitle,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(width: 70),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
