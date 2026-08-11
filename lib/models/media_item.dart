import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MediaItem {
  final String? id;
  final String title;
  final String category; // 'Press', 'Photo', 'Video', 'Document', 'Event Gallery'
  final String date;
  final String description;
  final String mediaUrl; // Primary banner / cover image or video URL
  final List<String> galleryUrls; // Multiple photos for event galleries / albums
  final String? videoUrl; // Video URL (Cloudinary or YouTube)
  final String? documentUrl; // Cloudinary PDF press clipping or circular
  final String? externalLink; // Optional external news link / YouTube
  final IconData? fallbackIcon;
  final DateTime? createdAt;

  const MediaItem({
    this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.description,
    required this.mediaUrl,
    this.galleryUrls = const [],
    this.videoUrl,
    this.documentUrl,
    this.externalLink,
    this.fallbackIcon,
    this.createdAt,
  });

  factory MediaItem.fromMap(Map<String, dynamic> map, {String? docId}) {
    IconData defaultIcon = Icons.article_outlined;
    final cat = map['category'] as String? ?? 'Photo';
    if (cat == 'Photo' || cat == 'Event Gallery') {
      defaultIcon = Icons.photo_library_outlined;
    } else if (cat == 'Video') {
      defaultIcon = Icons.play_circle_fill_rounded;
    } else if (cat == 'Document') {
      defaultIcon = Icons.picture_as_pdf_rounded;
    } else {
      defaultIcon = Icons.newspaper_rounded;
    }

    DateTime? createdTime;
    if (map['createdAt'] is Timestamp) {
      createdTime = (map['createdAt'] as Timestamp).toDate();
    }

    List<String> parsedGallery = [];
    if (map['galleryUrls'] is List) {
      parsedGallery = (map['galleryUrls'] as List).map((e) => e.toString()).toList();
    }

    return MediaItem(
      id: docId ?? map['id'] as String?,
      title: map['title'] as String? ?? '',
      category: cat,
      date: map['date'] as String? ?? '',
      description: map['description'] as String? ?? '',
      mediaUrl: map['mediaUrl'] as String? ?? '',
      galleryUrls: parsedGallery,
      videoUrl: map['videoUrl'] as String?,
      documentUrl: map['documentUrl'] as String?,
      externalLink: map['externalLink'] as String?,
      fallbackIcon: defaultIcon,
      createdAt: createdTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category,
      'date': date,
      'description': description,
      'mediaUrl': mediaUrl,
      'galleryUrls': galleryUrls,
      'videoUrl': videoUrl ?? '',
      'documentUrl': documentUrl ?? '',
      'externalLink': externalLink ?? '',
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }
}
