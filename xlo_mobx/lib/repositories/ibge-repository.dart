import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xlo_mobx/models/uf.dart';

import '../models/city.dart';

class IBGERepository {
  Future<List<UF>> getUFList() async {
    final preferences = await SharedPreferences.getInstance();

    //verifica se os estados já não estão salvos em cache
    if(preferences.containsKey('UF_LIST')){
      //pega os dados em cache
      final j = json.decode(preferences.getString('UF_LIST')!) as List;
      //mapeia cada um dos estados de json para UF
      final ufList = j.map<UF>((j) => UF.fromJson(j)).toList()
        //ordem alfabética
        ..sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
      return ufList;
    }

    //se os estados não estão salvos, pega na API
    const endpoint =
        'https://servicodados.ibge.gov.br/api/v1/localidades/estados';

    try {
      final response = await Dio().get<List>(endpoint);
      
      // pegando o json e salvando em cache
      preferences.setString('UF_LIST', json.encode(response.data)); 

      //mapeia cada um dos estados de json para UF
      final ufList = response.data!.map<UF>((j) => UF.fromJson(j)).toList()
        ..sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
      return ufList;

      //não coloque catch diretamente, coloque o erro específico, neste caso 'DioError'
    } on DioError {
      return Future.error('Falha ao obter lista de Estados');
    }
  }


//pega as cidades de certo estado
  Future<List<City>> getCityListFromApi(UF uf) async {
    final String endpoint =
        'https://servicodados.ibge.gov.br/api/v1/localidades/estados/${uf.initials}/municipios';

    try {
      final response = await Dio().get<List>(endpoint);
      //mapeia cada uma das cidades de json para City
      final cityList = response.data!.map<City>((j) => City.fromJson(j)).toList()
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      return cityList;
    } on DioError {
      return Future.error('Falha ao obter lista de Cidades');
    }
  }
}
