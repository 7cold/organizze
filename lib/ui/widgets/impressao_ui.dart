import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money2/money2.dart';
import 'package:organizze/controller/todas_mov_controller.dart';
import 'package:organizze/data/categories.dart';
import 'package:organizze/data/transactions.dart';
import 'package:organizze/ui/widgets/appbar_custom.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

// ignore: must_be_immutable
class ImpressaoUi extends StatelessWidget {
  final TodasMovController tm = Get.put(TodasMovController());
  final RxList transFiltro;

  ImpressaoUi({this.transFiltro});

  var despesas = 0;
  var receitas = 0;
  Future<Uint8List> _generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        theme: pw.ThemeData(
          tableCell: pw.TextStyle(color: PdfColors.grey700),
        ),
        pageFormat: PdfPageFormat.a4,
        build: (context) => <pw.Widget>[
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
              ],
            ),
          ),
          pw.Padding(padding: const pw.EdgeInsets.only(bottom: 20)),
          pw.Table(
            defaultVerticalAlignment: pw.TableCellVerticalAlignment.full,
            columnWidths: {
              0: pw.FlexColumnWidth(1),
              1: pw.FlexColumnWidth(3.5),
              2: pw.FlexColumnWidth(0.9),
              3: pw.FlexColumnWidth(0.7),
            },
            children: [
              pw.TableRow(children: [
                pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Data', style: pw.TextStyle(fontSize: 14.0))
                    ]),
                pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Nome', style: pw.TextStyle(fontSize: 14.0))
                    ]),
                pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Valor', style: pw.TextStyle(fontSize: 14.0))
                    ]),
                pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Status', style: pw.TextStyle(fontSize: 14.0))
                    ]),
              ]),
            ],
          ),
          pw.Table(
              columnWidths: {
                0: pw.FlexColumnWidth(1),
                1: pw.FlexColumnWidth(3.5),
                2: pw.FlexColumnWidth(0.9),
                3: pw.FlexColumnWidth(0.7),
              },
              children: transFiltro.map((res) {
                Transactions trans = res;

                if (trans.amountCents.isNegative == true) {
                  despesas += trans.amountCents;
                } else {
                  receitas += trans.amountCents;
                }

                String categorie = "";

                c.categories.forEach((element) {
                  Categories categories = Categories.fromJson(element);
                  if (trans.categoryId == categories.id) {
                    categorie = element['name'];
                  }
                });

                return pw.TableRow(children: [
                  pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Divider(color: PdfColors.grey400),
                        pw.Text(
                            DateFormat('dd/MM/yyyy').format(
                                DateFormat('yyyy-MM-dd').parse(trans.date)),
                            style: pw.TextStyle(
                                fontSize: 12, color: PdfColors.grey600))
                      ]),
                  pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Divider(color: PdfColors.grey400),
                        pw.Text(
                          trans.description,
                          style: pw.TextStyle(
                              fontSize: 12, color: PdfColors.grey700),
                        ),
                        pw.Text(
                          categorie,
                          style: pw.TextStyle(
                              fontSize: 10, color: PdfColors.grey600),
                        ),
                        pw.Text(trans.notes,
                            style: pw.TextStyle(
                                fontSize: 10, color: PdfColors.grey600))
                      ]),
                  pw.Column(children: [
                    pw.Divider(color: PdfColors.grey400),
                    pw.Text(Money.fromInt(trans.amountCents, c.real).toString(),
                        style: pw.TextStyle(
                            fontSize: 12,
                            color: trans.amountCents.isNegative == true
                                ? PdfColors.red500
                                : PdfColors.green500))
                  ]),
                  pw.Column(children: [
                    pw.Divider(color: PdfColors.grey400),
                    pw.Text(trans.paid == true ? "Pago" : "Não pago",
                        style: pw.TextStyle(
                            fontSize: 12, color: PdfColors.grey600))
                  ]),
                ]);
              }).toList()),
          pw.Padding(padding: const pw.EdgeInsets.only(bottom: 40)),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(flex: 2, child: pw.SizedBox()),
              pw.Expanded(
                flex: 1,
                child: pw.DefaultTextStyle(
                  style: const pw.TextStyle(
                    fontSize: 10,
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Receitas: '),
                          pw.Text(
                            Money.fromInt(receitas, c.real).toString(),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 5),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Despesas: '),
                          pw.Text(
                            Money.fromInt(despesas, c.real).toString(),
                          ),
                        ],
                      ),
                      pw.Divider(),
                      pw.DefaultTextStyle(
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                        ),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Total:'),
                            pw.Text(
                                Money.fromInt((receitas + despesas), c.real)
                                    .toString(),
                                style: pw.TextStyle(
                                    color: (receitas + despesas > 0)
                                        ? PdfColors.green400
                                        : PdfColors.red400)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
        footer: (pw.Context context) {
          return pw.Column(children: [
            pw.Divider(color: PdfColors.grey400),
            pw.Container(
              alignment: pw.Alignment.centerLeft,
              child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                        DateFormat('dd/MM/yyyy HH:mm').format(
                            DateFormat('yyyy-MM-dd HH:mm')
                                .parse(DateTime.now().toString())),
                        style: pw.TextStyle(
                            fontSize: 11, color: PdfColors.grey600)),
                    pw.Text("Pag. ${context.pageNumber}/ ${context.pagesCount}",
                        style: pw.TextStyle(
                            fontSize: 11, color: PdfColors.grey600))
                  ]),
            )
          ]);
        },
      ),
    );

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarCustom("Relatório", null),
      body: Theme(
        data: ThemeData(
          primaryColor: CupertinoColors.activeGreen,
          accentColor: CupertinoColors.activeBlue,
        ),
        child: PdfPreview(
          canChangePageFormat: false,
          maxPageWidth: context.width / 2,
          canChangeOrientation: false,
          dynamicLayout: false,
          onPrinted: (context) => Get.back(),
          onShared: (context) => Get.back(),
          actions: [
            PdfPreviewAction(
              icon: Icon(Icons.exit_to_app),
              onPressed: (context, build, pageFormat) => Get.back(),
            )
          ],
          build: (format) => _generatePdf(),
        ),
      ),
    );
  }
}
