/// Demo admin account model for the Admin management panel.
class DemoAccount {
  DemoAccount(this.name, this.email, this.status, this.created, this.last);
  final String name;
  final String email;
  String status;
  final DateTime created;
  final String last;
}
