class MunicipalityFields {
  // database table
  static const tableMunicipality = 'municipality ';

  // database column
  static const id = 'id';
  static const id_dropdown = 'id_dropdown';
  static const name = 'name';
  static const kode_municipality = 'kode_municipality';

}

class MunicipalityDatabaseModel {
  int? id;
  String? name;
  int? id_dropdown;
  String? kode_municipality;


  MunicipalityDatabaseModel(
      {this.id, this.name, this.id_dropdown, this.kode_municipality});

  factory MunicipalityDatabaseModel.fromJson(Map<String, dynamic> json) {
    return MunicipalityDatabaseModel(
      id: json['id'],
      name: json['name'],
      id_dropdown: json['id_dropdown'],
      kode_municipality: json['kode_municipality'],
    );
  }

  Map<String, dynamic> toJson() => {
    MunicipalityFields.id: id,
    MunicipalityFields.name: name,
    MunicipalityFields.id_dropdown: id_dropdown,
    MunicipalityFields.kode_municipality: kode_municipality,
  };
}
