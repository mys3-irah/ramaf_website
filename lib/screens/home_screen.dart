import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/navbar.dart';
import '../widgets/footer.dart';
import '../sections/hero_section.dart';
import '../sections/about_section.dart';
import '../sections/work_section.dart';
import '../sections/products_section.dart';
import '../sections/events_section.dart';
import '../sections/media_section.dart';
import '../sections/contact_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  
  // Section Keys for smooth scrolling (7 sections total)
  final List<GlobalKey> _sectionKeys = List.generate(7, (index) => GlobalKey());
  
  int _activeIndex = 0;
  bool _isScrollingAutomatically = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isScrollingAutomatically) return;
    
    int newIndex = 0;
    double minDistance = double.maxFinite;

    for (int i = 0; i < _sectionKeys.length; i++) {
      final context = _sectionKeys[i].currentContext;
      if (context != null) {
        final RenderBox? box = context.findRenderObject() as RenderBox?;
        if (box != null) {
          final position = box.localToGlobal(Offset.zero);
          final double distance = position.dy.abs();
          if (distance < minDistance) {
            minDistance = distance;
            newIndex = i;
          }
        }
      }
    }

    if (newIndex != _activeIndex) {
      setState(() {
        _activeIndex = newIndex;
      });
    }
  }

  void _scrollToSection(int index) {
    setState(() {
      _activeIndex = index;
      _isScrollingAutomatically = true;
    });

    final context = _sectionKeys[index].currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      ).then((_) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            setState(() => _isScrollingAutomatically = false);
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isDesktop = width > 950;

    return Scaffold(
      key: _scaffoldKey,
      drawer: !isDesktop ? _buildMobileDrawer() : null,
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  // 0. Hero Section
                  HeroSection(
                    key: _sectionKeys[0],
                    onLearnMorePressed: () => _scrollToSection(1), // Scrolls to Services
                    onContactPressed: () => _scrollToSection(6),  // Scrolls to Contact Us
                  ),
                  
                  // 1. Services Section
                  WorkSection(key: _sectionKeys[1]),
                  
                  // 2. Products Section
                  ProductsSection(key: _sectionKeys[2]),
                  
                  // 3. Events Section
                  EventsSection(key: _sectionKeys[3]),

                  // 4. Media Section
                  MediaSection(key: _sectionKeys[4]),
                  
                  // 5. About Us Section (including board members)
                  AboutSection(key: _sectionKeys[5]),
                  
                  // 6. Contact Section
                  ContactSection(key: _sectionKeys[6]),
                  
                  // Footer
                  Footer(onItemTapped: _scrollToSection),
                ],
              ),
            ),
          ),
          
          // Floating Top Navbar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: NavBar(
              activeIndex: _activeIndex,
              onItemTapped: _scrollToSection,
              onMenuPressed: () {
                if (_scaffoldKey.currentState != null) {
                  (_scaffoldKey.currentState as ScaffoldState).openDrawer();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileDrawer() {
    final List<Map<String, dynamic>> items = [
      {'title': 'Home', 'icon': Icons.home_outlined},
      {'title': 'Services', 'icon': Icons.school_outlined},
      {'title': 'Products', 'icon': Icons.shopping_bag_outlined},
      {'title': 'Events', 'icon': Icons.event_outlined},
      {'title': 'Media', 'icon': Icons.perm_media_outlined},
      {'title': 'About Us', 'icon': Icons.info_outline_rounded},
      {'title': 'Contact Us', 'icon': Icons.mail_outline_rounded},
    ];

    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/logo.jpg',
                      height: 36,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'RAMAF',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final bool isActive = _activeIndex == index;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      leading: Icon(
                        items[index]['icon'] as IconData,
                        color: isActive ? AppTheme.primaryGreen : AppTheme.textMuted,
                      ),
                      title: Text(
                        items[index]['title'] as String,
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                          color: isActive ? AppTheme.primaryGreen : AppTheme.textDark,
                        ),
                      ),
                      selected: isActive,
                      selectedTileColor: AppTheme.mintGreen,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      onTap: () {
                        Navigator.of(context).pop();
                        _scrollToSection(index);
                      },
                    ),
                  );
                },
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                'Rama Foundation Manipur\nRegistered NGO, India',
                style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textMuted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
