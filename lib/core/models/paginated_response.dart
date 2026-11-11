class PaginatedResponse<T> {
  final int page;
  final int count;
  // final int pageSize;
  // final bool hasMore;
  final List<T> hotels;

  const PaginatedResponse({
    required this.page,
    required this.count,
    // required this.pageSize,
    // required this.hasMore,
    required this.hotels,
  });
}
