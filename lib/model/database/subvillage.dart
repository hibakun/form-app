class SubvillageFields {
  // database table
  static const tableSubvillage = 'subvillage';

  // database column
  static const id = 'id';
  static const name = 'name';
  static const id_dropdown = 'id_dropdown';
  static const kode_subvillage = 'kode_subvillage';
  static const kode_village = 'kode_village';

}

class SubVillageDatabaseModel {
  int? id;
  int? id_dropdown;
  String? name;
  String? kode_subvillage;
  String? kode_village;


  SubVillageDatabaseModel(
      {this.id, this.name, this.id_dropdown, this.kode_subvillage, this.kode_village});

  factory SubVillageDatabaseModel.fromJson(Map<String, dynamic> json) {
    return SubVillageDatabaseModel(
      id: json['id'],
      name: json['name'],
      id_dropdown: json['id_dropdown'],
      kode_subvillage: json['kode_subvillage'],
      kode_village: json['kode_village'],
    );
  }

  Map<String, dynamic> toJson() => {
    SubvillageFields.id: id,
    SubvillageFields.name: name,
    SubvillageFields.id_dropdown: id_dropdown,
    SubvillageFields.kode_subvillage: kode_subvillage,
    SubvillageFields.kode_village: kode_village,
  };
}
