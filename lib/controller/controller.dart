import 'dart:convert';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:money2/money2.dart';
import 'package:organizze/data/transactions.dart';
import 'package:intl/date_symbol_data_local.dart';

class Controller extends GetxController {
  @override
  onInit() async {
    initializeDateFormatting();
    carregarTudo();
    super.onInit();
  }

  carregarTudo() async {
    loading.value = true;
    limpartudo();
    await _categorias().whenComplete(() async {
      await _carregarTransacoes();
      await _carregarContas();
    });
    loading.value = false;
  }

  @override
  void onClose() {
    despesasFiltro.value = 0;
    receitasFiltro.value = 0;
    totalFiltro.value = 0;
    transacoesFiltro.clear();
    super.onClose();
  }

  var mesAtual = DateFormat.MMMM('pt').format(DateTime.now()).capitalizeFirst;
  var mesAnterior = DateFormat.MMMM('pt')
      .format(DateTime.now().subtract(Duration(days: 30)))
      .capitalizeFirst;
  var mesAtualInt = DateFormat.M('pt').format(DateTime.now());
  var anoAtualInt = DateFormat.y('pt').format(DateTime.now());
  var ultimoDiaInt =
      DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day.toString();
  var mesAnteriorInt =
      DateFormat.M('pt').format(DateTime.now().subtract(Duration(days: 30)));
  var anoAnteriorInt =
      DateFormat.y('pt').format(DateTime.now().subtract(Duration(days: 30)));
  var ultimoDiaMesAnteriorInt = DateTime(DateTime.now().year,
          DateTime.now().subtract(Duration(days: 30)).month + 1, 0)
      .day
      .toString();

  RxBool loading = false.obs;

  RxString filtroPeriodo1 = "".obs;
  RxString filtroPeriodo2 = "".obs;

  RxInt messaldo0 = 0.obs;
  RxInt messaldo1 = 0.obs;
  RxInt messaldo2 = 0.obs;
  RxInt messaldo3 = 0.obs;
  RxInt messaldo4 = 0.obs;

  RxString novaMovCategoriaName = "".obs;
  RxString novaMovCategoriaId = "".obs;
  RxString novaMovContaName = "".obs;
  RxString novaMovContaId = "".obs;
  Rx<Color> novaMovTipoColor = CupertinoColors.darkBackgroundGray.obs;
  RxInt movTipo1 = 1.obs;
  RxInt movTipo2 = 0.obs;
  RxInt movTipo3 = 0.obs;
  Rx novoValorC = MoneyMaskedTextController().obs;

  RxString filtroLabel = "Hoje".obs;
  RxBool verSaldo = false.obs;
  RxList categories = [].obs;
  RxList transacoes = [].obs;

  RxList transacoesFiltro = [].obs;
  RxInt despesasFiltro = 0.obs;
  RxInt receitasFiltro = 0.obs;
  RxInt totalFiltro = 0.obs;

  RxList contas = [].obs;
  RxInt saldoPrincipal = 0.obs;
  RxInt saldoSecundario = 0.obs;

  String dateNowName = DateFormat('yyyy-MM-dd').format(DateTime.now());
  NumberFormat numberFormat =
      NumberFormat.currency(locale: 'pt_br', name: 'br');
  final real = Currency.create('EUR', 2,
      symbol: 'R\$', invertSeparators: true, pattern: 'S #.##0,00');
  String basicAuth = 'Basic ' +
      base64Encode(utf8.encode(
          'leobragac@gmail.com:583ce7d8327777f4f66b09d3f592e83cf7c2cfaf'));

  void alterarTipoMov(int tipo) {
    switch (tipo) {
      case 1:
        {
          movTipo1.value = 1;
          movTipo2.value = 0;
          movTipo3.value = 0;
          novaMovTipoColor.value =
              CupertinoColors.destructiveRed.withAlpha(190);
        }
        break;
      case 2:
        {
          movTipo1.value = 0;
          movTipo2.value = 1;
          movTipo3.value = 0;
          novaMovTipoColor.value = CupertinoColors.activeGreen.withAlpha(190);
        }
        break;
      case 3:
        {
          movTipo1.value = 0;
          movTipo2.value = 0;
          movTipo3.value = 1;
          novaMovTipoColor.value = CupertinoColors.darkBackgroundGray;
        }
        break;
      default:
        movTipo1.value = 0;
    }
  }

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
    loading.value = true;
    final response = await http.get(
      Uri.parse('https://api.organizze.com.br/rest/v2/accounts'),
      headers: {'authorization': basicAuth},
    );

