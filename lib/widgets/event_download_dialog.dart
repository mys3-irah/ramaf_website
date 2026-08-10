import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../services/pdf_download_service.dart';

class EventDownloadDialog extends StatelessWidget {
  final String title;
  final String location;
  final DateTime registrationDeadline;
  final List<String> requiredDocs;

  const EventDownloadDialog({
    super.key,
    required this.title,
    required this.location,
    required this.registrationDeadline,
    required this.requiredDocs,
  });

  @override
  Widget build(BuildContext context) {
    final deadlineFormatted = DateFormat('dd MMMM yyyy (hh:mm a)').format(registrationDeadline);
    final isExpired = DateTime.now().isAfter(registrationDeadline);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 580),
        padding: const EdgeInsets.all(28),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.mintGreen,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.picture_as_pdf_rounded,
                      color: AppTheme.primaryGreen,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Download Application Form',
                          style: GoogleFonts.outfit(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          title,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppTheme.textMuted,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.grey),
                  ),
                ],
              ),
              const Divider(height: 32),

              // Deadline Notice
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isExpired ? Colors.red.shade50 : Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isExpired ? Colors.red.shade200 : Colors.amber.shade300,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isExpired ? Icons.error_outline : Icons.alarm,
                      color: isExpired ? Colors.red.shade800 : Colors.amber.shade900,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isExpired
                                ? 'Physical Submission Closed'
                                : 'Last Date of Submission:',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: isExpired ? Colors.red.shade900 : Colors.amber.shade900,
                            ),
                          ),
                          Text(
                            deadlineFormatted,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isExpired ? Colors.red.shade800 : AppTheme.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Mandatory Documents Title
              Row(
                children: [
                  const Icon(Icons.assignment_turned_in_outlined, color: AppTheme.primaryGreen, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Required Documents for Submission',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Please enclose self-attested photocopies of the following documents along with your printed and signed form:',
                style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textMuted),
              ),
              const SizedBox(height: 14),

              // List of Required Documents
              ...requiredDocs.map((doc) => _buildDocItem(doc)),

              const SizedBox(height: 20),

              // Submission HQ & Fee Concession Banner
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.mintGreen.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.mintGreen),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 18, color: AppTheme.primaryGreen),
                        const SizedBox(width: 6),
                        Text(
                          'Submission Location & Timings',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: AppTheme.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'RAMA Foundation HQ, RIMS Road, Imphal West, Manipur - 795004\nOffice Hours: Monday – Saturday (9:30 AM to 4:30 PM)',
                      style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textDark, height: 1.4),
                    ),
                    const Divider(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.verified, size: 16, color: AppTheme.primaryGreen),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Special 100% Fee Concession available for Relief Camp Inmates, Persons with Disabilities (PwD), and SC/ST candidates.',
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.inter(color: AppTheme.textMuted, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      PdfDownloadService.downloadApplicationForm(
                        eventTitle: title,
                        eventLocation: location,
                        lastDate: deadlineFormatted,
                        requiredDocs: requiredDocs,
                      );
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: AppTheme.primaryGreen,
                          behavior: SnackBarBehavior.floating,
                          content: Row(
                            children: [
                              const Icon(Icons.download_done, color: Colors.white),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text('Opening printable official application form for "$title"...'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.file_download_outlined, size: 20),
                    label: const Text('Download PDF Form'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDocItem(String doc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: AppTheme.mintGreen,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, size: 14, color: AppTheme.primaryGreen),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              doc,
              style: GoogleFonts.inter(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: AppTheme.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
