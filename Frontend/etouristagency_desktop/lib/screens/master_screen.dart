import 'package:etouristagency_desktop/consts/app_colors.dart';
import 'package:etouristagency_desktop/consts/entity_code.dart';
import 'package:etouristagency_desktop/consts/screen_names.dart';
import 'package:etouristagency_desktop/screens/city/city_list_screen.dart';
import 'package:etouristagency_desktop/screens/country/country_list_screen.dart';
import 'package:etouristagency_desktop/screens/entity_code_value/entity_code_value_list_screen.dart';
import 'package:etouristagency_desktop/screens/hotel/hotel_list_screen.dart';
import 'package:etouristagency_desktop/screens/login_screen.dart';
import 'package:etouristagency_desktop/screens/offer/offer_list_screen.dart';
import 'package:etouristagency_desktop/screens/user/account_screen.dart';
import 'package:etouristagency_desktop/screens/user/user_list_screen.dart';
import 'package:etouristagency_desktop/services/auth_service.dart';
import 'package:flutter/material.dart';

class MasterScreen extends StatefulWidget {
  final Widget body;
  final String? screenName;
  const MasterScreen(this.screenName, this.body, {super.key});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  late final AuthService authService;
  bool isOffersOpened = false;
  bool isUsersOpened = false;
  bool isEntityCodesOpened = false;
  bool isAdminPanelOpened = false;

  @override
  void initState() {
    authService = AuthService();
    setBooleans();
    super.initState();
  }

  void setBooleans() {
    isOffersOpened = widget.screenName == ScreenNames.offerScreen;
    isUsersOpened = widget.screenName == ScreenNames.userScreen;
    isEntityCodesOpened = widget.screenName == ScreenNames.entityCodeScreen;
    isAdminPanelOpened = widget.screenName == ScreenNames.adminPanelScreen;
  }

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
            child: Stack(
              children: [Positioned(top:0, left:0, child: Image.asset("lib/assets/images/logo.png", width: 70,)), Center(
                child: Row(
                  spacing: 20,
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
                        isOffersOpened,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => UserListScreen(),
                          ),
                        );
                      },
                      child: generateNavbarItem(
                        Icons.groups,
                        "Korisnici",
                        isUsersOpened,
                      ),
                    ),
                    getEntityCodesDropdown(),
                    getProfileDropdown(),
                  ],
                ),
              )],
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
      onSelected: (value) async {
        if (value == "logout") {
          await authService.clearCredentials();

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
      child: generateNavbarItem(Icons.person, "Moj nalog", isAdminPanelOpened),
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

        if (value == "reservationStatus") {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) =>
                  EntityCodeValueListScreen(EntityCode.reservationStatus),
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
      child: generateNavbarItem(
        Icons.storage,
        "Šifarnici",
        isEntityCodesOpened,
      ),
      itemBuilder: (context) {
        return [
          PopupMenuItem<String>(
            value: 'boardType',
            child: Text('Tipovi usluga'),
          ),
          PopupMenuItem<String>(
            value: 'reservationStatus',
            child: Text('Statusi rezervacije'),
          ),
          PopupMenuItem<String>(value: 'hotel', child: Text('Hoteli')),
          PopupMenuItem<String>(value: 'city', child: Text('Gradovi')),
          PopupMenuItem<String>(value: 'country', child: Text('Države')),
        ];
      },
    );
  }

  Widget generateNavbarItem(IconData icon, String text, bool isItemOpened) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.white, size: 30),
        IntrinsicWidth(
          child: Column(
            children: [
              Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
              isItemOpened ? const SizedBox(height: 2) : const SizedBox(),
              isItemOpened
                  ? Container(
                      height: 2, // Debljina linije
                      color: Colors.white, // Boja linije
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}
