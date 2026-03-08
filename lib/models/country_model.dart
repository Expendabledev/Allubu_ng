class CountryModel {
  List<Currency>? countries;

  CountryModel({this.countries});

  CountryModel.fromJson(Map<String, dynamic> json) {
    if (json['countries'] != null) {
      countries = <Currency>[];
      json['countries'].forEach((v) {
        countries!.add(Currency.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (countries != null) {
      data['countries'] = countries!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Currency {
  String? name;
  String? dialCode;
  String? currency;
  String? symbol;

  Currency({this.name, this.dialCode, this.currency, this.symbol});

  Currency.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    dialCode = json['dial_code'];
    currency = json['currency'];
    symbol = json['symbol'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['dial_code'] = dialCode;
    data['currency'] = currency;
    data['symbol'] = symbol;
    return data;
  }
}
