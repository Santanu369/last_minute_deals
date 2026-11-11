class ListingImageModel {
  final String url;
  final int position;

  const ListingImageModel({required this.url, required this.position});

  factory ListingImageModel.fromJson(Map<String, dynamic> json) {
    return ListingImageModel(
      url: json['url'] ?? '',
      position: json['position'] ?? 0,
    );
  }
}
// I am currently using it for both menu images and room images in details page. Since both are similar.