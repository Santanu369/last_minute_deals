import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lmd_app/core/theme/design_tokens.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:lmd_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:lmd_app/features/booking/data/services/booking_service.dart';

const _maxGuests = 35; // also enforced by the API

// Same palette and card style as the Guests tab of your_selection_page.dart.
const _kBg = DS.background;
const _kBorder = DS.borderLight; // card borders / dividers
const _kInputBorder = DS.borderMedium;
const _kDark = DS.textPrimary;
const _kGray = DS.textSecondary;
const _kPlaceholder = DS.textTertiary;
const _kRed = DS.accentRed;
const _kPillBg = DS.borderLight;
const _kInputBg = DS.card;
final _emailRe = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');

/// Enquiry form for a price-on-request villa. No payment; the host calls back.
class EnquiryPage extends StatefulWidget {
  final String variantId;
  final String villaName;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final int adults;
  final int children;

  const EnquiryPage({
    super.key,
    required this.variantId,
    required this.villaName,
    this.checkIn,
    this.checkOut,
    this.adults = 2,
    this.children = 0,
  });

  @override
  State<EnquiryPage> createState() => _EnquiryPageState();
}

class _EnquiryPageState extends State<EnquiryPage> {
  final _name = TextEditingController();
  final _dial = TextEditingController(text: '+91');
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _message = TextEditingController();
  // Default to today -> tomorrow (check-out must be after check-in).
  static DateTime get _today {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  late DateTime? _in = widget.checkIn ?? _today;
  late DateTime? _out =
      widget.checkOut ?? (widget.checkIn ?? _today).add(const Duration(days: 1));
  late int _adults = widget.adults.clamp(1, _maxGuests);
  late int _children = widget.children.clamp(0, _maxGuests - _adults);
  bool _busy = false, _done = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthCubit>().state.user;
    if (user != null) {
      _name.text = '${user.firstName} ${user.lastName}'.trim();
      _email.text = user.email;
      final ph = (user.phone ?? '').replaceAll(RegExp(r'\D'), '');
      _phone.text = ph.length > 10 ? ph.substring(ph.length - 10) : ph;
    }
  }

  @override
  void dispose() {
    for (final c in [_name, _dial, _phone, _email, _message]) {
      c.dispose();
    }
    super.dispose();
  }

  String _iso(DateTime d) => DateFormat('yyyy-MM-dd').format(d);

