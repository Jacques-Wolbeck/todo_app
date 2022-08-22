class TodoModel {
  int? uid;
  String? title;
  String? description;
  String? status;
  String? creationDate;

  TodoModel({
    this.uid,
    this.title,
    this.description,
    this.status,
    this.creationDate,
  });

  factory TodoModel.fromJson(Map<String, dynamic> todo) {
    return TodoModel(
      uid: todo['uid'],
      title: todo['title'],
      description: todo['description'],
      status: todo['status'],
      creationDate: todo['creationDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'title': title,
      'description': description,
      'status': status,
      'creationDate': creationDate
    };
  }
}
