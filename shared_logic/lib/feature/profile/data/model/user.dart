import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Equatable {
   User({
    required this.name,
    required this.sex,
    required this.dob,
    required this.idCard,
    required this.date,
    required this.placeID,
    required this.contactAdress,
    required this.city,
    required this.phone,
    required this.email,
  });

   String name;
   String sex;
   String dob;
   String idCard;
   String date;
   String placeID;
   String contactAdress;
   String city;
   String phone;
   String email;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object?> get props =>
      [name, sex, dob, idCard, date, placeID, contactAdress, city, phone, email];
}
