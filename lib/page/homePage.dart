import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_money_tracker/databases/databases.dart';
import 'package:project_money_tracker/databases/transaction_category.dart';
import 'package:project_money_tracker/page/transaksi.dart';

class HomePage extends StatefulWidget {
  final DateTime selectDate;
  const HomePage({Key? key, required this.selectDate}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AppDb database = AppDb();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Income dan Outcome

            Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)),
                          child: const Icon(
                            Icons.download,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Income",
                              style: GoogleFonts.montserrat(
                                  color: Colors.white, fontSize: 12),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Text(
                              "Rp. 3.000.000",
                              style: GoogleFonts.montserrat(
                                  color: Colors.white, fontSize: 12),
                            ),
                          ],
                        )
                      ],
                    ),
                    // SizedBox(
                    //   width: 20,
                    // ),
                    Row(
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8)),
                              child: const Icon(
                                Icons.upload,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Outcome",
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white, fontSize: 12),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  "Rp. 2.000.000",
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            //Text Transaction
            Padding(
              padding: const EdgeInsets.all(18),
              child: Text(
                "Transaction",
                style: GoogleFonts.montserrat(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),

            StreamBuilder<List<TransactionCategory>>(
              stream: database.getTransactionCategoryByDate(widget.selectDate),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isNotEmpty) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Card(
                              elevation: 10,
                              child: ListTile(
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () async {
                                        await database.deleteTransactionRepo(
                                            snapshot
                                                .data![index].transaction.id);
                                        setState(() {});
                                      },
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  TransactionPage(
                                                      transactionCategory:
                                                          snapshot
                                                              .data![index]),
                                            ))
                                            .then((value) {});
                                      },
                                    )
                                  ],
                                ),
                                title: Text("Rp. " +
                                    snapshot.data![index].transaction.amount
                                        .toString()),
                                subtitle: Text(
                                    snapshot.data![index].category.name +
                                        " (" +
                                        snapshot.data![index].category.name +
                                        ")"),
                                leading: Container(
                                  child:
                                      (snapshot.data![index].category.type == 2)
                                          ? Icon(
                                              Icons.upload,
                                              color: Colors.red,
                                            )
                                          : Icon(
                                              Icons.download,
                                              color: Colors.green,
                                            ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: Text("Data Not Found"),
                      );
                    }
                  } else {
                    return Center(
                      child: Text("Data Not Found"),
                    );
                  }
                }
              },
            ),

            //List Transaction
          ],
        ),
      ),
    );
  }
}
