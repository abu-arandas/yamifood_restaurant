import '/exports.dart';

class TeamModel {
  String name;
  String job;
  String image;
  String facebook;
  String instagram;

  TeamModel({
    required this.name,
    required this.job,
    required this.image,
    required this.facebook,
    required this.instagram,
  });

  factory TeamModel.fromJson(DocumentSnapshot data) {
    return TeamModel(
      name: data['name'],
      job: data['job'],
      image: data['image'],
      facebook: data['facebook'],
      instagram: data['instagram'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'job': job,
        'image': image,
        'facebook': facebook,
        'instagram': instagram,
      };
}
