import 'dart:io';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:xlo_mobx/models/category.dart';
import 'package:xlo_mobx/models/user.dart';
import 'package:xlo_mobx/repositories/parse_errors.dart';
import 'package:xlo_mobx/repositories/tables_keys.dart';
import '../models/ad.dart';
import 'package:path/path.dart' as path;
import '../stores/filter_store.dart';

class AdRepository {
  Future<List<Ad>> getHomeAdList({
    required FilterStore filter,
    required String? search,
    required Category? category,
    required int page,
  }) async {
    try {
      final queryBuilder = QueryBuilder<ParseObject>(ParseObject(keyAdTable));
      //além de trazer o objeto anúncio,
      //trazer também o objeto do usuário que está vinculado a este anúncio
      //e a categoria
      queryBuilder.includeObject([keyAdOwner, keyAdCategory]);

      //pular o número de itens já pegos nas páginas anteriores,
      //peganto então novos itens
      queryBuilder.setAmountToSkip(page * 10);

      //pega 20 anúncios por página,
      queryBuilder.setLimit(10);

      //pega somente os anúncios que estão ativos
      queryBuilder.whereEqualTo(keyAdStatus, AdStatus.active.index);

      //trim() - tira os espaços vazios da string
      //então se pesquisar espaço vazio('     '),
      //não vai pesquisar nada, pois o trim vai tirar e ficará uma string vazia
      if (search != null && search.trim().isNotEmpty) {
        //pesquisa onde o titilo contém o search
        queryBuilder.whereContains(keyAdTitle, search, caseSensitive: false);
      }

      //diferente da opção 'Todas' que tem id '*', ela não precisa de filtro
      if (category != null && category.id != '*') {
        queryBuilder.whereEqualTo(
          keyAdCategory,
          //pega o objeto, que é a categoria selecionada, e tranforma em um ponteiro
          //pois no parse, os anúncios apontam para a categoria a qual pertencem
          (ParseObject(keyCategoryTable)..set(keyCategoryId, category.id))
              .toPointer(),
        );
      }

      //ordenando por preço ou data de criação(que será o default também)
      switch (filter.orderBy) {
        case OrderBy.price:
          queryBuilder.orderByAscending(keyAdPrice);
          break;
        case OrderBy.date:
        default:
          queryBuilder.orderByDescending(keyAdCreatedAt);
          break;
      }

      //filtrando por preço
      if (filter.minPrice != null && filter.minPrice! > 0) {
        //onde é maior ou igual
        queryBuilder.whereGreaterThanOrEqualsTo(keyAdPrice, filter.minPrice);
      }
      if (filter.maxPrice != null && filter.maxPrice! > 0) {
        //onde é menor ou igual
        queryBuilder.whereLessThanOrEqualTo(keyAdPrice, filter.maxPrice);
      }

      //filtrando por tipo de vendedor

      if (filter.vendorType != null &&
          filter.vendorType > 0 &&
          //verifica se pelo menos um está selecionado ou se todos estão(nao podendo ter mais que todos)
          filter.vendorType < (vendorTypeParticular | vendorTypeProfessional)) {
        //fazendo subquery para obter o tipo de vendedor
        final userQuery = QueryBuilder<ParseUser>(ParseUser.forQuery());
        //buscando os de tipo particular
        if (filter.vendorType == vendorTypeParticular) {
          userQuery.whereEqualTo(keyUserType, UserType.particular.index);
        }
        //buscando os de tipo profissional
        if (filter.vendorType == vendorTypeProfessional) {
          userQuery.whereEqualTo(keyUserType, UserType.professional.index);
        }
        //se não for nenhum dos dois, vai buscar dos dois tipos, não vai filtrar

        //juntando a subquery com a query
        queryBuilder.whereMatchesQuery(keyAdOwner, userQuery);
      }
      //executando a query
      final response = await queryBuilder.query();
      if (response.success && response.results != null) {
        //convertendo a lista de parse objects para uma lista de Ads
        return response.results!.map((po) => Ad.fromParse(po)).toList();
      } else if (response.success && response.results == null) {
        return [];
      } else {
        return Future.error(ParseErrors.getDescription(response.error!.code)!);
      }
    } catch (e) {
      return Future.error('Falha de conexão');
    }
  }

