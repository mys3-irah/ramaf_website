import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class ProductItem {
  final String id;
  final String title;
  final String category;
  final String description;
  final String longDescription;
  final String imagePath;
  final IconData fallbackIcon;
  final String availabilityString;

  const ProductItem({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.longDescription,
    required this.imagePath,
    required this.fallbackIcon,
    required this.availabilityString,
  });
}

class ProductsSection extends StatefulWidget {
  const ProductsSection({super.key});

  @override
  State<ProductsSection> createState() => _ProductsSectionState();
}

class _ProductsSectionState extends State<ProductsSection> {
  String _selectedCategory = 'All';

  final List<ProductItem> _products = const [
    ProductItem(
      id: 'p1',
      title: 'Fresh Mushrooms',
      category: 'Fresh',
      description: 'Oyster, Paddy Straw, Button, Enoki, King Oyster, and Shiitake varieties.',
      longDescription: 'Directly harvested from our temperature-controlled organic growth chambers. Available varieties include premium Oyster, high-temperature Paddy Straw, classic Button, delicate Enoki, dense King Oyster, and highly nutritive Shiitake mushrooms.',
      imagePath: 'assets/images/WhatsApp Image 2023-12-20 at 14.16.36_a40e1cbc.jpg', // Local image!
      fallbackIcon: Icons.grass,
      availabilityString: 'Available Daily',
    ),
    ProductItem(
      id: 'p2',
      title: 'Dry Schizophyllum & Wood Ear',
      category: 'Dry',
      description: 'Dehydrated Kanglayen and Uchina edible wild forest fungi.',
      longDescription: 'Carefully sun-dried and sorted Schizophyllum Commune (Kanglayen) and Auricularia Auricula-Judae (Uchina / Wood Ear) mushrooms. Fosters long shelf life, intensive flavor profiles, and rich medicinal antioxidants. Perfect for traditional soups and curries.',
      imagePath: '',
      fallbackIcon: Icons.wb_sunny_outlined,
      availabilityString: 'In Stock',
    ),
    ProductItem(
      id: 'p3',
      title: 'Dry Shiitake (Uyen)',
      category: 'Dry',
      description: 'Pre-packaged dried Shiitake mushrooms with intensive umami taste.',
      longDescription: 'Direct-farm harvested Shiitake mushrooms dried utilizing high-grade food dehydrators to preserve standard cellular density and nutritive structure. Perfect long-storage item with authentic Manipuri Uyen flavor profiles.',
      imagePath: '',
      fallbackIcon: Icons.eco_outlined,
      availabilityString: 'In Stock',
    ),
    ProductItem(
      id: 'p4',
      title: 'Chaff Cutter & Local Hand Baler',
      category: 'Equipment',
      description: 'Substrate straw preparation tools and local hand-baling systems.',
      longDescription: 'High-yield manual and semi-automatic straw chaff cutters along with local hand-baling presses designed to simplify compost bed preparation and maximize density control for mushroom cultivation.',
      imagePath: '',
      fallbackIcon: Icons.construction_outlined,
      availabilityString: 'Upon Request',
    ),
    ProductItem(
      id: 'p5',
      title: 'Humidifier & Bagging Machine',
      category: 'Equipment',
      description: 'Edible growroom automation equipment and substrate bagging devices.',
      longDescription: 'Industrial hydrometers, ultrasonic cool-mist growroom humidifiers, and pneumatic/mechanical substrate bagging machines designed to automate farm scale crop setups.',
      imagePath: '',
      fallbackIcon: Icons.settings_input_component_outlined,
      availabilityString: 'Upon Request',
    ),
    ProductItem(
      id: 'p6',
      title: 'Agricultural & Bio-chemicals',
      category: 'Inputs',
      description: 'Disinfectants, calcium carbonate, and biochemical growth promoters.',
      longDescription: 'Standard sterilizing chemicals (formaldehyde, bleaching powder), pH control agents (gypsum, calcium carbonate), and certified organic growth hormones required to maintain pure mushroom grow rooms.',
      imagePath: '',
      fallbackIcon: Icons.biotech_outlined,
      availabilityString: 'In Stock',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final List<String> categories = ['All', 'Fresh', 'Dry', 'Equipment', 'Inputs'];

    final List<ProductItem> filteredProducts = _selectedCategory == 'All'
        ? _products
        : _products.where((p) => p.category == _selectedCategory).toList();

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
                'PRODUCTS',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.accentGreen,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Available Items & Farming Inputs',
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

              // Filters
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: categories.map((cat) {
                  final bool isSelected = _selectedCategory == cat;
                  return ChoiceChip(
                    label: Text(cat),
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

              // Grid
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
                      childAspectRatio: 0.85,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      return _ProductCard(
                        product: filteredProducts[index],
                        onTap: () => _showProductDetails(context, filteredProducts[index]),
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

  void _showProductDetails(BuildContext context, ProductItem product) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          clipBehavior: Clip.antiAlias,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (product.imagePath.isNotEmpty)
                    Image.asset(
                      product.imagePath,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  else
                    Container(
                      height: 200,
                      width: double.infinity,
                      color: AppTheme.mintGreen,
                      child: Icon(product.fallbackIcon, size: 72, color: AppTheme.primaryGreen),
                    ),
                  
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppTheme.accentGreen.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                product.category.toUpperCase(),
                                style: GoogleFonts.outfit(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryGreen,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                            Text(
                              product.availabilityString,
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryGreen,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          product.title,
                          style: GoogleFonts.outfit(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          product.longDescription,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            color: AppTheme.textMuted,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Close'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Purchase request for "${product.title}" simulated successfully!'),
                                      backgroundColor: AppTheme.primaryGreen,
                                    ),
                                  );
                                },
                                child: const Text('Inquire Stock'),
                              ),
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
  }
}

class _ProductCard extends StatefulWidget {
  final ProductItem product;
  final VoidCallback onTap;

  const _ProductCard({required this.product, required this.onTap});

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
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
                    if (widget.product.imagePath.isNotEmpty)
                      AnimatedScale(
                        scale: _isHovered ? 1.08 : 1.0,
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(widget.product.imagePath),
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
                          widget.product.fallbackIcon,
                          size: 48,
                          color: _isHovered ? AppTheme.primaryGreen : AppTheme.primaryGreen.withOpacity(0.6),
                        ),
                      ),
                    
                    // Availability tag
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          widget.product.availabilityString,
                          style: GoogleFonts.outfit(
                            fontSize: 12,
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
                      widget.product.category.toUpperCase(),
                      style: GoogleFonts.outfit(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.accentGreen,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.product.title,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.product.description,
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
