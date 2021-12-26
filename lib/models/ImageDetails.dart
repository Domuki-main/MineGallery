class ImageDetails {
  final String id;
  final String imagePath;
  final String location;
  final String time;
  final String title;
  final String details;
  // final bool selected;
  ImageDetails({
    required this.id,
    required this.imagePath,
    required this.location,
    required this.time,
    required this.title,
    required this.details,
  });

  String getId() {
    return this.id;
  }
}
