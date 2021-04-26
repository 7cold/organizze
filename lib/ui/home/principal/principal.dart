import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:layout/layout.dart';
import 'package:money2/money2.dart';
import 'package:organizze/const/fonts.dart';
import 'package:organizze/controller/controller.dart';
import 'package:organizze/data/accounts.dart';
import 'package:organizze/ui/contas_a_pagar/contas_a_pagarUI.dart';
import 'package:organizze/ui/todas_movimentacoes/todas_movimentacoes_ui.dart';
import 'package:responsive_grid/responsive_grid.dart';

final Controller c = Get.put(Controller());

class Principal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 2,
      child: Obx(
        () => c.contas.length == 0
            ? Container(
                color: CupertinoColors.systemGroupedBackground,
                width: Get.width,
                height: Get.height,
                child: CupertinoActivityIndicator())
            : SingleChildScrollView(
                child: Container(
                  color: CupertinoColors.systemGroupedBackground,
                  child: ResponsiveGridRow(
                    children: [
                      ResponsiveGridCol(
                        md: 12,
                        child: Container(
                          width: Get.width,
                          height: 300,
                          margin: EdgeInsets.only(
                              bottom: 10, top: 25, left: 20, right: 20),
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: CupertinoColors.white),
                          child: _Chart(),
                        ),
                      ),
                      ResponsiveGridCol(
                        child: ResponsiveGridRow(
                          children: c.contas.take(2).map((e) {
                            Accouts accouts = e;
                            return ResponsiveGridCol(
                                md: context.breakpoint == LayoutBreakpoint.md
                                    ? 6
                                    : 12,
                                child: _Item(
                                  accouts: accouts,
                                ));
                          }).toList(),
                        ),
                      ),
                      ResponsiveGridCol(
                        md: 12,
                        child: Container(
                          width: Get.width,
                          height: 100,
                          margin: EdgeInsets.only(
                              bottom: 10, top: 10, left: 20, right: 20),
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: CupertinoColors.white),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    "Consultar todas as movimentações",
                                    style: fbold18,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: CupertinoButton(
                                      color: CupertinoColors.activeGreen,
                                      child: c.loading.value == true
                                          ? CupertinoActivityIndicator()
                                          : Text(
                                              "Consultar",
                                              style: TextStyle(
                                                  fontFamily: fontThin),
                                            ),
                                      onPressed: () {
                                        Get.to(() => TodasMovimentacoesUi());
                                      }),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      ResponsiveGridCol(
                        md: 12,
                        child: Container(
                          width: Get.width,
                          height: 100,
                          margin: EdgeInsets.only(
                              bottom: 25, top: 10, left: 20, right: 20),
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: CupertinoColors.white),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    "Contas a Pagar",
                                    style: fbold18,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: CupertinoButton(
                                      color: CupertinoColors.activeGreen,
                                      child: c.loading.value == true
                                          ? CupertinoActivityIndicator()
                                          : Text(
                                              "Consultar",
                                              style: TextStyle(
                                                  fontFamily: fontThin),
                                            ),
                                      onPressed: () {
                                        Get.to(() => ContasaPagarUi());
                                      }),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final Accouts accouts;

  _Item({this.accouts});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: 200,
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: CupertinoColors.white),
      child: Container(
        margin: EdgeInsets.all(25),
        width: Get.width,
        height: Get.height,
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  accouts.name,
                  style: fbold24,
                ),
                Text(
                  accouts.defaultAccount == true ? "Principal" : "Secundaria",
                  style: fthin18,
                ),
              ],
            ),
            SizedBox(height: 20),
            Obx(
              () => Positioned(
                  left: 0,
                  bottom: 0,
                  child: Container(
                    height: 70,
                    width: 230,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: CupertinoColors.tertiarySystemFill),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: IconButton(
                              onPressed: () {
                                c.funcaoVerSaldo();
                              },
                              icon: Icon(CupertinoIcons.lock),
                            ),
                          ),
                        ),
                        Positioned(
                            left: 20,
                            top: 8,
                            child: Text(
                              "Saldo",
                              style: fthin18,
                            )),
                        c.saldoPrincipal.value == 0
                            ? Positioned(
                                left: 20,
                                bottom: 8,
                                child: CupertinoActivityIndicator())
                            : Positioned(
                                left: 20,
                                bottom: 8,
                                child: accouts.id == 4741627
                                    ? Text(
                                        c.verSaldo.value == false
                                            ? "💰💰💰💰💰"
                                            : Money.fromInt(
                                                    c.saldoPrincipal.value,
                                                    c.real)
                                                .toString(),
                                        style: fbold20,
                                      )
                                    : Text(
                                        c.verSaldo.value == false
                                            ? "💰💰💰💰💰"
                                            : Money.fromInt(
                                                    c.saldoSecundario.value,
                                                    c.real)
                                                .toString(),
                                        style: fbold20,
                                      )),
                        Container(
                          height: Get.height,
                          width: 12,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10)),
                              color: CupertinoColors.systemGreen),
                        )
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

