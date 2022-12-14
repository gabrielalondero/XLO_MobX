// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'city.dart';
import 'uf.dart';

class Address {
  Address({
    required this.uf,
    required this.city,
    required this.cep,
    required this.district,
    required this.street,
  });

  UF uf;
  City city;
  String cep;
  String district;
  String street;


  @override
  String toString() {
    return 'Address(uf: $uf, city: $city, cep: $cep, district: $district, street: $street)';
  }
}
