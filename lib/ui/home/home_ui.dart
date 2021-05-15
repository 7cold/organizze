import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:layout/layout.dart';
import 'package:organizze/controller/controller.dart';
import 'package:organizze/ui/home/menu/menu.dart';
import 'package:organizze/ui/home/movimentacoes/movimentacoes.dart';
import 'package:organizze/ui/home/principal/principal.dart';

final Controller c = Get.put(Controller());

class HomeUi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      body: Flex(
        direction: Axis.horizontal,
        children: [
          context.breakpoint > LayoutBreakpoint.md ? Menu() : SizedBox(),
          Principal(),
          Movimentacoes()
        ],
      ),
    );
  }
}
