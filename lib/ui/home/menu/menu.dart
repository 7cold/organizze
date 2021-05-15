import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:organizze/const/fonts.dart';
import 'package:organizze/controller/controller_system.dart';
import 'package:organizze/ui/contas_a_pagar/contas_a_pagarUI.dart';
import 'package:organizze/ui/todas_movimentacoes/todas_movimentacoes_ui.dart';
import 'package:responsive_grid/responsive_grid.dart';

final ControllerSystem c = Get.put(ControllerSystem());
Color cor = CupertinoColors.systemGroupedBackground;

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: Padding(
        padding: EdgeInsets.only(top: 20, bottom: 20, left: 20),
        child: Container(
          padding: EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: CupertinoColors.white,
          ),
          child: ResponsiveGridRow(children: [
            ResponsiveGridCol(
              md: 12,
              child: Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  "Menu",
                  style: fbold22,
                ),
              ),
            ),
            ResponsiveGridCol(
              md: 12,
              child: _Item(
                label: "Minhas Movimentações",
                page: TodasMovimentacoesUi(),
              ),
            ),
            ResponsiveGridCol(
              md: 12,
              child: _Item(
                label: "Contas a Pagar",
                page: ContasaPagarUi(),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class _Item extends StatefulWidget {
  final String label;
  final Widget page;
  _Item({this.label, this.page});

  @override
  __ItemState createState() => __ItemState();
}

class __ItemState extends State<_Item> {
  changeColor(state) {
    switch (state) {
      case true:
        setState(() {
          cor = CupertinoColors.lightBackgroundGray;
        });
        break;
      case false:
        setState(() {
          cor = CupertinoColors.systemGroupedBackground;
        });
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: MouseRegion(
        onHover: (event) {
          changeColor(true);
        },
        onExit: (event) {
          changeColor(false);
        },
        child: InkWell(
          onTap: () => Get.to(() => widget.page),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 100),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: cor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.label,
                  style: fbold14,
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 15,
                  color: CupertinoColors.inactiveGray,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
