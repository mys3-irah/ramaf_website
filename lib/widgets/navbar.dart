import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  final int activeIndex;
  final Function(int) onItemTapped;
  final VoidCallback onMenuPressed;

  const NavBar({
    super.key,
    required this.activeIndex,
    required this.onItemTapped,
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isDesktop = width > 950;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: Colors.white.withOpacity(0.5),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo/Brand Section
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => onItemTapped(0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/images/logo.jpg',
                              height: 40,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'RAMA',
                                style: GoogleFonts.outfit(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.primaryGreen,
                                  letterSpacing: 1.5,
                                  height: 1.0,
                                ),
                              ),
                              Text(
                                'FOUNDATION',
                                style: GoogleFonts.outfit(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.accentGreen,
                                  letterSpacing: 2.0,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Desktop Navigation Items
                  if (isDesktop)
                    Row(
                      children: [
                        _NavBarItem(title: 'Home', isActive: activeIndex == 0, onTap: () => onItemTapped(0)),
                        _NavBarItem(title: 'Services', isActive: activeIndex == 1, onTap: () => onItemTapped(1)),
                        _NavBarItem(title: 'Products', isActive: activeIndex == 2, onTap: () => onItemTapped(2)),
                        _NavBarItem(title: 'Events', isActive: activeIndex == 3, onTap: () => onItemTapped(3)),
                        _NavBarItem(title: 'Media', isActive: activeIndex == 4, onTap: () => onItemTapped(4)),
                        _NavBarItem(title: 'About Us', isActive: activeIndex == 5, onTap: () => onItemTapped(5)),
                        _NavBarItem(title: 'Contact Us', isActive: activeIndex == 6, onTap: () => onItemTapped(6)),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () => onItemTapped(6), // Go to contact
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            minimumSize: Size.zero,
                          ),
                          child: const Text('Get Involved', style: TextStyle(fontSize: 14)),
                        ),
                      ],
                    )
                  else
                    IconButton(
                      icon: const Icon(Icons.menu, color: AppTheme.primaryGreen, size: 28),
                      onPressed: onMenuPressed,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class _NavBarItem extends StatefulWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<_NavBarItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 14),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title,
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: widget.isActive ? FontWeight.w700 : FontWeight.w500,
                  color: widget.isActive 
                      ? AppTheme.primaryGreen 
                      : (_isHovered ? AppTheme.primaryGreenLight : AppTheme.textMuted),
                ),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 2,
                width: widget.isActive ? 20 : (_isHovered ? 12 : 0),
                color: AppTheme.primaryGreen,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
