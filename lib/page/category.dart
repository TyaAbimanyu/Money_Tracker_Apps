import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_money_tracker/databases/databases.dart';

class CategorPage extends StatefulWidget {
  const CategorPage({super.key});

  @override
  State<CategorPage> createState() => _CategorPageState();
}

class _CategorPageState extends State<CategorPage> {
  bool isExpaense = true;
  TextEditingController categoryNameController = TextEditingController();
  final AppDb database = AppDb();
  Future insert(int id, String name, int type) async {
    DateTime now = DateTime.now();
    final row = await database.into(database.categories).insertReturning(
        CategoriesCompanion.insert(
            id: id, name: name, Type: type, createdAt: now, updatedAt: now));
    print('Masuk : ' + row.toString());
  }

  Future<List<Category>> getAllCategory(int type) async {
    return await database.getAllCategoryRepo(type);
  }

  void dialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Text(
                      (isExpaense) ? "Add Outcome" : "Add Income",
                      style: GoogleFonts.montserrat(
                          fontSize: 18,
                          color: (isExpaense) ? Colors.red : Colors.green),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: categoryNameController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), hintText: "Name"),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          insert(0, categoryNameController.text,
                              isExpaense ? 2 : 1);
                          Navigator.of(context, rootNavigator: true)
                              .pop('Dialog');
                          setState(() {});
                        },
                        child: const Text("Save"))
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                IconButton(
                    onPressed: () {
                      dialog();
                    },
                    icon: const Icon(Icons.add))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              elevation: 10,
              child: ListTile(
                title: const Text("Bayar Cicilan"),
                leading: (isExpaense == true)
                    ? const Icon(
                        Icons.upload,
                        color: Colors.red,
                      )
                    : const Icon(
                        Icons.download,
                        color: Colors.green,
                      ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.delete)),
                    const SizedBox(
                      width: 10,
                    ),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              elevation: 10,
              child: ListTile(
                title: const Text("Bayar Cicilan"),
                leading: (isExpaense == true)
                    ? const Icon(
                        Icons.upload,
                        color: Colors.red,
                      )
                    : const Icon(
                        Icons.download,
                        color: Colors.green,
                      ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.delete)),
                    const SizedBox(
                      width: 10,
                    ),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              elevation: 10,
              child: ListTile(
                title: const Text("Bayar Cicilan"),
                leading: (isExpaense == true)
                    ? const Icon(
                        Icons.upload,
                        color: Colors.red,
                      )
                    : const Icon(
                        Icons.download,
                        color: Colors.green,
                      ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.delete)),
                    const SizedBox(
                      width: 10,
                    ),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
