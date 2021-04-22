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
import 'package:pdf/pdf.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:pdf/widgets.dart' as pw;

class TodasMovimentacoesUi extends StatelessWidget {
  final Controller c = Get.put(Controller());
  final TodasMovController tm = Get.put(TodasMovController());

  @override
  Widget build(BuildContext context) {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => <pw.Widget>[
          pw.Header(
              level: 0,
              title: '',
              textStyle: pw.TextStyle(fontSize: 18),
              child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: <pw.Widget>[
                    pw.Text('Relatório Movimentações', textScaleFactor: 1.5),
                    pw.Text(c.popup.toString(),
                        textScaleFactor: 1,
                        style: pw.TextStyle(color: PdfColors.grey700)),
                  ])),
          pw.Padding(padding: const pw.EdgeInsets.only(bottom: 20)),
          pw.Table.fromTextArray(
              headers: ["Data", "Descrição", "Valor", "Status"],
              context: context,
              data: c.transacoesFiltro.map((res) {
                Transactions trans = res;
                return [
                  DateFormat('dd/MM/yyyy')
                      .format(DateFormat('yyyy-MM-dd').parse(trans.date)),
                  trans.description,
                  Money.fromInt(trans.amountCents, c.real).toString(),
                  trans.paid == true ? "Sim" : "Não"
                ];
              }).toList()),
        ],
        footer: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.centerLeft,
            child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                      "Gerado dia: " +
                          DateFormat('dd/MM/yyyy').format(
                              DateFormat('yyyy-MM-dd')
                                  .parse(DateTime.now().toString())),
                      style:
                          pw.TextStyle(fontSize: 11, color: PdfColors.grey600)),
                  pw.Text("Pag. ${context.pageNumber} of ${context.pagesCount}",
                      style:
                          pw.TextStyle(fontSize: 11, color: PdfColors.grey600))
                ]),
          );
        },
      ),
    ); //

    return Scaffold(
      appBar: appBarCustom("Minhas Movimentações", () {
        Get.to(ImpressaoUi(
          doc: pdf,
        ));
      }),
      backgroundColor: CupertinoColors.extraLightBackgroundGray,
      body: SafeArea(
        child: Obx(
          () => Stack(
            children: [
              Align(
                  alignment: Alignment.topCenter,
                  child: Row(
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
                                c.popup.value,
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
                                    c.popup.value = "Hoje";
                                    c.carregarTransacoesFiltro(
                                        c.dateNowName, c.dateNowName);
                                    Navigator.pop(context);
                                  },
                                ),
                                CupertinoActionSheetAction(
                                  child: Text('Tudo'),
                                  onPressed: () {
                                    c.loading.value = true;
                                    c.popup.value = "Tudo";
                                    c.carregarTransacoesFiltro(
                                        '2020-01-01', c.dateNowName);
                                    Navigator.pop(context);
                                  },
                                ),
                                CupertinoActionSheetAction(
                                  child: Text(c.mesAtual),
                                  onPressed: () {
                                    c.loading.value = true;
                                    c.popup.value = c.mesAtual;
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
                                    c.popup.value = c.mesAnterior;
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
                                    c.popup.value = "Outro período";

                                    final List<DateTime> picked =
                                        await DateRangePicker.showDatePicker(
                                      context: context,
                                      initialFirstDate: DateTime.now(),
                                      initialLastDate:
                                          DateTime.now().add(Duration(days: 7)),
                                      firstDate: DateTime(2015),
                                      lastDate:
                                          DateTime(DateTime.now().year + 2),
                                    );
                                    if (picked != null && picked.length == 2) {
                                      c.outroP1.value = DateFormat('yyyy-MM-dd')
                                          .format(DateFormat('yyyy-MM-dd')
                                              .parse(picked
                                                  .elementAt(0)
                                                  .toString()));

                                      c.outroP2.value = DateFormat('yyyy-MM-dd')
                                          .format(DateFormat('yyyy-MM-dd')
                                              .parse(picked
                                                  .elementAt(1)
                                                  .toString()));
                                    }
                                    c.carregarTransacoesFiltro(
                                        c.outroP1.value, c.outroP2.value);

                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  )),
              Container(
                margin:
                    EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 70),
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
                color: CupertinoColors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(10),
              ),
              textStyle: fthin14,
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
            color: CupertinoColors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: fthin14,
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
