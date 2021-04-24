import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money2/money2.dart';
import 'package:organizze/const/fonts.dart';
import 'package:organizze/controller/contas_a_pagar_controller.dart';
import 'package:organizze/controller/controller.dart';
import 'package:organizze/data/categories.dart';
import 'package:organizze/data/transactions.dart';
import 'package:organizze/ui/widgets/appbar_custom.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;

class ContasaPagarUi extends StatelessWidget {
  final Controller c = Get.put(Controller());
  final ContasaPagarController cp = Get.put(ContasaPagarController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarCustom("Contas a Pagar", null),
      backgroundColor: CupertinoColors.extraLightBackgroundGray,
      body: SafeArea(
        child: Obx(
          () => Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Período de referência:    ",
                          style: fbold20,
                        ),
                        CupertinoButton(
                          color: CupertinoColors.activeGreen,
                          child: c.loading.value == true
                              ? CupertinoActivityIndicator()
                              : Text(
                                  "Selecione",
                                  style: TextStyle(fontFamily: fontThin),
                                ),
                          onPressed: () async {
                            c.loading.value = true;

                            final List<DateTime> picked =
                                await DateRangePicker.showDatePicker(
                              context: context,
                              initialFirstDate: DateTime.now(),
                              initialLastDate:
                                  DateTime.now().add(Duration(days: 7)),
                              firstDate: DateTime(2015),
                              lastDate: DateTime(DateTime.now().year + 2),
                            );
                            if (picked != null && picked.length == 2) {
                              cp.outroP1.value = DateFormat('yyyy-MM-dd')
                                  .format(DateFormat('yyyy-MM-dd')
                                      .parse(picked.elementAt(0).toString()));

                              cp.outroP2.value = DateFormat('yyyy-MM-dd')
                                  .format(DateFormat('yyyy-MM-dd')
                                      .parse(picked.elementAt(1).toString()));
                            }
                            cp.carregarContasaPagar(
                                cp.outroP1.value, cp.outroP2.value);
                          },
                        ),
                      ],
                    ),
                    cp.outroP1.toString() == '1990-01-01'
                        ? SizedBox()
                        : Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              "de: " +
                                  DateFormat('dd/MM/yy').format(
                                      DateFormat('yyyy-MM-dd')
                                          .parse(cp.outroP1.toString())) +
                                  "    até: " +
                                  DateFormat('dd/MM/yy').format(
                                      DateFormat('yyyy-MM-dd')
                                          .parse(cp.outroP2.toString())),
                              style: fbold14,
                            ),
                          )
                  ],
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 90),
                width: context.width,
                height: Get.height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: CupertinoColors.white,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      cp.contasapagar.length == 0
                          ? Container(
                              width: context.width,
                              height: context.height / 1.5,
                              child: Center(
                                child: Text(
                                  "nenhuma conta para pagar para esse período 😀",
                                  style: fthin22,
                                ),
                              ),
                            )
                          : Column(
                              children: cp.contasapagar.map((data) {
                                Transactions transactions = data;
                                return transactions.paid == true
                                    ? SizedBox()
                                    : item(
                                        transactions,
                                      );
                              }).toList(),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget item(Transactions transactions) {
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
    margin: EdgeInsets.only(bottom: 10, left: 20, right: 20, top: 10),
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
        color: CupertinoColors.secondarySystemBackground,
        borderRadius: BorderRadius.circular(10)),
    child: ResponsiveGridRow(children: [
      ResponsiveGridCol(
        md: 6,
        child: Row(
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
                  style: fbold18,
                ),
                Text(
                  categorie,
                  style: fthin14,
                ),
              ],
            ),
          ],
        ),
      ),
      ResponsiveGridCol(
        md: 2,
        child: transactions.amountCents < 0
            ? Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment(0, 0),
                child: Text(
                  Money.fromInt(transactions.amountCents, c.real).toString(),
                  style: fthin16r,
                ),
              )
            : Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment(0, 0),
                child: Text(
                  Money.fromInt(transactions.amountCents, c.real).toString(),
                  style: fthin16g,
                ),
              ),
      ),
      ResponsiveGridCol(
        md: 2,
        child: Container(
          padding: EdgeInsets.all(10),
          alignment: Alignment(0, 0),
          child: Text(
            DateFormat('dd/MM/yyyy')
                .format(DateFormat('yyyy-MM-dd').parse(transactions.date)),
            style: fthin16,
          ),
        ),
      ),
      ResponsiveGridCol(
        md: 2,
        child: Container(
          width: Get.width,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Row(
              children: [
                _IconButton(
                  func: () {},
                  icon: CupertinoIcons.delete,
                  color: CupertinoColors.systemRed.withOpacity(0.5),
                  label: "excluir",
                ),
                _IconButton(
                  func: () {},
                  icon: CupertinoIcons.pencil,
                  color: CupertinoColors.activeBlue.withOpacity(0.5),
                  label: "editar",
                ),
                _IconButton(
                  func: () {},
                  icon: CupertinoIcons.info_circle,
                  color: CupertinoColors.activeOrange.withOpacity(0.5),
                  label: "detalhes",
                  transactions: transactions,
                ),
              ],
            ),
            Tooltip(
              decoration: BoxDecoration(
                color: CupertinoColors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(6),
              ),
              textStyle: fthin14w,
              message:
                  transactions.paid == true ? "Pago" : "Pendente de pagamento",
              child: Icon(
                transactions.paid == true
                    ? CupertinoIcons.checkmark_alt
                    : CupertinoIcons.clock,
                color: transactions.paid == true
                    ? CupertinoColors.activeGreen
                    : CupertinoColors.systemOrange,
              ),
            ),
          ]),
        ),
      ),
    ]),
  );
}

class _IconButton extends StatelessWidget {
  final Transactions transactions;
  final IconData icon;
  final Function func;
  final Color color;
  final String label;

  _IconButton(
      {this.icon, this.func, this.color, this.label, this.transactions});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        child: Tooltip(
          message:
              label == "detalhes" ? transacaoDetalhes(transactions) : label,
          decoration: BoxDecoration(
            color: CupertinoColors.black.withOpacity(0.8),
            borderRadius: BorderRadius.circular(6),
          ),
          textStyle: fthin14w,
          child: InkWell(
            mouseCursor: label == "detalhes" ? MouseCursor.defer : null,
            borderRadius: BorderRadius.circular(10),
            hoverColor: CupertinoColors.systemGrey2,
            highlightColor: CupertinoColors.white,
            focusColor: CupertinoColors.activeBlue,
            onTap: func,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 20,
                color: CupertinoColors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

transacaoDetalhes(Transactions transactions) {
  var nome = transactions.description;
  var pago = transactions.paid == true ? "Sim" : "Não";
  var notas = transactions.notes;
  var fixo = transactions.recurring == true ? "Sim" : "Não";

  return "\n$nome\nPago: $pago\nFixo: $fixo\n$notas";
}