    if (response.statusCode == 200) {
      // Iterable res = json.decode(response.body);
      // List list = res.map((e) => Accouts.fromJson(e)).toList();
      // contas.addAll(list);
      contas.addAll(jsonDecode(response.body));
      loading.value = false;
      return jsonDecode(response.body);
    } else {
      loading.value = false;
      throw Exception('Falha ao carregar...');
    }
  }

  Future _carregarTransacoes() async {
    final response = await http.get(
      Uri.parse(
          'https://api.organizze.com.br/rest/v2/transactions?start_date=2015-01-01&end_date=$dateNowName'),
      headers: {'authorization': basicAuth},
    );
    loading.value = true;

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

      //saldos
      for (Transactions t in transacoes) {
        DateTime dt = DateTime.parse(t.date);

        if (dt.month == DateTime.now().month && t.accountId == 4741627) {
          messaldo0.value += t.amountCents;
        } else if (dt.month == DateTime.now().month - 1 &&
            t.accountId == 4741627) {
          messaldo1.value += t.amountCents;
        } else if (dt.month == DateTime.now().month - 2 &&
            t.accountId == 4741627) {
          messaldo2.value += t.amountCents;
        } else if (dt.month == DateTime.now().month - 3 &&
            t.accountId == 4741627) {
          messaldo3.value += t.amountCents;
        } else {
          if (dt.month == DateTime.now().month - 4 && t.accountId == 4741627) {
            messaldo4.value += t.amountCents;
          }
        }
      }
      loading.value = false;
    } else {
      throw Exception('Falha ao carregar...');
    }
  }

  Future carregarTransacoesFiltro(String dataInicio, String dataFim) async {
    loading.value = true;
    despesasFiltro.value = 0;
    receitasFiltro.value = 0;
    transacoesFiltro.clear();

    final response = await http.get(
      Uri.parse(
          'https://api.organizze.com.br/rest/v2/transactions?start_date=$dataInicio&end_date=$dataFim'),
      headers: {'authorization': basicAuth},
    );

    if (response.statusCode == 200) {
      Iterable res = json.decode(response.body);
      List list = res.map((e) => Transactions.fromJson(e)).toList();

      transacoesFiltro.addAll(list);

      transacoesFiltro.forEach((res) {
        Transactions trans = res;
        if (trans.amountCents.isNegative == true) {
          despesasFiltro.value += trans.amountCents;
        } else {
          receitasFiltro.value += trans.amountCents;
        }
      });

      totalFiltro.value = (receitasFiltro.value + despesasFiltro.value);

      loading.value = false;
    } else {
      throw Exception('Falha ao carregar...');
    }
  }

  Future criarMovimentacao(Map novaMov) async {
    loading.value = true;
    var response = await http.post(
        Uri.parse('https://api.organizze.com.br/rest/v2/transactions'),
        headers: {'authorization': basicAuth},
        body: novaMov);
    print(response.body);
    loading.value = false;
  }

  Future excluirMovimentacao(int id) async {
    loading.value = true;
    var response = await http.delete(
        Uri.parse('https://api.organizze.com.br/rest/v2/transactions/$id'),
        headers: {'authorization': basicAuth},
        body: {});
    print(response.body);
    carregarTransacoesFiltro(dateNowName, dateNowName);
    carregarTudo();
    loading.value = false;
  }

  limpartudo() {
    filtroPeriodo1 = "".obs;
    filtroPeriodo2 = "".obs;
    messaldo0 = 0.obs;
    messaldo1 = 0.obs;
    messaldo2 = 0.obs;
    messaldo3 = 0.obs;
    messaldo4 = 0.obs;
    novaMovCategoriaName = "".obs;
    novaMovCategoriaId = "".obs;
    novaMovContaName = "".obs;
    novaMovContaId = "".obs;
    movTipo1 = 0.obs;
    movTipo2 = 0.obs;
    movTipo3 = 0.obs;
    filtroLabel = "Hoje".obs;
    loading = false.obs;
    verSaldo = true.obs;
    categories = [].obs;
    transacoes.clear();
    transacoesFiltro = [].obs;
    contas = [].obs;
    saldoPrincipal = 0.obs;
    saldoSecundario = 0.obs;
    dateNowName = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }
}
