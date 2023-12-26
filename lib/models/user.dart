import '/exports.dart';

class UserModel {
  UserName name;
  String email, image, role;
  PhoneNumber phone;
  GeoPoint? address;
  String? password;
  String token;

  UserModel({
    required this.name,
    required this.email,
    this.password,
    required this.image,
    required this.phone,
    this.address,
    required this.role,
    required this.token,
  });

  factory UserModel.fromJson(DocumentSnapshot data) => UserModel(
        name: UserName.fromMap(data['name']),
        email: data['email'].toString(),
        phone: PhoneNumber.fromJson(data['phone']),
        image: data['image'].toString(),
        address: data['address'],
        role: data['role'].toString(),
        token: data['token'].toString(),
      );

  factory UserModel.fromMap(Map data) => UserModel(
        name: UserName.fromMap(data['name']),
        email: data['email'].toString(),
        phone: PhoneNumber(isoCode: data['phone']['isoCode'], nsn: data['phone']['nsn']),
        image: data['image'].toString(),
        address: data['address'],
        role: data['role'].toString(),
        token: data['token'].toString(),
      );

  Map<String, dynamic> toJson() => {
        'name': name.toMap(),
        'email': email,
        'image': image,
        'phone': phone.toJson(),
        'address': address,
        'role': role,
        'token': token,
      };
}

class UserName {
  String firstName, lastName;

  UserName({required this.firstName, required this.lastName});

  factory UserName.fromMap(Map data) => UserName(firstName: data['firstName'], lastName: data['lastName']);

  String name() => '$firstName $lastName';

  Map toMap() => {'firstName': firstName, 'lastName': lastName};
}
