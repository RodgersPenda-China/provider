class CreateServiceModel {
  String? serviceId;
  String? title;
  String? description;
  String? price;
  int? duration;
  String? maxQty;
  String? tags;
  String? members;
  String? categories;
  String? cancelableTill;
  int? iscancelable;
  int? is_pay_later_allowed;
  int? discounted_price;
  String? tax_type;
  String? taxId;
  int? tax;
  dynamic image;
  CreateServiceModel(
      {this.title,
      this.serviceId,
      this.description,
      this.price,
      this.duration,
      this.maxQty,
      this.image,
      this.tags,
      this.members,
      this.categories,
      this.iscancelable,
      this.is_pay_later_allowed,
      this.discounted_price,
      this.tax_type,
      this.tax,
      this.cancelableTill,
      this.taxId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (serviceId != "" && serviceId != null) {
      data['service_id'] = serviceId;
    }

    data['title'] = title;
    data['description'] = description;
    data['price'] = price;
    data['duration'] = duration;
    data['max_qty'] = maxQty;
    data['tags'] = tags;
    data['members'] = members;
    data['categories'] = categories;
    data['cancelable_till'] = cancelableTill;
    data['is_cancelable'] = iscancelable;
    data['is_pay_later_allowed'] = is_pay_later_allowed;
    data['discounted_price'] = discounted_price;
    data['tax_type'] = tax_type;
    data['image'] = image;
    data['tax'] = tax;
    data['tax_id'] = taxId;
    return data;
  }
}
