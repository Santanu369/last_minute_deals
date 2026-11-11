// import 'package:flutter_test/flutter_test.dart';

// void main() {
//   group('HomeDataModel Tests', () {
//     test('should parse home data from JSON correctly', () {
//       // Sample JSON data based on the API response structure
//       final jsonData = {
//         "success": true,
//         "message": "Home page data fetched successfully",
//         "data": {
//           "categories": {
//             "title": "Categories",
//             "description": "Browse products by category",
//             "data": [
//               {
//                 "_id": "685a5c265cbb8fb42f6ead2e",
//                 "name": "Apparel",
//                 "slug": "apparel",
//                 "imageUrl": "https://example.com/apparel.png"
//               }
//             ],
//             "count": 1
//           },
//           "subcategories": {
//             "title": "Subcategories",
//             "description": "Browse products by subcategory",
//             "data": [
//               {
//                 "_id": "6862ce2f5ac7f8bf8d45835d",
//                 "category_id": {
//                   "_id": "685a5c3e5cbb8fb42f6ead30",
//                   "name": "Electronics",
//                   "slug": "electronics"
//                 },
//                 "name": "Accessories",
//                 "slug": "accessories",
//                 "imageUrl": "https://example.com/accessories.png"
//               }
//             ],
//             "groupedByCategory": {
//               "Electronics": [
//                 {
//                   "_id": "6862ce2f5ac7f8bf8d45835d",
//                   "category_id": {
//                     "_id": "685a5c3e5cbb8fb42f6ead30",
//                     "name": "Electronics",
//                     "slug": "electronics"
//                   },
//                   "name": "Accessories",
//                   "slug": "accessories",
//                   "imageUrl": "https://example.com/accessories.png"
//                 }
//               ]
//             },
//             "count": 1
//           },
//           "featuredProducts": {
//             "title": "Featured Products",
//             "description": "Handpicked products for you",
//             "data": [
//               {
//                 "_id": "6865816ec4a4357782a0d0a5",
//                 "name": "Test Product",
//                 "description": "Test description",
//                 "category": {
//                   "_id": "685a5a695cbb8fb42f6ead21",
//                   "name": "Kitchenware & Appliances",
//                   "slug": "kitchenware-and-appliances"
//                 },
//                 "subcategory": {
//                   "_id": "6862d2fc5ac7f8bf8d458463",
//                   "name": "Small Appliances",
//                   "slug": "small-appliances"
//                 },
//                 "vendor_store_id": {
//                   "_id": "685802e482f6237cdd3f9c86",
//                   "store_name": "TechStore Pro",
//                   "store_url": "https://techstore.com",
//                   "fullAddress": "Test Address",
//                   "logoUrl": null,
//                   "bannerUrl": null,
//                   "carouselUrls": [],
//                   "galleryUrls": []
//                 },
//                 "rating": {"average": 4.5, "count": 100},
//                 "images": [
//                   {"url": "https://example.com/product.jpg", "is_primary": true}
//                 ],
//                 "variants": [
//                   {
//                     "_id": "test-variant-id",
//                     "product_id": "6865816ec4a4357782a0d0a5",
//                     "sku": "TEST-SKU",
//                     "variant_name": "Test Variant",
//                     "price": {
//                       "base_price": 1000,
//                       "sale_price": 800,
//                       "discount_percentage": 20
//                     },
//                     "stock": {
//                       "quantity": 50,
//                       "low_stock_threshold": 5,
//                       "reserved_quantity": 2
//                     },
//                     "status": "active",
//                     "barcode": "123456789",
//                     "createdAt": "2025-01-01T00:00:00.000Z",
//                     "updatedAt": "2025-01-01T00:00:00.000Z",
//                     "is_low_stock": false,
//                     "available_quantity": 48,
//                     "current_price": 800
//                   }
//                 ]
//               }
//             ],
//             "count": 1
//           },
//           "bestSellers": {
//             "title": "Best Sellers",
//             "description": "Most popular products",
//             "data": [],
//             "count": 0
//           },
//           "newArrivals": {
//             "title": "New Arrivals",
//             "description": "Latest products added",
//             "data": [],
//             "count": 0
//           },
//           "vendors": {
//             "title": "Top Vendors",
//             "description": "Verified and trusted vendors",
//             "data": [
//               {
//                 "_id": "685af11b07b957843402dfb6",
//                 "store_name": "Minute Store",
//                 "store_url": "https://minutestore.com",
//                 "city": "Mumbai",
//                 "store_description": "Premium electronics store",
//                 "address": "123 Tech Street",
//                 "pincode": "400058",
//                 "business_hours": "9:00 AM - 8:00 PM",
//                 "rating": 4.5,
//                 "fullAddress": "123 Tech Street, Mumbai - 400058",
//                 "logoUrl": "https://example.com/logo.png",
//                 "bannerUrl": "https://example.com/banner.png",
//                 "carouselUrls": [],
//                 "galleryUrls": []
//               }
//             ],
//             "count": 1
//           }
//         },
//         "meta": {
//           "totalCategories": 1,
//           "totalSubcategories": 1,
//           "totalFeaturedProducts": 1,
//           "totalBestSellers": 0,
//           "totalNewArrivals": 0,
//           "totalVendors": 1
//         }
//       };

