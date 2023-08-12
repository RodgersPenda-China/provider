// ignore_for_file: public_member_api_docs, sort_constructors_first
class ServiceModel {
  String? id;
  String? userId;
  String? categoryId;
  String? parentId;
  String? categoryName;
  String? partnerName;
  String? tax;
  String? taxType;
  String? title;
  String? slug;
  String? description;
  String? tags;
  String? imageOfTheService;
  String? price;
  String? discountedPrice;
  String? numberOfMembersRequired;
  String? duration;
  String? rating;
  String? numberOfRatings;
  String? onSiteAllowed;
  String? maxQuantityAllowed;
  String? isPayLaterAllowed;
  String? status;
  String? createdAt;
  String? cancelableTill;
  String? cancelable;
  String? isCancelable;
  String? inCartQuantity;
  String? taxId;
  String? taxTitle;
  String? taxPercentage;

  ServiceModel(
      {this.id,
      this.userId,
      this.categoryId,
      this.parentId,
      this.categoryName,
      this.partnerName,
      this.tax,
      this.taxType,
      this.title,
      this.slug,
      this.description,
      this.tags,
      this.imageOfTheService,
      this.price,
      this.discountedPrice,
      this.numberOfMembersRequired,
      this.duration,
      this.rating,
      this.numberOfRatings,
      this.onSiteAllowed,
      this.maxQuantityAllowed,
      this.isPayLaterAllowed,
      this.status,
      this.createdAt,
      this.cancelableTill,
      this.cancelable,
      this.isCancelable,
      this.taxId,
      this.taxPercentage,
      this.taxTitle,
      this.inCartQuantity});

  ServiceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "0";
    userId = json['user_id'].toString();
    categoryId = json['category_id'].toString();
    parentId = json['parent_id'].toString();
    categoryName = json['category_name'].toString();
    partnerName = json['partner_name'].toString();
    tax = json['tax'].toString();
    taxType = json['tax_type'].toString();
    title = json['title'].toString();
    slug = json['slug'].toString();
    description = json['description'].toString();
    tags = json['tags'].toString();
    imageOfTheService = json['image_of_the_service'].toString();
    price = json['price'].toString();
    discountedPrice = json['discounted_price'].toString();
    numberOfMembersRequired = json['number_of_members_required'].toString();
    duration = json['duration'].toString();
    rating = json['rating'].toString();
    numberOfRatings = json['number_of_ratings'].toString();
    onSiteAllowed = json['on_site_allowed'].toString();
    maxQuantityAllowed = json['max_quantity_allowed'].toString();
    isPayLaterAllowed = json['is_pay_later_allowed'].toString();
    status = json['status'].toString();
    createdAt = json['created_at'].toString();
    cancelableTill = json['cancelable_till'].toString();
    cancelable = json['cancelable'].toString();
    isCancelable = json['is_cancelable'].toString();
    inCartQuantity = json['in_cart_quantity'].toString();
    taxId = json['tax_id'].toString();
    taxTitle = json['tax_title'].toString();
    taxPercentage = json['tax_percentage'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['category_id'] = categoryId;
    data['parent_id'] = parentId;
    data['category_name'] = categoryName;
    data['partner_name'] = partnerName;
    data['tax'] = tax;
    data['tax_type'] = taxType;
    data['title'] = title;
    data['slug'] = slug;
    data['description'] = description;
    data['tags'] = tags;
    data['image_of_the_service'] = imageOfTheService;
    data['price'] = price;
    data['discounted_price'] = discountedPrice;
    data['number_of_members_required'] = numberOfMembersRequired;
    data['duration'] = duration;
    data['rating'] = rating;
    data['number_of_ratings'] = numberOfRatings;
    data['on_site_allowed'] = onSiteAllowed;
    data['max_quantity_allowed'] = maxQuantityAllowed;
    data['is_pay_later_allowed'] = isPayLaterAllowed;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['cancelable_till'] = cancelableTill;
    data['cancelable'] = cancelable;
    data['is_cancelable'] = isCancelable;
    data['in_cart_quantity'] = inCartQuantity;
    return data;
  }

  @override
  String toString() {
    return 'ServiceModel(id: $id, userId: $userId, categoryId: $categoryId, parentId: $parentId, categoryName: $categoryName, partnerName: $partnerName, tax: $tax, taxType: $taxType, title: $title, slug: $slug, description: $description, tags: $tags, imageOfTheService: $imageOfTheService, price: $price, discountedPrice: $discountedPrice, numberOfMembersRequired: $numberOfMembersRequired, duration: $duration, rating: $rating, numberOfRatings: $numberOfRatings, onSiteAllowed: $onSiteAllowed, maxQuantityAllowed: $maxQuantityAllowed, isPayLaterAllowed: $isPayLaterAllowed, status: $status, createdAt: $createdAt, cancelableTill: $cancelableTill, cancelable: $cancelable, isCancelable: $isCancelable, inCartQuantity: $inCartQuantity)';
  }
}
