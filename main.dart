import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Akademi Crypto - Demo',
      theme: ThemeData.dark()
          .copyWith(scaffoldBackgroundColor: Colors.black, useMaterial3: true),
      home: const HomePage(),
    );
  }
}

// ------------------ Models ------------------
class ProfitItem {
  final String id;
  final String owner;
  final double pnl; // in percent
  final String exchange;

  ProfitItem({
    required this.id,
    required this.owner,
    required this.pnl,
    required this.exchange,
  });
}

final sampleData = <ProfitItem>[
  ProfitItem(id: '1', owner: 'CryptoFury', pnl: 68.92, exchange: 'Binance'),
  ProfitItem(id: '2', owner: 'Spongebop', pnl: 77.41, exchange: 'Binance'),
  ProfitItem(id: '3', owner: 'clefordlim', pnl: 515.28, exchange: 'Bybit'),
  ProfitItem(id: '4', owner: 'vidatz', pnl: 869.92, exchange: 'Binance'),
  ProfitItem(id: '5', owner: 'Jago', pnl: 41.83, exchange: 'MEXC'),
  ProfitItem(id: '6', owner: 'Howfel', pnl: 100.02, exchange: 'Bitget'),
  ProfitItem(id: '7', owner: 'Vincent', pnl: 2821.06, exchange: 'BingX'),
];

// ------------------ Riverpod State ------------------
// Provider that holds set of liked item ids
class LikedNotifier extends StateNotifier<Set<String>> {
  LikedNotifier() : super({});

  void toggleLike(String id) {
    final newSet = Set<String>.from(state);
    if (newSet.contains(id))
      newSet.remove(id);
    else
      newSet.add(id);
    state = newSet;
  }
}

final likedProvider = StateNotifierProvider<LikedNotifier, Set<String>>((ref) {
  return LikedNotifier();
});

// A provider that holds the list of items (immutable here but demonstrates Riverpod usage)
final profitListProvider = Provider<List<ProfitItem>>((ref) => sampleData);

// ------------------ UI ------------------
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(profitListProvider);
    final screenW = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background gradient with subtle pattern
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0F0F13), Color(0xFF0A0A0D)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            // Neon header and content
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 36),
                  // Logo + Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Transform.rotate(
                              angle: -pi / 8,
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(colors: [
                                    Color(0xFF8A2BE2),
                                    Color(0xFF00C6FF)
                                  ]),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Center(
                                    child:
                                        Icon(Icons.currency_bitcoin, size: 20)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text('AKADEMI\nCRYPTO',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    height: 1.05)),
                          ],
                        ),
                        Row(
                          children: [
                            Text('bahulreyhan@gmail.com',
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.7))),
                            const SizedBox(width: 6),
                            const Icon(Icons.keyboard_arrow_down)
                          ],
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Big headline
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                  text: 'Strategi Trading Crypto\nUntuk ',
                                  style: TextStyle(
                                      fontSize: screenW < 600 ? 28 : 40,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white.withOpacity(0.95))),
                              TextSpan(
                                  text: 'Gandain Uang Kalian.',
                                  style: TextStyle(
                                      fontSize: screenW < 600 ? 28 : 40,
                                      fontWeight: FontWeight.w700,
                                      foreground: Paint()
                                        ..shader = const LinearGradient(
                                          colors: [
                                            Color(0xFF7E5FFF),
                                            Color(0xFF2EE6FF)
                                          ],
                                        ).createShader(const Rect.fromLTWH(
                                            0, 0, 200, 70)))),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 12),
                        Text(
                            '71% Pelajar Akademi Crypto Balik Modal\nDalam Waktu 3 Minggu.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14)),

                        const SizedBox(height: 18),

                        // Horizontal ListView of cards
                        SizedBox(
                          height: 260,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            scrollDirection: Axis.horizontal,
                            itemCount: items.length,
                            itemBuilder: (context, idx) {
                              final it = items[idx];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: ProfitCard(item: it),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 26),

                        // Grid-like section that mimics screenshots below
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            alignment: WrapAlignment.center,
                            children: List.generate(4, (i) {
                              return SizedBox(
                                width: min(320, screenW * 0.45),
                                child: _MiniShowcaseCard(index: i),
                              );
                            }),
                          ),
                        ),

                        const SizedBox(height: 36),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------ Custom Widgets ------------------

