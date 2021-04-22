import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:organizze/ui/widgets/appbar_custom.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class ImpressaoUi extends StatelessWidget {
  final pw.Document doc;

  const ImpressaoUi({Key key, this.doc}) : super(key: key);
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
          build: (format) => doc.save(),
        ),
      ),
    );
  }
}
