import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class WorkSection extends StatelessWidget {
  const WorkSection({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isDesktop = width > 950;

    return Container(
      width: double.infinity,
      color: AppTheme.backgroundCard, // Subtle off-white/greenish background
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Column(
                  children: [
                    Text(
                      'SERVICES',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.accentGreen,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Our Support Areas',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 4,
                      width: 60,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),

              // Grid / Column Layout
              LayoutBuilder(
                builder: (context, constraints) {
                  if (isDesktop) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Expanded(
                          child: _FocusCard(
                            icon: Icons.school_outlined,
                            title: 'Training Programs',
                            subtitle: 'Practical Skills Development',
                            description: 'Comprehensive residential, group, online, and offline training packages to build real micro-enterprise capability.',
                            points: [
                              'Mushroom Cultivation & Spawn Production',
                              'Vermicompost, Food Processing / Value Add',
                              'Biofloc, Hydroponics & Eel farming',
                              'Nursery setup (Dragon Fruit, Apple, Strawberry)',
                              'Computers, Blogspot, & Accounting systems',
                            ],
                          ),
                        ),
                        SizedBox(width: 24),
                        Expanded(
                          child: _FocusCard(
                            icon: Icons.storefront_rounded,
                            title: 'Assist Marketing',
                            subtitle: 'Market Connections',
                            description: 'Establishing micro-channels and buyback operations for sustainable trade development.',
                            points: [
                              'Assistance in selling fresh/dry mushrooms',
                              'Organic fruits & vegetable micro-markets',
                              'Sales channels for handloom garments',
                              'Local handicraft marketing support',
                            ],
                          ),
                        ),
                        SizedBox(width: 24),
                        Expanded(
                          child: _FocusCard(
                            icon: Icons.account_balance_wallet_outlined,
                            title: 'Financial Assistance',
                            subtitle: 'Economic Integration',
                            description: 'Guiding rural entrepreneurs through financial frameworks to secure funding, build projects, and find employment.',
                            points: [
                              'Project creation & business layout plans',
                              'Support applying for private/govt. loans',
                              'Providing valid rate quotations for loans',
                              'Fostering work-from-home operations',
                              'Job creation matching qualifications',
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: const [
                        _FocusCard(
                          icon: Icons.school_outlined,
                          title: 'Training Programs',
                          subtitle: 'Practical Skills Development',
                          description: 'Comprehensive residential, group, online, and offline training packages to build real micro-enterprise capability.',
                          points: [
                            'Mushroom Cultivation & Spawn Production',
                            'Vermicompost, Food Processing / Value Add',
                            'Biofloc, Hydroponics & Eel farming',
                            'Nursery setup (Dragon Fruit, Apple, Strawberry)',
                            'Computers, Blogspot, & Accounting systems',
                          ],
                        ),
                        SizedBox(height: 32),
                        _FocusCard(
                          icon: Icons.storefront_rounded,
                          title: 'Assist Marketing',
                          subtitle: 'Market Connections',
                          description: 'Establishing micro-channels and buyback operations for sustainable trade development.',
                          points: [
                            'Assistance in selling fresh/dry mushrooms',
                            'Organic fruits & vegetable micro-markets',
                            'Sales channels for handloom garments',
                            'Local handicraft marketing support',
                          ],
                        ),
                        SizedBox(height: 32),
                        _FocusCard(
                          icon: Icons.account_balance_wallet_outlined,
                          title: 'Financial Assistance',
                          subtitle: 'Economic Integration',
                          description: 'Guiding rural entrepreneurs through financial frameworks to secure funding, build projects, and find employment.',
                          points: [
                            'Project creation & business layout plans',
                            'Support applying for private/govt. loans',
                            'Providing valid rate quotations for loans',
                            'Fostering work-from-home operations',
                            'Job creation matching qualifications',
                          ],
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FocusCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String description;
  final List<String> points;

  const _FocusCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.points,
  });

  @override
  State<_FocusCard> createState() => _FocusCardState();
}

class _FocusCardState extends State<_FocusCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        transform: _isHovered ? (Matrix4.identity()..translate(0, -8, 0)) : Matrix4.identity(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isHovered ? AppTheme.accentGreen.withOpacity(0.4) : Colors.black.withOpacity(0.04),
            width: 1.5,
          ),
          boxShadow: _isHovered ? AppTheme.hoverShadow : AppTheme.softShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _isHovered ? AppTheme.primaryGreen : AppTheme.mintGreen,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                widget.icon,
                color: _isHovered ? Colors.white : AppTheme.primaryGreen,
                size: 32,
              ),
            ),
            const SizedBox(height: 24),
            
            // Header
            Text(
              widget.title,
              style: GoogleFonts.outfit(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.subtitle.toUpperCase(),
              style: GoogleFonts.outfit(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppTheme.accentGreen,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 16),
            
            // Paragraph
            Text(
              widget.description,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.textMuted,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            
            const Divider(color: Colors.black12),
            const SizedBox(height: 16),
            
            // Bullet Points
            ...widget.points.map((pt) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 6.0),
                    child: Icon(Icons.circle, color: AppTheme.accentGreen, size: 6),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      pt,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textDark.withOpacity(0.85),
                      ),
                    ),
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }
}
