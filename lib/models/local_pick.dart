/// Represents a locally picked file awaiting upload processing.
class LocalPick {
  LocalPick(this.name, this.size, this.extension, {this.status = 'Processing'});
  final String name;
  final int size;
  final String extension;
  String status;
}
