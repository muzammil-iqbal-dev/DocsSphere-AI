/// A reported system issue/error visible in the Admin panel.
class DemoIssue {
  DemoIssue(
    this.title,
    this.type,
    this.service,
    this.status,
    this.time,
    this.detail, {
    this.note = '',
  });
  final String title;
  final String type;
  final String service;
  String status;
  final String time;
  final String detail;
  String note;
}
