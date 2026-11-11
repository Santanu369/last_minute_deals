import 'package:lmd_app/features/hotel/data/models/hotel_details/hotel_model.dart';
import 'package:lmd_app/features/hotel/data/models/hotel_details/room_model.dart';
import 'package:lmd_app/features/hotel/data/models/hotel_details/search_guest_model.dart';

class HotelDetailsModel {
  final HotelModel hotel;
  final List<SearchGuestModel> searchGuests;
  final List<RoomModel> rooms;

  const HotelDetailsModel({
    required this.hotel,
    required this.searchGuests,
    required this.rooms,
  });

  factory HotelDetailsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;

    return HotelDetailsModel(
      hotel: HotelModel.fromJson(data['hotel']),
      searchGuests: (data['searchGuests'] as List<dynamic>? ?? [])
          .map((e) => SearchGuestModel.fromJson(e))
          .toList(),
      rooms: (data['rooms'] as List<dynamic>? ?? [])
          .map((e) => RoomModel.fromJson(e))
          .toList(),
    );
  }
}
