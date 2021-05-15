import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money2/money2.dart';
import 'package:organizze/const/fonts.dart';
import 'package:organizze/controller/controller.dart';
import 'package:organizze/controller/todas_mov_controller.dart';
import 'package:organizze/data/categories.dart';
import 'package:organizze/data/transactions.dart';
import 'package:organizze/ui/widgets/impressao_ui.dart';
import 'package:organizze/ui/widgets/appbar_custom.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;

class TodasMovimentacoesUi extends StatelessWidget {
  final TodasMovController tm = Get.put(TodasMovController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarCustom("Minhas Movimentações", () {
        Get.to(ImpressaoUi(
          transFiltro: c.transacoesFiltro,
        ));
      }),
      backgroundColor: CupertinoColors.extraLightBackgroundGray,
      body: SafeArea(
        child: Obx(
          () => Stack(
            children: [
              Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 60,
                    width: 380,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Período de referência:    ",
                          style: fbold16,
                        ),
                        SizedBox(
                          height: 30,
                          child: CupertinoButton(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            color: CupertinoColors.activeGreen,
                            child: c.loading.value == true
                                ? CupertinoActivityIndicator()
                                : Text(
                                    c.filtroLabel.value,
                                    style: TextStyle(fontFamily: fontThin),
                                  ),
                            onPressed: () {
                              showCupertinoModalPopup(
                                context: context,
                                builder: (BuildContext context) =>
                                    CupertinoActionSheet(
                                  title: Text('Período'),
                                  actions: [
                                    CupertinoActionSheetAction(
                                      child: Text('Hoje'),
                                      onPressed: () {
                                        c.loading.value = true;
                                        c.filtroLabel.value = "Hoje";
                                        c.carregarTransacoesFiltro(
                                            c.dateNowName, c.dateNowName);
                                        Navigator.pop(context);
                                      },
                                    ),
                                    CupertinoActionSheetAction(
                                      child: Text('Tudo'),
                                      onPressed: () {
                                        c.loading.value = true;
                                        c.filtroLabel.value = "Tudo";
                                        c.carregarTransacoesFiltro(
                                            '2020-01-01', c.dateNowName);
                                        Navigator.pop(context);
                                      },
                                    ),
                                    CupertinoActionSheetAction(
                                      child: Text(c.mesAtual),
                                      onPressed: () {
                                        c.loading.value = true;
                                        c.filtroLabel.value = c.mesAtual;
                                        c.carregarTransacoesFiltro(
                                            c.anoAtualInt +
                                                '-' +
                                                c.mesAtualInt +
                                                '-01',
                                            c.anoAtualInt +
                                                '-' +
                                                c.mesAtualInt +
                                                '-' +
                                                c.ultimoDiaInt);
                                        Navigator.pop(context);
                                      },
                                    ),
                                    CupertinoActionSheetAction(
                                      child: Text(c.mesAnterior),
                                      onPressed: () {
                                        c.loading.value = true;
                                        c.filtroLabel.value = c.mesAnterior;
                                        c.carregarTransacoesFiltro(
                                            c.anoAnteriorInt +
                                                '-' +
                                                c.mesAnteriorInt +
                                                '-01',
                                            c.anoAnteriorInt +
                                                '-' +
                                                c.mesAnteriorInt +
                                                '-' +
                                                c.ultimoDiaMesAnteriorInt);
                                        Navigator.pop(context);
                                      },
                                    ),
                                    CupertinoActionSheetAction(
                                      child: Text("Outro período"),
                                      onPressed: () async {
                                        c.loading.value = true;
                                        c.filtroLabel.value = "Outro período";

                                        final List<DateTime> picked =
                                            await DateRangePicker
                                                .showDatePicker(
                                          context: context,
                                          initialFirstDate: DateTime.now(),
                                          initialLastDate: DateTime.now()
                                              .add(Duration(days: 7)),
                                          firstDate: DateTime(2015),
                                          lastDate:
                                              DateTime(DateTime.now().year + 2),
                                        );
                                        if (picked != null &&
                                            picked.length == 2) {
                                          c.filtroPeriodo1.value =
                                              DateFormat('yyyy-MM-dd').format(
                                                  DateFormat('yyyy-MM-dd')
                                                      .parse(picked
                                                          .elementAt(0)
                                                          .toString()));

                                          c.filtroPeriodo2.value =
                                              DateFormat('yyyy-MM-dd').format(
                                                  DateFormat('yyyy-MM-dd')
                                                      .parse(picked
                                                          .elementAt(1)
                                                          .toString()));
                                        }
                                        c.carregarTransacoesFiltro(
                                            c.filtroPeriodo1.value,
                                            c.filtroPeriodo2.value);

                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding: EdgeInsets.only(right: 30),
                  height: 60,
                  width: 380,
                  //color: Colors.amber,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Receitas: ",
                                style: fbold14,
                              ),
                              Text(
                                Money.fromInt(c.receitasFiltro.value, c.real)
                                    .toString(),
                                style: fthin16g,
                              ),
                            ],
                          ),
                          SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                "Despesas: ",
                                style: fbold14,
                              ),
                              Text(
                                Money.fromInt(c.despesasFiltro.value, c.real)
                                    .toString(),
                                style: fthin16r,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: VerticalDivider(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Total: ",
                            style: fbold18,
                          ),
                          Text(
                            Money.fromInt(c.totalFiltro.value, c.real)
                                .toString(),
                            style: fthin16,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 70),
                width: context.width,
                height: Get.height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: CupertinoColors.white,
                ),
                child: Scrollbar(
                  interactive: true,
                  isAlwaysShown: true,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        c.transacoesFiltro.length == 0
                            ? Container(
                                width: context.width,
                                height: context.height / 1.5,
                                child: Center(
                                  child: Text(
                                    "nenhuma transação para esse período 😀",
                                    style: fthin22,
                                  ),
                                ),
                              )
                            : Column(
                                children: c.transacoesFiltro.map((data) {
                                  Transactions transactions = data;
                                  return item(
                                    transactions,
                                  );
                                }).toList(),
                              ),
                      ],
                    ),
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
                  func: () {
                    c.excluirMovimentacao(transactions.id);
                  },
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
