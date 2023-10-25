import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:project_money_tracker/databases/databases.dart';
import 'package:project_money_tracker/databases/transaction_category.dart';

class TransactionPage extends StatefulWidget {
  final TransactionCategory? transactionCategory;
  const TransactionPage({
    Key? key,
    required this.transactionCategory,
  }) : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final AppDb database = AppDb();
  bool isExpaense = true;
  late int type;

  TextEditingController Datecontrol = TextEditingController();
  TextEditingController amountControl = TextEditingController();
  TextEditingController detailControl = TextEditingController();
  Category? SelectedCategory;

  Future insert(int amount, DateTime date, String detail, int id) async {
    DateTime now = DateTime.now();
    await database.into(database.transactions).insertReturning(
        TransactionsCompanion.insert(
            name: detail,
            category_id: id,
            amount: amount,
            transaction_date: date,
            createdAt: now,
            updatedAt: now));
  }

  Future<List<Category>> getAllCategory(int type) async {
    return await database.getAllCategoryRepo(type);
  }

  @override
  void initState() {
    // TODO: implement initState
    if (widget.transactionCategory != null) {
      updateTransaksiHome(widget.transactionCategory!);
    }
    type = 2;
    super.initState();
  }

  void updateTransaksiHome(TransactionCategory initTransaction) {
    amountControl.text = initTransaction.transaction.amount.toString();
    detailControl.text = initTransaction.transaction.name.toString();
    Datecontrol.text = DateFormat('yyyy-MM-dd')
        .format(initTransaction.transaction.transaction_date);
    type = initTransaction.category.type;
    (type == 2) ? isExpaense = true : isExpaense = false;
    SelectedCategory = initTransaction.category;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Transaction"),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Switch(
                    value: isExpaense,
                    onChanged: (bool value) {
                      setState(() {
                        isExpaense = value;
                        type = (isExpaense) ? 2 : 1;
                        SelectedCategory = null;
                      });
                    },
                    inactiveTrackColor: Colors.green[200],
                    inactiveThumbColor: Colors.green,
                    activeColor: Colors.red,
                  ),
                  Text(
                    isExpaense ? 'Expense' : 'Icome',
                    style: GoogleFonts.montserrat(fontSize: 14),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: amountControl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: const UnderlineInputBorder(),
                      labelText: "Amount",
                      labelStyle: GoogleFonts.montserrat()),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Category",
                  style: GoogleFonts.montserrat(fontSize: 16),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              FutureBuilder<List<Category>>(
                  future: getAllCategory(type),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      if (snapshot.hasData) {
                        if (snapshot.data!.isNotEmpty) {
                          SelectedCategory = (SelectedCategory == null)
                              ? snapshot.data!.first
                              : SelectedCategory;
                          //SelectedCategory = snapshot.data!.first;
                          print(snapshot.toString());
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: DropdownButton<Category>(
                              value: SelectedCategory,
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_downward),
                              items: snapshot.data!.map((Category item) {
                                return DropdownMenuItem<Category>(
                                  value:
                                      item, // Set the value property to the current item
                                  child: Text(item.name),
                                );
                              }).toList(),
                              onChanged: (Category? value) {
                                setState(() {
                                  SelectedCategory = value;
                                });
                              },
                            ),
                          );
                        } else {
                          return const Center(
                            child: Text("Data Not Found"),
                          );
                        }
                      } else {
                        return const Center(
                          child: Text("Data Not Found"),
                        );
                      }
                    }
                  }),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  controller: Datecontrol,
                  decoration: const InputDecoration(
                    labelText: "Enter Date",
                  ),
                  onTap: () async {
                    DateTime? pickaDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2015),
                        lastDate: DateTime(2030));

                    if (pickaDate != Null) {
                      String formate =
                          DateFormat('yyyy-MM-dd').format(pickaDate!);

                      Datecontrol.text = formate;
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: detailControl,
                  decoration: InputDecoration(
                      border: const UnderlineInputBorder(),
                      labelText: "Detail",
                      labelStyle: GoogleFonts.montserrat()),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Center(
                  child: ElevatedButton(
                      onPressed: () {
                        insert(
                            int.parse(amountControl.text),
                            DateTime.parse(Datecontrol.text),
                            detailControl.text,
                            SelectedCategory!.id);

                        Navigator.pop(context, true);
                      },
                      child: const Text("Save")))
            ],
          ),
        ),
      ),
    );
  }
}
