import 'package:etouristagency_mobile/consts/app_colors.dart';
import 'package:etouristagency_mobile/screens/account_screen.dart';
import 'package:etouristagency_mobile/screens/offer/last_minute_offer_list_screen.dart';
import 'package:etouristagency_mobile/screens/offer/offer_list_screen.dart';
import 'package:etouristagency_mobile/screens/reservation/my_reservations_list_screen.dart';
import 'package:flutter/material.dart';

class MasterScreen extends StatefulWidget {
  final Widget _widget;
  final String _screenTitle;
  final bool isBackButtonVisible;
  final VoidCallback? onClickMethod;

  const MasterScreen(
    this._screenTitle,
    this._widget, {
    this.isBackButtonVisible = false,
    this.onClickMethod,
    super.key,
  });

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._screenTitle, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        centerTitle: true,
        leadingWidth: 70,
        leading: widget.isBackButtonVisible
            ? IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: widget.onClickMethod,
              )
            : Image.asset("lib/assets/images/logo.png", width: 70, height: 70),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: widget._widget),
          buildMobileNavbar(),
        ],
      ),
    );
  }

  Widget buildMobileNavbar() {
    return Container(
      height: 75,
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
                MaterialPageRoute(
                  builder: (context) => MyReservationsListScreen(),
                ),
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
}