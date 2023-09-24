import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  bool isExpaense = true;
  List<String> list = ["Hang Out", "Food & Beverage", "Shopping", "Saving"];
  late String dropDownValue = list.first;
  TextEditingController Datecontrol = TextEditingController();

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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButton<String>(
                    value: dropDownValue,
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_downward),
                    items: list.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {}),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
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
              Center(
                  child: ElevatedButton(onPressed: () {}, child: const Text("Save")))
            ],
          ),
        ),
      ),
    );
  }
}