List<Color> gradientColors = [
  const Color(0xff23b6e6),
  const Color(0xff02d39a),
];

class _Chart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: Text("Saldo entre entradas e saídas", style: fbold18),
        ),
        Container(
          margin: EdgeInsets.only(left: 10, top: 70),
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: 4,
              minY: -2000,
              maxY: 2000,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                drawHorizontalLine: true,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: CupertinoColors.tertiaryLabel,
                    strokeWidth: 0.3,
                  );
                },
                getDrawingVerticalLine: (value) {
                  return FlLine(
                    color: CupertinoColors.tertiaryLabel,
                    strokeWidth: 0,
                  );
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 22,
                  getTextStyles: (value) => fbold14,
                  getTitles: (value) {
                    var date = new DateTime(DateTime.now().year,
                        DateTime.now().month, DateTime.now().day);

                    switch (value.toInt()) {
                      case 0:
                        return DateFormat.MMM('pt')
                            .format(
                                DateTime(date.year, date.month - 4, date.day))
                            .toString();
                      case 1:
                        return DateFormat.MMM('pt')
                            .format(
                                DateTime(date.year, date.month - 3, date.day))
                            .toString();
                      case 2:
                        return DateFormat.MMM('pt')
                            .format(
                                DateTime(date.year, date.month - 2, date.day))
                            .toString();
                      case 3:
                        return DateFormat.MMM('pt')
                            .format(
                                DateTime(date.year, date.month - 1, date.day))
                            .toString();
                      case 4:
                        return DateFormat.MMM('pt')
                            .format(DateTime(date.year, date.month, date.day))
                            .toString();
                    }
                    return '';
                  },
                  margin: 8,
                ),
                leftTitles: SideTitles(
                  showTitles: true,
                  getTextStyles: (value) => fthin14,
                  getTitles: (value) {
                    switch (value.toInt()) {
                      case 500:
                        return 'R\$500';
                      case 1000:
                        return 'R\$1000';
                      case 1500:
                        return 'R\$1500';
                      case 2000:
                        return 'R\$1500';
                      case 0:
                        return 'R\$0,00';
                      case -1000:
                        return 'R\$-1000';
                      case -1500:
                        return 'R\$-1500';
                      case 2000:
                        return 'R\$-1500';
                    }
                    return '';
                  },
                  reservedSize: 50,
                  margin: 12,
                ),
              ),
              borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: CupertinoColors.tertiaryLabel,
                    width: 0.3,
                  )),
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    FlSpot(0, (c.messaldo4.value / 100)),
                    FlSpot(1, (c.messaldo3.value / 100)),
                    FlSpot(2, (c.messaldo2.value / 100)),
                    FlSpot(3, (c.messaldo1.value / 100)),
                    FlSpot(4, (c.messaldo0.value / 100)),
                  ],
                  isCurved: false,
                  colors: gradientColors,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    colors: gradientColors
                        .map((color) => color.withOpacity(0.3))
                        .toList(),
                  ),
                ),
              ],
            ),
            swapAnimationDuration: Duration(milliseconds: 150),
            swapAnimationCurve: Curves.linear,
          ),
        ),
      ],
    );
  }
}
