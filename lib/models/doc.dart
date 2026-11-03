/// Document model representing a single user document in DocSphereAI.
class Doc {
  Doc(
    this.name,
    this.category,
    this.type,
    this.status,
    this.added, {
    this.expiry,
    this.text = '',
    this.summary = '',
    this.author = '',
    this.favorite = false,
    this.pinned = false,
    this.hidden = false,
    this.deleted = false,
    this.id = '',
  });

  String name;
  String category;
  String type;
  String status;
  final DateTime added;
  DateTime? expiry;
  String text;
  String summary;
  String author;
  bool favorite;
  bool pinned;
  bool hidden;
  bool deleted;
  String id;
}
