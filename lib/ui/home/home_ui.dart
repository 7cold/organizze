import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:organizze/ui/home/movimentacoes/movimentacoes.dart';
import 'package:organizze/ui/home/principal/principal.dart';

class HomeUi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      body: Flex(
        direction: Axis.horizontal,
        children: [
          //Menu(),
          Principal(),
          Movimentacoes(),
        ],
      ),
    );
  }
}
