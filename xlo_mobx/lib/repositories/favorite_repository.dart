import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:xlo_mobx/models/ad.dart';
import 'package:xlo_mobx/repositories/parse_errors.dart';
import 'package:xlo_mobx/repositories/tables_keys.dart';

import '../models/user.dart';

class FavoriteRepository {
  Future<List<Ad>> getFavorites(User user) async {
    //pegando todos os favoritos
    final queryBuilder =
        QueryBuilder<ParseObject>(ParseObject(keyFavoritesTable));
    //filtrando pelo id do usuário
    queryBuilder.whereEqualTo(keyFavoritesOwner, user.id);
    //incluíndo os dados dos anúncios, e os dados do dono do anúncio, e os dados da categoria
    queryBuilder.includeObject([keyFavoritesAd, 'ad.owner','ad.category']);

    final response = await queryBuilder.query();

    if (response.success && response.results != null) {
      final resp = response.results! as List<ParseObject>;

      //convertendo a lista de parse objects da coluna keyFavoritesAd, para uma lista de Ads
      return resp.map((po) => Ad.fromParse(po.get(keyFavoritesAd))).toList();
    } else if (response.success && response.results == null) {
      return [];
    } else {
      return Future.error(ParseErrors.getDescription(response.error!.code)!);
    }
  }

  Future<void> save(Ad ad, User user) async {
    final favoriteObject = ParseObject(keyFavoritesTable);
    //neste caso, não foi feito ponteiro, pois não precisamos dos dados do dono dos favoritos
    //então salvamos somente o id
    favoriteObject.set(keyFavoritesOwner, user.id);

    //settando uma relação entra a tabela de favoritos e a tabela de anúncios
    //pois assim podemos pegar as informações dos anúncios quando pegarmos
    //a lista de favoritos
    favoriteObject.set<ParseObject>(
        keyFavoritesAd, ParseObject(keyAdTable)..set(keyAdId, ad.id));

    final response = await favoriteObject.save();
    if (!response.success) {
      return Future.error(ParseErrors.getDescription(response.error!.code)!);
    }
  }

//excluindo o favorito
  Future<void> delete(Ad ad, User user) async {
    try {
      //pegando todos os favoritos
      final queryBuilder =
          QueryBuilder<ParseObject>(ParseObject(keyFavoritesTable));
      //filtrando...
      queryBuilder.whereEqualTo(
          keyFavoritesOwner, user.id); //...pelo id do usuário
      queryBuilder.whereEqualTo(keyFavoritesAd,
          ParseObject(keyAdTable)..set(keyAdId, ad.id)); //...pelo id do anúncio

      //executando
      final response = await queryBuilder.query();

      //esse laço abaixo vai deletar o favorito, e caso ele esteja duplicado por conta de algum bug,
      //também delterá as duplicatas
      if (response.success && response.results != null) {
        //passa por cada um dos favoritos
        for (final fav in response.results as List<ParseObject>) {
          await fav.delete();
        }
      }
    } catch (e) {
      return Future.error('Falha ao deletar favorito');
    }
  }
}
