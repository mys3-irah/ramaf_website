import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/media_item.dart';
import '../services/cloudinary_service.dart';
import '../services/firebase_service.dart';
import '../theme/app_theme.dart';

class AddMediaDialog extends StatefulWidget {
  const AddMediaDialog({super.key});

  @override
  State<AddMediaDialog> createState() => _AddMediaDialogState();
}

class _AddMediaDialogState extends State<AddMediaDialog> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _externalLinkController = TextEditingController();

  String _selectedCategory = 'Press';
  PlatformFile? _pickedMediaFile;
  PlatformFile? _pickedPdfDoc;

  bool _isPublishing = false;
  String _uploadStatus = 'Ready to publish';

  final List<String> _categories = ['Press', 'Photo', 'Video', 'Document'];

  @override
  void initState() {
    super.initState();
    // Default date to current month & year
    final now = DateTime.now();
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    _dateController.text = '${months[now.month - 1]} ${now.year}';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _descriptionController.dispose();
    _externalLinkController.dispose();
    super.dispose();
  }

  Future<void> _pickMediaFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'webp', 'mp4'],
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _pickedMediaFile = result.files.first;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick file: $e'), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  Future<void> _pickPdfDoc() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _pickedPdfDoc = result.files.first;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick document: $e'), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  Future<void> _handlePublish() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isPublishing = true;
      _uploadStatus = 'Uploading to Cloudinary...';
    });

    String mediaUrl = '';
    String? docUrl;

    try {
      // 1. Upload Banner / Image / Media to Cloudinary
      if (_pickedMediaFile != null && _pickedMediaFile!.bytes != null) {
        setState(() => _uploadStatus = 'Uploading media to Cloudinary...');
        final res = await CloudinaryService().uploadFile(
          bytes: _pickedMediaFile!.bytes!,
          fileName: 'media_${DateTime.now().millisecondsSinceEpoch}_${_pickedMediaFile!.name}',
          folder: 'ramaf_media',
          resourceType: _pickedMediaFile!.name.endsWith('.mp4') ? 'video' : 'image',
        );

        if (res.isSuccess && res.secureUrl != null) {
          mediaUrl = res.secureUrl!;
        } else {
          debugPrint('Notice: Media upload error: ${res.errorMessage}');
        }
      }

      // 2. Upload Document / Press Clipping PDF to Cloudinary
      if (_pickedPdfDoc != null && _pickedPdfDoc!.bytes != null) {
        setState(() => _uploadStatus = 'Uploading PDF/Document to Cloudinary...');
        final isPdf = _pickedPdfDoc!.name.toLowerCase().endsWith('.pdf');
        final res = await CloudinaryService().uploadFile(
          bytes: _pickedPdfDoc!.bytes!,
          fileName: 'press_doc_${DateTime.now().millisecondsSinceEpoch}_${_pickedPdfDoc!.name}',
          folder: 'ramaf_media/press_docs',
          resourceType: isPdf ? 'raw' : 'auto',
        );

        if (res.isSuccess && res.secureUrl != null) {
          docUrl = res.secureUrl!;
        }
      }

      // 3. Save to Firebase Firestore
      setState(() => _uploadStatus = 'Publishing to Firebase...');
      final mediaItem = MediaItem(
        title: _titleController.text.trim(),
        category: _selectedCategory,
        date: _dateController.text.trim(),
        description: _descriptionController.text.trim(),
        mediaUrl: mediaUrl,
        documentUrl: docUrl,
        externalLink: _externalLinkController.text.trim().isNotEmpty
            ? _externalLinkController.text.trim()
            : null,
        createdAt: DateTime.now(),
      );

      final success = await FirebaseService().addMediaItem(mediaItem);

      if (mounted) {
        setState(() => _isPublishing = false);
        if (success) {
          Navigator.of(context).pop(true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Media & Press item successfully published to Cloud!'),
              backgroundColor: AppTheme.accentGreen,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to save to Firebase. Please check Firebase initialization.'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isPublishing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Publishing error: $e'), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 620),
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
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.mintGreen,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.cloud_upload_rounded, color: AppTheme.primaryGreen, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Publish Media / Press Release',
                            style: GoogleFonts.outfit(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textDark,
                            ),
                          ),
                          Text(
                            'Files are stored on Cloudinary & indexed in Firestore',
                            style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textMuted),
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

                // Category & Date
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedCategory,
                        decoration: InputDecoration(
                          labelText: 'Category *',
                          prefixIcon: const Icon(Icons.category_outlined),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        items: _categories.map((c) {
                          String label = c;
                          if (c == 'Press') label = 'Press Release';
                          if (c == 'Photo') label = 'Work Photo';
                          if (c == 'Video') label = 'Video Story';
                          if (c == 'Document') label = 'Official Circular/Report';
                          return DropdownMenuItem(value: c, child: Text(label));
                        }).toList(),
                        onChanged: _isPublishing
                            ? null
                            : (val) {
                                if (val != null) setState(() => _selectedCategory = val);
                              },
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: TextFormField(
                        controller: _dateController,
                        enabled: !_isPublishing,
                        decoration: InputDecoration(
                          labelText: 'Date / Month *',
                          hintText: 'e.g. August 2024',
                          prefixIcon: const Icon(Icons.calendar_today_outlined),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (val) => val == null || val.trim().isEmpty ? 'Date required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Title
                TextFormField(
                  controller: _titleController,
                  enabled: !_isPublishing,
                  decoration: InputDecoration(
                    labelText: 'Headline / Title *',
                    hintText: 'e.g. Sangai Express Feature: Women Vocational Drive',
                    prefixIcon: const Icon(Icons.title_rounded),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (val) => val == null || val.trim().isEmpty ? 'Title is required' : null,
                ),
                const SizedBox(height: 14),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  enabled: !_isPublishing,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description / Summary *',
                    hintText: 'Brief summary of the coverage, event, or press note...',
                    alignLabelWithHint: true,
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(bottom: 40),
                      child: Icon(Icons.description_outlined),
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (val) => val == null || val.trim().isEmpty ? 'Description required' : null,
                ),
                const SizedBox(height: 14),

                // External Link (optional)
                TextFormField(
                  controller: _externalLinkController,
                  enabled: !_isPublishing,
                  decoration: InputDecoration(
                    labelText: 'External URL / YouTube Link (Optional)',
                    hintText: 'https://youtube.com/... or https://news.com/...',
                    prefixIcon: const Icon(Icons.link_rounded),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 20),

                // Cloud File Uploads
                Text(
                  'Cloud Media & Attachments (Cloudinary)',
                  style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                ),
                const SizedBox(height: 10),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Media / Photo Upload Box
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _pickedMediaFile != null ? AppTheme.mintGreen.withValues(alpha: 0.4) : AppTheme.backgroundCard,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _pickedMediaFile != null ? AppTheme.primaryGreen : Colors.grey.shade300,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.image_outlined, size: 18, color: AppTheme.primaryGreen),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Banner / Image',
                                    style: GoogleFonts.outfit(fontSize: 12.5, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            if (_pickedMediaFile != null) ...[
                              Row(
                                children: [
                                  if (_pickedMediaFile!.bytes != null && !_pickedMediaFile!.name.endsWith('.mp4'))
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: Image.memory(
                                        _pickedMediaFile!.bytes!,
                                        width: 32,
                                        height: 32,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _pickedMediaFile!.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: const Icon(Icons.cancel, size: 16, color: Colors.grey),
                                    onPressed: _isPublishing ? null : () => setState(() => _pickedMediaFile = null),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                            ],
                            OutlinedButton.icon(
                              onPressed: _isPublishing ? null : _pickMediaFile,
                              icon: Icon(_pickedMediaFile == null ? Icons.upload : Icons.refresh, size: 14),
                              label: Text(_pickedMediaFile == null ? 'Select Image' : 'Change Image', style: const TextStyle(fontSize: 11)),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.primaryGreen,
                                side: const BorderSide(color: AppTheme.primaryGreen),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // PDF Press Clipping / Document Box
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _pickedPdfDoc != null ? AppTheme.mintGreen.withValues(alpha: 0.4) : AppTheme.backgroundCard,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _pickedPdfDoc != null ? AppTheme.primaryGreen : Colors.grey.shade300,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.picture_as_pdf_outlined, size: 18, color: AppTheme.primaryGreen),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'PDF Clipping (Opt.)',
                                    style: GoogleFonts.outfit(fontSize: 12.5, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            if (_pickedPdfDoc != null) ...[
                              Row(
                                children: [
                                  const Icon(Icons.file_present, size: 24, color: AppTheme.primaryGreen),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _pickedPdfDoc!.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: const Icon(Icons.cancel, size: 16, color: Colors.grey),
                                    onPressed: _isPublishing ? null : () => setState(() => _pickedPdfDoc = null),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                            ],
                            OutlinedButton.icon(
                              onPressed: _isPublishing ? null : _pickPdfDoc,
                              icon: Icon(_pickedPdfDoc == null ? Icons.attach_file : Icons.refresh, size: 14),
                              label: Text(_pickedPdfDoc == null ? 'Select PDF' : 'Change PDF', style: const TextStyle(fontSize: 11)),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.primaryGreen,
                                side: const BorderSide(color: AppTheme.primaryGreen),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Progress Indicator if publishing
                if (_isPublishing)
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
                            _uploadStatus,
                            style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppTheme.primaryGreen),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isPublishing ? null : () => Navigator.of(context).pop(),
                      child: Text('Cancel', style: GoogleFonts.inter(color: AppTheme.textMuted)),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: _isPublishing ? null : _handlePublish,
                      icon: const Icon(Icons.cloud_upload_outlined, size: 18),
                      label: const Text('Publish to Cloud'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
