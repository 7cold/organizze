class Categories {
  int id;
  String name;
  String color;
  dynamic parentId;

  Categories({this.id, this.name, this.color, this.parentId});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    color = json['color'];
    parentId = json['parent_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['color'] = this.color;
    data['parent_id'] = this.parentId;
    return data;
  }
}
