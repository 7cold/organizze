import 'dart:convert';
import 'package:get/get.dart';
import 'package:organizze/controller/controller.dart';
import 'package:http/http.dart' as http;
import 'package:organizze/data/transactions.dart';

class ContasaPagarController extends GetxController {
  final Controller c = Get.put(Controller());

  @override
  void onClose() {
    c.despesasFiltro.value = 0;
    c.receitasFiltro.value = 0;
    c.totalFiltro.value = 0;
    c.transacoesFiltro.clear();
    contasapagar.clear();
    super.onClose();
  }

  @override
  get onDelete => super.onDelete;

  RxList contasapagar = [].obs;
  var outroP1 = "1990-01-01".obs;
  var outroP2 = "1990-01-01".obs;

  Future carregarContasaPagar(String dataInicio, String dataFim) async {
    c.loading.value = true;
    c.despesasFiltro.value = 0;
    c.receitasFiltro.value = 0;
    c.transacoesFiltro.clear();
    contasapagar.clear();

    final response = await http.get(
      Uri.parse(
          'https://api.organizze.com.br/rest/v2/transactions?start_date=$dataInicio&end_date=$dataFim'),
      headers: {'authorization': c.basicAuth},
    );

    if (response.statusCode == 200) {
      Iterable res = json.decode(response.body);
      List list = res.map((e) => Transactions.fromJson(e)).toList();

      contasapagar.addAll(list);

      contasapagar.forEach((res) {
        Transactions trans = res;
        if (trans.amountCents.isNegative == true && trans.paid == false) {
          c.despesasFiltro.value += trans.amountCents;
        } else {
          c.receitasFiltro.value += trans.amountCents;
        }
      });

      c.totalFiltro.value = c.despesasFiltro.value;

      c.loading.value = false;
    } else {
      throw Exception('Falha ao carregar...');
    }
  }
}
