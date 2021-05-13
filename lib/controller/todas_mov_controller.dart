import 'package:get/get.dart';
import 'package:organizze/controller/controller.dart';

class TodasMovController extends GetxController {
  final Controller c = Get.put(Controller());

  @override
  onInit() {
    super.onInit();
  }

  @override
  onReady() {
    super.onReady();
    c.carregarTransacoesFiltro(c.dateNowName, c.dateNowName);
  }

  @override
  void onClose() {
    super.onClose();
    c.transacoesFiltro.clear();
    c.filtroLabel.value = "Hoje";
  }
}
