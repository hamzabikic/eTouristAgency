import 'package:etouristagency_desktop/consts/app_colors.dart';
import 'package:etouristagency_desktop/consts/entity_code.dart';
import 'package:etouristagency_desktop/screens/city/city_list_screen.dart';
import 'package:etouristagency_desktop/screens/country/country_list_screen.dart';
import 'package:etouristagency_desktop/screens/entity_code_value/entity_code_value_list_screen.dart';
import 'package:etouristagency_desktop/screens/hotel/hotel_list_screen.dart';
import 'package:etouristagency_desktop/screens/login_screen.dart';
import 'package:etouristagency_desktop/screens/offer/offer_list_screen.dart';
import 'package:etouristagency_desktop/screens/user/account_screen.dart';
import 'package:etouristagency_desktop/screens/user/user_list_screen.dart';
import 'package:flutter/material.dart';

class MasterScreen extends StatefulWidget {
  final Widget body;
  const MasterScreen(this.body, {super.key});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: AppColors.primary,
            width: MediaQuery.of(context).size.width,
            height: 70,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => OfferListScreen(),
                        ),
                      );
                    },
                    child: generateNavbarItem(
                      Icons.airplane_ticket_outlined,
                      "Ponude",
                    ),
                  ),
                  SizedBox(width: 20),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => UserListScreen(),
                        ),
                      );
                    },
                    child: generateNavbarItem(Icons.groups, "Korisnici"),
                  ),
                  SizedBox(width: 20),
                  getEntityCodesDropdown(),
                  SizedBox(width: 20),
                  getProfileDropdown(),
                ],
              ),
            ),
          ),
          Expanded(child: widget.body),
        ],
      ),
    );
  }

  Widget getProfileDropdown() {
    return PopupMenuButton(
      offset: Offset(0, 65),
      tooltip: "",
      onSelected: (value) {
        if (value == "logout") {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }

        if (value == "profil") {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => AccountScreen()),
          );
        }
      },
      child: generateNavbarItem(Icons.person, "Moj nalog"),
      itemBuilder: (context) {
        return [
          PopupMenuItem<String>(value: 'profil', child: Text('Detalji')),
          PopupMenuItem<String>(value: 'logout', child: Text('Odjavi se')),
        ];
      },
    );
  }

  Widget getEntityCodesDropdown() {
    return PopupMenuButton(
      offset: Offset(0, 65),
      tooltip: "",
      onSelected: (value) {
        if (value == "boardType") {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) =>
                  EntityCodeValueListScreen(EntityCode.boardType),
            ),
          );
        }

        if (value == "hotel") {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HotelListScreen()),
          );
        }

        if (value == "city") {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => CityListScreen()),
          );
        }

        if (value == "country") {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => CountryListScreen()),
          );
        }
      },
      child: generateNavbarItem(Icons.storage, "Šifarnici"),
      itemBuilder: (context) {
        return [
          PopupMenuItem<String>(
            value: 'boardType',
            child: Text('Tipovi usluga'),
          ),
          PopupMenuItem<String>(value: 'hotel', child: Text('Hoteli')),
          PopupMenuItem<String>(value: 'city', child: Text('Gradovi')),
          PopupMenuItem<String>(value: 'country', child: Text('Države')),
        ];
      },
    );
  }

  Widget generateNavbarItem(IconData icon, String text) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.white, size: 30),
        Text(
          text,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}
