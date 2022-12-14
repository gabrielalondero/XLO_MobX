import 'package:dio/dio.dart';
import 'package:xlo_mobx/models/address.dart';
import 'package:xlo_mobx/models/city.dart';
import 'package:xlo_mobx/repositories/ibge-repository.dart';

class CepRepository {
  Future<Address> getAdressFromApi(String cep) async {
    if (cep == null || cep.isEmpty) {
      return Future.error('CEP inválido');
    }
    //quanquer caracter que não seja de 0 a 9, vai ser substituido por vazio
    final clearCep = cep.replaceAll(RegExp('[^0-9]'), '');
    if (clearCep.length != 8) {
      return Future.error('CEP inválido');
    }
    

    final endpoint = 'https://viacep.com.br/ws/$clearCep/json/';

    try {
      final response = await Dio().get<Map>(endpoint);
      if (response.data!.containsKey('erro') && response.data!['erro']) {
        return Future.error('CEP inválido');
      }

      final ufList = await IBGERepository().getUFList();

      return Address(
        uf: ufList.firstWhere((uf) => uf.initials == response.data!['uf']),
        city: City(
          name: response.data!['localidade'],
        ),
        cep: response.data!['cep'],
        district: response.data!['bairro'],
        street: response.data!['logradouro'],
      );

      //tem dois tipos de erros(no Dio e no IBGERepository),
      //então coloca o catch para obter qualque excessão que possa ocorrer
    } catch (e) {
      return Future.error('Falha ao buscar CEP');
    }
  }
}
