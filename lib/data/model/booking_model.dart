class BookingsModel {
  String? id;
  String? customer;
  String? latitude;
  String? longitude;
  String? customerId;
  String? customerNo;
  String? customerEmail;
  String? userWallet;
  String? paymentMethod;
  String? partner;
  String? profileImage;
  String? userId;
  String? partnerId;
  String? cityId;
  String? total;
  String? taxPercentage;
  String? taxAmount;
  String? promoCode;
  String? promoDiscount;
  String? finalTotal;
  String? adminEarnings;
  String? partnerEarnings;
  String? addressId;
  String? address;
  String? dateOfService;
  String? startingTime;
  String? endingTime;
  String? duration;
  int? isCancelable;
  String? status;
  String? remarks;
  String? createdAt;
  String? companyName;
  String? visitingCharges;
  List<Services>? services;
  String? invoiceNo;
  String? advanceBookingDays;

  BookingsModel(
      {this.id,
      this.customer,
      this.customerId,
      this.customerNo,
      this.customerEmail,
      this.userWallet,
      this.paymentMethod,
      this.partner,
      this.profileImage,
      this.userId,
      this.partnerId,
      this.cityId,
      this.total,
      this.taxPercentage,
      this.taxAmount,
      this.promoCode,
      this.promoDiscount,
      this.finalTotal,
      this.adminEarnings,
      this.partnerEarnings,
      this.addressId,
      this.address,
      this.dateOfService,
      this.startingTime,
      this.endingTime,
      this.duration,
      this.isCancelable,
      this.status,
      this.remarks,
      this.createdAt,
      this.companyName,
      this.visitingCharges,
      this.services,
      this.latitude,
      this.longitude,
      this.advanceBookingDays,
      this.invoiceNo});

  BookingsModel.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    id = json['id'];
    customer = json['customer'];
    customerId = json['customer_id'];
    customerNo = json['customer_no'];
    customerEmail = json['customer_email'];
    userWallet = json['user_wallet'];
    paymentMethod = json['payment_method'];
    partner = json['partner'];
    profileImage = json['profile_image'];
    userId = json['user_id'];
    partnerId = json['partner_id'];
    cityId = json['city_id'];
    total = json['total'];
    taxPercentage = json['tax_percentage'];
    taxAmount = json['tax_amount'];
    promoCode = json['promo_code'];
    promoDiscount = json['promo_discount'];
    finalTotal = json['final_total'];
    adminEarnings = json['admin_earnings'];
    partnerEarnings = json['partner_earnings'];
    addressId = json['address_id'];
    address = json['address'];
    dateOfService = json['date_of_service'];
    startingTime = json['starting_time'];
    endingTime = json['ending_time'];
    duration = json['duration'];
    isCancelable = json['is_cancelable'];
    status = json['status'];
    remarks = json['remarks'];
    createdAt = json['created_at'];
    companyName = json['company_name'];
    advanceBookingDays = json['advance_booking_days'];

    visitingCharges = json['visiting_charges'];
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(Services.fromJson(v));
      });
    }
    invoiceNo = json['invoice_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['customer'] = customer;
    data['customer_id'] = customerId;
    data['customer_no'] = customerNo;
    data['customer_email'] = customerEmail;
    data['user_wallet'] = userWallet;
    data['payment_method'] = paymentMethod;
    data['partner'] = partner;
    data['profile_image'] = profileImage;
    data['user_id'] = userId;
    data['partner_id'] = partnerId;
    data['city_id'] = cityId;
    data['total'] = total;
    data['tax_percentage'] = taxPercentage;
    data['tax_amount'] = taxAmount;
    data['promo_code'] = promoCode;
    data['promo_discount'] = promoDiscount;
    data['final_total'] = finalTotal;
    data['admin_earnings'] = adminEarnings;
    data['partner_earnings'] = partnerEarnings;
    data['address_id'] = addressId;
    data['address'] = address;
    data['date_of_service'] = dateOfService;
    data['starting_time'] = startingTime;
    data['ending_time'] = endingTime;
    data['duration'] = duration;
    data['is_cancelable'] = isCancelable;
    data['status'] = status;
    data['remarks'] = remarks;
    data['created_at'] = createdAt;
    data['company_name'] = companyName;
    data['visiting_charges'] = visitingCharges;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['advance_booking_days'] = advanceBookingDays;

    if (services != null) {
      data['services'] = services!.map((v) => v.toJson()).toList();
    }
    data['invoice_no'] = invoiceNo;
    return data;
  }
}

class Services {
  String? id;
  String? orderId;
  String? serviceId;
  String? serviceTitle;
  String? taxPercentage;
  String? taxAmount;
  String? price;
  String? taxValue;
  String? priceWithTax;
  String? quantity;
  String? subTotal;
  String? status;
  String? tags;
  String? duration;
  String? categoryId;
  String? isCancelable;
  String? cancelableTill;
  String? rating;
  String? comment;
  String? images;
  String? advanceBookingDays;
  Services(
      {this.id,
      this.orderId,
      this.serviceId,
      this.serviceTitle,
      this.taxPercentage,
      this.taxAmount,
      this.price,
      this.priceWithTax,
      this.taxValue,
      this.quantity,
      this.subTotal,
      this.status,
      this.tags,
      this.duration,
      this.categoryId,
      this.isCancelable,
      this.cancelableTill,
      this.rating,
      this.comment,
      this.advanceBookingDays,
      this.images});

  Services.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    serviceId = json['service_id'];
    serviceTitle = json['service_title'];
    taxPercentage = json['tax_percentage'];
    taxAmount = json['tax_amount'];
    price = json['price'];
    priceWithTax = json['price_with_tax'];
    taxValue = json['tax_value'];
    quantity = json['quantity'];
    subTotal = json['sub_total'];
    status = json['status'];
    tags = json['tags'];
    duration = json['duration'];
    categoryId = json['category_id'];
    isCancelable = json['is_cancelable'];
    cancelableTill = json['cancelable_till'];
    rating = json['rating'];
    comment = json['comment'];
    images = json['images'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['service_id'] = serviceId;
    data['service_title'] = serviceTitle;
    data['tax_percentage'] = taxPercentage;
    data['tax_amount'] = taxAmount;
    data['price'] = price;
    data['quantity'] = quantity;
    data['sub_total'] = subTotal;
    data['status'] = status;
    data['tags'] = tags;
    data['duration'] = duration;
    data['category_id'] = categoryId;
    data['is_cancelable'] = isCancelable;
    data['cancelable_till'] = cancelableTill;
    data['rating'] = rating;
    data['comment'] = comment;
    data['images'] = images;
    return data;
  }
}
