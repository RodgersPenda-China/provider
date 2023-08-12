import 'package:country_calling_code_picker/picker.dart';
import 'package:edemand_partner/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CountryCodeState {}

class CountryCodeInitial extends CountryCodeState {}

class CountryCodeLoadingInProgress extends CountryCodeState {}

class CountryCodeFetchSuccess extends CountryCodeState {
  final Country? selectedCountry;
  final List<Country>? countryList;
  final List<Country>? temporaryCountryList;

  CountryCodeFetchSuccess({
    this.selectedCountry,
    this.countryList,
    this.temporaryCountryList,
  });
}

class CountryCodeFetchFail extends CountryCodeState {
  final dynamic error;

  CountryCodeFetchFail(this.error);
}

class CountryCodeCubit extends Cubit<CountryCodeState> {
  CountryCodeCubit() : super(CountryCodeInitial());

  loadAllCountryCode(BuildContext context) async {
    try {
      emit(CountryCodeLoadingInProgress());
      //Country country = await getDefaultCountry(context);
      Country country =
          await getCountryByCountryCode(context, Constant.defaultCountryCode ?? "IN") ??
              await getDefaultCountry(context);
      // ignore: use_build_context_synchronously
      List<Country> countriesList = await getCountries(context);
      emit(CountryCodeFetchSuccess(
          selectedCountry: country,
          countryList: countriesList,
          temporaryCountryList: countriesList));
    } catch (e) {
      emit(CountryCodeFetchFail(e));
    }
  }

  selectCountryCode(Country country) {
    if (state is CountryCodeFetchSuccess) {
      emit(CountryCodeFetchSuccess(
          selectedCountry: country,
          countryList: (state as CountryCodeFetchSuccess).countryList,
          temporaryCountryList: (state as CountryCodeFetchSuccess).temporaryCountryList));
    }
  }

  filterCountryCodeList(String content) {
    if (state is CountryCodeFetchSuccess) {
      List<Country>? mainList = (state as CountryCodeFetchSuccess).countryList;
      List<Country>? tempList = [];

      Country? seleceted = (state as CountryCodeFetchSuccess).selectedCountry;

      for (var i = 0; i < mainList!.length; i++) {
        Country country = mainList[i];

        if (country.name.toLowerCase().contains(content.toLowerCase()) ||
            country.callingCode.toLowerCase().contains(content.toLowerCase())) {
          if (!tempList.contains(country)) {
            tempList.add(country);
          }
        }
      }

      emit(CountryCodeFetchSuccess(
          temporaryCountryList: tempList, countryList: mainList, selectedCountry: seleceted));
    }
  }

  clearTemporaryList() {
    if (state is CountryCodeFetchSuccess) {
      List<Country>? mainList = (state as CountryCodeFetchSuccess).countryList;
      Country? seleceted = (state as CountryCodeFetchSuccess).selectedCountry;
      emit(CountryCodeFetchSuccess(
          temporaryCountryList: [], countryList: mainList, selectedCountry: seleceted));
    }
  }

  fillTemporaryList() {
    if (state is CountryCodeFetchSuccess) {
      List<Country>? mainList = (state as CountryCodeFetchSuccess).countryList;
      Country? seleceted = (state as CountryCodeFetchSuccess).selectedCountry;
      emit(CountryCodeFetchSuccess(
          temporaryCountryList: mainList, countryList: mainList, selectedCountry: seleceted));
    }
  }

  String getSelectedCountryCode() {
    return (state as CountryCodeFetchSuccess).selectedCountry!.callingCode;
  }
}
