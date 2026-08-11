import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/media_item.dart';
import '../services/firebase_service.dart';
import '../theme/app_theme.dart';

class MediaSection extends StatefulWidget {
  const MediaSection({super.key});

  @override
  State<MediaSection> createState() => _MediaSectionState();
}

class _MediaSectionState extends State<MediaSection> {
  String _selectedCategory = 'All';

  // Seed / fallback items for when Firestore is initializing or offline
  final List<MediaItem> _fallbackMediaList = const [
    MediaItem(
      id: 'm_training_apr25',
      title: '2-Day Practical Mushroom Cultivation & Spawning Workshop',
      category: 'Photo',
      date: '28 - 29 April 2025',
      description: 'Comprehensive 2-day practical training workshop on oyster & button mushroom cultivation, substrate preparation, sterilization, spawn inoculation, and climate control at RAMA Foundation Training Center.',
      mediaUrl: 'https://res.cloudinary.com/zu7a4qdi/image/upload/v1786432554/WhatsApp_Image_2025-04-30_at_13.22.11_ff6b99ef.jpg',
      galleryUrls: [
        'https://res.cloudinary.com/zu7a4qdi/image/upload/v1786432554/WhatsApp_Image_2025-04-30_at_13.22.11_ff6b99ef.jpg',
        'https://res.cloudinary.com/zu7a4qdi/image/upload/v1786432554/WhatsApp_Image_2025-04-30_at_13.14.38_aa7473f3.jpg',
        'https://res.cloudinary.com/zu7a4qdi/image/upload/v1786432553/WhatsApp_Image_2025-04-30_at_13.28.54_bf029b72.jpg',
        'https://res.cloudinary.com/zu7a4qdi/image/upload/v1786432552/WhatsApp_Image_2025-04-30_at_13.29.13_1354dbac.jpg',
        'https://res.cloudinary.com/zu7a4qdi/image/upload/v1786432551/WhatsApp_Image_2025-04-30_at_13.29.01_f347a8c9.jpg',
        'https://res.cloudinary.com/zu7a4qdi/image/upload/v1786432550/WhatsApp_Image_2025-04-30_at_13.29.10_c4fab950.jpg',
        'https://res.cloudinary.com/zu7a4qdi/image/upload/v1786432550/WhatsApp_Image_2025-04-30_at_13.29.13_494ec78f.jpg',
        'https://res.cloudinary.com/zu7a4qdi/image/upload/v1786432550/WhatsApp_Image_2025-04-30_at_13.29.08_997ecf49.jpg',
        'https://res.cloudinary.com/zu7a4qdi/image/upload/v1786432549/WhatsApp_Image_2025-04-30_at_13.29.15_f6d31513.jpg',
      ],
      videoUrl: 'https://res.cloudinary.com/zu7a4qdi/video/upload/v1786432742/WhatsApp_Video_2025-04-30_at_13.47.28_6e776ecb.mp4',
      externalLink: 'https://res.cloudinary.com/zu7a4qdi/video/upload/v1786432742/WhatsApp_Video_2025-04-30_at_13.47.28_6e776ecb.mp4',
      fallbackIcon: Icons.photo_library_outlined,
    ),
    MediaItem(
      id: 'm_training_apr25_video',
      title: 'Mushroom Spawning & Bedding Practical Training (Live Session)',
      category: 'Video',
      date: '28 - 29 April 2025',
      description: 'Video recording showing practical hands-on substrate bagging, straw sterilization, and spawn inoculation demonstrated to trainees.',
      mediaUrl: 'https://res.cloudinary.com/zu7a4qdi/image/upload/v1786432551/WhatsApp_Image_2025-04-30_at_13.29.01_f347a8c9.jpg',
      videoUrl: 'https://res.cloudinary.com/zu7a4qdi/video/upload/v1786432742/WhatsApp_Video_2025-04-30_at_13.47.28_6e776ecb.mp4',
      externalLink: 'https://res.cloudinary.com/zu7a4qdi/video/upload/v1786432742/WhatsApp_Video_2025-04-30_at_13.47.28_6e776ecb.mp4',
      fallbackIcon: Icons.play_circle_fill_rounded,
    ),
    MediaItem(
      id: 'm_sana',
      title: 'Sanaleibak Press Release: Vocational Training Initiative',
      category: 'Press',
      date: 'Recent Feature',
      description: 'Sanaleibak Daily featured report covering RAMA Foundation\'s sustainable agro-farming drives and vocational programs across Manipur.',
      mediaUrl: 'https://res.cloudinary.com/zu7a4qdi/image/upload/v1786431245/sana.jpg',
      documentUrl: 'https://res.cloudinary.com/zu7a4qdi/image/upload/v1786431245/sana.jpg',
      fallbackIcon: Icons.newspaper_rounded,
    ),
    MediaItem(
      id: 'm1',
      title: 'Mushroom Vocational Campaign Covered by Sangai Express',
      category: 'Press',
      date: 'April 2023',
      description: 'Sangai Express featured a detailed page report on our free training drive for under-privileged rural women in Imphal West.',
      mediaUrl: '',
      fallbackIcon: Icons.newspaper_rounded,
    ),
    MediaItem(
      id: 'm2',
      title: 'Poknapham Press Coverage: Vocational Support in Manipur',
      category: 'Press',
      date: 'November 2023',
      description: 'Poknapham highlights the Trust\'s efforts to establish spawn banks and buyback guarantees to secure local grower livelihoods.',
      mediaUrl: '',
      fallbackIcon: Icons.menu_book_rounded,
    ),
    MediaItem(
      id: 'm3',
      title: 'Mushroom Inoculation Training Workshop',
      category: 'Photo',
      date: 'December 2023',
      description: 'Farming candidates learning sterilization and substrate inoculation at our main campus laboratory.',
      mediaUrl: 'assets/images/WhatsApp Image 2023-12-20 at 14.16.36_a40e1cbc.jpg',
      fallbackIcon: Icons.camera_alt_outlined,
    ),
    MediaItem(
      id: 'm4',
      title: 'Vermicompost Setup Demonstration Garden',
      category: 'Photo',
      date: 'March 2024',
      description: 'Rural coordinators illustrating earthworm-cast beds creation to organic growers.',
      mediaUrl: '',
      fallbackIcon: Icons.yard_outlined,
    ),
    MediaItem(
      id: 'm5',
      title: 'Commercial Oyster Grow House Setup',
      category: 'Video',
      date: 'January 2024',
      description: 'Video guide showing micro-humidity sprays and bamboo racks layout inside commercial grow rooms.',
      mediaUrl: '',
      fallbackIcon: Icons.play_circle_fill_rounded,
    ),
    MediaItem(
      id: 'm6',
      title: 'Advanced Fruit Bud Grafting Steps',
      category: 'Video',
      date: 'May 2024',
      description: 'Step-by-step video demonstration of wedge and bud grafting for apple and dragon fruit plants.',
      mediaUrl: '',
      fallbackIcon: Icons.play_circle_fill_rounded,
    ),
  ];

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Could not launch URL $url: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final List<String> categories = ['All', 'Press', 'Photo', 'Video'];

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
              // Section Subtitle & Title
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
              const SizedBox(height: 16),
              Text(
                'Access our latest newspaper press clippings, workshop event galleries, and training video streams.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppTheme.textMuted,
                ),
              ),
              const SizedBox(height: 36),

              // Categories Filters
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
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

              // Dynamic Firestore Stream + Fallback Content
              StreamBuilder<List<MediaItem>>(
                stream: FirebaseService().streamMediaItems(),
                builder: (context, snapshot) {
                  final List<MediaItem> cloudItems = snapshot.data ?? [];
                  
                  // Merge Cloud items (at top) with curated fallback items
                  final List<MediaItem> combinedList = [
                    ...cloudItems,
                    ..._fallbackMediaList.where(
                      (f) => !cloudItems.any((c) => c.title.toLowerCase() == f.title.toLowerCase()),
                    ),
                  ];

                  final List<MediaItem> filteredMedia = _selectedCategory == 'All'
                      ? combinedList
                      : combinedList.where((m) => m.category == _selectedCategory).toList();

                  if (filteredMedia.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        children: [
                          Icon(Icons.perm_media_outlined, size: 48, color: Colors.grey.shade400),
                          const SizedBox(height: 12),
                          Text(
                            'No media available in "$_selectedCategory"',
                            style: GoogleFonts.outfit(fontSize: 16, color: AppTheme.textMuted),
                          ),
                        ],
                      ),
                    );
                  }

                  return LayoutBuilder(
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
                          childAspectRatio: 0.88,
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
    } else if (item.category == 'Press' || item.category == 'Document') {
      _showPressRelease(context, item);
    } else {
      _showPhotoZoom(context, item);
    }
  }

  void _showVideoPlayer(BuildContext context, MediaItem item) {
    showDialog(
      context: context,
      builder: (context) {
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
                // Video Screen Header
                Container(
                  height: 280,
                  color: Colors.black87,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(Icons.movie_creation_outlined, size: 72, color: Colors.white.withValues(alpha: 0.1)),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        right: 20,
                        child: Column(
                          children: [
                            Row(
                              children: const [
                                Text('RAMAF Media Stream', style: TextStyle(color: Colors.white70, fontSize: 12)),
                                Spacer(),
                                Text('Cloud Hosted', style: TextStyle(color: AppTheme.accentGreen, fontSize: 12)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const LinearProgressIndicator(
                              value: 0.45,
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
                          child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 42),
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
                        style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textMuted, height: 1.4),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (item.externalLink != null && item.externalLink!.isNotEmpty)
                            ElevatedButton.icon(
                              onPressed: () => _openUrl(item.externalLink!),
                              icon: const Icon(Icons.open_in_new, size: 16),
                              label: const Text('Watch on YouTube / Web'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade700,
                                foregroundColor: Colors.white,
                              ),
                            )
                          else
                            const SizedBox(),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Close'),
                          ),
                        ],
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

  void _showPressRelease(BuildContext context, MediaItem item) {
    showDialog(
      context: context,
      builder: (context) {
        final hasDoc = item.documentUrl != null && item.documentUrl!.isNotEmpty;
        final hasExt = item.externalLink != null && item.externalLink!.isNotEmpty;

        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.mintGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  item.category == 'Document' ? Icons.picture_as_pdf_rounded : Icons.newspaper_rounded,
                  color: AppTheme.primaryGreen,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.category == 'Document' ? 'Official Publication' : 'Press Release & Clipping',
                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ],
          ),
          content: Container(
            constraints: const BoxConstraints(maxWidth: 540),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.date.toUpperCase(),
                    style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.accentGreen, letterSpacing: 1.1),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.title,
                    style: GoogleFonts.outfit(fontSize: 19, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                  ),
                  const SizedBox(height: 14),

                  // Image preview if attached
                  if (item.mediaUrl.isNotEmpty) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: item.mediaUrl.startsWith('http')
                          ? Image.network(
                              item.mediaUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 200,
                              errorBuilder: (context, error, stackTrace) => const SizedBox(),
                            )
                          : Image.asset(
                              item.mediaUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 200,
                              errorBuilder: (context, error, stackTrace) => const SizedBox(),
                            ),
                    ),
                    const SizedBox(height: 14),
                  ],

                  Text(
                    item.description,
                    style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textMuted, height: 1.5),
                  ),
                  const SizedBox(height: 20),

                  // Cloud Document Download Box
                  if (hasDoc)
                    InkWell(
                      onTap: () => _openUrl(item.documentUrl!),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.mintGreen.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.primaryGreen.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.picture_as_pdf_outlined, color: AppTheme.primaryGreen, size: 32),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Download / View Official PDF',
                                    style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
                                  ),
                                  Text(
                                    'Stored on Cloudinary CDN',
                                    style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textMuted),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.download_rounded, color: AppTheme.primaryGreen),
                          ],
                        ),
                      ),
                    ),

                  if (hasExt && !hasDoc)
                    OutlinedButton.icon(
                      onPressed: () => _openUrl(item.externalLink!),
                      icon: const Icon(Icons.open_in_browser, size: 16),
                      label: const Text('Read Full Article Online'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryGreen,
                        side: const BorderSide(color: AppTheme.primaryGreen),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                ],
              ),
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
    // Collect all available photos (cover + gallery)
    final List<String> allPhotos = [
      if (item.mediaUrl.isNotEmpty) item.mediaUrl,
      ...item.galleryUrls.where((u) => u != item.mediaUrl),
    ];

    int activeIndex = 0;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final String currentPhoto = allPhotos.isNotEmpty ? allPhotos[activeIndex] : '';
            final bool isNetwork = currentPhoto.startsWith('http');
            final bool hasVideo = item.videoUrl != null && item.videoUrl!.isNotEmpty;

            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              clipBehavior: Clip.antiAlias,
              insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 720),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Main Photo View with Navigation Arrows
                      Container(
                        height: 360,
                        width: double.infinity,
                        color: Colors.black,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            if (currentPhoto.isNotEmpty)
                              isNetwork
                                  ? Image.network(
                                      currentPhoto,
                                      fit: BoxFit.contain,
                                      width: double.infinity,
                                      height: 360,
                                      loadingBuilder: (context, child, progress) {
                                        if (progress == null) return child;
                                        return const Center(
                                          child: CircularProgressIndicator(color: AppTheme.primaryGreen),
                                        );
                                      },
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.black87,
                                          child: const Center(
                                            child: Icon(Icons.broken_image, size: 64, color: Colors.white38),
                                          ),
                                        );
                                      },
                                    )
                                  : Image.asset(
                                      currentPhoto,
                                      fit: BoxFit.contain,
                                      width: double.infinity,
                                      height: 360,
                                    )
                            else
                              Container(
                                color: AppTheme.mintGreen,
                                child: Center(
                                  child: Icon(item.fallbackIcon ?? Icons.photo_library_outlined, size: 72, color: AppTheme.primaryGreen),
                                ),
                              ),

                            // Prev Arrow
                            if (allPhotos.length > 1)
                              Positioned(
                                left: 12,
                                child: CircleAvatar(
                                  backgroundColor: Colors.black54,
                                  child: IconButton(
                                    icon: const Icon(Icons.chevron_left, color: Colors.white),
                                    onPressed: () {
                                      setDialogState(() {
                                        activeIndex = (activeIndex - 1 + allPhotos.length) % allPhotos.length;
                                      });
                                    },
                                  ),
                                ),
                              ),

                            // Next Arrow
                            if (allPhotos.length > 1)
                              Positioned(
                                right: 12,
                                child: CircleAvatar(
                                  backgroundColor: Colors.black54,
                                  child: IconButton(
                                    icon: const Icon(Icons.chevron_right, color: Colors.white),
                                    onPressed: () {
                                      setDialogState(() {
                                        activeIndex = (activeIndex + 1) % allPhotos.length;
                                      });
                                    },
                                  ),
                                ),
                              ),

                            // Counter badge
                            if (allPhotos.length > 1)
                              Positioned(
                                bottom: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.65),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '${activeIndex + 1} / ${allPhotos.length}',
                                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      // Thumbnail Strip if multiple photos
                      if (allPhotos.length > 1)
                        Container(
                          color: Colors.grey.shade900,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(allPhotos.length, (idx) {
                                final thumb = allPhotos[idx];
                                final isSelected = idx == activeIndex;
                                return GestureDetector(
                                  onTap: () => setDialogState(() => activeIndex = idx),
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: isSelected ? AppTheme.accentGreen : Colors.transparent,
                                        width: 2.5,
                                      ),
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: thumb.startsWith('http')
                                        ? Image.network(thumb, fit: BoxFit.cover)
                                        : Image.asset(thumb, fit: BoxFit.cover),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),

                      // Content Details
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppTheme.mintGreen,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.event, size: 14, color: AppTheme.primaryGreen),
                                      const SizedBox(width: 6),
                                      Text(
                                        item.date.toUpperCase(),
                                        style: GoogleFonts.outfit(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.primaryGreen,
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (allPhotos.length > 1) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '${allPhotos.length} Photos',
                                      style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              item.title,
                              style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              item.description,
                              style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textMuted, height: 1.5),
                            ),
                            const SizedBox(height: 24),

                            // Actions
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (hasVideo)
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      _showVideoPlayer(context, item);
                                    },
                                    icon: const Icon(Icons.play_circle_filled, size: 18),
                                    label: const Text('Play Workshop Video'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red.shade700,
                                      foregroundColor: Colors.white,
                                    ),
                                  )
                                else if (item.externalLink != null && item.externalLink!.isNotEmpty)
                                  OutlinedButton.icon(
                                    onPressed: () => _openUrl(item.externalLink!),
                                    icon: const Icon(Icons.open_in_new, size: 16),
                                    label: const Text('Open Link'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppTheme.primaryGreen,
                                    ),
                                  )
                                else
                                  const SizedBox(),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Close'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
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
    final bool isNetwork = widget.item.mediaUrl.startsWith('http');
    final bool hasImage = widget.item.mediaUrl.isNotEmpty;
    final int totalPhotos = 1 + widget.item.galleryUrls.where((u) => u != widget.item.mediaUrl).length;

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
              color: _isHovered ? AppTheme.accentGreen.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.04),
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
                    if (hasImage)
                      Positioned.fill(
                        child: AnimatedScale(
                          scale: _isHovered ? 1.06 : 1.0,
                          duration: const Duration(milliseconds: 300),
                          child: isNetwork
                              ? Image.network(
                                  widget.item.mediaUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  loadingBuilder: (context, child, progress) {
                                    if (progress == null) return child;
                                    return Container(
                                      color: AppTheme.mintGreen.withValues(alpha: 0.4),
                                      child: const Center(
                                        child: SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primaryGreen),
                                        ),
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: AppTheme.backgroundCard,
                                      child: Center(
                                        child: Icon(
                                          widget.item.fallbackIcon ?? Icons.newspaper_rounded,
                                          size: 48,
                                          color: AppTheme.primaryGreen,
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Image.asset(
                                  widget.item.mediaUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: AppTheme.backgroundCard,
                                      child: Center(
                                        child: Icon(
                                          widget.item.fallbackIcon ?? Icons.newspaper_rounded,
                                          size: 48,
                                          color: AppTheme.primaryGreen,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      )
                    else
                      Container(
                        width: double.infinity,
                        color: AppTheme.backgroundCard,
                        child: Icon(
                          widget.item.fallbackIcon ?? Icons.newspaper_rounded,
                          size: 48,
                          color: _isHovered ? AppTheme.primaryGreen : AppTheme.primaryGreen.withValues(alpha: 0.6),
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
                                  : widget.item.category == 'Document'
                                      ? Colors.amber.shade900
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

                    // Multi-photo count pill / Cloud badge
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: Row(
                        children: [
                          if (isNetwork)
                            Container(
                              margin: const EdgeInsets.only(right: 6),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.65),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.cloud_done_rounded, size: 12, color: Colors.white),
                                  SizedBox(width: 4),
                                  Text('Cloud', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          if (totalPhotos > 1)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryGreen.withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.photo_library, size: 12, color: Colors.white),
                                  const SizedBox(width: 4),
                                  Text('$totalPhotos Photos', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(18.0),
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
                    const SizedBox(height: 6),
                    Text(
                      widget.item.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
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
