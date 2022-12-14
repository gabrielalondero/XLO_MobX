// ignore_for_file: public_member_api_docs, sort_constructors_first
class UF {
  UF({this.id,required this.initials,this.name});

//factory - construtor cria um novo objeto
//Estados
  factory UF.fromJson(Map<String, dynamic> json) => UF(   
    id: json['id'],
    initials: json['sigla'],
    name: json['nome'],
  );

  int? id;
  String initials;
  String? name;

  @override
  String toString() => 'UF(id: $id, initials: $initials, name: $name)';
}
