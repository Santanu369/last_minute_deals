// lib/utils/api_constants.dart

class ApiConstants {
  static const String baseUrl1 = 'https://api.lastminutessdeal.com/lmd/api';
  static const String baseUrl = 'https://sbd.lastminutessdeal.com';
  static const String version = 'v1';

  // Buffets
  static const String getBuffets = '/$version/retail/products';
  static const String createVariant = '/$version/retail/product-variants';
  static const String buffetLiveActivity = '/$version/retail/deals/active';

  static const auth = '/$version/auth/customer';
  static const ratehawk = '/$version/hotels/ratehawk';

  static const listings = '/$ratehawk/listings';
  static const searchListings = '$ratehawk/search';
  static const searchListingss = '/$version/hotels/ratehawk/search';

  // ratehawk hotel listing..
  static const String hotelListings = '/$version/hotels/ratehawk/listing';
  static const hotelPage = '/$version/hotels/ratehawk/hotelpage';
  static const prebook = '/$version/hotels/ratehawk/prebook';
  static const Rsearch = '/$version/hotels/ratehawk/search';
  static String hotelStatic(String source, String id) =>
      '/$version/hotels/static/$source/$id';
  static const fcmToken = '/$version/fcm/token'; // POST register / DELETE remove (auth)
  static const hotelFilters = '/$version/hotels/ratehawk/filters';

  // Notification inbox
  static const notifications = '/$version/retail/notifications';
  static const personalNotifications = '$notifications/personal'; // auth
  static const publicNotifications = '$notifications/public'; // guests
  static const markAllNotificationsRead = '$notifications/customer/mark-all-read';
  static String markNotificationRead(String id) =>
      '$notifications/customer/$id/read';

  // retail partner api list
  static const comprehensiveHome = '/$version/retail/home/comprehensive';
  static const retailProducts = '/$version/retail/products';
  static const retailProductVariants = '/$version/retail/product-variants';
  static String retailProduct(String productId) =>
      '/$version/retail/products/$productId';

  // Cart
  static const retailCart = '/$version/retail/cart';
  static const cartItems = '$retailCart/me/items';

  // Orders
  static const retailOrders = '/$version/retail/orders';
  static const priceEnquiry = '$retailOrders/price-enquiry';
  static const myRetailOrders = '$retailOrders/me';
  static const createOrderFromCart = '$retailOrders/create-from-cart';

  // new apis from api.lastminutessdeal.com
  static const login = '$auth/login';
  static const signup = '$auth/signup';
  static const profile = '$auth/profile';
  static const forgotPassword = '$auth/forgot-password';
  static const verifyOtp = '$auth/verify-otp';
  static const resendOtp = '$auth/resend-otp';
  static const resetPassword = '$auth/reset-password';
  static const changePassword = '$auth/change-password';
  static const logout = '$auth/logout';

  static const refresh = '$auth/refresh';
  static const me = '$auth/me';
  static const google = '$auth/google';
  static const googleCallback = '/v1/auth/google/callback';

  // bookings
  static const bookings = '/$version/bookings';

  static const finalListing = '/$version/hotels/ratehawk/finallisting';
  static const bookingHistory = '/$version/hotels/ratehawk/booking-history';
  static const cancelBooking = '/$version/hotels/ratehawk/cancel';

  // Cancel booking
  static const cancelBookingEndpoint =
      '/$version/hotels/ratehawk/booking-history';

  // public bookings
  static const publicBooking = '/$version/public/deals';

  // Public Checkout
  static const publicCheckout = '/$version/public/checkout';
  static const publicStayCheckout = '$publicCheckout/stay';
  static const publicBuffetCheckout = '$publicCheckout/buffet';

  // Vendor Bookings
  static const vendors = '/$version/vendors';
  static String vendorBookings(String vendorId) =>
      '$vendors/$vendorId/bookings';
  static String vendorBookingStats(String vendorId) =>
      '$vendors/$vendorId/bookings/stats';
  static String vendorBooking(String vendorId, String bookingId) =>
      '$vendors/$vendorId/bookings/$bookingId';
  static const cashfreeCreateOrder = '/$version/payments/cashfree/order';
  static const cashfreePaymentSession = '/$version/payments/cashfree/session';
  static String cashfreeSyncPayment(String bookingId) =>
      '$bookings/$bookingId/payments/cashfree/sync';

  //  WISHLIST ENDPOINTS

  static const String wishlist = '/$version/retail/wishlist';

  // Check if a hotel is in wishlist
  static String checkWishlist(String id, String hotelSource) =>
      '$wishlist/check/$id?hotel_source=$hotelSource';

  // Toggle add/remove (smart endpoint)
  static String toggleWishlist(String id) => '$wishlist/toggle/$id';

  // Get all wishlist items (you may need to adjust the endpoint)
  // Documentation didn't specify, but common endpoints are:
  static const String myWishlistItems = '$wishlist/me/items';
  // or simply:
  // static const String myWishlistItems = wishlist;
}
