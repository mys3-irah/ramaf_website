import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class BoardMember {
  final String name;
  final String role;
  final String initials;
  final String description;

  const BoardMember({
    required this.name,
    required this.role,
    required this.initials,
    required this.description,
  });
}

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  final List<BoardMember> _members = const [
    BoardMember(
      name: 'Pheiroijam Saroja Devi',
      role: 'Chairperson',
      initials: 'SD',
      description: 'Guiding the foundation\'s strategic vision and ensuring compliance with community development targets.',
    ),
    BoardMember(
      name: 'Soram Rajendra Kumar',
      role: 'Managing Director & Founder',
      initials: 'RK',
      description: 'Active founder since 2000. Steers day-to-day operations, training curriculums, and local trust partnerships.',
    ),
    BoardMember(
      name: 'Lamabam Manorama Devi',
      role: 'Treasurer',
      initials: 'MD',
      description: 'Oversees financial assistance programs, budget allocations, and organic farm project audit streams.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isDesktop = width > 900;

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header
              Center(
                child: Column(
                  children: [
                    Text(
                      'ABOUT US',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.accentGreen,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Decades of Service & Empowerment',
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

              // 2. Content Split Layout (Story & Core Cards)
              LayoutBuilder(
                builder: (context, constraints) {
                  if (isDesktop) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildStoryPart(context)),
                        const SizedBox(width: 60),
                        Expanded(child: _buildCardsPart(context)),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        _buildStoryPart(context),
                        const SizedBox(height: 50),
                        _buildCardsPart(context),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 80),
              
              const Divider(color: Colors.black12),
              const SizedBox(height: 60),

              // 3. Board Members Sub-Section
              Center(
                child: Column(
                  children: [
                    Text(
                      'BOARD MEMBERS',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.accentGreen,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Our Leadership Team',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 3,
                      width: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen,
                        borderRadius: BorderRadius.circular(1.5),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // Featured MD Card
              Center(child: _buildMDCard(context, _members[1])),
              const SizedBox(height: 32),

              // Executive Committee Cards
              LayoutBuilder(
                builder: (context, constraints) {
                  if (isDesktop) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildMemberCard(context, _members[0])),
                        const SizedBox(width: 24),
                        Expanded(child: _buildMemberCard(context, _members[2])),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        _buildMemberCard(context, _members[0]),
                        const SizedBox(height: 24),
                        _buildMemberCard(context, _members[2]),
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

  Widget _buildStoryPart(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Brief History of the Trust',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 20),
        Text(
          'The Trust was originally started in the year 2000 by Mr. Soram Rajendra Kumar. The credit for the current position of the Trust goes to his hard work, commitment and dedication. He has always taken the initiative wherever needed to take the trust forward and help it grow. The actual declaration of this charitable trust was made on the 9th of December, 2005 by Mr. Soram Rajendra Kumar, a resident of Nagamapal, RIMS Road, Imphal West District, Manipur.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 16),
        Text(
          'The founder was always desirous of creating a trust under India\'s Trust Act, 1882 for the purpose of executing developmental works irrespective of caste, creed, community and religion in the interest of mankind. Today, the trust acts as a helping hand to society, socially and economically.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 32),
        Text(
          'Relief Camp & Health Awareness',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Text(
          'Free mushroom cultivation training is provided to relief camps located in various parts of Manipur. Health checkups and awareness programmes are also provided periodically with the help of the Director of RIMS Manipur.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
        _buildCheckItem(context, 'Pioneering organic cultivation training programs in Imphal'),
        _buildCheckItem(context, 'Free skill development for relief camp residents'),
        _buildCheckItem(context, 'Periodic health camps in association with RIMS Manipur'),
      ],
    );
  }

  Widget _buildCheckItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, color: AppTheme.accentGreen, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppTheme.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardsPart(BuildContext context) {
    return Column(
      children: const [
        _HoverCard(
          icon: Icons.eco_outlined,
          title: 'Mission Statement',
          description: 'To establish and administer different institutions or centres and collaborate with any like-minded organisations in order to enable overall development activities, schemes, and programs.',
        ),
        SizedBox(height: 24),
        _HoverCard(
          icon: Icons.lightbulb_outline_rounded,
          title: 'Our Vision',
          description: 'To promote activities in the field of Health, Education, Economy, and Social to bring service, unity, and prosperity for the upliftment of backward classes including SC/ST/OBC, disabled individuals, orphans, and rural citizens.',
        ),
        SizedBox(height: 24),
        _HoverCard(
          icon: Icons.favorite_border_rounded,
          title: 'Inclusive Focus',
          description: 'Uplifting minority groups and educationally backward classes in rural areas in particular, and the public in general, irrespective of caste, creed, community, and religion.',
        ),
      ],
    );
  }

  Widget _buildMDCard(BuildContext context, BoardMember md) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isWide = screenWidth > 800;

    return Container(
      constraints: const BoxConstraints(maxWidth: 800),
      decoration: BoxDecoration(
        color: AppTheme.backgroundCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.1), width: 1.5),
        boxShadow: AppTheme.softShadow,
      ),
      padding: const EdgeInsets.all(32),
      child: Flex(
        direction: isWide ? Axis.horizontal : Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryGreen, AppTheme.accentGreen],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryGreen.withOpacity(0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: Text(
                md.initials,
                style: GoogleFonts.outfit(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 32, height: 24),
          Expanded(
            flex: isWide ? 1 : 0,
            child: Column(
              crossAxisAlignment: isWide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    md.role.toUpperCase(),
                    style: GoogleFonts.outfit(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryGreen,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  md.name,
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  md.description,
                  textAlign: isWide ? TextAlign.left : TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppTheme.textMuted,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberCard(BuildContext context, BoardMember member) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundCard,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.softShadow,
      ),
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.mintGreen,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                member.initials,
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryGreen,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.role,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.accentGreen,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  member.name,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  member.description,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppTheme.textMuted,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HoverCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;

  const _HoverCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        transform: _isHovered ? (Matrix4.identity()..translate(0, -6, 0)) : Matrix4.identity(),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.backgroundCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered ? AppTheme.accentGreen.withOpacity(0.3) : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: _isHovered ? AppTheme.hoverShadow : AppTheme.softShadow,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _isHovered ? AppTheme.primaryGreen : AppTheme.mintGreen,
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.icon,
                color: _isHovered ? Colors.white : AppTheme.primaryGreen,
                size: 26,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.description,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppTheme.textMuted,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
