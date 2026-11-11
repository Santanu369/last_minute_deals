import 'package:flutter_test/flutter_test.dart';
import 'package:lmd_app/core/utils/image_url.dart';

void main() {
  test('fills {size}, upgrades http, fixes protocol-relative, reads maps/lists', () {
    expect(ImageUrl.clean('https://cdn.worldota.net/t/{size}/content/a.JPEG'),
        'https://cdn.worldota.net/t/640x400/content/a.JPEG');
    expect(ImageUrl.clean('http://x.com/{size}/a.jpg', size: ImageUrl.full),
        'https://x.com/x1080/a.jpg');
    expect(ImageUrl.clean('//photos.hotelbeds.com/a.JPG'), 'https://photos.hotelbeds.com/a.JPG');
    expect(ImageUrl.clean({'url': 'https://a/{size}.jpg'}), 'https://a/640x400.jpg');
    expect(ImageUrl.clean(['https://a/b.jpg', 'x']), 'https://a/b.jpg');
    expect(ImageUrl.clean(null), '');
    expect(ImageUrl.clean('https://a/%7Bsize%7D/b.jpg'), 'https://a/640x400/b.jpg');
  });
}
