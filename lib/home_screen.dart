import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // bool _isFirst = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: const Text("Notes", style: TextStyle(fontSize: 35)),
          ),
        ),
        actions: [],
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 20),
        // 2. تغليف الـ AnimatedContainer بـ GestureDetector للاستماع للضغطات
        child: Lottie.asset("assets/business_app.json"),
      ),
    );
  }
}
/*
AnimatedContainer(
            // 3. استخدام الاسم الصحيح للمتغير بالشرطة السفلية (_isExpanded)
            width: _isExpanded ? 250 : 100,
            height: _isExpanded ? 250 : 100,
            color: _isExpanded ? Colors.blue : Colors.red,
            alignment: _isExpanded ? Alignment.center : Alignment.topCenter,
            duration: const Duration(seconds: 1),
            curve: Curves.fastOutSlowIn,
            child: const Icon(Icons.star, size: 50, color: Colors.white),
          ),
AnimatedCrossFade(
            duration: const Duration(milliseconds: 500),
            firstChild: const FlutterLogo(
              style: FlutterLogoStyle.horizontal,
              size: 500,
            ),
            secondChild: const FlutterLogo(
              style: FlutterLogoStyle.markOnly,
              size: 800,
            ),
            crossFadeState: _isFirst
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
          ),
          Animated opasity
          Lottie
*/