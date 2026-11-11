// import 'dart:convert';

// import '../models/deal_model.dart';

// import 'api_service.dart';

// class DealService {
//   final ApiService _apiService = ApiService();

//   Future<List<DealModel>> getDeals({required String listingId}) async {
//     final response = await _apiService.get(
//       endpoint:
//           '/v1/public/deals'
//           '?listing_id=$listingId',
//     );

//     final data = jsonDecode(response.body) as List<dynamic>;

//     return data.map((e) => DealModel.fromJson(e)).toList();
//   }
// }
