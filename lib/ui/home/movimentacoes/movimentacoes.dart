import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:layout/layout.dart';
import 'package:organizze/const/fonts.dart';
import 'package:organizze/controller/controller.dart';
import 'package:organizze/data/categories.dart';
import 'package:organizze/data/transactions.dart';
import 'package:money2/money2.dart';

final Controller c = Get.put(Controller());

class Movimentacoes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: context.breakpoint == LayoutBreakpoint.lg ? 2 : 1,
      child: Obx(
        () => Container(
          padding: EdgeInsets.only(right: 20, top: 20),
          color: CupertinoColors.systemGroupedBackground,
          child: Column(
            children: [
              Container(
                width: Get.width,
                height: 480,
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: CupertinoColors.white),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "Movimentações",
                          style: fbold24,
                        ),
                      ),
                    ),
                    c.transacoes.length == 0
                        ? Center(child: CupertinoActivityIndicator())
                        : Padding(
                            padding: EdgeInsets.only(top: 60),
                            child: Column(
                              children: c.transacoes.take(5).map((data) {
                                Transactions transactions = data;
                                return _Item(transactions: transactions);
                              }).toList(),
                            ),
                          ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final Transactions transactions;

  _Item({this.transactions});

  @override
  Widget build(BuildContext context) {
    Color color = CupertinoColors.white;
    String categorie = "";

    c.categories.forEach((element) {
      Categories categories = Categories.fromJson(element);
      if (transactions.categoryId == categories.id) {
        color = Color(int.parse('0XFF' + categories.color));
        categorie = element['name'];
      }
    });

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: CupertinoColors.secondarySystemBackground,
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 16),
                padding: EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transactions.description,
                    style: fbold16,
                  ),
                  Text(
                    categorie,
                    style: fthin14,
                  ),
                  transactions.amountCents < 0
                      ? Text(
                          Money.fromInt(transactions.amountCents, c.real)
                              .toString(),
                          style: fthin14r,
                        )
                      : Text(
                          Money.fromInt(transactions.amountCents, c.real)
                              .toString(),
                          style: fthin14g,
                        )
                ],
              ),
            ],
          ),
          Text(
            DateFormat('dd/MM/yyyy')
                .format(DateFormat('yyyy-MM-dd').parse(transactions.date)),
            style: fthin14,
          )
        ],
      ),
    );
  }
}
