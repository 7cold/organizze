import 'dart:convert';

import 'package:get/get.dart';
import 'package:organizze/controller/controller.dart';
import 'package:http/http.dart' as http;
import 'package:organizze/data/transactions.dart';

class ContasaPagarController extends GetxController {
  final Controller c = Get.put(Controller());

  RxList contasapagar = [].obs;
  var outroP1 = "1990-01-01".obs;
  var outroP2 = "1990-01-01".obs;

  Future carregarContasaPagar(String dataInicio, String dataFim) async {
    c.loading.value = true;
    final response = await http.get(
      Uri.parse(
          'https://api.organizze.com.br/rest/v2/transactions?start_date=$dataInicio&end_date=$dataFim'),
      headers: {'authorization': c.basicAuth},
    );

    if (response.statusCode == 200) {
      contasapagar.clear();
      Iterable res = json.decode(response.body);
      List list = res.map((e) => Transactions.fromJson(e)).toList();
      contasapagar.addAll(list);
      c.loading.value = false;
    } else {
      throw Exception('Falha ao carregar...');
    }
  }
}
