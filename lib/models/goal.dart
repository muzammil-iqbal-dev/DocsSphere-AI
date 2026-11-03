import 'doc.dart';

/// Goal model representing a user-defined document readiness checklist.
class Goal {
  Goal(this.title, this.items, {this.description = ''});
  String title;
  String description;
  List<GoalItem> items;
}

/// A single checklist item inside a Goal, optionally linked to a Doc.
class GoalItem {
  GoalItem(this.name, {this.doc});
  String name;
  Doc? doc;
}
