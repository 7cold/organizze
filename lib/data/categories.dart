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
}
