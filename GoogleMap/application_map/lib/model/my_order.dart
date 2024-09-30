class MyOrder {
  String? _id;
  String? _name;
  String? _phone;
  String? _address;
  double? _latitude;
  double? _longitude;
  double? _amount;

  MyOrder(
      {String? id,
      String? name,
      String? phone,
      String? address,
      double? latitude,
      double? longitude,
      double? amount}) {
    if (id != null) {
      this._id = id;
    }
    if (name != null) {
      this._name = name;
    }
    if (phone != null) {
      this._phone = phone;
    }
    if (address != null) {
      this._address = address;
    }
    if (latitude != null) {
      this._latitude = latitude;
    }
    if (longitude != null) {
      this._longitude = longitude;
    }
    if (amount != null) {
      this._amount = amount;
    }
  }

  String? get id => _id;
  set id(String? id) => _id = id;
  String? get name => _name;
  set name(String? name) => _name = name;
  String? get phone => _phone;
  set phone(String? phone) => _phone = phone;
  String? get address => _address;
  set address(String? address) => _address = address;
  double? get latitude => _latitude;
  set latitude(double? latitude) => _latitude = latitude;
  double? get longitude => _longitude;
  set longitude(double? longitude) => _longitude = longitude;
  double? get amount => _amount;
  set amount(double? amount) => _amount = amount;

  MyOrder.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _phone = json['phone'];
    _address = json['address'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['phone'] = this._phone;
    data['address'] = this._address;
    data['latitude'] = this._latitude;
    data['longitude'] = this._longitude;
    data['amount'] = this._amount;
    return data;
  }
}
