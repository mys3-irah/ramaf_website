import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback onLearnMorePressed;
  final VoidCallback onContactPressed;

  const HeroSection({
    super.key,
    required this.onLearnMorePressed,
    required this.onContactPressed,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final bool isSmallScreen = width < 600;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: height * 0.85 > 500 ? height * 0.85 : 500),
      padding: const EdgeInsets.symmetric(vertical: 80),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/images/hero_bg.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.55),
            BlendMode.darken,
          ),
        ),
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1000),
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Pre-title tag
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.accentGreen.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.accentGreen.withOpacity(0.4), width: 1.5),
                ),
                child: Text(
                  'RAMA FOUNDATION MANIPUR',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: isSmallScreen ? 11 : 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade300,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Main Heading
              Text(
                'Helping the needy section\nof the society develop',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: isSmallScreen ? 34 : (width < 900 ? 46 : 60),
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1.15,
                  letterSpacing: -1.0,
                ),
              ),
              const SizedBox(height: 20),
              
              // Description Subtext
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Text(
                  'We provide structured social support on: Training, Marketing Assistance, and Financial Assistance to bring unity, service, and economic prosperity.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: isSmallScreen ? 15 : 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.85),
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              
              // Action Buttons
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: onLearnMorePressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreenLight,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text('Our Services'),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded, size: 18),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: onContactPressed,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white, width: 2),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                    ),
                    child: const Text('Contact Us'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
