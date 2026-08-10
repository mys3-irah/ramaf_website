import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';

class Footer extends StatelessWidget {
  final Function(int) onItemTapped;

  const Footer({super.key, required this.onItemTapped});

  void _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isDesktop = width > 800;

    return Container(
      width: double.infinity,
      color: const Color(0xFF0C2417), // Deep forest dark green
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              if (isDesktop) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(flex: 2, child: _buildBrandingSection(context)),
                    const SizedBox(width: 40),
                    Expanded(child: _buildLinksSection(context)),
                    const SizedBox(width: 40),
                    Expanded(child: _buildContactSection(context)),
                    const SizedBox(width: 40),
                    Expanded(flex: 2, child: _buildNewsletterSection(context)),
                  ],
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBrandingSection(context),
                    const SizedBox(height: 40),
                    _buildLinksSection(context),
                    const SizedBox(height: 40),
                    _buildContactSection(context),
                    const SizedBox(height: 40),
                    _buildNewsletterSection(context),
                  ],
                );
              }
            },
          ),
          const SizedBox(height: 40),
          const Divider(color: Colors.white12),
          const SizedBox(height: 20),
          Flex(
            direction: isDesktop ? Axis.horizontal : Axis.vertical,
            mainAxisAlignment: isDesktop ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
            children: [
              Text(
                '© 2026 Rama Foundation Manipur. All rights reserved.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white38,
                ),
              ),
              if (!isDesktop) const SizedBox(height: 12),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSocialIcon(Icons.facebook, 'https://www.facebook.com/profile.php?id=100064750836589'),
                  const SizedBox(width: 16),
                  _buildSocialIcon(Icons.camera_alt_outlined, 'https://www.instagram.com/_rama_foundation_/?igshid=MzRlODBiNWFlZA%3D%3D'),
                  const SizedBox(width: 16),
                  _buildSocialIcon(Icons.chat_bubble_outline_rounded, 'https://wa.me/+919402005803'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBrandingSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(4),
                child: Image.asset(
                  'assets/images/logo.jpg',
                  height: 40,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'RAMAF',
              style: GoogleFonts.outfit(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Rama Foundation Manipur is a registered charitable trust dedicated to executing developmental works in the interest of mankind, upliftment of backward classes, SC/ST/OBC/minorities, orphans, and rural citizens.',
          style: GoogleFonts.inter(
            fontSize: 14,
            height: 1.6,
            color: Colors.white60,
          ),
        ),
      ],
    );
  }

  Widget _buildLinksSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Links',
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        _buildFooterLink('Home', () => onItemTapped(0)),
        _buildFooterLink('Services', () => onItemTapped(1)),
        _buildFooterLink('Products', () => onItemTapped(2)),
        _buildFooterLink('Events', () => onItemTapped(3)),
        _buildFooterLink('Media', () => onItemTapped(4)),
        _buildFooterLink('About Us', () => onItemTapped(5)),
        _buildFooterLink('Contact Us', () => onItemTapped(6)),
      ],
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact',
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        _buildContactItem(
          Icons.location_on_outlined,
          'Nagamapal RIMS Road, Imphal West District, B.P.D. Lamphel, P.S. Imphal, Manipur, India 795001',
          onTap: () => _launchURL('https://maps.google.com/?q=Rama+Foundation+Imphal+Manipur'),
        ),
        _buildContactItem(
          Icons.phone_outlined,
          '+91 8787734452 / +91 9402005803',
          onTap: () => _launchURL('tel:+918787734452'),
        ),
        _buildContactItem(
          Icons.email_outlined,
          'ramafoundationmanipur@gmail.com',
          onTap: () => _launchURL('mailto:ramafoundationmanipur@gmail.com'),
        ),
      ],
    );
  }

  Widget _buildNewsletterSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Newsletter',
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Subscribe to get the latest updates on our training schedules, upcoming events, and agricultural insights.',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.white60,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: TextField(
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Your email address',
                    hintStyle: const TextStyle(color: Colors.white30, fontSize: 14),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.06),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppTheme.accentGreen, width: 1.5),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                child: const Icon(Icons.send_rounded, size: 20),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooterLink(String label, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text, {VoidCallback? onTap}) {
    return MouseRegion(
      cursor: onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: AppTheme.accentGreen, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.white70,
                    height: 1.4,
                    decoration: onTap != null ? TextDecoration.underline : TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, String url) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _launchURL(url),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white70, size: 18),
        ),
      ),
    );
  }
}
