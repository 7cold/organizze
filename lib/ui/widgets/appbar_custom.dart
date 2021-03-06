import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:organizze/const/fonts.dart';
import 'package:organizze/controller/controller.dart';

final Controller c = Get.put(Controller());

appBarCustom(String label, Function func) {
  return AppBar(
    centerTitle: true,
    actions: [
      func == null
          ? SizedBox()
          : Padding(
              padding: EdgeInsets.only(right: 25),
              child: IconButton(
                onPressed: () {
                  func();
                },
                icon: Icon(
                  Icons.print_outlined,
                  color: CupertinoColors.activeGreen,
                  size: 28,
                ),
              ),
            ),
    ],
    toolbarHeight: 90,
    title: Container(
      padding: EdgeInsets.symmetric(horizontal: 100, vertical: 10),
      decoration: BoxDecoration(
        color: CupertinoColors.activeGreen.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
            fontFamily: fontBold,
            color: CupertinoColors.activeGreen,
            fontSize: 20),
      ),
    ),
    backgroundColor: Colors.transparent,
    shadowColor: Colors.transparent,
    leading: Padding(
      padding: EdgeInsets.all(8.0),
      child: InkWell(
        focusColor: CupertinoColors.activeGreen,
        hoverColor: CupertinoColors.activeGreen.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Get.back();
        },
        child: Row(
          children: [
            Icon(
              CupertinoIcons.chevron_back,
              color: CupertinoColors.activeGreen,
            ),
            Text(
              "Voltar",
              style: TextStyle(
                  fontFamily: fontBold,
                  color: CupertinoColors.activeGreen,
                  fontSize: 20),
            )
          ],
        ),
      ),
    ),
    leadingWidth: 110,
  );
}
