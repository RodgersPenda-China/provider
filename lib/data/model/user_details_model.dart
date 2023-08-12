// ignore_for_file: public_member_api_docs, sort_constructors_first

// class UserDetailsModel {
//   UserDetailsModel(
//       {this.addressIdImage,
//       this.id,
//       this.phone,
//       this.email,
//       this.fcmId,
//       this.image,
//       this.username});

//   final String? id;
//   final String? username;
//   final String? phone;
//   final String? email;
//   final String? fcmId;
//   final String? image;
//   String? addressIdImage;

//   UserDetailsModel copyWith({
//     String? id,
//     String? username,
//     String? phone,
//     String? email,
//     String? fcmId,
//     String? image,
//     String? addressIdImage,
//   }) =>
//       UserDetailsModel(
//         id: id ?? this.id,
//         username: username ?? this.username,
//         phone: phone ?? this.phone,
//         email: email ?? this.email,
//         fcmId: fcmId ?? this.fcmId,
//         image: image ?? this.image,
//         addressIdImage: image ?? this.addressIdImage,
//       );

//   factory UserDetailsModel.fromJson(String str) =>
//       UserDetailsModel.fromMap(json.decode(str));

//   String toJson() => json.encode(toMap());

//   factory UserDetailsModel.fromMap(Map<String, dynamic> json) =>
//       UserDetailsModel(
//         id: json["id"] ?? '0',
//         username: json["username"].toString(),
//         phone: json["phone"].toString(),
//         email: json["email"].toString(),
//         fcmId: json["fcm_id"].toString(),
//         image: json["image"].toString(),
//       );

//   Map<String, dynamic> toMap() => {
//         "id": id,
//         "username": username,
//         "phone": phone,
//         "email": email,
//         "fcm_id": fcmId,
//         "image": image,
//       };

//   factory UserDetailsModel.createEmptyModel() {
//     return UserDetailsModel(
//         id: "", username: "", phone: "", email: "", fcmId: "", image: "");
//   }

//   @override
//   String toString() {
//     return 'UserDetailsModel(id: $id, username: $username, phone: $phone, email: $email, fcmId: $fcmId, image: $image)';
//   }
// }

import 'dart:convert';

class ProviderDetails {
  ProviderDetails({
    this.locationInformation,
    this.user,
    this.providerInformation,
    this.bankInformation,
    this.workingDays,
  });

  final LocationInformation? locationInformation;
  final User? user;
  final ProviderInformation? providerInformation;
  final BankInformation? bankInformation;
  final List<WorkingDay>? workingDays;

  factory ProviderDetails.createEmptyModel() {
    return ProviderDetails(
        workingDays: [],
        user: User(),
        providerInformation: ProviderInformation(),
        locationInformation: LocationInformation(),
        bankInformation: BankInformation());
  }

  factory ProviderDetails.fromJson(Map<String, dynamic> json) {
    return ProviderDetails(
      locationInformation: LocationInformation.fromJson(
          Map.from(json["location_information"] ?? LocationInformation())),
      user: User.fromJson(Map.from(json["user"] ?? User())),
      providerInformation: ProviderInformation.fromJson(
          Map.from(json["provder_information"] ?? ProviderInformation())),
      bankInformation:
          BankInformation.fromJson(Map.from(json["bank_information"] ?? BankInformation())),
      workingDays: json["working_days"] == null
          ? []
          : (json["working_days"] as List).map((e) {
              return WorkingDay.fromJson(Map.from(e));
            }).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> parameters = {
      "city": locationInformation?.city,
      "current_location": locationInformation?.city,
      "latitude": locationInformation?.latitude,
      "longitude": locationInformation?.longitude,
      "address": locationInformation?.address,

      //
      "username": user?.username,
      "email": user?.email,
      "mobile": user?.phone,
      "image": user?.image,
      "password": user?.password,
      "password_confirm": user?.password,
      "country_code": user?.countryCode,
      //
      "tax_name": bankInformation?.taxName,
      "tax_number": bankInformation?.taxNumber,
      "account_number": bankInformation?.accountNumber,
      "account_name": bankInformation?.accountName,
      "bank_code": bankInformation?.bankCode,
      "swift_code": bankInformation?.swiftCode,
      "bank_name": bankInformation?.bankName,
      //
      "days": workingDays == null ? [] : List<dynamic>.from(workingDays!.map((x) => x.toJson())),
      //
      "company_name": providerInformation?.companyName,
      "about_provider": providerInformation?.about,
      "national_id": providerInformation?.nationalId,
      "banner_image": providerInformation?.banner,
      "address_id": providerInformation?.addressId,
      "passport": providerInformation?.passport,
      "advance_booking_days": providerInformation?.advanceBookingDays,
      "type": providerInformation?.type,
      "number_of_members": providerInformation?.numberOfMembers,
      "visiting_charges": providerInformation?.visitingCharges,
    };

    final String jsonString = jsonEncode(parameters['days']);
    parameters['days'] = jsonString;
    return parameters;
  }
}

class BankInformation {
  BankInformation({
    this.taxName,
    this.taxNumber,
    this.accountNumber,
    this.accountName,
    this.bankCode,
    this.swiftCode,
    this.bankName,
  });

  final String? taxName;
  final String? taxNumber;
  final String? accountNumber;
  final String? accountName;
  final String? bankCode;
  final String? swiftCode;
  final String? bankName;