  Future<void> _pickDates() async {
    final now = DateTime.now();
    final r = await showDateRangePicker(
      context: context,
      builder: (c, child) => Theme(
        data: Theme.of(c).copyWith(
          colorScheme: const ColorScheme.light(
            primary: DS.primaryBlue,
            onPrimary: Colors.white,
            onSurface: DS.textPrimary,
          ),
        ),
        child: child!,
      ),
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 730)),
      initialDateRange: _in != null && _out != null
          ? DateTimeRange(start: _in!, end: _out!)
          : null,
    );
    if (r != null) {
      setState(() {
        _in = r.start;
        _out = r.end;
      });
    }
  }

  /// First problem found, or null. Mirrors the server rules.
  String? _validate() {
    if (_in == null || _out == null || !_out!.isAfter(_in!)) {
      return 'Select check-in and check-out dates.';
    }
    if (_name.text.trim().length < 2) return 'Enter your full name.';
    final digits = '${_dial.text}${_phone.text}'.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 8 || digits.length > 15) {
      return 'Enter a valid phone number.';
    }
    if (!_emailRe.hasMatch(_email.text.trim())) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  Future<void> _submit() async {
    final problem = _validate();
    if (problem != null) {
      setState(() => _error = problem);
      return;
    }
    setState(() {
      _busy = true;
      _error = '';
    });
    try {
      await BookingService().sendPriceEnquiry({
        'variant_id': widget.variantId,
        'check_in_date': _iso(_in!),
        'check_out_date': _iso(_out!),
        'adults': _adults,
        'children': _children,
        'contact_name': _name.text.trim(),
        'contact_phone': '${_dial.text.trim()}${_phone.text.trim()}',
        'contact_email': _email.text.trim(),
        'message': _message.text.trim(),
      });
      if (mounted) setState(() => _done = true);
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  TextStyle _t(double size, FontWeight w, [Color c = _kDark]) =>
      GoogleFonts.inter(fontSize: size.sp, fontWeight: w, color: c);

  Widget _header(String title) => Container(
    height: 56.h,
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    decoration: const BoxDecoration(
      color: Colors.white,
      border: Border(bottom: BorderSide(color: _kBorder, width: 1)),
    ),
    child: Stack(alignment: Alignment.center, children: [
      Align(
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
            child: Icon(Icons.arrow_back, size: 22.r, color: _kDark),
          ),
        ),
      ),
      Text(title, style: _t(20, FontWeight.w700)),
    ]),
  );

  Widget _intro(String title, String sub) => Padding(
    padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: _t(20, FontWeight.w700)),
      SizedBox(height: 4.h),
      Text(sub, style: _t(14, FontWeight.w400, _kGray)),
    ]),
  );

  /// Numbered section card, same as "1 Contact Details" in the cart's Guests tab.
  Widget _section(String number, String title, List<Widget> children) =>
      Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: DS.card,
          borderRadius: BorderRadius.circular(DS.radiusCard.r),
          border: Border.all(color: _kBorder, width: 1),
          boxShadow: DS.shadowCard,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              width: 24.w,
              height: 24.h,
              decoration:
              const BoxDecoration(color: _kRed, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Text(number, style: _t(12, FontWeight.w700, Colors.white)),
            ),
            SizedBox(width: 10.w),
            Expanded(child: Text(title, style: _t(14, FontWeight.w700))),
          ]),
          SizedBox(height: 12.h),
          const Divider(color: _kPillBg, height: 1, thickness: 1),
          SizedBox(height: 16.h),
          ...children,
        ]),
      );

  Widget _label(String text) => Padding(
    padding: EdgeInsets.only(bottom: 6.h),
    child: Text(text,
        style: _t(11, FontWeight.w500, _kPlaceholder).copyWith(letterSpacing: 0.88)),
  );

  Widget _box({required Widget child, double? height}) => Container(
    height: height,
    decoration: BoxDecoration(
      color: _kInputBg,
      borderRadius: BorderRadius.circular(DS.radiusInput.r),
      border: Border.all(color: _kInputBorder, width: 1),
    ),
    child: child,
  );

  Widget _input(TextEditingController c, String hint,
      {TextInputType type = TextInputType.text,
        int maxLines = 1,
        int? maxLength}) =>
      _box(
        height: maxLines == 1 ? 48.h : null,
        child: TextField(
          controller: c,
          keyboardType: type,
          maxLines: maxLines,
          maxLength: maxLength,
          style: _t(14, FontWeight.w500),
          decoration: InputDecoration(
            isDense: true,
            counterText: '',
            hintText: hint,
            hintStyle: _t(14, FontWeight.w400, _kPlaceholder),
            border: InputBorder.none,
            contentPadding:
            EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          ),
        ),
      );

  Widget _gap() => SizedBox(height: 16.h);

  Widget _counter(String label, int v, int min, int max, ValueChanged<int> on) {
    Widget btn(IconData i, VoidCallback? f) => GestureDetector(
      onTap: f,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 32.r,
        height: 32.r,
        child: Icon(i, size: 16.r, color: f == null ? _kPlaceholder : _kDark),
      ),
    );
    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: Row(children: [
        Expanded(child: Text(label, style: _t(14, FontWeight.w600))),
        // Quantity pill:  -  value  +
        Container(
          height: 32.r,
          decoration: BoxDecoration(
            color: DS.card,
            borderRadius: BorderRadius.circular(DS.radiusPill),
            border: Border.all(color: _kInputBorder, width: 1),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            btn(Icons.remove, v > min ? () => on(v - 1) : null),
            SizedBox(
              width: 40.w,
              child: _CountInput(
                  value: v,
                  min: min,
                  max: max,
                  style: _t(14, FontWeight.w500),
                  onChanged: on),
            ),
            btn(Icons.add, v < max ? () => on(v + 1) : null),
          ]),
        ),
      ]),
    );
  }

  Widget _bottomBar(String text, VoidCallback? onTap, {bool busy = false}) =>
      Container(
        height: 72.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: const BoxDecoration(
          color: DS.card,
          border: Border(top: BorderSide(color: _kBorder, width: 1)),
        ),
        child: SizedBox(
          width: double.infinity,
          height: 48.h,
          child: ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: DS.primaryBlue,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(DS.radiusButton.r)),
            ),
            child: busy
                ? SizedBox(
                width: 22.w,
                height: 22.h,
                child: const CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2.5))
                : Text(text, style: _t(14, FontWeight.w700, Colors.white)),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (_done) return _success();
    final fmt = DateFormat('d MMM yyyy');
    final nights =
    (_in != null && _out != null) ? _out!.difference(_in!).inDays : 0;
    return Scaffold(
      backgroundColor: _kBg,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: DS.maxWidth),
          child: SafeArea(child: Column(children: [
            _header('Enquiry'),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _intro('Send Your Enquiry',
                        '${widget.villaName}: the host will call you to confirm availability and price. No payment now.'),
                    _section('1', 'Your Stay', [
                      _label('CHECK-IN / CHECK-OUT *'),
                      GestureDetector(
                        onTap: _pickDates,
                        child: _box(
                          height: 48.h,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14.w),
                            child: Row(children: [
                              Icon(Icons.calendar_today_outlined,
                                  size: 18.r, color: _kGray),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Text(
                                  _in == null || _out == null
                                      ? 'Select dates'
                                      : '${fmt.format(_in!)} - ${fmt.format(_out!)}'
                                      '${nights > 0 ? '  ($nights night${nights > 1 ? 's' : ''})' : ''}',
                                  style: _t(
                                      14,
                                      FontWeight.w500,
                                      _in == null ? _kPlaceholder : _kDark),
                                ),
                              ),
                            ]),
                          ),
                        ),
                      ),
                      _counter('Adults', _adults, 1, _maxGuests - _children,
                              (v) => setState(() => _adults = v)),
                      _counter('Children', _children, 0, _maxGuests - _adults,
                              (v) => setState(() => _children = v)),
                    ]),
                    _section('2', 'Contact Details', [
                      _label('FULL NAME *'),
                      _input(_name, 'John Doe'),
                      _gap(),
                      _label('EMAIL ADDRESS *'),
                      _input(_email, 'john@example.com',
                          type: TextInputType.emailAddress),
                      _gap(),
                      _label('PHONE NUMBER *'),
                      Row(children: [
                        SizedBox(
                            width: 76.w,
                            child: _input(_dial, '+91', type: TextInputType.phone)),
                        SizedBox(width: 10.w),
                        Expanded(
                            child: _input(_phone, '9876543210',
                                type: TextInputType.phone)),
                      ]),
                      _gap(),
                      _label('MESSAGE (OPTIONAL)'),
                      _input(_message, 'Occasion, special requests...',
                          maxLines: 3, maxLength: 1000),
                    ]),
                    if (_error.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 0),
                        child: Text(_error, style: _t(13, FontWeight.w600, _kRed)),
                      ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
            _bottomBar('Send Enquiry →', _busy ? null : _submit, busy: _busy), ]), ), ), ), ); }

  Widget _success() => Scaffold(
    backgroundColor: _kBg,
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: DS.maxWidth),
        child: SafeArea(child: Column(children: [
          _header('Enquiry'),
          Expanded(
            child: Center(
              child: Container(
                margin: EdgeInsets.all(16.w),
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: DS.card,
                  borderRadius: BorderRadius.circular(DS.radiusCard.r),
                  border: Border.all(color: _kBorder, width: 1),
                  boxShadow: DS.shadowCard,
                ),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.check_circle,
                      color: DS.success, size: 56.r),
                  SizedBox(height: 12.h),
                  Text('Enquiry sent', style: _t(20, FontWeight.w700)),
                  SizedBox(height: 8.h),
                  Text(
                      'The host of ${widget.villaName} will call you to confirm availability and price. We also emailed you a copy.',
                      textAlign: TextAlign.center,
                      style: _t(14, FontWeight.w400, _kGray)),
                ]),
              ),
            ),
          ),
          _bottomBar('Done', () => Navigator.of(context).pop()), ]), ), ), ), );
}

