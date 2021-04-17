import 'package:get/get.dart';
import 'package:organizze/controller/controller.dart';

class TodasMovController extends GetxController {
  final Controller c = Get.put(Controller());

  @override
  onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    c.carregarTransacoesFiltro('2020-01-01', c.dateNowName);
  }

  @override
  void onClose() {
    super.onClose();
    c.transacoesFiltro.clear();
    c.popup.value = "Tudo";
  }
}
