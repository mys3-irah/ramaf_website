import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../services/firebase_service.dart';
import '../services/razorpay_service.dart';
import '../services/cloudinary_service.dart';

class EventRegistrationDialog extends StatefulWidget {
  final String eventId;
  final String eventTitle;
  final String eventLocation;
  final double baseFee;
  final DateTime registrationDeadline;
  final List<String> requiredDocs;

  const EventRegistrationDialog({
    super.key,
    required this.eventId,
    required this.eventTitle,
    required this.eventLocation,
    required this.baseFee,
    required this.registrationDeadline,
    required this.requiredDocs,
  });

  @override
  State<EventRegistrationDialog> createState() => _EventRegistrationDialogState();
}

class _EventRegistrationDialogState extends State<EventRegistrationDialog> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _guardianController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _qualificationController = TextEditingController();

  String _selectedDistrict = 'Imphal West';
  String _selectedCategory = 'General';
  bool _agreedToTerms = true;
  bool _isSubmitting = false;
  String _submitStatusText = 'Processing...';

  // File upload state for Cloudinary
  PlatformFile? _pickedPhoto;
  PlatformFile? _pickedDocument;

  final List<String> _districts = [
    'Imphal West',
    'Imphal East',
    'Bishnupur',
    'Thoubal',
    'Kakching',
    'Churachandpur',
    'Kangpokpi',
    'Senapati',
    'Ukhrul',
    'Tamenglong',
    'Chandel',
    'Tengnoupal',
    'Noney',
    'Kamjong',
    'Pherzawl',
    'Jiribam',
    'Other / Outside Manipur',
  ];

  final List<String> _categories = [
    'General',
    'OBC',
    'SC',
    'ST',
    'Relief Camp Inmate',
    'Person with Disability (PwD)',
  ];

  bool get _isConcessionEligible {
    return _selectedCategory == 'Relief Camp Inmate' ||
        _selectedCategory == 'Person with Disability (PwD)' ||
        _selectedCategory == 'SC' ||
        _selectedCategory == 'ST';
  }

  double get _effectiveFee {
    return _isConcessionEligible ? 0.0 : widget.baseFee;
  }

  bool get _isRegistrationExpired {
    return DateTime.now().isAfter(widget.registrationDeadline);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _guardianController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _qualificationController.dispose();
    super.dispose();
  }

  // Pick applicant passport photo
  Future<void> _pickPhoto() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _pickedPhoto = result.files.first;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to select image: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  // Pick ID / Concession certificate document
  Future<void> _pickDocument() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _pickedDocument = result.files.first;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to select document: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Future<void> _handleRegistration() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to terms and bring required documents.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (_isRegistrationExpired) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration deadline has passed. Submission is closed.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
      _submitStatusText = 'Starting registration...';
    });

    String paymentId = 'EXEMPTED';
    String paymentStatus = 'Exempted';
    String? photoUrl;
    String? docUrl;

    try {
      // 1. Upload files to Cloudinary if attached
      if (_pickedPhoto != null && _pickedPhoto!.bytes != null) {
        setState(() => _submitStatusText = 'Uploading photo to Cloudinary...');
        final photoResult = await CloudinaryService().uploadFile(
          bytes: _pickedPhoto!.bytes!,
          fileName: 'photo_${DateTime.now().millisecondsSinceEpoch}_${_pickedPhoto!.name}',
          folder: 'ramaf_registrations/photos',
          resourceType: 'image',
        );

        if (photoResult.isSuccess) {
          photoUrl = photoResult.secureUrl;
        } else {
          debugPrint('Notice: Photo upload notice: ${photoResult.errorMessage}');
        }
      }

      if (_pickedDocument != null && _pickedDocument!.bytes != null) {
        setState(() => _submitStatusText = 'Uploading document to Cloudinary...');
        final isPdf = _pickedDocument!.name.toLowerCase().endsWith('.pdf');
        final docResult = await CloudinaryService().uploadFile(
          bytes: _pickedDocument!.bytes!,
          fileName: 'doc_${DateTime.now().millisecondsSinceEpoch}_${_pickedDocument!.name}',
          folder: 'ramaf_registrations/documents',
          resourceType: isPdf ? 'raw' : 'auto',
        );

        if (docResult.isSuccess) {
          docUrl = docResult.secureUrl;
        } else {
          debugPrint('Notice: Document upload notice: ${docResult.errorMessage}');
        }
      }

      // 2. If fee > 0, trigger Razorpay payment gateway
      if (_effectiveFee > 0) {
        setState(() => _submitStatusText = 'Opening payment gateway...');
        final paymentResult = await RazorpayService.openCheckout(
          amountInRupees: _effectiveFee,
          eventTitle: widget.eventTitle,
          customerName: _nameController.text.trim(),
          customerEmail: _emailController.text.trim(),
          customerPhone: _phoneController.text.trim(),
        );

        if (!paymentResult.isSuccess) {
          setState(() => _isSubmitting = false);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(paymentResult.errorMessage ?? 'Payment cancelled/failed.'),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
          return;
        }

        paymentId = paymentResult.paymentId ?? 'PAY_${DateTime.now().millisecondsSinceEpoch}';
        paymentStatus = 'Paid';
      }

      // 3. Save registration record into Firebase Firestore
      setState(() => _submitStatusText = 'Recording registration in Firebase...');
      final regData = RegistrationData(
        eventId: widget.eventId,
        eventTitle: widget.eventTitle,
        fullName: _nameController.text.trim(),
        guardianName: _guardianController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        address: _addressController.text.trim(),
        district: _selectedDistrict,
        qualification: _qualificationController.text.trim(),
        category: _selectedCategory,
        isConcessionApplied: _isConcessionEligible,
        feePaid: _effectiveFee,
        photoUrl: photoUrl,
        documentUrl: docUrl,
        paymentId: paymentId,
        paymentStatus: paymentStatus,
        registrationDate: DateTime.now(),
      );

      final registrationId = await FirebaseService().submitRegistration(regData);

      if (mounted) {
        setState(() => _isSubmitting = false);
        Navigator.of(context).pop(); // Close registration dialog
        _showSuccessDialog(registrationId, paymentId, paymentStatus, photoUrl, docUrl);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration submission error: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  void _showSuccessDialog(
    String regId,
    String paymentId,
    String paymentStatus,
    String? photoUrl,
    String? docUrl,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          contentPadding: const EdgeInsets.all(28),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded, color: AppTheme.accentGreen, size: 54),
              ),
              const SizedBox(height: 18),
              Text(
                'Registration Successful!',
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your application has been recorded in the RAMA Foundation database.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textMuted),
              ),
              const SizedBox(height: 20),

              // Application ID card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.mintGreen,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.primaryGreen.withValues(alpha: 0.2)),
                ),
                child: Column(
                  children: [
                    Text(
                      'APPLICATION / REGISTRATION ID',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryGreen,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    SelectableText(
                      regId,
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.primaryGreen,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Applicant:', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textMuted)),
                        Text(_nameController.text, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Payment Status:', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textMuted)),
                        Text(
                          '$paymentStatus (${_effectiveFee > 0 ? "₹$_effectiveFee" : "Free/Concession"})',
                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
                        ),
                      ],
                    ),
                    if (paymentId != 'EXEMPTED') ...[
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Transaction ID:', style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textMuted)),
                          Text(paymentId, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ],
                    if (photoUrl != null && photoUrl.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Photo Upload:', style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textMuted)),
                          Text('Uploaded to Cloudinary', style: GoogleFonts.inter(fontSize: 11, color: AppTheme.accentGreen, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                    if (docUrl != null && docUrl.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Proof Document:', style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textMuted)),
                          Text('Uploaded to Cloudinary', style: GoogleFonts.inter(fontSize: 11, color: AppTheme.accentGreen, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Checklist reminder
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.amber.shade900, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Important: Please keep your Application ID saved for orientation at RAMAF Center.',
                        style: GoogleFonts.inter(fontSize: 11.5, color: Colors.amber.shade900),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Done'),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final deadlineStr = DateFormat('dd MMM yyyy, hh:mm a').format(widget.registrationDeadline);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 640),
        padding: const EdgeInsets.all(28),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
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
                      child: const Icon(Icons.app_registration_rounded, color: AppTheme.primaryGreen, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Online Event Registration',
                            style: GoogleFonts.outfit(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.eventTitle,
                            style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textMuted),
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
                const Divider(height: 28),

                // Deadline Notice & Registration Status
                if (_isRegistrationExpired)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade300),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.block, color: Colors.red.shade800, size: 26),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Registration Closed',
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red.shade900,
                                ),
                              ),
                              Text(
                                'The last date of submission for this event was $deadlineStr. No new registrations are being accepted.',
                                style: GoogleFonts.inter(fontSize: 12.5, color: Colors.red.shade800),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.timer_outlined, color: AppTheme.accentGreen, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Registration is OPEN until $deadlineStr',
                            style: GoogleFonts.inter(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Section 1: Input Fields
                Text(
                  '1. Participant Details',
                  style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                ),
                const SizedBox(height: 14),

                TextFormField(
                  controller: _nameController,
                  enabled: !_isRegistrationExpired && !_isSubmitting,
                  decoration: InputDecoration(
                    labelText: 'Full Name *',
                    hintText: 'Enter participant name',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (val) => val == null || val.trim().isEmpty ? 'Full name is required' : null,
                ),
                const SizedBox(height: 14),

                TextFormField(
                  controller: _guardianController,
                  enabled: !_isRegistrationExpired && !_isSubmitting,
                  decoration: InputDecoration(
                    labelText: "Father's / Guardian's Name *",
                    hintText: "Enter father or guardian's name",
                    prefixIcon: const Icon(Icons.family_restroom_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (val) => val == null || val.trim().isEmpty ? 'Guardian name is required' : null,
                ),
                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _phoneController,
                        enabled: !_isRegistrationExpired && !_isSubmitting,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Contact Number *',
                          hintText: '10-digit mobile number',
                          prefixIcon: const Icon(Icons.phone_outlined),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) return 'Phone number required';
                          if (val.trim().length < 10) return 'Enter valid 10-digit number';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: TextFormField(
                        controller: _emailController,
                        enabled: !_isRegistrationExpired && !_isSubmitting,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          hintText: 'For confirmation receipt',
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedDistrict,
                        decoration: InputDecoration(
                          labelText: 'District *',
                          prefixIcon: const Icon(Icons.location_city_outlined),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        items: _districts.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                        onChanged: _isRegistrationExpired || _isSubmitting
                            ? null
                            : (val) {
                                if (val != null) setState(() => _selectedDistrict = val);
                              },
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedCategory,
                        decoration: InputDecoration(
                          labelText: 'Category *',
                          prefixIcon: const Icon(Icons.category_outlined),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                        onChanged: _isRegistrationExpired || _isSubmitting
                            ? null
                            : (val) {
                                if (val != null) setState(() => _selectedCategory = val);
                              },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                TextFormField(
                  controller: _addressController,
                  enabled: !_isRegistrationExpired && !_isSubmitting,
                  decoration: InputDecoration(
                    labelText: 'Address / Village / Relief Camp *',
                    hintText: 'Detailed local address',
                    prefixIcon: const Icon(Icons.home_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (val) => val == null || val.trim().isEmpty ? 'Address is required' : null,
                ),
                const SizedBox(height: 14),

                TextFormField(
                  controller: _qualificationController,
                  enabled: !_isRegistrationExpired && !_isSubmitting,
                  decoration: InputDecoration(
                    labelText: 'Educational Qualification / Occupation',
                    hintText: 'e.g. 10th / 12th / Farmer / Self-Employed',
                    prefixIcon: const Icon(Icons.school_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 24),

                // Section 2: File Uploads (Powered by Cloudinary)
                Row(
                  children: [
                    Text(
                      '2. Documents & Photo Upload',
                      style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Text(
                        'Cloudinary Storage',
                        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.blue.shade700),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Upload your passport photograph and ID / concession certificates (optional or for fee-exempt categories).',
                  style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textMuted),
                ),
                const SizedBox(height: 14),

                // Photo & Document Picker Cards
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Photo Box
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: _pickedPhoto != null ? AppTheme.mintGreen.withValues(alpha: 0.4) : AppTheme.backgroundCard,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _pickedPhoto != null ? AppTheme.primaryGreen : Colors.grey.shade300,
                            width: _pickedPhoto != null ? 1.5 : 1.0,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.account_box_outlined, size: 20, color: AppTheme.primaryGreen),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Passport Photo',
                                    style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            if (_pickedPhoto != null) ...[
                              Row(
                                children: [
                                  if (_pickedPhoto!.bytes != null)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: Image.memory(
                                        _pickedPhoto!.bytes!,
                                        width: 38,
                                        height: 38,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _pickedPhoto!.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: const Icon(Icons.cancel, size: 18, color: Colors.grey),
                                    onPressed: _isSubmitting ? null : () => setState(() => _pickedPhoto = null),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                            ],
                            OutlinedButton.icon(
                              onPressed: _isSubmitting || _isRegistrationExpired ? null : _pickPhoto,
                              icon: Icon(_pickedPhoto == null ? Icons.upload_file : Icons.refresh, size: 16),
                              label: Text(
                                _pickedPhoto == null ? 'Select Photo' : 'Change Photo',
                                style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w600),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.primaryGreen,
                                side: const BorderSide(color: AppTheme.primaryGreen),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),

                    // ID / Concession Document Box
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: _pickedDocument != null ? AppTheme.mintGreen.withValues(alpha: 0.4) : AppTheme.backgroundCard,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _pickedDocument != null ? AppTheme.primaryGreen : Colors.grey.shade300,
                            width: _pickedDocument != null ? 1.5 : 1.0,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.description_outlined, size: 20, color: AppTheme.primaryGreen),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'ID / Concession Proof',
                                    style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            if (_pickedDocument != null) ...[
                              Row(
                                children: [
                                  const Icon(Icons.file_present_rounded, size: 28, color: AppTheme.primaryGreen),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _pickedDocument!.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: const Icon(Icons.cancel, size: 18, color: Colors.grey),
                                    onPressed: _isSubmitting ? null : () => setState(() => _pickedDocument = null),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                            ],
                            OutlinedButton.icon(
                              onPressed: _isSubmitting || _isRegistrationExpired ? null : _pickDocument,
                              icon: Icon(_pickedDocument == null ? Icons.attach_file : Icons.refresh, size: 16),
                              label: Text(
                                _pickedDocument == null ? 'Select Document' : 'Change Document',
                                style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w600),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.primaryGreen,
                                side: const BorderSide(color: AppTheme.primaryGreen),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Section 3: Fee Summary Box
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundCard,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Course / Registration Fee:', style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textMuted)),
                          Text('₹${widget.baseFee.toStringAsFixed(0)}', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      if (_isConcessionEligible) ...[
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Category Concession ($_selectedCategory):', style: GoogleFonts.inter(fontSize: 13, color: AppTheme.accentGreen)),
                            Text('- ₹${widget.baseFee.toStringAsFixed(0)} (100% Free)', style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.accentGreen)),
                          ],
                        ),
                      ],
                      const Divider(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Payable Amount:', style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                          Text(
                            _effectiveFee > 0 ? '₹${_effectiveFee.toStringAsFixed(0)}' : 'FREE',
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.primaryGreen,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Document Agreement Checkbox
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _agreedToTerms,
                  onChanged: _isRegistrationExpired || _isSubmitting
                      ? null
                      : (val) {
                          setState(() => _agreedToTerms = val ?? true);
                        },
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(
                    'I confirm that the information and documents provided are genuine, and I agree to the RAMAF registration guidelines.',
                    style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textDark),
                  ),
                ),
                const SizedBox(height: 24),

                // Action Buttons & Progress state
                if (_isSubmitting)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.mintGreen.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primaryGreen),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _submitStatusText,
                            style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppTheme.primaryGreen),
                          ),
                        ],
                      ),
                    ),
                  ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.inter(color: AppTheme.textMuted, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: (_isRegistrationExpired || _isSubmitting) ? null : _handleRegistration,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isRegistrationExpired ? Colors.grey : AppTheme.primaryGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _effectiveFee > 0 ? Icons.payment : Icons.check_circle_outline,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isRegistrationExpired
                                ? 'Registration Closed'
                                : _effectiveFee > 0
                                    ? 'Pay ₹${_effectiveFee.toStringAsFixed(0)} & Register'
                                    : 'Complete Free Registration',
                            style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