// ProfitCard is a stateful widget with entry animation
class ProfitCard extends StatefulWidget {
  final ProfitItem item;
  const ProfitCard({super.key, required this.item});

  @override
  State<ProfitCard> createState() => _ProfitCardState();
}

class _ProfitCardState extends State<ProfitCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offset;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));

    _offset = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _opacity = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // little staggered delay based on hash
    Future.delayed(Duration(milliseconds: 100 * (widget.item.id.hashCode % 5)),
        () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pnl = widget.item.pnl;
    return SlideTransition(
      position: _offset,
      child: FadeTransition(
        opacity: _opacity,
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0F1113),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.04)),
            boxShadow: [
              BoxShadow(
                color: pnl > 0
                    ? Colors.green.withOpacity(0.06)
                    : Colors.red.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 8),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.grey.shade900,
                        child: Text(widget.item.owner[0].toUpperCase()),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.item.owner,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 14)),
                          Text(widget.item.exchange,
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 12)),
                        ],
                      )
                    ],
                  ),
                  // like button controlled by Riverpod
                  Consumer(builder: (context, ref, _) {
                    final liked = ref.watch(likedProvider);
                    final isLiked = liked.contains(widget.item.id);
                    return IconButton(
                      onPressed: () => ref
                          .read(likedProvider.notifier)
                          .toggleLike(widget.item.id),
                      icon: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked
                            ? Colors.redAccent
                            : Colors.white.withOpacity(0.8),
                      ),
                    );
                  })
                ],
              ),

              const Spacer(),

              // Big PNL text
              Text(
                (pnl >= 0 ? '+' : '') + pnl.toStringAsFixed(2) + '%',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: pnl >= 0 ? Colors.greenAccent : Colors.redAccent,
                    shadows: [
                      Shadow(
                        blurRadius: 12,
                        color: pnl >= 0
                            ? Colors.greenAccent.withOpacity(0.25)
                            : Colors.redAccent.withOpacity(0.25),
                        offset: const Offset(0, 4),
                      )
                    ]),
              ),

              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Entry: 1.21',
                      style: TextStyle(color: Colors.white.withOpacity(0.6))),
                  Text('Mark: 1.39',
                      style: TextStyle(color: Colors.white.withOpacity(0.6)))
                ],
              ),

              const SizedBox(height: 12),

              // small footer with referral code mock
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('BINANCE FUTURES',
                        style: TextStyle(fontSize: 11)),
                  ),
                  Text('Referral: 85681279',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.6), fontSize: 12))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

// A small showcase card mimicking the grid below the hero
class _MiniShowcaseCard extends StatelessWidget {
  final int index;
  const _MiniShowcaseCard({required this.index});

  @override
  Widget build(BuildContext context) {
    final colors = [
      LinearGradient(colors: [Color(0xFF2EE6FF), Color(0xFF7E5FFF)]),
      LinearGradient(colors: [Color(0xFFFF7A7A), Color(0xFFFFC777)]),
      LinearGradient(colors: [Color(0xFF8A2BE2), Color(0xFF00C6FF)]),
      LinearGradient(colors: [Color(0xFF5AFFC2), Color(0xFF6E5BFF)]),
    ];

    return Container(
      height: 140,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1113),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.03)),
      ),
      child: Row(
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
                gradient: colors[index % colors.length],
                borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.show_chart, size: 34, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Student Win',
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 6),
                Text('+${(50 + index * 40).toStringAsFixed(2)}%',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.greenAccent)),
                const SizedBox(height: 6),
                Text('From our community',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.6), fontSize: 12))
              ],
            ),
          )
        ],
      ),
    );
  }
}
