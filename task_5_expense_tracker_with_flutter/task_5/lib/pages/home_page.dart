import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_5/services/firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

//logout from account
void logout() {
  FirebaseAuth.instance.signOut();
}

class _HomePageState extends State<HomePage> {
  final Firestore firestoreService = Firestore();
  final TextEditingController textController = TextEditingController();
  String selectedCategory = 'Food'; // Default category

  // List of categories
  final List<String> categories = [
    'Food',
    'Medical',
    'Groceries',
    'Eat Out',
    'Education'
  ];

  // Map of categories to icons
  final Map<String, IconData> categoryIcons = {
    'Food': Icons.fastfood,
    'Medical': Icons.local_hospital,
    'Groceries': Icons.shopping_cart,
    'Eat Out': Icons.restaurant,
    'Education': Icons.school,
  };
//dialog box for add button
  void openExpenseBox({String? docID}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.teal[50],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textController,
              decoration: InputDecoration(hintText: 'Enter Expense'),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            //different expense categories
            DropdownButton<String>(
              dropdownColor: Colors.teal[50],
              value: selectedCategory,
              items: categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue!;
                });
              },
            ),
          ],
        ),
        actions: [
          //adding/updating expenses
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal[700],
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              //if no value is entered

              if (textController.text.isEmpty ||
                  double.tryParse(textController.text) == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Please enter a valid expense amount')),
                );
                return;
              }
              //if need to add new expense
              if (docID == null) {
                firestoreService.addExpense(
                    textController.text, selectedCategory);
                //if need to update existing expense
              } else {
                firestoreService.updateExpense(
                    docID, textController.text, selectedCategory);
              }
              textController.clear();
              Navigator.pop(context);
            },
            child: Text(docID == null ? 'Add Expense' : 'Update Expense'),
          ),
          //if no longer need to add expense
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal[700],
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              textController.clear();
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

// calculating total expense
  double calculateTotalExpenses(List expenseList) {
    double total = 0;
    for (var doc in expenseList) {
      total += double.tryParse(doc['expense']) ?? 0;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Text("Expense Tracker"),
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
        actions: [IconButton(onPressed: logout, icon: Icon(Icons.logout))],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openExpenseBox,
        backgroundColor: Color.fromRGBO(0, 121, 107, 0.5),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: StreamBuilder(
        //displaying expense list
        stream: firestoreService.getExpenseStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //if there is list of expense
            List expenseList = snapshot.data!.docs;
            double totalExpenses = calculateTotalExpenses(expenseList);
            return Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                //displaying total expense
                Container(
                    height: 160,
                    width: 390,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.teal[700],
                    ),
                    padding: EdgeInsets.all(5),
                    child: Center(
                      child: Text(
                        'Total Expenses: PKR ${totalExpenses.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  // display expenses
                  child: ListView.builder(
                    itemCount: expenseList.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = expenseList[index];
                      String docID = document.id;
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      String expenseText = data['expense'];
                      String category = data['category'];
                      return Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Color.fromRGBO(227, 240, 239, 0.7),
                        ),
                        child: ListTile(
                            leading: Icon(
                                color: Colors.teal[700],
                                categoryIcons[category]),
                            title: Text(expenseText),
                            subtitle: Text(category),
                            trailing:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              //update existing expense
                              IconButton(
                                color: Colors.teal[700],
                                icon: const Icon(Icons.edit),
                                onPressed: () => openExpenseBox(docID: docID),
                              ),
                              //delete exisiting expense
                              IconButton(
                                color: Colors.teal[700],
                                icon: const Icon(Icons.delete),
                                onPressed: () =>
                                    firestoreService.deleteExpense(docID),
                              ),
                            ])),
                      );
                    },
                  ),
                ),
              ],
            );
          }
          //if no expense list
          else {
            return const Center(child: Text('No expenses...'));
          }
        },
      ),
    );
  }
}
