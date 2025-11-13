// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  name: json['name'] as String,
  sex: json['sex'] as String,
  dob: json['dob'] as String,
  idCard: json['idCard'] as String,
  date: json['date'] as String,
  placeID: json['placeID'] as String,
  contactAdress: json['contactAdress'] as String,
  city: json['city'] as String,
  phone: json['phone'] as String,
  email: json['email'] as String,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'name': instance.name,
  'sex': instance.sex,
  'dob': instance.dob,
  'idCard': instance.idCard,
  'date': instance.date,
  'placeID': instance.placeID,
  'contactAdress': instance.contactAdress,
  'city': instance.city,
  'phone': instance.phone,
  'email': instance.email,
};
