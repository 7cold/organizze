import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
            : Container(
                color: CupertinoColors.systemGroupedBackground,
                child: ResponsiveGridRow(
                  children: [
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
                        margin: EdgeInsets.all(20),
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
                                            style:
                                                TextStyle(fontFamily: fontThin),
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
                        margin: EdgeInsets.all(20),
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
                                            style:
                                                TextStyle(fontFamily: fontThin),
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
            )
            //_Chart(),
          ],
        ),
      ),
    );
  }
}

// List<Color> gradientColors = [
//   const Color(0xff23b6e6),
//   const Color(0xff02d39a),
// ];

// class _Chart extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(left: 10, top: 50),
//       child: LineChart(
//         LineChartData(
//           minX: 0,
//           maxX: 4,
//           minY: 0,
//           maxY: 1500,
//           gridData: FlGridData(
//             show: true,
//             drawVerticalLine: true,
//             getDrawingHorizontalLine: (value) {
//               return FlLine(
//                 color: CupertinoColors.tertiaryLabel,
//                 strokeWidth: 0.3,
//               );
//             },
//             getDrawingVerticalLine: (value) {
//               return FlLine(
//                 color: CupertinoColors.tertiaryLabel,
//                 strokeWidth: 0.3,
//               );
//             },
//             drawHorizontalLine: true,
//           ),
//           titlesData: FlTitlesData(
//             show: true,
//             bottomTitles: SideTitles(
//               showTitles: true,
//               reservedSize: 22,
//               getTextStyles: (value) => const TextStyle(
//                   color: Color(0xff68737d),
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16),
//               getTitles: (value) {
//                 switch (value.toInt()) {
//                   case 0:
//                     return DateFormat.MMM('pt')
//                         .format(c.dateNow.subtract(const Duration(days: 120)));
//                   case 1:
//                     return DateFormat.MMM('pt')
//                         .format(c.dateNow.subtract(const Duration(days: 90)));
//                   case 2:
//                     return DateFormat.MMM('pt')
//                         .format(c.dateNow.subtract(const Duration(days: 60)));
//                   case 3:
//                     return DateFormat.MMM('pt')
//                         .format(c.dateNow.subtract(const Duration(days: 30)));
//                   case 4:
//                     return DateFormat.MMM('pt').format(c.dateNow);
//                 }
//                 return '';
//               },
//               margin: 8,
//             ),
//             leftTitles: SideTitles(
//               showTitles: true,
//               getTextStyles: (value) => const TextStyle(
//                 color: Color(0xff67727d),
//                 fontWeight: FontWeight.bold,
//                 fontSize: 15,
//               ),
//               getTitles: (value) {
//                 switch (value.toInt()) {
//                   case 500:
//                     return 'R\$500';
//                   case 1000:
//                     return 'R\$1000';
//                   case 1500:
//                     return 'R\$1500';
//                 }
//                 return '';
//               },
//               reservedSize: 50,
//               margin: 12,
//             ),
//           ),
//           borderData: FlBorderData(
//               show: true,
//               border: Border.all(
//                 color: CupertinoColors.tertiaryLabel,
//                 width: 0.3,
//               )),
//           lineBarsData: [
//             LineChartBarData(
//               spots: [
//                 FlSpot(0, 3),
//                 FlSpot(2.6, 1500),
//               ],
//               isCurved: true,
//               colors: gradientColors,
//               barWidth: 5,
//               isStrokeCapRound: true,
//               dotData: FlDotData(
//                 show: true,
//               ),
//               belowBarData: BarAreaData(
//                 show: true,
//                 colors: gradientColors
//                     .map((color) => color.withOpacity(0.3))
//                     .toList(),
//               ),
//             ),
//           ],
//         ),
//         swapAnimationDuration: Duration(milliseconds: 150),
//         swapAnimationCurve: Curves.linear,
//       ),
//     );
//   }
// }
