import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class MediaItem {
  final String id;
  final String title;
  final String category; // 'Press', 'Photo', 'Video'
  final String date;
  final String description;
  final String imagePath;
  final IconData fallbackIcon;

  const MediaItem({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.description,
    required this.imagePath,
    required this.fallbackIcon,
  });
}

class MediaSection extends StatefulWidget {
  const MediaSection({super.key});

  @override
  State<MediaSection> createState() => _MediaSectionState();
}

class _MediaSectionState extends State<MediaSection> {
  String _selectedCategory = 'All';

  final List<MediaItem> _mediaList = const [
    MediaItem(
      id: 'm1',
      title: 'Mushroom Vocational Campaign Covered by Sangai Express',
      category: 'Press',
      date: 'April 2023',
      description: 'Sangai Express featured a detailed page report on our free training drive for under-privileged rural women in Imphal West.',
      imagePath: '',
      fallbackIcon: Icons.newspaper_rounded,
    ),
    MediaItem(
      id: 'm2',
      title: 'Poknapham Press Coverage: Vocational Support in Manipur',
      category: 'Press',
      date: 'November 2023',
      description: 'Poknapham highlights the Trust\'s efforts to establish spawn banks and buyback guarantees to secure local grower livelihoods.',
      imagePath: '',
      fallbackIcon: Icons.menu_book_rounded,
    ),
    MediaItem(
      id: 'm3',
      title: 'Mushroom Inoculation Training Workshop',
      category: 'Photo',
      date: 'December 2023',
      description: 'Farming candidates learning sterilization and substrate inoculation at our main campus laboratory.',
      imagePath: 'assets/images/WhatsApp Image 2023-12-20 at 14.16.36_a40e1cbc.jpg', // Local Image!
      fallbackIcon: Icons.camera_alt_outlined,
    ),
    MediaItem(
      id: 'm4',
      title: 'Vermicompost Setup Demonstration Garden',
      category: 'Photo',
      date: 'March 2024',
      description: 'Rural coordinators illustrating earthworm-cast beds creation to organic growers.',
      imagePath: '',
      fallbackIcon: Icons.yard_outlined,
    ),
    MediaItem(
      id: 'm5',
      title: 'Commercial Oyster Grow House Setup',
      category: 'Video',
      date: 'January 2024',
      description: 'Video guide showing micro-humidity sprays and bamboo racks layout inside commercial grow rooms.',
      imagePath: '',
      fallbackIcon: Icons.play_circle_fill_rounded,
    ),
    MediaItem(
      id: 'm6',
      title: 'Advanced Fruit Bud Grafting Steps',
      category: 'Video',
      date: 'May 2024',
      description: 'Step-by-step video demonstration of wedge and bud grafting for apple and dragon fruit plants.',
      imagePath: '',
      fallbackIcon: Icons.play_circle_fill_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final List<String> categories = ['All', 'Press', 'Photo', 'Video'];

    final List<MediaItem> filteredMedia = _selectedCategory == 'All'
        ? _mediaList
        : _mediaList.where((m) => m.category == _selectedCategory).toList();

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header
              Text(
                'MEDIA CENTRE & PRESS',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.accentGreen,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Our Work & News Coverage',
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
              const SizedBox(height: 40),

              // Categories Filters
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: categories.map((cat) {
                  final bool isSelected = _selectedCategory == cat;
                  String displayLabel = cat;
                  if (cat == 'Press') displayLabel = 'Press Releases';
                  if (cat == 'Photo') displayLabel = 'Work Photos';
                  if (cat == 'Video') displayLabel = 'Videos';
                  
                  return ChoiceChip(
                    label: Text(displayLabel),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedCategory = cat);
                      }
                    },
                    selectedColor: AppTheme.primaryGreen,
                    backgroundColor: AppTheme.mintGreen,
                    labelStyle: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isSelected ? Colors.white : AppTheme.primaryGreen,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide.none,
                    ),
                    showCheckmark: false,
                  );
                }).toList(),
              ),
              const SizedBox(height: 50),

              // Media items grid
              LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = 1;
                  if (width > 900) {
                    crossAxisCount = 3;
                  } else if (width > 600) {
                    crossAxisCount = 2;
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: filteredMedia.length,
                    itemBuilder: (context, index) {
                      return _MediaCard(
                        item: filteredMedia[index],
                        onTap: () => _handleItemClick(context, filteredMedia[index]),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleItemClick(BuildContext context, MediaItem item) {
    if (item.category == 'Video') {
      _showVideoPlayer(context, item);
    } else if (item.category == 'Press') {
      _showPressRelease(context, item);
    } else {
      _showPhotoZoom(context, item);
    }
  }

  void _showVideoPlayer(BuildContext context, MediaItem item) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              contentPadding: EdgeInsets.zero,
              clipBehavior: Clip.antiAlias,
              content: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                color: Colors.black,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Mock Video Screen
                    Container(
                      height: 300,
                      color: Colors.black87,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(Icons.movie_creation_outlined, size: 72, color: Colors.white.withOpacity(0.1)),
                          Positioned(
                            bottom: 20,
                            left: 20,
                            right: 20,
                            child: Column(
                              children: [
                                Row(
                                  children: const [
                                    Text('0:12', style: TextStyle(color: Colors.white70, fontSize: 12)),
                                    Spacer(),
                                    Text('2:45', style: TextStyle(color: Colors.white70, fontSize: 12)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                LinearProgressIndicator(
                                  value: 0.08,
                                  backgroundColor: Colors.white24,
                                  color: AppTheme.accentGreen,
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: CircleAvatar(
                              radius: 36,
                              backgroundColor: AppTheme.primaryGreen,
                              child: const Icon(Icons.pause, color: Colors.white, size: 36),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.description,
                            style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textMuted),
                          ),
                          const SizedBox(height: 24),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Close Player'),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showPressRelease(BuildContext context, MediaItem item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Row(
            children: [
              Icon(Icons.newspaper_rounded, color: AppTheme.primaryGreen),
              const SizedBox(width: 12),
              Text('Press Clipping', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.date.toUpperCase(),
                  style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.accentGreen),
                ),
                const SizedBox(height: 8),
                Text(
                  item.title,
                  style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                ),
                const SizedBox(height: 16),
                Text(
                  item.description,
                  style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textMuted, height: 1.5),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 120,
                  width: double.infinity,
                  color: AppTheme.backgroundCard,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.picture_as_pdf_outlined, color: AppTheme.primaryGreen, size: 36),
                        const SizedBox(height: 8),
                        Text(
                          'Download Newspaper Page PDF',
                          style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showPhotoZoom(BuildContext context, MediaItem item) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          clipBehavior: Clip.antiAlias,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (item.imagePath.isNotEmpty)
                  Image.asset(item.imagePath, fit: BoxFit.cover, width: double.infinity)
                else
                  Container(
                    height: 300,
                    width: double.infinity,
                    color: AppTheme.mintGreen,
                    child: Icon(item.fallbackIcon, size: 72, color: AppTheme.primaryGreen),
                  ),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(item.description, style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textMuted)),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Close'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MediaCard extends StatefulWidget {
  final MediaItem item;
  final VoidCallback onTap;

  const _MediaCard({required this.item, required this.onTap});

  @override
  State<_MediaCard> createState() => _MediaCardState();
}

class _MediaCardState extends State<_MediaCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _isHovered ? AppTheme.accentGreen.withOpacity(0.3) : Colors.black.withOpacity(0.04),
              width: 1.5,
            ),
            boxShadow: _isHovered ? AppTheme.hoverShadow : AppTheme.softShadow,
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    if (widget.item.imagePath.isNotEmpty)
                      AnimatedScale(
                        scale: _isHovered ? 1.08 : 1.0,
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(widget.item.imagePath),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    else
                      Container(
                        width: double.infinity,
                        color: AppTheme.backgroundCard,
                        child: Icon(
                          widget.item.fallbackIcon,
                          size: 48,
                          color: _isHovered ? AppTheme.primaryGreen : AppTheme.primaryGreen.withOpacity(0.6),
                        ),
                      ),
                    
                    // Media Category badge tag
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: widget.item.category == 'Press'
                              ? Colors.blue.shade800
                              : widget.item.category == 'Video'
                                  ? Colors.red.shade800
                                  : AppTheme.primaryGreen,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          widget.item.category.toUpperCase(),
                          style: GoogleFonts.outfit(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.date.toUpperCase(),
                      style: GoogleFonts.outfit(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.accentGreen,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.item.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppTheme.textMuted,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
