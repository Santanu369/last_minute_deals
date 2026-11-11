import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Guards the listing screen's scroll structure: tall box sliver, pinned header, list.
void main() {
  testWidgets('pinned header + list scroll without sliver geometry errors',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CustomScrollView(slivers: [
          SliverToBoxAdapter(child: SizedBox(height: 700, child: Text('search'))),
          PinnedHeaderSliver(child: Container(height: 52, color: Colors.white)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList.separated(
              itemCount: 20,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) => SizedBox(height: 96, child: Text('$i')),
            ),
          ),
        ]),
      ),
    ));
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -900));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
