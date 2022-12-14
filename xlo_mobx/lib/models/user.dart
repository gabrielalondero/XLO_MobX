// ignore_for_file: public_member_api_docs, sort_constructors_first
enum UserType { particular, professional }

class User {
  User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.password,
    this.type = UserType.particular, //setta particular por default
    this.createdAt
  });

  String? id;
  String? name;
  String? email;
  String? phone;
  String? password;
  UserType type;
  DateTime? createdAt;

  

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, phone: $phone, password: $password, type: $type, createdAt: $createdAt)';
  }
}
