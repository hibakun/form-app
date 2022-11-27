class VillageFields {
  // database table
  static const tableVillage = 'village';

  // database column
  static const id = 'id';
  static const name = 'name';
  static const id_dropdown = 'id_dropdown';
  static const kode_subdistrict = 'kode_subdistrict';
  static const kode_village = 'kode_village';

}

class VillageDatabaseModel {
  int? id;
  int? id_dropdown;
  String? name;
  String? kode_subdistrict;
  String? kode_village;


  VillageDatabaseModel(
      {this.id, this.name, this.kode_subdistrict, this.id_dropdown, this.kode_village});

  factory VillageDatabaseModel.fromJson(Map<String, dynamic> json) {
    return VillageDatabaseModel(
      id: json['id'],
      name: json['name'],
      id_dropdown: json['id_dropdown'],
      kode_subdistrict: json['kode_subdistrict'],
      kode_village: json['kode_village'],
    );
  }

  Map<String, dynamic> toJson() => {
    VillageFields.id: id,
    VillageFields.name: name,
    VillageFields.id_dropdown: id_dropdown,
    VillageFields.kode_subdistrict: kode_subdistrict,
    VillageFields.kode_village: kode_village,
  };
}
