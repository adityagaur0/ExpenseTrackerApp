import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/chart/chart_bar.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/model/expense.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expanses extends StatefulWidget {
  const Expanses({super.key});

  @override
  State<Expanses> createState() => _ExpansesState();
}

class _ExpansesState extends State<Expanses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        title: 'FlutterCourse',
        amount: 17.99,
        datetime: DateTime.now(),
        category: Category.work),
    Expense(
      title: 'Cinema',
      amount: 50,
      datetime: DateTime.now(),
      category: Category.leisure,
    ),
  ];

  void _openaddExpenseOverlay() {
    //   6**************
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _saveExpenseDate),
    );
  }

  void _saveExpenseDate(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _deleteExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Expense Deleted"),
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    Widget mainContent = const Center(
      child: Text(
        "No expenses found. Start adding some!",
      ),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _deleteExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Tracker"),
        actions: [
          IconButton(
            onPressed: _openaddExpenseOverlay, //7****
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Center(
        child: width < 600
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Chart(expenses: _registeredExpenses),
                  Expanded(
                    child: mainContent,
                    //       ExpensesList(
                    // expenses: _registeredExpenses,
                    // onRemoveExpense: _deleteExpense,
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(child: Chart(expenses: _registeredExpenses)),
                  Expanded(
                    child: mainContent,
                    //       ExpensesList(
                    // expenses: _registeredExpenses,
                    // onRemoveExpense: _deleteExpense,
                  ),
                ],
              ),
      ),
    );
  }
}
