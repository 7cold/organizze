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
import 'package:organizze/ui/widgets/appbar_custom.dart';
import 'package:responsive_grid/responsive_grid.dart';

class TodasMovimentacoesUi extends StatelessWidget {
  final Controller c = Get.put(Controller());
  final TodasMovController tm = Get.put(TodasMovController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarCustom("Minhas Movimentações"),
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
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: CupertinoColors.white,
                ),
                height: Get.height,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Column(
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
              ),
            ],
          ),
        ),
      ),
    ]),
  );
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final Function func;
  final Color color;
  final String label;

  _IconButton({this.icon, this.func, this.color, this.label});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        child: Tooltip(
          message: label,
          child: InkWell(
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
