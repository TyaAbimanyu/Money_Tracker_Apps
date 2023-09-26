import 'dart:async';

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
  int type = 2;
  TextEditingController categoryNameController = TextEditingController();
  final AppDb database = AppDb();
  Future insert(String name, int type) async {
    DateTime now = DateTime.now();
    final row = await database
        .into(database.categories)
        .insertReturning(CategoriesCompanion.insert(
          name: name,
          type: type,
          createdAt: now,
          updatedAt: now,
        ));
    print('Masuk : ' + row.toString());
  }

  Future<List<Category>> getAllCategory(int type) async {
    return await database.getAllCategoryRepo(type);
  }

  Future update(int categoryId, String newName) async {
    await database.updateaCategoryRepo(categoryId, newName);
  }

  void dialog(Category? category) {
    if (category != null) {
      categoryNameController.text = category.name;
    }
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
                          if (category == null) {
                            insert(categoryNameController.text,
                                isExpaense ? 2 : 1);
                          } else {
                            update(category.id, categoryNameController.text);
                          }
                          setState(() {});
                          Navigator.of(context, rootNavigator: true)
                              .pop('Dialog');
                          categoryNameController.clear();
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
                      type = value ? 2 : 1;
                    });
                  },
                  inactiveTrackColor: Colors.green[200],
                  inactiveThumbColor: Colors.green,
                  activeColor: Colors.red,
                ),
                IconButton(
                    onPressed: () {
                      dialog(null);
                    },
                    icon: const Icon(Icons.add))
              ],
            ),
          ),
          FutureBuilder<List<Category>>(
              future: getAllCategory(type),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.hasData) {
                    if (snapshot.data!.length > 0) {
                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Card(
                                elevation: 10,
                                child: ListTile(
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            database.deleteCategoryRepo(
                                                snapshot.data![index].id);

                                            setState(() {});
                                          },
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.edit),
                                          onPressed: () {
                                            dialog(snapshot.data![index]);
                                          },
                                        )
                                      ],
                                    ),
                                    leading: Container(
                                        padding: EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: (isExpaense)
                                            ? Icon(Icons.upload,
                                                color: Colors.redAccent[400])
                                            : Icon(
                                                Icons.download,
                                                color: Colors.greenAccent[400],
                                              )),
                                    title: Text(snapshot.data![index].name)),
                              ),
                            );
                          });
                    } else {
                      return Center(
                        child: Text("No Has Data"),
                      );
                    }
                  } else {
                    return Center(
                      child: Text("No Has Data"),
                    );
                  }
                }
              }),
        ],
      ),
    );
  }
}
