// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:xlo_mobx/models/address.dart';
import 'package:xlo_mobx/models/category.dart';
import 'package:xlo_mobx/models/city.dart';
import 'package:xlo_mobx/models/uf.dart';
import 'package:xlo_mobx/models/user.dart';
import 'package:xlo_mobx/repositories/tables_keys.dart';
import 'package:xlo_mobx/repositories/user_repository.dart';

enum AdStatus { pending, active, sold, deleted }

class Ad {
  Ad({
    this.id,
    this.images,
    this.title,
    this.description,
    this.category,
    this.address,
    this.price,
    this.hidePhone = false,
    this.created,
    this.status = AdStatus.pending,
    this.user,
    this.views,
  });

  Ad.fromParse(ParseObject object) :
    id = object.objectId,
    title = object.get<String>(keyAdTitle),
    description = object.get<String>(keyAdDescription),
    //pegando cada um dos ParseFiles, pegando sua url e craindo uma lista de urls
    images = object.get<List>(keyAdImages)!.map((e) => e.url).toList(),
    hidePhone = object.get<bool>(keyAdHidePhone)!,
    price = object.get<num>(keyAdPrice),
    created = object.createdAt,
    address = Address(
      uf: UF(initials: object.get<String>(keyAdFederativeUnit)!),
      city: City(name: object.get<String>(keyAdCity)!),
      cep: object.get<String>(keyAdPostalCode)!,
      district: object.get<String>(keyAdDistrict)!,
      street: object.get<String>(keyAdStreet)!,
    ),
    //se não existir valor, o default é 0
    views = object.get<int>(keyAdViews, defaultValue: 0),
    //mapeando de ParseUser para User
    user = UserRepository().mapParseToUser(object.get<ParseUser>(keyAdOwner)!),
    category = Category.fromParse(object.get<ParseObject>(keyAdCategory)!),
    status = AdStatus.values[object.get<int>(keyAdStatus)!]; //convertendo para enum
  

  String? id;

  List? images = [];

  String? title;
  String? description;

  Category? category;

  Address? address;

  num? price;
  bool hidePhone = false;

  AdStatus status;
  DateTime? created;

  User? user;

  int? views;

  @override
  String toString() {
    return 'Ad(id: $id, images: $images, title: $title, description: $description, category: $category, price: $price, Address: $address, hidePhone: $hidePhone, created: $created,status: $status, user: $user, views: $views)';
  }
}