  factory BankInformation.fromJson(Map<String, dynamic> json) => BankInformation(
        taxName: json["tax_name"].toString(),
        taxNumber: json["tax_number"].toString(),
        accountNumber: json["account_number"].toString(),
        accountName: json["account_name"].toString(),
        bankCode: json["bank_code"].toString(),
        swiftCode: json["swift_code"] ?? "",
        bankName: json["bank_name"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "tax_name": taxName,
        "tax_number": taxNumber,
        "account_number": accountNumber,
        "account_name": accountName,
        "bank_code": bankCode,
        "swift_code": swiftCode,
        "bank_name": bankName,
      };
}

class LocationInformation {
  LocationInformation({
    this.city,
    this.latitude,
    this.longitude,
    this.address,
  });

  final String? city;
  final String? latitude;
  final String? longitude;
  final String? address;

  factory LocationInformation.fromJson(Map<String, dynamic> json) {
    return LocationInformation(
      city: json["city"] ?? "",
      latitude: json["latitude"].toString(),
      longitude: json["longitude"].toString(),
      address: json["address"].toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        "city": city,
        "latitude": latitude,
        "longitude": longitude,
        "address": address,
      };
}

class ProviderInformation {
  ProviderInformation({
    this.id,
    this.partnerId,
    this.companyName,
    this.about,
    this.nationalId,
    this.banner,
    this.addressId,
    this.passport,
    this.advanceBookingDays,
    this.type,
    this.numberOfMembers,
    this.adminCommission,
    this.visitingCharges,
    this.isApproved,
    this.serviceRange,
    this.ratings,
    this.numberOfRatings,
    this.createdAt,
    this.updatedAt,
  });

  final String? id;
  final String? partnerId;
  final String? companyName;
  final String? about;
  final String? nationalId;
  final String? banner;
  final String? addressId;
  final String? passport;
  final String? advanceBookingDays;
  final String? type;
  final String? numberOfMembers;
  final String? adminCommission;
  final String? visitingCharges;
  final String? isApproved;
  final dynamic serviceRange;
  final String? ratings;
  final String? numberOfRatings;
  final DateTime? createdAt;
  final String? updatedAt;

  factory ProviderInformation.fromJson(Map<String, dynamic> json) {
    return ProviderInformation(
      id: json["id"] ?? "0",
      partnerId: json["partner_id"] ?? "0",
      companyName: json["company_name"].toString(),
      about: json["about"].toString(),
      nationalId: json["national_id"].toString(),
      banner: json["banner"].toString(),
      addressId: json["address_id"].toString(),
      passport: json["passport"].toString(),
      advanceBookingDays: json["advance_booking_days"].toString(),
      type: json["type"].toString(),
      numberOfMembers: json["number_of_members"].toString(),
      adminCommission: json["admin_commission"].toString(),
      visitingCharges: json["visiting_charges"].toString(),
      isApproved: json["is_approved"].toString(),
      serviceRange: json["service_range"].toString(),
      ratings: json["ratings"].toString(),
      numberOfRatings: json["number_of_ratings"].toString(),
      createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
      updatedAt: json["updated_at"].toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "partner_id": partnerId,
        "company_name": companyName,
        "about": about,
        "national_id": nationalId,
        "banner": banner,
        "address_id": addressId,
        "passport": passport,
        "advance_booking_days": advanceBookingDays,
        "type": type,
        "number_of_members": numberOfMembers,
        "admin_commission": adminCommission,
        "visiting_charges": visitingCharges,
        "is_approved": isApproved,
        "service_range": serviceRange,
        "ratings": ratings,
        "number_of_ratings": numberOfRatings,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt,
      };
}

class User {
  User(
      {this.id,
      this.username,
      this.email,
      this.password,
      this.balance,
      this.active,
      this.firstName,
      this.lastName,
      this.company,
      this.phone,
      this.fcmId,
      this.image,
      this.cityId,
      this.countryCode});

  final String? id;
  final String? username;
  final String? email;
  final String? balance;
  final String? active;
  final dynamic firstName;
  final dynamic lastName;
  final dynamic company;
  final String? phone;
  final String? countryCode;
  final dynamic fcmId;
  final dynamic image;
  final String? cityId;
  final String? password;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"] ?? "0",
      username: json["username"].toString(),
      email: json["email"].toString(),
      balance: json["balance"].toString(),
      active: json["active"].toString(),
      firstName: json["first_name"].toString(),
      lastName: json["last_name"].toString(),
      company: json["company"].toString(),
      phone: json["phone"].toString(),
      countryCode: json["country_code"].toString(),
      fcmId: json["fcm_id"].toString(),
      image: json["image"].toString(),
      cityId: json["city_id"].toString(),
      password: json["password"].toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "balance": balance,
        "active": active,
        "first_name": firstName,
        "last_name": lastName,
        "company": company,
        "phone": phone,
        "fcm_id": fcmId,
        "image": image,
        "city_id": cityId,
        "password": password,
        "country_code": countryCode
      };
}

class WorkingDay {
  WorkingDay({
    this.day,
    this.isOpen,
    this.startTime,
    this.endTime,
  });

  final String? day;
  final int? isOpen;
  final String? startTime;
  final String? endTime;

  factory WorkingDay.fromJson(Map<String, dynamic> json) {
    return WorkingDay(
      day: json["day"].toString(),
      isOpen: int.parse(json["isOpen"].toString()),
      startTime: json["start_time"].toString(),
      endTime: json["end_time"].toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        "day": day,
        "isOpen": isOpen,
        "start_time": startTime,
        "end_time": endTime,
      };
}