  Future<void> save(Ad ad) async {
    try {
      final parseImages = await saveImages(ad.images!);

      // criando parseUser com o id do usuário que passamos no ad
      //este será o parseUser que iremos vincular ao anúncio
      final parseUser = await ParseUser.currentUser()
          as ParseUser; //pega o último usuário logado

      //criando parse object(criando o anúncio)
      //ParseObject(nomeDaTabela)
      final adObject = ParseObject(keyAdTable);

      //se estiver editando um anúncio
      if (ad.id != null) {
        adObject.objectId = ad.id;
      }

      //vinculando o usuário ao anúncio (tipo uma chave estrangeira, que aponta para o usuário)
      final parseAcl = ParseACL(owner: parseUser);
      //permições de leitura e escrita no parse
      //qualquer pessoa pode ler os dados
      parseAcl.setPublicReadAccess(allowed: true);
      //somente o dono pode escrever
      parseAcl.setPublicWriteAccess(allowed: false);
      //salvando as permições
      adObject.setACL(parseAcl);

      //setando os dados do anúncio
      //set<>(coluna, valor);
      adObject.set<String>(keyAdTitle, ad.title!);
      adObject.set<String>(keyAdDescription, ad.description!);
      adObject.set<bool>(keyAdHidePhone, ad.hidePhone);
      adObject.set<num>(keyAdPrice, ad.price!);
      //não podemos passar o enum, passamos o index(pending = 0, active = 1, sold = 3, deleted = 4)
      adObject.set<int>(keyAdStatus, ad.status.index);

      adObject.set<String>(keyAdStreet, ad.address!.street);
      adObject.set<String>(keyAdDistrict, ad.address!.district);
      adObject.set<String>(keyAdCity, ad.address!.city.name);
      adObject.set<String>(keyAdFederativeUnit, ad.address!.uf.initials);
      adObject.set<String>(keyAdPostalCode, ad.address!.cep);

      adObject.set<List<ParseFile>>(keyAdImages, parseImages);

      adObject.set<ParseUser>(keyAdOwner, parseUser);

      //setando categoria
      //vincula a categoria ao anúncio (tipo uma chave estrangeira, que aponta para a categoria)
      adObject.set<ParseObject>(keyAdCategory,
          ParseObject(keyCategoryTable)..set(keyCategoryId, ad.category!.id));

      final response = await adObject.save();

      if (!response.success) {
        return Future.error(ParseErrors.getDescription(response.error!.code)!);
      }
    } catch (e) {
      return Future.error('Falha ao salvar anúncio');
    }
  }

  Future<List<ParseFile>> saveImages(List images) async {
    final parseImages = <ParseFile>[];
    try {
      for (final image in images) {
        if (image is File) {
          //ParseFile(arquivo, nome)
          final parseFile = ParseFile(image, name: path.basename(image.path));
          //fazendo upload
          final response = await parseFile.save();
          //verifica se teve erro
          if (!response.success) {
            return Future.error(
                ParseErrors.getDescription(response.error!.code)!);
          }
          //salva na lista
          parseImages.add(parseFile);
        } else {
          //caso seja uma imagem que já está no parse e vamos editar, ela é uma URL
          final ParseFile parseFile =
              ParseFile(null, name: path.basename(image));
          parseFile.url = image;
          parseImages.add(parseFile);
        }
      }
      return parseImages;
    } catch (e) {
      return Future.error('Falha ao Salvar imagens');
    }
  }

  Future<List<Ad>> getMyAds(User user) async {
    //referenciando para o usuário
    final currentUser = ParseUser(user.email, '', user.email)
      ..set(keyUserId, user.id);
    //await ParseUser.currentUser() as ParseUser; //pega o último usuário logado
    final queryBuilder = QueryBuilder<ParseObject>(ParseObject(keyAdTable));
    queryBuilder.setLimit(100);
    queryBuilder.orderByDescending(keyAdCreatedAt);
    queryBuilder.whereEqualTo(
        keyAdOwner, currentUser.toPointer()); //ponteiro para usuário
    queryBuilder.includeObject([keyAdCategory, keyAdOwner]);

    final response = await queryBuilder.query();
    if (response.success && response.results != null) {
      //convertendo a lista de parse objects para uma lista de Ads
      return response.results!.map((po) => Ad.fromParse(po)).toList();
    } else if (response.success && response.results == null) {
      return [];
    } else {
      return Future.error(ParseErrors.getDescription(response.error!.code)!);
    }
  }

//atualizando o status para 'vendido'
  Future<void> sold(Ad ad) async {
    final parseObject = ParseObject(keyAdTable)..set(keyAdId, ad.id);
    parseObject.set(keyAdStatus, AdStatus.sold.index);
    final response = await parseObject.save();
    if (!response.success) {
      return Future.error(ParseErrors.getDescription(response.error!.code)!);
    }
  }

//atualizando o status para 'deletado',
//assim ninguém mais verá o anúncio
//não vamos realmente deletar, só mudamos o status
//dessa forma podemeos ter um histórico
  Future<void> delete(Ad ad) async {
    final parseObject = ParseObject(keyAdTable)..set(keyAdId, ad.id);
    parseObject.set(keyAdStatus, AdStatus.deleted.index);
    final response = await parseObject.save();
    if (!response.success) {
      return Future.error(ParseErrors.getDescription(response.error!.code)!);
    }
  }
}
