// class DealModel {
//   final String id;

//   final String listingId;

//   final String title;

//   final double listPrice;

//   final double dealPrice;

//   final int discountBps;

//   final String currency;

//   final DateTime endsAt;

//   final DateTime statsAt;

//   final String status;

//   DealModel({
//     required this.id,
//     required this.listingId,
//     required this.title,
//     required this.listPrice,
//     required this.dealPrice,
//     required this.discountBps,
//     required this.currency,
//     required this.endsAt,
//     required this.statsAt,
//     required this.status,
//   });

//   factory DealModel.fromJson(Map<String, dynamic> json) {
//     return DealModel(
//       id: json['id'] ?? '',

//       listingId: json['listing_id'] ?? '',

//       title: json['title'] ?? '',

//       listPrice: (json['list_price'] ?? 0).toDouble(),

//       dealPrice: (json['deal_price'] ?? 0).toDouble(),

//       discountBps: json['discount_bps'] ?? 0,

//       currency: json['currency'] ?? '',

//       endsAt: DateTime.parse(json['ends_at']),

//       statsAt: DateTime.parse(json['starts_at']),

//       status: json['status'] ?? '',
//     );
//   }
// }
