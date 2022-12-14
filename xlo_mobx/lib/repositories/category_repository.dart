import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:xlo_mobx/models/category.dart';
import 'package:xlo_mobx/repositories/tables_keys.dart';

import 'parse_errors.dart';

class CategoryRepository{
  Future<List<Category>> getList() async {
    final queryBuilder = QueryBuilder(ParseObject(keyCategoryTable))
        ..orderByAscending(keyCategoryDescription); //ordem alfabética
    
    final response = await queryBuilder.query();

    if(response.success){
      //tranforma cada um dos Objetos Parse em Objetos Category
      return response.results!.map((p) => Category.fromParse(p)).toList();
      
    }else{
      throw ParseErrors.getDescription(response.error!.code)!;
    }
  }
}