/// Number box between the - and + buttons: typing is clamped to [min, max].
class _CountInput extends StatefulWidget {
  final int value, min, max;
  final TextStyle style;
  final ValueChanged<int> onChanged;

  const _CountInput({
    required this.value,
    required this.min,
    required this.max,
    required this.style,
    required this.onChanged,
  });

  @override
  State<_CountInput> createState() => _CountInputState();
}

class _CountInputState extends State<_CountInput> {
  late final _c = TextEditingController(text: '${widget.value}');
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() {
      if (!_focus.hasFocus) _c.text = '${widget.value}'; // restore if left empty
    });
  }

  @override
  void didUpdateWidget(_CountInput old) {
    super.didUpdateWidget(old);
    // Keep the box in sync when +/- or the other counter changes the value.
    if (int.tryParse(_c.text) != widget.value && !_focus.hasFocus) {
      _c.text = '${widget.value}';
    }
  }

  @override
  void dispose() {
    _c.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _typed(String t) {
    final n = int.tryParse(t);
    if (n == null) return;
    final v = n.clamp(widget.min, widget.max);
    if (v != n) {
      _c.value = TextEditingValue(
        text: '$v',
        selection: TextSelection.collapsed(offset: '$v'.length),
      );
    }
    if (v != widget.value) widget.onChanged(v);
  }

  @override
  Widget build(BuildContext context) => TextField(
    controller: _c,
    focusNode: _focus,
    textAlign: TextAlign.center,
    keyboardType: TextInputType.number,
    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    style: widget.style,
    onChanged: _typed,
    decoration: InputDecoration(
      isDense: true,
      contentPadding: EdgeInsets.symmetric(vertical: 8.h),
      border: InputBorder.none,
    ),
  );
}