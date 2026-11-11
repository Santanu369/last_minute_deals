// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:lmd_app/bloc/buffet/buffet_state.dart';
// import 'package:lmd_app/models/listing_model.dart';
// import 'package:lmd_app/services/listing_service.dart';

// class BuffetCubit extends Cubit<BuffetState> {
//   final ListingService _listingService;

//   BuffetCubit(this._listingService) : super(BuffetState());

//   Future<void> loadBuffets() async {
//     try {
//       emit(state.copyWith(isLoading: true, error: null));

//       final response = await _listingService.getBuffetListings(page: 1);

//       emit(
//         state.copyWith(
//           isLoading: false,
//           allBuffets: response.hotels,
//           visibleBuffets: response.hotels,
//           page: 1,
//           // hasMore: response.hasMore,
//         ),
//       );
//     } catch (e) {
//       emit(state.copyWith(isLoading: false, error: e.toString()));
//     }
//   }

//   Future<void> loadMore() async {
//     if (state.isLoadingMore) return;

//     if (!state.hasMore) return;

//     try {
//       emit(state.copyWith(isLoadingMore: true));

//       final nextPage = state.page + 1;

//       final response = await _listingService.getBuffetListings(page: nextPage);

//       final updatedBuffets = [...state.allBuffets, ...response.hotels];

//       emit(
//         state.copyWith(
//           allBuffets: updatedBuffets,
//           visibleBuffets: _applyFilters(
//             updatedBuffets,
//             state.selectedCategory,
//             state.searchQuery,
//           ),
//           page: nextPage,
//           // hasMore: response.hasMore,
//           isLoadingMore: false,
//         ),
//       );
//     } catch (e) {
//       emit(state.copyWith(isLoadingMore: false, error: e.toString()));
//     }
//   }

//   void search(String query) {
//     emit(
//       state.copyWith(
//         searchQuery: query,
//         visibleBuffets: _applyFilters(
//           state.allBuffets,
//           state.selectedCategory,
//           query,
//         ),
//       ),
//     );
//   }

//   Future<void> changeCategory(String category) async {
//     emit(
//       state.copyWith(
//         selectedCategory: category,
//         visibleBuffets: _applyFilters(
//           state.allBuffets,
//           category,
//           state.searchQuery,
//         ),
//       ),
//     );
//   }

//   List<ListingModel> _applyFilters(
//     List<ListingModel> buffets,
//     String category,
//     String query,
//   ) {
//     var filtered = buffets;

//     // Category filter
//     if (category.toLowerCase() != 'all') {
//       filtered = filtered.where((listing) {
//         final cat = listing.category.toLowerCase().trim();

//         switch (category.toLowerCase()) {
//           case 'lunch':
//             return cat == 'lunch';

//           case 'dinner':
//             return cat == 'dinner';

//           case 'buffet':
//             return cat == 'buffet';

//           case 'group friendly':
//             return cat == 'group friendly';

//           default:
//             return true;
//         }
//       }).toList();
//     }

//     // Search filter
//     if (query.trim().isNotEmpty) {
//       final search = query.toLowerCase().trim();

//       filtered = filtered.where((listing) {
//         return listing.name.toLowerCase().contains(search) ||
//             listing.city.toLowerCase().contains(search) 
//             // ||
//             // listing.vendorName.toLowerCase().contains(search)
//             ;
//       }).toList();
//     }

//     return filtered;
//   }
// }
