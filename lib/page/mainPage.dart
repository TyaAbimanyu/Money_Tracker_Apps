import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:calendar_appbar/calendar_appbar.dart';
import 'package:project_money_tracker/page/category.dart';
import 'package:project_money_tracker/page/homePage.dart';
import 'package:project_money_tracker/page/transaksi.dart';
import 'package:intl/intl.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late DateTime selectDate;
  late List<Widget> childrn; //Menggunakan Index Area yang akan dipanggil
  late int curr;

  @override
  void initState() {
    // TODO: implement initState
    updateView(0, DateTime.now());
    super.initState();
  }

  void updateView(int index, DateTime? date) {
    setState(() {
      if (date != null) {
        selectDate = DateTime.parse(DateFormat('yyyy-MM-dd').format(date));
      }

      curr = index;
      childrn = [
        HomePage(
          selectDate: selectDate,
        ),
        const CategorPage()
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (curr == 0)
          ? CalendarAppBar(
              accent: Colors.green,
              backButton: false,
              locale: 'id',
              onDateChanged: (value) {
                setState(() {
                  selectDate = value;
                  updateView(0, selectDate);
                });
              },
              firstDate: DateTime.now().subtract(const Duration(days: 365)),
              lastDate: DateTime.now(),
            )
          : PreferredSize(
              preferredSize: const Size.fromHeight(100),
              child: Container(
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 36, horizontal: 16),
                    child: Text(
                      "Categories",
                      style: GoogleFonts.montserrat(
                          fontSize: 20, fontWeight: FontWeight.w400),
                    )),
              )),
      floatingActionButton: Visibility(
        visible: (curr == 0) ? true : false,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => const TransactionPage(
                          transactionCategory: null,
                        )))
                .then((value) {
              setState(() {}); //Arah ke Transaksi Page
            });
          },
          backgroundColor: Colors.green,
          child: const Icon(
            Icons.add,
          ),
        ),
      ),
      body: childrn[curr],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                onPressed: () {
                  updateView(0, DateTime.now());
                },
                icon: const Icon(
                  Icons.home,
                  size: 40,
                )),
            const SizedBox(
              width: 20,
            ),
            IconButton(
                onPressed: () {
                  updateView(1, null);
                },
                icon: const Icon(
                  Icons.list,
                  size: 40,
                ))
          ],
        ),
      ),
    );
  }
}
