import 'package:flutter/material.dart';
import '../theme.dart';
import 'main_shell.dart';

// بدّلي الأيقونات بصور الـ illustrations بعد ما تعملي export من فيجما
const _pages = [
  (
    'Manage your notes easily',
    'A completely easy way to manage and customize your notes.',
    Icons.edit_note,
  ),
  (
    'Organize your thougts',
    'Most beautiful note taking application.',
    Icons.folder_open,
  ),
  (
    'Create cards and easy styling',
    'Making your content legible has never been easier.',
    Icons.style,
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;
  bool get _isLast => _page == _pages.length - 1;

  void _goHome() => Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => const MainShell()),
  );

  void _goTo(int p) => _controller.animateToPage(
    p,
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeInOut,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _page > 0
                    ? TextButton(
                        onPressed: () => _goTo(_page - 1),
                        child: const Text('Back'),
                      )
                    : const SizedBox(),
                TextButton(onPressed: _goHome, child: const Text('Skip')),
              ],
            ),
            Row(
              children: [
                for (var i = 0; i < _pages.length; i++)
                  Expanded(
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: i <= _page
                            ? AppColors.primary
                            : AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
              ],
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (_, i) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(_pages[i].$3, size: 180, color: AppColors.primary),
                    const SizedBox(height: 32),
                    Text(
                      _pages[i].$1,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _pages[i].$2,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.grey),
                    ),
                  ],
                ),
              ),
            ),
            FilledButton(
              onPressed: _isLast ? _goHome : () => _goTo(_page + 1),
              child: Text(_isLast ? 'Get Started' : 'Next'),
            ),
            if (_isLast)
              TextButton(onPressed: _goHome, child: const Text('Sign In')),
          ],
        ),
      ),
    ),
  );
}
