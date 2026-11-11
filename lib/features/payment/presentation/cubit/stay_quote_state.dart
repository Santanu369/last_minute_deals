import 'package:lmd_app/features/payment/data/models/stay_quote_response.dart';

abstract class StayQuoteState {}

class StayQuoteInitial extends StayQuoteState {}

class StayQuoteLoading extends StayQuoteState {}

class StayQuoteLoaded extends StayQuoteState {
  final StayQuoteResponse quote;

  StayQuoteLoaded(this.quote);
}

class StayQuoteError extends StayQuoteState {
  final String message;
  final int? statusCode;

  StayQuoteError(this.message, {this.statusCode});
}
