class CustomType {
  int id;
  int inOutDoor;
  String typeText;

  CustomType({
    this.id,
    this.inOutDoor,
    this.typeText,
  });

  CustomType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    inOutDoor = json['in_out_door'];
    typeText = json['type_text'];
  }

  CustomType.fromSql(Map<String, dynamic> json) {
    id = json['id'];
    inOutDoor = json['in_out_door'];
    typeText = json['type_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['in_out_door'] = this.inOutDoor;
    data['type_text'] = this.typeText;
    return data;
  }
}
