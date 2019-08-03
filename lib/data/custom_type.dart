class CustomType {
  int id;
  String typeText;

  CustomType({
    this.id,
    this.typeText,
  });

  CustomType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    typeText = json['type_text'];
  }

  CustomType.fromSql(Map<String, dynamic> json) {
    id = json['id'];
    typeText = json['type_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type_text'] = this.typeText;
    return data;
  }
}
