import 'package:cloud_firestore/cloud_firestore.dart';

class Firestore {
  // Get collection
  final CollectionReference expenses =
      FirebaseFirestore.instance.collection('expenses');

  // Create
  Future<void> addExpense(String? expense, String selectedCategory) {
    return expenses.add({
      'expense': expense,
      'category': selectedCategory,
      'timestamp': Timestamp.now(),
    });
  }

  // Read
  Stream<QuerySnapshot> getExpenseStream() {
    final expenseStream =
        expenses.orderBy('timestamp', descending: true).snapshots();
    return expenseStream;
  }

  // Update
  Future<void> updateExpense(
      String docID, String newExpense, String selectedCategory) {
    return expenses.doc(docID).update({
      'expense': newExpense,
      'category': selectedCategory,
      'timestamp': Timestamp.now(),
    });
  }

  // Delete
  Future<void> deleteExpense(String docID) {
    return expenses.doc(docID).delete();
  }
}
