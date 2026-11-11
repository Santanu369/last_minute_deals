import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lmd_app/core/theme/design_tokens.dart';
import 'package:lmd_app/features/booking/presentation/pages/booking_success_screen.dart';
import 'package:lmd_app/features/payment/data/services/payment_service_impl.dart';

class PaymentCheckoutPage extends StatefulWidget {
  final double totalAmount;
  final String stayName;
  final String guestEmail;
  final String guestPhone;
  final String? bookingId; // Real booking ID from backend

  const PaymentCheckoutPage({
    super.key,
    required this.totalAmount,
    required this.stayName,
    required this.guestEmail,
    required this.guestPhone,
    this.bookingId,
  });

  @override
  State<PaymentCheckoutPage> createState() => _PaymentCheckoutPageState();
}

enum _PaymentMethod { upi, card, netBanking, wallets, payLater, emi }

class _PaymentCheckoutPageState extends State<PaymentCheckoutPage> {
  bool _isLoading = false;
  String? _orderId;
  String? _paymentSessionId;
  _PaymentMethod _selectedMethod = _PaymentMethod.upi;

  final CFPaymentGatewayService _cfPaymentGatewayService = CFPaymentGatewayService();

  bool get _cashfreeSupported =>
      !kIsWeb &&
          (defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.iOS);

  @override
  void initState() {
    super.initState();
    if (_cashfreeSupported) {
      _cfPaymentGatewayService.setCallback(verifyPayment, onError);
    }
  }

