import 'package:flutter/material.dart';
import 'package:flutter_application_tugasbesar/View/home_content.dart';
import 'package:flutter_application_tugasbesar/View/profile_view.dart';
import 'package:flutter_application_tugasbesar/View/login.dart';
import 'package:flutter_application_tugasbesar/View/register.dart';
import 'package:flutter_application_tugasbesar/view/history.dart';
import 'package:quickalert/quickalert.dart';

class HomeView extends StatefulWidget {
  final Map<String, dynamic> formData;

  const HomeView({super.key, required this.formData});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  final List<String> appBarTitles = [
    'Selamat Datang\ndi GYM POINT',
    'History',
    'Profile'
  ];

  void _onItemTapped(int index) {
    bool isLoggedIn = widget.formData['username'] != null && widget.formData['username'].isNotEmpty;
    if (!isLoggedIn && (index == 1 || index == 2)) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.info,
        title: 'Akses Ditolak',
        text: 'Anda harus login terlebih dahulu',
        confirmBtnText: 'Login',
        cancelBtnText: 'Cancel',
        showCancelBtn: true,
        confirmBtnColor: Colors.blue,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        titleColor: Colors.white,
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => LoginView(data: widget.formData),
            ),
          );
        },
        onCancelBtnTap: () {
          Navigator.of(context).pop();
        },
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      HomeContent(),
      HistoryPage(),
      ProfileView(formData: widget.formData),
    ];

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[600],
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    appBarTitles[_selectedIndex],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Image.asset(
                  'images/blackLogo.png',
                  height: 90,
                  width: 90,
                ),
              ),
            ],
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}