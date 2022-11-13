class SubdistrictFields {
  // database table
  static const tableSubdistrict = 'subdistrict ';

  // database column
  static const id = 'id';
  static const name = 'name';
  static const id_dropdown = 'id_dropdown';
  static const kode_municipality = 'kode_municipality';
  static const kode_subdistrict = 'kode_subdistrict';

}

class SubdistrictDatabaseModel {
  int? id;
  int? id_dropdown;
  String? name;
  String? kode_municipality;
  String? kode_subdistrict;


  SubdistrictDatabaseModel(
      {this.id, this.name, this.id_dropdown ,this.kode_municipality, this.kode_subdistrict});

  factory SubdistrictDatabaseModel.fromJson(Map<String, dynamic> json) {
    return SubdistrictDatabaseModel(
      id: json['id'],
      name: json['name'],
      id_dropdown: json['id_dropdown'],
      kode_municipality: json['kode_municipality'],
      kode_subdistrict: json['kode_subdistrict'],
    );
  }

  Map<String, dynamic> toJson() => {
    SubdistrictFields.id: id,
    SubdistrictFields.name: name,
    SubdistrictFields.id_dropdown: id_dropdown,
    SubdistrictFields.kode_municipality: kode_municipality,
    SubdistrictFields.kode_subdistrict: kode_subdistrict,
  };
}
