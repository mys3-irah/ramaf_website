import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class CloudinaryUploadResult {
  final bool isSuccess;
  final String? secureUrl;
  final String? publicId;
  final String? format;
  final int? bytes;
  final String? errorMessage;

  CloudinaryUploadResult({
    required this.isSuccess,
    this.secureUrl,
    this.publicId,
    this.format,
    this.bytes,
    this.errorMessage,
  });
}

class CloudinaryService {
  static final CloudinaryService _instance = CloudinaryService._internal();
  factory CloudinaryService() => _instance;
  CloudinaryService._internal();

  /// Cloudinary configuration
  static const String cloudName = 'zu7a4qdi';
  static const String uploadPreset = 'ramaf_preset';

  /// Upload file bytes directly to Cloudinary using unsigned upload preset
  /// [bytes] The file content as bytes (compatible with Web and Mobile)
  /// [fileName] The original or intended file name (e.g. photo.jpg, aadhaar.pdf)
  /// [folder] Optional folder name in Cloudinary (e.g. 'registrations', 'documents')
  /// [resourceType] 'image', 'raw', or 'auto' (default: 'auto')
  Future<CloudinaryUploadResult> uploadFile({
    required Uint8List bytes,
    required String fileName,
    String? folder,
    String resourceType = 'auto',
  }) async {
    try {
      final uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/$resourceType/upload');

      final request = http.MultipartRequest('POST', uri);

      // Add required Cloudinary fields for unsigned upload
      request.fields['upload_preset'] = uploadPreset;
      if (folder != null && folder.isNotEmpty) {
        request.fields['folder'] = folder;
      }

      // Add file from byte array
      final multipartFile = http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: fileName,
      );
      request.files.add(multipartFile);

      debugPrint('Cloudinary: Uploading $fileName (${bytes.length} bytes) to $cloudName...');

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String secureUrl = responseData['secure_url'] ?? responseData['url'] ?? '';
        final String publicId = responseData['public_id'] ?? '';
        final String format = responseData['format'] ?? '';
        final int fileBytes = responseData['bytes'] ?? bytes.length;

        debugPrint('Cloudinary: Upload successful! URL: $secureUrl');
        return CloudinaryUploadResult(
          isSuccess: true,
          secureUrl: secureUrl,
          publicId: publicId,
          format: format,
          bytes: fileBytes,
        );
      } else {
        final Map<String, dynamic>? errorData = jsonDecode(response.body) is Map ? jsonDecode(response.body) : null;
        final String errorMsg = errorData?['error']?['message'] ?? 'Upload failed with status code ${response.statusCode}';
        debugPrint('Cloudinary Upload Error (${response.statusCode}): $errorMsg');
        return CloudinaryUploadResult(
          isSuccess: false,
          errorMessage: errorMsg,
        );
      }
    } catch (e) {
      debugPrint('Cloudinary Upload Exception: $e');
      return CloudinaryUploadResult(
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }
}
