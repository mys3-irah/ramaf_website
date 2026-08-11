import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class BoardMember {
  final String name;
  final String role;
  final String imagePath;
  final String description;

  const BoardMember({
    required this.name,
    required this.role,
    required this.imagePath,
    required this.description,
  });
}

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  final List<BoardMember> _members = const [
    BoardMember(
      name: 'Pheiroijam Saroja Devi',
      role: 'Chairperson',
      imagePath: 'assets/images/chairperson.jpg',
      description: 'Guiding the foundation\'s strategic vision and ensuring compliance with community development targets.',
    ),
    BoardMember(
      name: 'Soram Rajendra Kumar',
      role: 'Managing Director & Founder',
      imagePath: 'assets/images/md red.jpg',
      description: 'Active founder since 2000. Steers day-to-day operations, training curriculums, and local trust partnerships.',
    ),
    BoardMember(
      name: 'Lamabam Manorama Devi',
      role: 'Treasurer',
      imagePath: 'assets/images/treasurer.jpg',
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

              // Featured MD Card with Picture
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
          icon: Icons.lightbulb_outline,
          title: 'Our Vision',
          description:
              'To empower every rural family in Manipur with sustainable vocational skills in agro-tech, mushroom farming, and vermicomposting to achieve self-reliance.',
        ),
        SizedBox(height: 24),
        _HoverCard(
          icon: Icons.track_changes,
          title: 'Our Mission',
          description:
              'Executing high-yield, grassroots training, establishing community spawn banks, ensuring product buyback, and providing aid to relief camp residents.',
        ),
        SizedBox(height: 24),
        _HoverCard(
          icon: Icons.volunteer_activism_outlined,
          title: 'Community Impact',
          description:
              'Over two decades of free training sessions across 16 districts, supporting hundreds of entrepreneurs, women SHGs, and agricultural innovators.',
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
        border: Border.all(color: AppTheme.primaryGreen.withValues(alpha: 0.15), width: 1.5),
        boxShadow: AppTheme.softShadow,
      ),
      padding: const EdgeInsets.all(32),
      child: Flex(
        direction: isWide ? Axis.horizontal : Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Founder & MD Photo
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.primaryGreen, width: 3),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryGreen.withValues(alpha: 0.25),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipOval(
              child: md.imagePath.isNotEmpty
                  ? Image.asset(
                      md.imagePath,
                      fit: BoxFit.cover,
                      width: 130,
                      height: 130,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppTheme.mintGreen,
                          child: const Icon(Icons.person, size: 60, color: AppTheme.primaryGreen),
                        );
                      },
                    )
                  : Container(
                      color: AppTheme.mintGreen,
                      child: const Icon(Icons.person, size: 60, color: AppTheme.primaryGreen),
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
                    color: AppTheme.primaryGreen.withValues(alpha: 0.1),
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
          // Member Image / Avatar
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppTheme.mintGreen,
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.primaryGreen.withValues(alpha: 0.2), width: 1.5),
            ),
            child: ClipOval(
              child: member.imagePath.isNotEmpty
                  ? Image.asset(
                      member.imagePath,
                      fit: BoxFit.cover,
                      width: 64,
                      height: 64,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.person_outline_rounded, size: 32, color: AppTheme.primaryGreen),
                        );
                      },
                    )
                  : const Center(
                      child: Icon(Icons.person_outline_rounded, size: 32, color: AppTheme.primaryGreen),
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
        transform: Matrix4.translationValues(0, _isHovered ? -6.0 : 0.0, 0),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.backgroundCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered ? AppTheme.accentGreen.withValues(alpha: 0.3) : Colors.transparent,
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
