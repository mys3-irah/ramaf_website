import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../widgets/event_download_dialog.dart';
import '../widgets/event_registration_dialog.dart';

class EventModel {
  final String id;
  final String dateDay;
  final String dateMonth;
  final String title;
  final String time;
  final String location;
  final String description;
  final double fee;
  final DateTime registrationDeadline;
  final List<String> requiredDocs;
  final bool isUpcoming;
  final bool isTraining;

  const EventModel({
    required this.id,
    required this.dateDay,
    required this.dateMonth,
    required this.title,
    required this.time,
    required this.location,
    required this.description,
    required this.fee,
    required this.registrationDeadline,
    required this.requiredDocs,
    required this.isUpcoming,
    required this.isTraining,
  });

  bool get isRegistrationOpen => DateTime.now().isBefore(registrationDeadline);
}

class EventsSection extends StatefulWidget {
  const EventsSection({super.key});

  @override
  State<EventsSection> createState() => _EventsSectionState();
}

class _EventsSectionState extends State<EventsSection> {
  String _selectedFilter = 'All';

  final List<EventModel> _events = [
    EventModel(
      id: 'EVT-MUSHROOM-2026',
      dateDay: '18',
      dateMonth: 'AUG',
      title: 'Mushroom Spawning & Bed Preparation (15 Days Intensive Training)',
      time: '10:00 AM - 02:00 PM',
      location: 'RAMAF Imphal Training Center, RIMS Road',
      description: 'Comprehensive hands-on curriculum covering crop sterilisation, spawns, substrate bags, humidity control, and marketing for commercial setups.',
      fee: 250.0,
      registrationDeadline: DateTime(2026, 8, 16, 23, 59),
      requiredDocs: [
        '2 Recent Passport Size Color Photographs',
        'Photocopy of Aadhaar Card (Self-Attested)',
        'Photocopy of PAN Card / Voter ID (If available)',
        'Relief Camp ID Card (For Camp Inmates - 100% Free)',
        'Disability / Caste Certificate (For Fee Concession)',
      ],
      isUpcoming: true,
      isTraining: true,
    ),
    EventModel(
      id: 'EVT-HORTI-2026',
      dateDay: '05',
      dateMonth: 'SEP',
      title: 'Horticultural Grafting & Dragon Fruit Nursery Setup',
      time: '09:30 AM - 01:00 PM',
      location: 'Community Horti Garden, Manipur',
      description: 'Learn modern bud-grafting methods, vertical trellis setups, pruning, organic compost application, and seedling nursery commercialization.',
      fee: 300.0,
      registrationDeadline: DateTime(2026, 9, 3, 23, 59),
      requiredDocs: [
        '2 Recent Passport Size Photographs',
        'Photocopy of Aadhaar Card (Self-Attested)',
        'Copy of Highest Educational Marksheet / Certificate',
        'Relief Camp Registration Card / ID (If applicable)',
      ],
      isUpcoming: true,
      isTraining: true,
    ),
    EventModel(
      id: 'EVT-BIOFLOC-2026',
      dateDay: '12',
      dateMonth: 'JUL',
      title: 'Free Biofloc & Eel Farming Skill Program',
      time: '09:00 AM - 12:00 PM',
      location: 'RIMS Road Community Hub, Imphal',
      description: 'Aquaculture training for marginal farmers and relief camp residents to foster localized fish breeding, tank maintenance, and feed formulation.',
      fee: 0.0,
      registrationDeadline: DateTime(2026, 7, 10, 18, 00),
      requiredDocs: [
        '2 Passport Size Photographs',
        'Aadhaar Card Copy',
        'Relief Camp Inmate Proof (If applicable)',
      ],
      isUpcoming: false,
      isTraining: true,
    ),
    EventModel(
      id: 'EVT-HEALTH-2026',
      dateDay: '28',
      dateMonth: 'JUN',
      title: 'RIMS Manipur Health Checkup & Awareness Camp',
      time: '10:00 AM - 05:00 PM',
      location: 'Relief Camp Area B, Imphal West',
      description: 'Provided general medical checkups, essential medicines distribution, child nutrition kits, and sanitation awareness to relief camp families.',
      fee: 0.0,
      registrationDeadline: DateTime(2026, 6, 27, 18, 00),
      requiredDocs: [
        'Camp ID / Resident Proof',
        'Medical Prescription / History (If available)',
      ],
      isUpcoming: false,
      isTraining: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isDesktop = width > 900;

    final List<EventModel> filteredEvents = _selectedFilter == 'All'
        ? _events
        : _selectedFilter == 'Upcoming'
            ? _events.where((e) => e.isUpcoming).toList()
            : _events.where((e) => !e.isUpcoming).toList();

    return Container(
      width: double.infinity,
      color: AppTheme.backgroundCard,
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
                      'WORKSHOPS & EVENTS',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.accentGreen,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Training & Support Seminars',
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
              const SizedBox(height: 40),

              // Filter Chips
              Center(
                child: Wrap(
                  spacing: 12,
                  children: ['All', 'Upcoming', 'Past'].map((filter) {
                    final bool isSelected = _selectedFilter == filter;
                    return ChoiceChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (val) {
                        if (val) {
                          setState(() => _selectedFilter = filter);
                        }
                      },
                      selectedColor: AppTheme.primaryGreen,
                      backgroundColor: AppTheme.mintGreen,
                      labelStyle: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : AppTheme.primaryGreen,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide.none,
                      ),
                      showCheckmark: false,
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 48),

              // Events List Layout
              if (filteredEvents.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Text(
                      'No events found in this category.',
                      style: GoogleFonts.inter(fontSize: 16, color: AppTheme.textMuted),
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredEvents.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 24),
                  itemBuilder: (context, index) {
                    return _EventRow(
                      event: filteredEvents[index],
                      isDesktop: isDesktop,
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EventRow extends StatefulWidget {
  final EventModel event;
  final bool isDesktop;

  const _EventRow({required this.event, required this.isDesktop});

  @override
  State<_EventRow> createState() => _EventRowState();
}

class _EventRowState extends State<_EventRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isHovered ? AppTheme.accentGreen.withOpacity(0.3) : Colors.black.withOpacity(0.04),
            width: 1.5,
          ),
          boxShadow: _isHovered ? AppTheme.hoverShadow : AppTheme.softShadow,
        ),
        padding: const EdgeInsets.all(24),
        child: widget.isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    final deadlineFormatted = DateFormat('dd MMM yyyy').format(widget.event.registrationDeadline);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildDateBox(),
        const SizedBox(width: 32),
        
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildBadges(),
                  const SizedBox(width: 12),
                  _buildDeadlineBadge(deadlineFormatted),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                widget.event.title,
                style: GoogleFonts.outfit(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.event.description,
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  color: AppTheme.textMuted,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 20,
                runSpacing: 8,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.access_time_rounded, size: 16, color: AppTheme.accentGreen),
                      const SizedBox(width: 6),
                      Text(widget.event.time, style: GoogleFonts.inter(fontSize: 12.5, color: AppTheme.textMuted)),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.location_on_outlined, size: 16, color: AppTheme.accentGreen),
                      const SizedBox(width: 6),
                      Text(widget.event.location, style: GoogleFonts.inter(fontSize: 12.5, color: AppTheme.textMuted)),
                    ],
                  ),
                  if (widget.event.fee > 0)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.payments_outlined, size: 16, color: AppTheme.primaryGreen),
                        const SizedBox(width: 6),
                        Text(
                          'Fee: ₹${widget.event.fee.toStringAsFixed(0)} (Concession for Camp/PwD)',
                          style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppTheme.primaryGreen),
                        ),
                      ],
                    )
                  else
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.volunteer_activism_outlined, size: 16, color: AppTheme.accentGreen),
                        const SizedBox(width: 6),
                        Text(
                          'Fee: Free / Sponsored',
                          style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppTheme.accentGreen),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        _buildActionButton(),
      ],
    );
  }

  Widget _buildMobileLayout() {
    final deadlineFormatted = DateFormat('dd MMM yyyy').format(widget.event.registrationDeadline);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildDateBox(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBadges(),
                const SizedBox(height: 6),
                _buildDeadlineBadge(deadlineFormatted),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          widget.event.title,
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textDark,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.event.description,
          style: GoogleFonts.inter(
            fontSize: 13.5,
            color: AppTheme.textMuted,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(Icons.access_time_rounded, size: 16, color: AppTheme.accentGreen),
            const SizedBox(width: 8),
            Expanded(child: Text(widget.event.time, style: GoogleFonts.inter(fontSize: 12.5, color: AppTheme.textMuted))),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(Icons.location_on_outlined, size: 16, color: AppTheme.accentGreen),
            const SizedBox(width: 8),
            Expanded(child: Text(widget.event.location, style: GoogleFonts.inter(fontSize: 12.5, color: AppTheme.textMuted))),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(Icons.payments_outlined, size: 16, color: AppTheme.primaryGreen),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                widget.event.fee > 0
                    ? 'Fee: ₹${widget.event.fee.toStringAsFixed(0)} (Concession available)'
                    : 'Fee: Free / Community Program',
                style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppTheme.primaryGreen),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: _buildActionButton(),
        ),
      ],
    );
  }

  Widget _buildDateBox() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: widget.event.isUpcoming ? AppTheme.primaryGreen : AppTheme.mintGreen,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.event.dateDay,
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: widget.event.isUpcoming ? Colors.white : AppTheme.primaryGreen,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.event.dateMonth,
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: widget.event.isUpcoming ? Colors.white70 : AppTheme.primaryGreen.withOpacity(0.8),
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadges() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: widget.event.isUpcoming
            ? Colors.orange.shade50
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: widget.event.isUpcoming
              ? Colors.orange.shade200
              : Colors.grey.shade300,
        ),
      ),
      child: Text(
        widget.event.isUpcoming
            ? (widget.event.isTraining ? 'UPCOMING TRAINING' : 'UPCOMING EVENT')
            : 'PAST PROGRAM',
        style: GoogleFonts.outfit(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: widget.event.isUpcoming ? Colors.orange.shade800 : Colors.grey.shade700,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildDeadlineBadge(String deadlineFormatted) {
    final bool isOpen = widget.event.isRegistrationOpen;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isOpen ? Colors.blue.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isOpen ? Colors.blue.shade200 : Colors.red.shade200,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isOpen ? Icons.timer_outlined : Icons.lock_clock,
            size: 11,
            color: isOpen ? Colors.blue.shade800 : Colors.red.shade800,
          ),
          const SizedBox(width: 4),
          Text(
            isOpen ? 'Last Date: $deadlineFormatted' : 'Deadline Closed ($deadlineFormatted)',
            style: GoogleFonts.outfit(
              fontSize: 9.5,
              fontWeight: FontWeight.bold,
              color: isOpen ? Colors.blue.shade800 : Colors.red.shade800,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    final bool isOpen = widget.event.isRegistrationOpen;

    if (widget.event.isUpcoming) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          OutlinedButton.icon(
            onPressed: () => _openDownloadDialog(context),
            icon: const Icon(Icons.file_download_outlined, size: 16),
            label: const Text('Download Form'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton.icon(
            onPressed: isOpen ? () => _openRegistrationDialog(context) : null,
            icon: Icon(isOpen ? Icons.how_to_reg_outlined : Icons.block, size: 16),
            label: Text(isOpen ? 'Register Online' : 'Closed'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              backgroundColor: isOpen ? AppTheme.primaryGreen : Colors.grey.shade400,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      );
    } else {
      return OutlinedButton.icon(
        onPressed: () => _openDownloadDialog(context),
        icon: const Icon(Icons.info_outline, size: 16),
        label: const Text('View Documents Required'),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      );
    }
  }

  void _openDownloadDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return EventDownloadDialog(
          title: widget.event.title,
          location: widget.event.location,
          registrationDeadline: widget.event.registrationDeadline,
          requiredDocs: widget.event.requiredDocs,
        );
      },
    );
  }

  void _openRegistrationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return EventRegistrationDialog(
          eventId: widget.event.id,
          eventTitle: widget.event.title,
          eventLocation: widget.event.location,
          baseFee: widget.event.fee,
          registrationDeadline: widget.event.registrationDeadline,
          requiredDocs: widget.event.requiredDocs,
        );
      },
    );
  }
}
