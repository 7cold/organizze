import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:layout/layout.dart';
import 'package:money2/money2.dart';
import 'package:organizze/const/fonts.dart';
import 'package:organizze/controller/controller.dart';
import 'package:organizze/data/categories.dart';
import 'package:organizze/data/transactions.dart';
import 'package:responsive_grid/responsive_grid.dart';

final Controller c = Get.put(Controller());
var novoValorC = MoneyMaskedTextController();
var novaMovDtC = MaskedTextController(mask: "00/00/0000");
var novaMovDtC2 = TextEditingController();
var novaDescC = TextEditingController();
var novaNotaC = TextEditingController();

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
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 0, top: 20),
                        child: Text(
                          "Movimentações",
                          style: fbold24,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                          padding: EdgeInsets.only(left: 0, top: 20),
                          child: IconButton(
                              onPressed: () {
                                Get.dialog(
                                  Obx(
                                    () => Dialog(
                                      backgroundColor: Colors.transparent,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white,
                                        ),
                                        height: 540,
                                        width: 380,
                                        child: Flex(
                                          direction: Axis.vertical,
                                          children: [
                                            Flexible(
                                              flex: 1,
                                              child: Container(
                                                width: Get.width,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    color: c.novaMovTipoColor
                                                        .value),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Nova Movimentação",
                                                      style: fbold18w,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 3,
                                              child: Container(
                                                  width: Get.width,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(8),
                                                      bottomRight:
                                                          Radius.circular(8),
                                                    ),
                                                    color: CupertinoColors
                                                        .systemBackground,
                                                  ),
                                                  child: _TipoMovimentacao()),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ).then((value) {
                                  novoValorC.text = "0,00";
                                  novaMovDtC.text = "";
                                  novaMovDtC2.text = "";
                                  novaDescC.text = "";
                                  novaNotaC.text = "";
                                  c.novaMovContaName.value = "";
                                  c.novaMovCategoriaName.value = "";
                                });
                              },
                              icon: Icon(CupertinoIcons.add))),
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
          color: transactions.date ==
                      DateFormat('yyyy-MM-dd').format(DateFormat('yyyy-MM-dd')
                          .parse(DateTime.now().toString())) &&
                  transactions.paid == false
              ? CupertinoColors.systemYellow.withAlpha(40)
              : CupertinoColors.secondarySystemBackground,
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
                  Row(
                    children: [
                      Text(
                        Money.fromInt(transactions.amountCents, c.real)
                            .toString(),
                        style:
                            transactions.amountCents < 0 ? fthin14r : fthin14g,
                      ),
                      SizedBox(width: 5),
                      transactions.date ==
                                  DateFormat('yyyy-MM-dd').format(
                                      DateFormat('yyyy-MM-dd')
                                          .parse(DateTime.now().toString())) &&
                              transactions.paid == false
                          ? Tooltip(
                              decoration: BoxDecoration(
                                color: CupertinoColors.black.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              textStyle: fthin14w,
                              message: "Sua fatura vence hoje.",
                              child: Image.asset(
                                "assets/icons/alert.png",
                                height: 15,
                              ),
                            )
                          : SizedBox()
                    ],
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

class _TipoMovimentacao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Theme(
        data: ThemeData(
          accentColor: Colors.grey[800],
          cupertinoOverrideTheme: CupertinoThemeData(
            primaryColor: Colors.grey[800],
          ),
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.grey[800],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: Text(
                "Tipo",
                style: fbold16,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            "Despesa",
                            style: fthin14,
                          ),
                          Radio(
                              value: c.movTipo1.value,
                              groupValue: 1,
                              onChanged: (i) {
                                c.alterarTipoMov(1);
                              }),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            "Receitas",
                            style: fthin14,
                          ),
                          Radio(
                              value: c.movTipo2.value,
                              groupValue: 1,
                              onChanged: (i) {
                                c.alterarTipoMov(2);
                              }),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            "Transf.",
                            style: fthin14,
                          ),
                          Radio(
                              value: c.movTipo3.value,
                              groupValue: 1,
                              onChanged: (i) {
                                c.alterarTipoMov(3);
                              }),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ResponsiveGridRow(children: [
              ResponsiveGridCol(
                  lg: 12,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, top: 10, right: 20),
                    child: CupertinoTextField(
                      suffix: SizedBox(height: 40),
                      style: fthin16,
                      placeholder: "Descrição",
                      controller: novaDescC,
                    ),
                  )),
            ]),
            ResponsiveGridRow(children: [
              ResponsiveGridCol(
                  lg: 6,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, top: 10, right: 10),
                    child: CupertinoTextField(
                      suffix: IconButton(
                        icon: Icon(Icons.clear_sharp, size: 15),
                        onPressed: () {
                          novoValorC.text = "0,00";
                        },
                      ),
                      style: fthin16,
                      keyboardType: TextInputType.number,
                      placeholder: "Valor",
                      prefix: Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Text("R\$"),
                      ),
                      controller: novoValorC,
                    ),
                  )),
              ResponsiveGridCol(
                  lg: 6,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, top: 10, right: 20),
                    child: CupertinoTextField(
                      suffix: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.calendar_today_outlined,
                            size: 16,
                          )),
                      style: fthin16,
                      maxLength: 10,
                      showCursor: false,
                      controller: novaMovDtC,
                      onTap: () async {
                        final DateTime picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            initialDatePickerMode: DatePickerMode.day,
                            firstDate: DateTime(2015),
                            lastDate: DateTime(2101));
                        if (picked != null) {
                          novaMovDtC.text =
                              DateFormat('dd/MM/yyyy').format(picked);
                          novaMovDtC2.text =
                              DateFormat('yyyy-MM-dd').format(picked);
                        }
                      },
                      placeholder: "Data",
                    ),
                  )),
            ]),
            ResponsiveGridRow(children: [
              ResponsiveGridCol(
                lg: 6,
                child: Padding(
                  padding: EdgeInsets.only(left: 20, top: 10, right: 10),
                  child: Container(
                    height: 40,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[350], width: 1.5),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        style: fthin16,
                        hint: Container(
                            width: 110, child: Text(c.novaMovContaName.value)),
                        items: c.contas.map((element) {
                          return DropdownMenuItem(
                            value: element,
                            child: Container(
                                width: 110, child: Text(element['name'])),
                          );
                        }).toList(),
                        onChanged: (_) {
                          c.novaMovContaName.value = _['name'];
                          c.novaMovContaId.value = _['id'].toString();
                        },
                      ),
                    ),
                  ),
                ),
              ),
              ResponsiveGridCol(
                  lg: 6,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, top: 10, right: 20),
                    child: Container(
                      height: 40,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[350], width: 1.5),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          style: fthin16,
                          hint: Container(
                              width: 110,
                              child: Text(c.novaMovCategoriaName.value)),
                          items: c.categories.map((element) {
                            return DropdownMenuItem(
                              value: element,
                              child: Container(
                                  width: 110, child: Text(element['name'])),
                            );
                          }).toList(),
                          onChanged: (_) {
                            c.novaMovCategoriaName.value = _['name'];
                            c.novaMovCategoriaId.value = _['id'].toString();
                          },
                        ),
                      ),
                    ),
                  )),
            ]),
            ResponsiveGridRow(children: [
              ResponsiveGridCol(
                  lg: 12,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 20, top: 10, right: 20, bottom: 10),
                    child: CupertinoTextField(
                      suffix: SizedBox(height: 40),
                      controller: novaNotaC,
                      style: fthin16,
                      placeholder: "Notas",
                      maxLines: 3,
                    ),
                  )),
            ]),
            ResponsiveGridRow(children: [
//____________________BOTAO SALVAR__________________________
              ResponsiveGridCol(
                  lg: 12,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 20, top: 10, right: 20, bottom: 10),
                    child: CupertinoButton(
                        color: CupertinoColors.activeGreen,
                        padding: EdgeInsets.all(0),
                        child: Text("Salvar"),
                        onPressed: () {
                          c.criarMovimentacao({
                            "description": novaDescC.text,
                            "date": novaMovDtC2.text,
                            "amount_cents": c.movTipo1.value == 1
                                ? ("-" +
                                    novoValorC.text
                                        .replaceAll(",", "")
                                        .replaceAll(".", ""))
                                : novoValorC.text
                                    .replaceAll(",", "")
                                    .replaceAll(".", ""),
                            "account_id": c.novaMovContaId.value,
                            "category_id": c.novaMovCategoriaId.value,
                            "notes": novaNotaC.text,
                          });
                          c.carregarTudo();
                          Get.back();
                        }),
                  )),
            ]),
          ],
        ),
      ),
    );
  }
}
