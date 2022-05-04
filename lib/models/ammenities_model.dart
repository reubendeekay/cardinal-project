class AmmenitiesModel {
  final String? beds;
  final String? bathrooms;
  final String? floors;
  final String? area;
  List<String>? others = [];

  AmmenitiesModel(this.beds, this.bathrooms, this.floors, this.area,
      {this.others});

  Map<String, dynamic> toJson() {
    return {
      'beds': beds,
      'bathrooms': bathrooms,
      'floors': floors,
      'area': area,
      'others': others,
    };
  }

  factory AmmenitiesModel.fromJson(dynamic json) {
    return AmmenitiesModel(
      json['beds'],
      json['bathrooms'],
      json['floors'],
      json['area'],
      others: json['others'],
    );
  }
}
