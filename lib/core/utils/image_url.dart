/// Normalises supplier image URLs (same rules as lmd-web `lib/imageUtils.ts`).
///
/// RateHawk/Worldota URLs contain a `{size}` placeholder that must be filled in
/// (e.g. `640x400`, `1024x768`, `x1080`); left as-is the URL is invalid and the
/// image never shows. Also upgrades http -> https and fixes `//host/...` URLs.
class ImageUrl {
  ImageUrl._();

  /// Card/list thumbnails.
  static const thumb = '640x400';

  /// Detail galleries (what lmd-web uses).
  static const full = 'x1080';

  static String clean(Object? raw, {String size = thumb}) {
    var url = _extract(raw).trim();
    if (url.isEmpty) return '';

    if (url.contains('%7Bsize%7D')) url = Uri.decodeFull(url);
    url = url.replaceAll('{size}', size);

    if (url.startsWith('//')) return 'https:$url';
    if (url.startsWith('http://')) return url.replaceFirst('http://', 'https://');
    return url;
  }

  static String _extract(Object? raw) {
    if (raw is String) return raw;
    if (raw is Map) {
      for (final k in const ['url', 'src', 'image', 'image_url', 'photo_url', 'link', 'href', 'path']) {
        final v = raw[k];
        if (v is String && v.isNotEmpty) return v;
      }
    }
    if (raw is List && raw.isNotEmpty) return _extract(raw.first);
    return '';
  }
}
