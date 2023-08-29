import 'package:flutter/material.dart';

import '../../model/expense.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem({super.key, required this.expense});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              expense.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Row(
              children: [
                Text(
                    '\Rs.${expense.amount.toStringAsFixed(2)}'), //imp topic  //5
                Spacer(),

                Row(
                  children: [
                    Icon(CategoryIcons[expense.category]),
                    SizedBox(
                      width: 8,
                    ),
                    Text(expense.formattedDate.toString()),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
