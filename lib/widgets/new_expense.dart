import 'dart:io';

import 'package:expense_tracker/model/expense.dart' as model;
import 'package:expense_tracker/model/expense.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  //8***********

  // var _enteredTitle = ''; //b
  // void _saveEnteredTitle(String inputTitle) {
  //   //a
  //   _enteredTitle = inputTitle; //c
  // }
  //******* CHANGE ABOVE WTIH TEXT CONTROLLER

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  //
  //
  DateTime? _selectedDate;

  model.Category _selectedCategory = model.Category.leisure;

  void _presentDayPicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final lastDate = now;
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _showDialog() {
    if (Platform.isIOS) {
      //show error message
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: Text("Invalid input"),
          content: const Text(
              "Please make sure a valid title, amount, date and category was entered."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Okay"),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Invalid input"),
          content: const Text(
              "Please make sure a valid title, amount, date and category was entered."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Okay"),
            ),
          ],
        ),
      );
    }
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      _showDialog();

      return;
    }
    widget.onAddExpense(
      Expense(
          title: _titleController.text,
          amount: enteredAmount,
          datetime: _selectedDate!,
          category: _selectedCategory),
    );
    Navigator.pop(context); //automatically close the modal by clickin on
    //the save expense button;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + keyboardSpace),
          //top 16 cuz used safe area true in modal sheet.
          child: Column(
            children: [
              TextField(
                //onChanged: _saveEnteredTitle, //d
                controller: _titleController,
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text("Title"),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        prefixText: 'Rs. ',
                        label: Text("Amount"),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _selectedDate == null
                              ? "No date selected"
                              : model.formatter.format(_selectedDate!),
                        ),
                        IconButton(
                          onPressed: _presentDayPicker,
                          icon: Icon(Icons.calendar_month),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  DropdownButton(
                    value: _selectedCategory,
                    items: model.Category.values
                        .map(
                          (category) => DropdownMenuItem(
                            value: category,
                            child: Text(
                              category.name.toUpperCase(),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        _selectedCategory = value;
                      });

                      print(value);
                    },
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); //CLose THe bottom modal manually
                    },
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _submitExpenseData();
                      //print(_enteredTitle); //e
                      // print(_titleController.text);
                      // print(_amountController.text);
                    },
                    child: const Text("Save Expense"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
