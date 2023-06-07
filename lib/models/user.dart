import '/exports.dart';

class UserModel {
  Map name;
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

  factory UserModel.fromJson(DocumentSnapshot data) {
    return UserModel(
      name: {
        'firstName': data['name']['firstName'],
        'lastName': data['name']['lastName'],
      },
      email: data['email'].toString(),
      phone: PhoneNumber(isoCode: data['phone']['isoCode'], nsn: data['phone']['nsn']),
      image: data['image'].toString(),
      address: data['address'],
      role: data['role'].toString(),
      token: data['token'].toString(),
    );
  }

  factory UserModel.fromMap(Map data) {
    return UserModel(
      name: {
        'firstName': data['name']['firstName'],
        'lastName': data['name']['lastName'],
      },
      email: data['email'].toString(),
      phone: PhoneNumber(isoCode: data['phone']['isoCode'], nsn: data['phone']['nsn']),
      image: data['image'].toString(),
      address: data['address'],
      role: data['role'].toString(),
      token: data['token'].toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': {
          'firstName': name['firstName'],
          'lastName': name['lastName'],
        },
        'email': email,
        'image': image,
        'phone': {
          'isoCode': phone.isoCode,
          'nsn': phone.nsn,
        },
        'address': address,
        'role': role,
        'token': token,
      };
}
