class PostModel {
  String? id;
  String? title;
  String? subTitle;
  String? body;
  DateTime? dateCreated;

  PostModel({
    this.id,
    required this.title,
    required this.subTitle,
    required this.body,
    required this.dateCreated,
  });

  static PostModel fromMap(Map map) {
    return PostModel(
      id: map["id"],
      title: map["title"],
      subTitle: map["subTitle"],
      body: map["body"],
      dateCreated: map["dateCreated"] != null && map["dateCreated"] != ""
          ? DateTime.parse(map["dateCreated"])
          : null,
    );
  }
}
