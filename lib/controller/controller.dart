import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:money2/money2.dart';
import 'package:organizze/data/accounts.dart';
import 'package:organizze/data/transactions.dart';
import 'package:intl/date_symbol_data_local.dart';

class Controller extends GetxController {
  @override
  onInit() async {
    print("atualizando");
    initializeDateFormatting();
    await _categorias().whenComplete(() async {
      await _carregarTransacoes();
      await _carregarContas();
    });

    super.onInit();
  }

  RxBool verSaldo = true.obs;
  RxList categories = [].obs;
  RxList transacoes = [].obs;
  RxList contas = [].obs;
  RxInt saldoPrincipal = 0.obs;
  RxInt saldoSecundario = 0.obs;
  String dateNowName = DateFormat('yyyy-MM-dd').format(DateTime.now());
  DateTime dateNow = DateTime.now();
  NumberFormat numberFormat =
      NumberFormat.currency(locale: 'pt_br', name: 'br');
  final real = Currency.create('EUR', 2,
      symbol: 'R\$', invertSeparators: true, pattern: 'S #.##0,00');
  String basicAuth = 'Basic ' +
      base64Encode(utf8.encode(
          'leobragac@gmail.com:583ce7d8327777f4f66b09d3f592e83cf7c2cfaf'));

  void funcaoVerSaldo() {
    verSaldo.value = !verSaldo.value;
  }

  Future _categorias() async {
    final response = await http.get(
      Uri.parse('https://api.organizze.com.br/rest/v2/categories'),
      headers: {'authorization': basicAuth},
    );

    if (response.statusCode == 200) {
      categories.addAll(jsonDecode(response.body));
      return jsonDecode(response.body);
    } else {
      throw Exception('Falha ao carregar...');
    }
  }

  Future _carregarContas() async {
    final response = await http.get(
      Uri.parse('https://api.organizze.com.br/rest/v2/accounts'),
      headers: {'authorization': basicAuth},
    );

    if (response.statusCode == 200) {
      Iterable res = json.decode(response.body);
      List list = res.map((e) => Accouts.fromJson(e)).toList();
      contas.addAll(list);
    } else {
      throw Exception('Falha ao carregar...');
    }
  }

  Future _carregarTransacoes() async {
    final response = await http.get(
      Uri.parse(
          'https://api.organizze.com.br/rest/v2/transactions?start_date=2015-01-01&end_date=$dateNowName'),
      headers: {'authorization': basicAuth},
    );

    if (response.statusCode == 200) {
      Iterable res = json.decode(response.body);
      List list = res.map((e) => Transactions.fromJson(e)).toList();
      transacoes.addAll(list);

      for (Transactions t in transacoes) {
        if (t.accountId == 4741627) {
          saldoPrincipal.value += t.amountCents;
        }
      }

      for (Transactions t in transacoes) {
        if (t.accountId == 4741628) {
          saldoSecundario.value += t.amountCents;
        }
      }
    } else {
      throw Exception('Falha ao carregar...');
    }
  }
}
