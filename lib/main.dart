import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Staggered Menu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MenuPage(),
    );
  }
}

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Interval> _menuItemSlideInterval = [];
  late Interval _buttonInterval;
  static const List<String> _menuItems = [
    'Home',
    'Specialization',
    'Portfolio',
    'Blog',
    'About Me',
    'Projects',
    'Keep In Touch',
  ];

  static const _initialDelayTime = Duration(milliseconds: 50);
  static const _staggerTime = Duration(milliseconds: 50);
  static const _itemSlideTime = Duration(milliseconds: 250);
  static const _buttonDelayTime = Duration(milliseconds: 150);
  static const _buttonAnimationTime = Duration(milliseconds: 500);

  final _animationTime = _initialDelayTime +
      (_staggerTime * _menuItems.length) +
      _buttonDelayTime +
      _buttonAnimationTime;

  Widget _bgImg() {
    return Container();
  }

  @override
  void initState() {
    super.initState();
    _initStaggerAnimation();
    _controller = AnimationController(duration: _animationTime, vsync: this)
      ..forward();
  }

  void _initStaggerAnimation() {
    for (int i = 0; i < _menuItems.length; i++) {
      final start = _initialDelayTime + (_staggerTime * i);
      final end = start + _itemSlideTime;
      _menuItemSlideInterval.add(
        Interval(
          start.inMilliseconds / _animationTime.inMilliseconds,
          end.inMilliseconds / _animationTime.inMilliseconds,
        ),
      );
    }
    final btnStart =
        Duration(milliseconds: (_menuItems.length * 50)) + _buttonDelayTime;
    final btnEnd = btnStart + _buttonAnimationTime;
    _buttonInterval = Interval(
        btnStart.inMilliseconds / _animationTime.inMilliseconds,
        btnEnd.inMilliseconds / _animationTime.inMilliseconds);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(fit: StackFit.expand, children: [
        _bgImg(),
        _buildContent(),
      ]),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        ..._buildListItems(),
        const Spacer(),
        _buildGetStartedButton(),
      ],
    );
  }

  List<Widget> _buildListItems() {
    final listItems = <Widget>[];
    for (var i = 0; i < _menuItems.length; ++i) {
      listItems.add(
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final percent = Curves.easeOut.transform(
              _menuItemSlideInterval[i].transform(_controller.value),
            );
            final opacity = percent;
            final translateOffsetX = (1-opacity) * 150;
            return Opacity(
              opacity: opacity,
              child: Transform.translate(
                offset: Offset(translateOffsetX,0),
                child: child,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 16),
            child: Text(
              _menuItems[i],
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    }
    return listItems;
  }

  Widget _buildGetStartedButton() {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(50.0),
        child: AnimatedBuilder(
          builder: (context, child) {
            final percent = Curves.elasticOut.transform(
              _buttonInterval.transform(_controller.value),
            );
            final opacity = percent.clamp(0.0, 1.0);
            final scale = (opacity * 0.5) + 0.5;
            return Opacity(
              opacity: opacity,
              child: Transform.scale(
                scale: scale,
                child: child,
              ),
            );
          },
          animation: _controller,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Colors.teal,
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
            ),
            onPressed: () {},
            child: const Text(
              'Love me 💖',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
