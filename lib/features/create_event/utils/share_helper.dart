import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ShareHelper {
  static Future<void> shareTextAndImage(
    String shareText,
    Rect? origin, {
    String? imageUrl,
    String? videoUrl,
    String? title,
    String? subject,
  }) async {
    final bool hasMediaToDownload =
        (videoUrl != null && videoUrl.isNotEmpty && videoUrl != 'null') ||
        (imageUrl != null && imageUrl.isNotEmpty && imageUrl != 'null');

    if (hasMediaToDownload) {
      // Show a loading dialog if downloading takes a moment
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6FB6)),
          ),
        ),
        barrierDismissible: false,
      );
    }

    final String effectiveTitle =
        title ?? subject ?? 'Treats Island Pop-Up Store';
    final String effectiveSubject =
        subject ?? title ?? 'Treats Island Pop-Up Store';

    try {
      final List<XFile> filesToShare = [];

      // Download custom video if available
      if (videoUrl != null && videoUrl.isNotEmpty && videoUrl != 'null') {
        final String videoFilename = 'video_${videoUrl.hashCode}.mp4';
        final file = await _downloadFile(videoUrl, videoFilename);
        if (file != null) {
          filesToShare.add(
            XFile(
              file.path,
              mimeType: 'video/mp4',
              name: 'store_video.mp4',
            ),
          );
        }
      }

      // Download custom image if available
      if (imageUrl != null && imageUrl.isNotEmpty && imageUrl != 'null') {
        final String imageFilename = 'image_${imageUrl.hashCode}.png';
        final file = await _downloadFile(imageUrl, imageFilename);
        if (file != null) {
          filesToShare.add(
            XFile(
              file.path,
              mimeType: 'image/png',
              name: 'store_photo.png',
            ),
          );
        }
      }

      // Close loading dialog
      if (hasMediaToDownload && (Get.isDialogOpen ?? false)) {
        Get.back();
      }

      if (filesToShare.isNotEmpty) {
        await SharePlus.instance.share(
          ShareParams(
            text: shareText,
            title: effectiveTitle,
            subject: effectiveSubject,
            files: filesToShare,
            sharePositionOrigin: origin,
          ),
        );
      } else {
        await SharePlus.instance.share(
          ShareParams(
            text: shareText,
            title: effectiveTitle,
            subject: effectiveSubject,
            sharePositionOrigin: origin,
          ),
        );
      }
    } catch (e) {
      // Close loading dialog if open
      if (hasMediaToDownload && (Get.isDialogOpen ?? false)) {
        Get.back();
      }
      debugPrint('Error preparing media share: $e');
      try {
        await SharePlus.instance.share(
          ShareParams(
            text: shareText,
            title: effectiveTitle,
            subject: effectiveSubject,
            sharePositionOrigin: origin,
          ),
        );
      } catch (err) {
        debugPrint('Fallback share error: $err');
      }
    }
  }

  static Future<File?> _downloadFile(String url, String filename) async {
    try {
      final HttpClient client = HttpClient();
      final HttpClientRequest request = await client.getUrl(Uri.parse(url));
      final HttpClientResponse response = await request.close();
      if (response.statusCode == 200) {
        final List<int> bytes = [];
        await for (final List<int> chunk in response) {
          bytes.addAll(chunk);
        }
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/$filename');
        await file.writeAsBytes(bytes);
        return file;
      }
    } catch (e) {
      debugPrint('Error downloading file $url: $e');
    }
    return null;
  }
}
