class Validator {
  static validateNumber(String number) {
    if (number.isEmpty) {
      return "Field must not be empty";
    } else if (number.length < 6 || number.length > 15) {
      return "Mobile number should be between 6 and 15 numbers";
    }

    return null;
  }

  static nullCheck(String? value, {int? requiredLength}) {
    if (value!.isEmpty) {
      return "Field must not be empty";
    } else if (requiredLength != null) {
      if (value.length < requiredLength) {
        return "Text must be $requiredLength character long";
      } else {
        return null;
      }
    }

    return null;
  }

  static validateEmail(String? email) {
    if (email!.isEmpty) {
      return "Field must not be empty";
    } else if (!_isValidateEmail(email)) {
      return "Please enter valid email";
    }
    return null;
  }

  /// Replace extra coma from String
  ///
  static filterAddressString(String text) {
    String middleDuplicateComaRegex = r',(.?),';
    String leadingAndTrailingComa = r'(^,)|(,$)';
    RegExp removeComaFromString = RegExp(
      middleDuplicateComaRegex,
      caseSensitive: false,
      multiLine: true,
    );

    RegExp leadingAndTrailing = RegExp(
      leadingAndTrailingComa,
      multiLine: true,
      caseSensitive: false,
    );
    text = text.trim();
    String filterdText = text.replaceAll(removeComaFromString, ",").replaceAll(leadingAndTrailing, "");

    return filterdText;
  }

  static _isValidateEmail(String email) {
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);

    return emailValid;
  }
}
