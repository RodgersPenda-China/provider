class GeneralSettings {
  String? companyTitle;
  String? supportName;
  String? supportEmail;
  String? phone;
  String? systemTimezoneGmt;
  String? systemTimezone;
  String? primaryColor;
  String? secondaryColor;
  String? primaryShadow;
  String? maxServiceableDistance;
  String? customerCurrentVersionAndroidApp;
  String? customerCurrentVersionIosApp;
  String? customerCompulsaryUpdateForceUpdate;
  String? providerCurrentVersionAndroidApp;
  String? providerCurrentVersionIosApp;
  String? providerCompulsaryUpdateForceUpdate;
  String? customerAppMaintenanceStartDate;
  String? customerAppMaintenanceEndDate;
  String? messageForCustomerApplication;
  String? customerAppMaintenanceMode;
  String? providerAppMaintenanceStartDate;
  String? providerAppMaintenanceEndDate;
  String? messageForProviderApplication;
  String? providerAppMaintenanceMode;
  String? countryCurrencyCode;
  String? currency;
  String? decimalPoint;
  String? address;
  String? shortDescription;
  String? copyrightDetails;
  String? supportHours;
  String? favicon;
  String? logo;
  String? halfLogo;
  String? partnerFavicon;
  String? partnerLogo;
  String? partnerHalfLogo;

  GeneralSettings(
      {this.companyTitle,
      this.supportName,
      this.supportEmail,
      this.phone,
      this.systemTimezoneGmt,
      this.systemTimezone,
      this.primaryColor,
      this.secondaryColor,
      this.primaryShadow,
      this.maxServiceableDistance,
      this.customerCurrentVersionAndroidApp,
      this.customerCurrentVersionIosApp,
      this.customerCompulsaryUpdateForceUpdate,
      this.providerCurrentVersionAndroidApp,
      this.providerCurrentVersionIosApp,
      this.providerCompulsaryUpdateForceUpdate,
      this.customerAppMaintenanceStartDate,
      this.customerAppMaintenanceEndDate,
      this.messageForCustomerApplication,
      this.customerAppMaintenanceMode,
      this.providerAppMaintenanceStartDate,
      this.providerAppMaintenanceEndDate,
      this.messageForProviderApplication,
      this.providerAppMaintenanceMode,
      this.countryCurrencyCode,
      this.currency,
      this.decimalPoint,
      this.address,
      this.shortDescription,
      this.copyrightDetails,
      this.supportHours,
      this.favicon,
      this.logo,
      this.halfLogo,
      this.partnerFavicon,
      this.partnerLogo,
      this.partnerHalfLogo});

  GeneralSettings.fromJson(Map<String, dynamic> json) {
    companyTitle = json['company_title'];
    supportName = json['support_name'];
    supportEmail = json['support_email'];
    phone = json['phone'];
    systemTimezoneGmt = json['system_timezone_gmt'];
    systemTimezone = json['system_timezone'];
    primaryColor = json['primary_color'];
    secondaryColor = json['secondary_color'];
    primaryShadow = json['primary_shadow'];
    maxServiceableDistance = json['max_serviceable_distance'];
    customerCurrentVersionAndroidApp =
        json['customer_current_version_android_app'];
    customerCurrentVersionIosApp = json['customer_current_version_ios_app'];
    customerCompulsaryUpdateForceUpdate =
        json['customer_compulsary_update_force_update'];
    providerCurrentVersionAndroidApp =
        json['provider_current_version_android_app'];
    providerCurrentVersionIosApp = json['provider_current_version_ios_app'];
    providerCompulsaryUpdateForceUpdate =
        json['provider_compulsary_update_force_update'];
    customerAppMaintenanceStartDate =
        json['customer_app_maintenance_start_date'];
    customerAppMaintenanceEndDate = json['customer_app_maintenance_end_date'];
    messageForCustomerApplication = json['message_for_customer_application'];
    customerAppMaintenanceMode = json['customer_app_maintenance_mode'];
    providerAppMaintenanceStartDate =
        json['provider_app_maintenance_start_date'];
    providerAppMaintenanceEndDate = json['provider_app_maintenance_end_date'];
    messageForProviderApplication = json['message_for_provider_application'];
    providerAppMaintenanceMode = json['provider_app_maintenance_mode'];
    countryCurrencyCode = json['country_currency_code'];
    currency = json['currency'];
    decimalPoint = json['decimal_point'];
    address = json['address'];
    shortDescription = json['short_description'];
    copyrightDetails = json['copyright_details'];
    supportHours = json['support_hours'];
    favicon = json['favicon'];
    logo = json['logo'];
    halfLogo = json['half_logo'];
    partnerFavicon = json['partner_favicon'];
    partnerLogo = json['partner_logo'];
    partnerHalfLogo = json['partner_half_logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> SystemSettings = <String, dynamic>{};
    SystemSettings['company_title'] = companyTitle;
    SystemSettings['support_name'] = supportName;
    SystemSettings['support_email'] = supportEmail;
    SystemSettings['phone'] = phone;
    SystemSettings['system_timezone_gmt'] = systemTimezoneGmt;
    SystemSettings['system_timezone'] = systemTimezone;
    SystemSettings['primary_color'] = primaryColor;
    SystemSettings['secondary_color'] = secondaryColor;
    SystemSettings['primary_shadow'] = primaryShadow;
    SystemSettings['max_serviceable_distance'] = maxServiceableDistance;
    SystemSettings['customer_current_version_android_app'] =
        customerCurrentVersionAndroidApp;
    SystemSettings['customer_current_version_ios_app'] =
        customerCurrentVersionIosApp;
    SystemSettings['customer_compulsary_update_force_update'] =
        customerCompulsaryUpdateForceUpdate;
    SystemSettings['provider_current_version_android_app'] =
        providerCurrentVersionAndroidApp;
    SystemSettings['provider_current_version_ios_app'] =
        providerCurrentVersionIosApp;
    SystemSettings['provider_compulsary_update_force_update'] =
        providerCompulsaryUpdateForceUpdate;
    SystemSettings['customer_app_maintenance_start_date'] =
        customerAppMaintenanceStartDate;
    SystemSettings['customer_app_maintenance_end_date'] =
        customerAppMaintenanceEndDate;
    SystemSettings['message_for_customer_application'] =
        messageForCustomerApplication;
    SystemSettings['customer_app_maintenance_mode'] =
        customerAppMaintenanceMode;
    SystemSettings['provider_app_maintenance_start_date'] =
        providerAppMaintenanceStartDate;
    SystemSettings['provider_app_maintenance_end_date'] =
        providerAppMaintenanceEndDate;
    SystemSettings['message_for_provider_application'] =
        messageForProviderApplication;
    SystemSettings['provider_app_maintenance_mode'] =
        providerAppMaintenanceMode;
    SystemSettings['country_currency_code'] = countryCurrencyCode;
    SystemSettings['currency'] = currency;
    SystemSettings['decimal_point'] = decimalPoint;
    SystemSettings['address'] = address;
    SystemSettings['short_description'] = shortDescription;
    SystemSettings['copyright_details'] = copyrightDetails;
    SystemSettings['support_hours'] = supportHours;
    SystemSettings['favicon'] = favicon;
    SystemSettings['logo'] = logo;
    SystemSettings['half_logo'] = halfLogo;
    SystemSettings['partner_favicon'] = partnerFavicon;
    SystemSettings['partner_logo'] = partnerLogo;
    SystemSettings['partner_half_logo'] = partnerHalfLogo;
    return SystemSettings;
  }
}
