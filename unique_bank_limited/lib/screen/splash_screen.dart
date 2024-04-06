import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final Widget? child;
  const SplashScreen({Key? key, this.child});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => widget.child!),
            (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://scontent.fdac24-4.fna.fbcdn.net/v/t39.30808-6/434996480_2469456036576109_6410386812238896771_n.jpg?_nc_cat=107&ccb=1-7&_nc_sid=5f2048&_nc_ohc=O6Tqb6mzs6QAb5LF5-0&_nc_ht=scontent.fdac24-4.fna&oh=00_AfAAxmmkIsUUVIwo4A22kQnfwr1BEnhvcNUCKW82Fe8iTw&oe=6613CDBC',
              width: 300, // Adjust the width as needed
              height: 300, // Adjust the height as needed
            ),
            SizedBox(height: 20),
            Text(
              "Welcome to Unique Bank Limited",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