  void verifyPayment(String orderId) async {
    debugPrint('✅ PAYMENT SUCCESSFUL: $orderId');

    // Sync backend status
    if (widget.bookingId != null) {
      try {
        await PaymentServiceImpl().syncPayment(bookingId: widget.bookingId!);
        await Future.delayed(const Duration(seconds: 2));
      } catch (e) {
        debugPrint('Backend Sync Error: $e');
      }
    }

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BookingSuccessScreen(
          bookingId: orderId,
          amountPaid: widget.totalAmount,
          paymentId: orderId,
        ),
      ),
    );
  }

  void onError(CFErrorResponse error, String orderId) {
    debugPrint('❌ PAYMENT ERROR: ${error.getMessage()}');
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment Failed: ${error.getMessage()}')),
    );
  }

  Future<void> _createOrderAndPay() async {
    if (widget.bookingId == null) return;

    if (!_cashfreeSupported) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cashfree payments are supported on Android and iOS.'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await PaymentServiceImpl().createCashfreeOrder(
        bookingId: widget.bookingId!,
        idempotencyKey: DateTime.now().millisecondsSinceEpoch.toString(),
      );

      setState(() {
        _orderId = response.orderId;
        _paymentSessionId = response.paymentSessionId;
      });

      _openCashfree();
    } catch (e) {
      debugPrint('🔥 Backend Order Error: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Unable to start payment: $e')));
      }
    }
  }

  void _openCashfree() async {
    if (!_cashfreeSupported || _orderId == null || _paymentSessionId == null) {
      return;
    }
    try {
      final session = CFSessionBuilder()
          .setOrderId(_orderId!)
          .setPaymentSessionId(_paymentSessionId!)
          .setEnvironment(
        dotenv.get('CASHFREE_ENV', fallback: 'TEST') == 'PRODUCTION'
            ? CFEnvironment.PRODUCTION
            : CFEnvironment.SANDBOX,
      )
          .build();

      final payment = CFWebCheckoutPaymentBuilder().setSession(session).build();
      setState(() => _isLoading = false);
      _cfPaymentGatewayService.doPayment(payment);
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final amount = '₹${NumberFormat('#,##,##0', 'en_IN').format(widget.totalAmount)}';

    return Scaffold(
      backgroundColor: DS.background,
      appBar: AppBar(
        backgroundColor: DS.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 18.r, color: DS.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(''),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: DS.maxWidth),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: DS.screenPadding.w, vertical: 4.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Select Payment Method',
                            style: DS.ts(20, FontWeight.w700, DS.textPrimary)),
                        SizedBox(height: 4.h),
                        Text('Choose a payment option to continue.',
                            style: DS.ts(14, FontWeight.w400, DS.textSecondary)),
                        SizedBox(height: 24.h),
                        _sectionLabel('Recommended'),
                        _methodTile(
                          method: _PaymentMethod.upi,
                          icon: Icons.radio_button_checked,
                          title: 'UPI',
                          subtitle: 'Pay using any UPI app',
                          trailingBadge: '🇮🇳',
                        ),
                        SizedBox(height: 12.h),
                        _sectionLabel('All Payment Options'),
                        _methodTile(
                          method: _PaymentMethod.card,
                          icon: Icons.credit_card_rounded,
                          title: 'Credit / Debit Card',
                          subtitle: 'Visa, Mastercard, RuPay',
                        ),
                        _methodTile(
                          method: _PaymentMethod.netBanking,
                          icon: Icons.account_balance_rounded,
                          title: 'Net Banking',
                          subtitle: 'All major banks supported',
                        ),
                        _methodTile(
                          method: _PaymentMethod.wallets,
                          icon: Icons.account_balance_wallet_rounded,
                          title: 'Wallets',
                          subtitle: 'Paytm, PhonePe, Amazon Pay',
                        ),
                        _methodTile(
                          method: _PaymentMethod.payLater,
                          icon: Icons.fast_forward_rounded,
                          title: 'Pay Later',
                          subtitle: 'LazyPay, Simpl, ICICI PayLater',
                        ),
                        _methodTile(
                          method: _PaymentMethod.emi,
                          icon: Icons.calendar_month_rounded,
                          title: 'EMI',
                          subtitle: 'Easy EMI options available',
                        ),
                        SizedBox(height: 8.h),
                      ],
                    ),
                  ),
                ),

                // ---- Sticky bottom bar ----
                Container(
                  padding: EdgeInsets.all(DS.screenPadding.w),
                  decoration: const BoxDecoration(
                    color: DS.card,
                    border: Border(top: BorderSide(color: DS.borderLight)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Total amount
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(DS.screenPadding.w),
                        decoration: DS.cardDecoration(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('TOTAL AMOUNT', style: DS.label(color: DS.textSecondary)),
                            Text(amount, style: DS.ts(24, FontWeight.w700, DS.textPrimary)),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.h),
                      // Pay Securely CTA
                      SizedBox(
                        width: double.infinity,
                        child: DSPrimaryButton(
                          height: 56,
                          onPressed: _isLoading ? () {} : _createOrderAndPay,
                          child: _isLoading
                              ? SizedBox(
                            width: 24.r,
                            height: 24.r,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                              : Text('Pay Securely  $amount',
                              style: DS.ts(16, FontWeight.w600, Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) => Padding(
    padding: EdgeInsets.only(bottom: 10.h),
    child: Text(text.toUpperCase(), style: DS.label()),
  );

  Widget _methodTile({
    required _PaymentMethod method,
    required IconData icon,
    required String title,
    required String subtitle,
    String? trailingBadge,
  }) {
    final isSelected = _selectedMethod == method;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: InkWell(
        borderRadius: BorderRadius.circular(DS.radiusCard.r),
        onTap: () => setState(() => _selectedMethod = method),
        child: Container(
          padding: EdgeInsets.all(DS.screenPadding.w),
          decoration: DS.cardDecoration().copyWith(
            border: Border.all(
              color: isSelected ? DS.success : DS.borderLight,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: const BoxDecoration(color: DS.background, shape: BoxShape.circle),
                child: Icon(icon, color: DS.textSecondary, size: 20.r),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: DS.ts(15, FontWeight.w600, DS.textPrimary)),
                    SizedBox(height: 2.h),
                    Text(subtitle, style: DS.ts(12, FontWeight.w400, DS.textSecondary)),
                  ],
                ),
              ),
              if (trailingBadge != null) ...[
                Text(trailingBadge, style: TextStyle(fontSize: 18.sp)),
                SizedBox(width: 8.w),
              ],
              Icon(
                isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
                color: isSelected ? DS.success : DS.textTertiary,
                size: 24.r,
              ),
            ],
          ),
        ),
      ),
    );
  }
}