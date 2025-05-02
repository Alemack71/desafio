import 'package:desafio/data/http/excpetions.dart';
import 'package:desafio/data/models/produto_model.dart';
import 'package:desafio/data/repositories/produto_repository.dart';
import 'package:flutter/foundation.dart';

class ProdutoStore {
  final IProdutoRepository repository;

  //Variável reativa para o loading
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  //Variável reativa para o state
  final ValueNotifier<List<ProdutoModel>> state = 
    ValueNotifier<List<ProdutoModel>>([]);

  //Variável reativa para o erro
  final ValueNotifier<String> erro = ValueNotifier<String>('');

  ProdutoStore({required this.repository});

  Future getProdutos() async {
    isLoading.value = true;

    try {
      final result = await repository.getProdutos();
      state.value = result;
    } on NotFoundException catch (e) {
      erro.value = e.message;
    } catch (e) {
      erro.value = e.toString();
    }

    isLoading.value = false;
  }
}