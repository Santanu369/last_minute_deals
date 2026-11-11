import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lmd_app/core/theme/design_tokens.dart';
import 'package:lmd_app/core/utils/app_snackbar.dart';
import 'package:lmd_app/features/notifications/data/notification_inbox_service.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  static Future<void> open(BuildContext context) => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const NotificationsPage()),
  );

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final NotificationInboxService _service = NotificationInboxService();
  final ScrollController _scroll = ScrollController();
  final Set<String> _expanded = {};

  List<AppNotification> _items = [];
  int _unread = 0;
  int _page = 1;
  int _pages = 1;
  bool _signedIn = false;
  bool _isLoading = true;
  bool _isLoadingMore = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
    _scroll.addListener(() {
      if (_scroll.position.extentAfter < 300) _loadMore();
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final result = await _service.fetch();
      if (!mounted) return;
      setState(() {
        _items = result.items;
        _unread = result.unread;
        _pages = result.pages;
        _signedIn = result.signedIn;
        _page = 1;
        _isLoading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMore() async {
    if (_isLoading || _isLoadingMore || _page >= _pages) return;
    setState(() => _isLoadingMore = true);
    try {
      final result = await _service.fetch(page: _page + 1);
      if (!mounted) return;
      // New arrivals shift the pages, so the next page can repeat items.
      final seen = _items.map((n) => n.id).toSet();
      setState(() {
        _items = [..._items, ...result.items.where((n) => !seen.contains(n.id))];
        _pages = result.pages;
        _page++;
      });
    } catch (_) {
      // Keep what is loaded; scrolling again retries.
    } finally {
      if (mounted) setState(() => _isLoadingMore = false);
    }
  }

  void _onTap(AppNotification item) {
    final wasUnread = !item.isRead;
    setState(() {
      if (!_expanded.remove(item.id)) _expanded.add(item.id);
      if (wasUnread) {
        item.isRead = true;
        if (_unread > 0) _unread--;
      }
    });
    // Optimistic: a failed call is corrected by the next refresh.
    if (wasUnread) _service.markRead(item.id).catchError((_) {});
  }

  Future<void> _markAllRead() async {
    try {
      await _service.markAllRead();
      if (!mounted) return;
      setState(() {
        for (final n in _items) {
          n.isRead = true;
        }
        _unread = 0;
      });
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.showError(context, e.toString().replaceFirst('Exception: ', ''));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DS.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: DS.maxWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(),
                Expanded(child: _body()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.w, 8.h, DS.screenPadding.w, 4.h),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: DS.textPrimary, size: 22.r),
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              _unread > 0 ? '${'notifications'.tr()} ($_unread)' : 'notifications'.tr(),
              style: DS.ts(20, FontWeight.w700, DS.textPrimary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (_unread > 0)
            TextButton(
              onPressed: _markAllRead,
              child: Text('Mark all as read',
                  style: DS.ts(13, FontWeight.w700, DS.primaryBlue)),
            ),
        ],
      ),
    );
  }

  Widget _body() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: DS.primaryBlue));
    }

    final Widget child;
    if (_error != null) {
      child = _message(Icons.error_outline, _error!, 'Pull down to try again.');
    } else if (_items.isEmpty) {
      child = _message(
        Icons.notifications_none_rounded,
        'No notifications yet',
        _signedIn
            ? 'Booking updates and offers will show up here.'
            : 'Log in to see booking updates and offers.',
      );
    } else {
      child = ListView.separated(
        controller: _scroll,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
            DS.screenPadding.w, 8.h, DS.screenPadding.w, DS.screenPadding.h),
        itemCount: _items.length + (_isLoadingMore ? 1 : 0),
        separatorBuilder: (_, _) => SizedBox(height: 12.h),
        itemBuilder: (_, i) => i < _items.length
            ? _card(_items[i])
            : const Center(child: CircularProgressIndicator(color: DS.primaryBlue)),
      );
    }

    return RefreshIndicator(color: DS.primaryBlue, onRefresh: _load, child: child);
  }

  /// Scrollable so pull-to-refresh still works on the empty / error states.
  Widget _message(IconData icon, String title, String subtitle) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(32.w, 140.h, 32.w, 24.h),
      children: [
        Icon(icon, size: 48.r, color: DS.textTertiary),
        SizedBox(height: 12.h),
        Text(title,
            textAlign: TextAlign.center,
            style: DS.ts(16, FontWeight.w600, DS.textPrimary)),
        SizedBox(height: 4.h),
        Text(subtitle,
            textAlign: TextAlign.center,
            style: DS.ts(14, FontWeight.w400, DS.textSecondary)),
      ],
    );
  }

  Widget _card(AppNotification item) {
    final (icon, color) = switch (item.type) {
      'success' => (Icons.check_circle_outline, DS.success),
      'warning' => (Icons.warning_amber_rounded, DS.starYellow),
      'error' => (Icons.error_outline, DS.accentRed),
      _ => (Icons.notifications_none_rounded, DS.primaryBlue),
    };
    final expanded = _expanded.contains(item.id);

    return Semantics(
      button: true,
      label: item.isRead ? null : 'Unread',
      child: Container(
        decoration: DS.cardDecoration(),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(DS.radiusCard.r),
            onTap: () => _onTap(item),
            child: Padding(
              padding: EdgeInsets.all(DS.screenPadding.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40.r,
                    height: 40.r,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 20.r, color: color),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: DS.ts(15, item.isRead ? FontWeight.w500 : FontWeight.w700,
                              DS.textPrimary),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          item.message,
                          style: DS.ts(14, FontWeight.w400, DS.textSecondary, height: 1.4),
                          maxLines: expanded ? null : 2,
                          overflow: expanded ? null : TextOverflow.ellipsis,
                        ),
                        if (item.createdAt != null) ...[
                          SizedBox(height: 6.h),
                          Text(_timeAgo(item.createdAt!),
                              style: DS.ts(12, FontWeight.w400, DS.textTertiary)),
                        ],
                      ],
                    ),
                  ),
                  if (!item.isRead)
                    Container(
                      margin: EdgeInsets.only(left: 8.w, top: 4.h),
                      width: 8.r,
                      height: 8.r,
                      decoration: const BoxDecoration(
                        color: DS.accentRed,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('d MMM y').format(time);
  }
}