//       // Parse the JSON
//       final homeData = HomeDataModel.fromJson(jsonData);

//       // Verify the structure
//       expect(homeData.success, true);
//       expect(homeData.message, "Home page data fetched successfully");

//       // Verify categories
//       expect(homeData.data.categories.title, "Categories");
//       expect(homeData.data.categories.data.length, 1);
//       expect(homeData.data.categories.data.first.name, "Apparel");

//       // Verify subcategories
//       expect(homeData.data.subcategories.title, "Subcategories");
//       expect(homeData.data.subcategories.data.length, 1);
//       expect(homeData.data.subcategories.data.first.name, "Accessories");

//       // Verify featured products
//       expect(homeData.data.featuredProducts.title, "Featured Products");
//       expect(homeData.data.featuredProducts.data.length, 1);
//       expect(homeData.data.featuredProducts.data.first.name, "Test Product");

//       // Verify vendors
//       expect(homeData.data.vendors.title, "Top Vendors");
//       expect(homeData.data.vendors.data.length, 1);
//       expect(homeData.data.vendors.data.first.storeName, "Minute Store");

//       // Verify meta
//       expect(homeData.meta.totalCategories, 1);
//       expect(homeData.meta.totalVendors, 1);
//     });

//     test('should handle empty data gracefully', () {
//       final jsonData = {
//         "success": true,
//         "message": "Home page data fetched successfully",
//         "data": {
//           "categories": {
//             "title": "Categories",
//             "description": "Browse products by category",
//             "data": [],
//             "count": 0
//           },
//           "subcategories": {
//             "title": "Subcategories",
//             "description": "Browse products by subcategory",
//             "data": [],
//             "groupedByCategory": {},
//             "count": 0
//           },
//           "featuredProducts": {
//             "title": "Featured Products",
//             "description": "Handpicked products for you",
//             "data": [],
//             "count": 0
//           },
//           "bestSellers": {
//             "title": "Best Sellers",
//             "description": "Most popular products",
//             "data": [],
//             "count": 0
//           },
//           "newArrivals": {
//             "title": "New Arrivals",
//             "description": "Latest products added",
//             "data": [],
//             "count": 0
//           },
//           "vendors": {
//             "title": "Top Vendors",
//             "description": "Verified and trusted vendors",
//             "data": [],
//             "count": 0
//           }
//         },
//         "meta": {
//           "totalCategories": 0,
//           "totalSubcategories": 0,
//           "totalFeaturedProducts": 0,
//           "totalBestSellers": 0,
//           "totalNewArrivals": 0,
//           "totalVendors": 0
//         }
//       };

//       final homeData = HomeDataModel.fromJson(jsonData);

//       expect(homeData.data.categories.data.isEmpty, true);
//       expect(homeData.data.subcategories.data.isEmpty, true);
//       expect(homeData.data.featuredProducts.data.isEmpty, true);
//       expect(homeData.data.bestSellers.data.isEmpty, true);
//       expect(homeData.data.newArrivals.data.isEmpty, true);
//       expect(homeData.data.vendors.data.isEmpty, true);
//     });
//   });
// }
