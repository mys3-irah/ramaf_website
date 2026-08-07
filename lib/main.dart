import 'package:flutter/material.dart';

void main() {
  runApp(const RamafWebsite());
}

class RamafWebsite extends StatelessWidget {
  const RamafWebsite({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RAMAF Foundation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const HomePage()),
                    (Route<dynamic> route) => false,
              );
            },
            // Replace the Text widget with the Image widget
            child: Image.asset(
              'assets/images/logo.jpg', // Make sure this matches your exact file name
              height: 40, // Adjust the height to fit your navigation bar perfectly
              fit: BoxFit.contain,
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () {}, child: const Text('Home', style: TextStyle(color: Colors.black))),
          TextButton(onPressed: () {}, child: const Text('About Us', style: TextStyle(color: Colors.black))),
          TextButton(onPressed: () {}, child: const Text('Our Work', style: TextStyle(color: Colors.black))),
          TextButton(onPressed: () {}, child: const Text('Events', style: TextStyle(color: Colors.black))),
          TextButton(onPressed: () {}, child: const Text('Media Centre', style: TextStyle(color: Colors.black))),
          TextButton(onPressed: () {}, child: const Text('Products', style: TextStyle(color: Colors.black))),
          TextButton(onPressed: () {}, child: const Text('Contact Us', style: TextStyle(color: Colors.black))),
          const SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HERO SECTION (Option A)
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/hero_bg.png'), // Uses your local file
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.6), // Dark overlay so white text stands out
                    BlendMode.darken,
                  ),
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Welcome to RAMAF Foundation\nCultivating Our Future',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 800),
                        child: const Text(
                          'Empowering communities through sustainable agriculture, horticulture, and innovative mushroom cultivation.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Learn More About Our Impact',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )

            // FUTURE SECTIONS WILL GO HERE (About Us, Our Work, etc.)

          ],
        ),
      ),
    );
  }
}