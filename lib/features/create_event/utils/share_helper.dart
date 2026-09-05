import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ShareHelper {
  static Future<void> shareTextAndImage(
    String shareText,
    Rect? origin, {
    String? imageUrl,
    String? videoUrl,
  }) async {
    // Show a loading dialog if downloading takes a moment
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6FB6)),
        ),
      ),
      barrierDismissible: false,
    );

    try {
      final List<XFile> filesToShare = [];

      // Download custom video if available
      if (videoUrl != null && videoUrl.isNotEmpty && videoUrl != 'null') {
        final String videoFilename = 'video_${videoUrl.hashCode}.mp4';
        final file = await _downloadFile(videoUrl, videoFilename);
        if (file != null) {
          filesToShare.add(XFile(file.path));
        }
      }

      // Download custom image if available
      if (imageUrl != null && imageUrl.isNotEmpty && imageUrl != 'null') {
        final String imageFilename = 'image_${imageUrl.hashCode}.png';
        final file = await _downloadFile(imageUrl, imageFilename);
        if (file != null) {
          filesToShare.add(XFile(file.path));
        }
      }

      // If no custom media was downloaded, fallback to the default logo
      if (filesToShare.isEmpty) {
        try {
          final byteData = await rootBundle.load('assets/logo/logo.png');
          final tempDir = await getTemporaryDirectory();
          final file = await File('${tempDir.path}/logo.png').create();
          await file.writeAsBytes(
            byteData.buffer.asUint8List(
              byteData.offsetInBytes,
              byteData.lengthInBytes,
            ),
          );
          filesToShare.add(XFile(file.path));
        } catch (e) {
          debugPrint('Error preparing default logo share: $e');
        }
      }

      // Close loading dialog
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      if (filesToShare.isNotEmpty) {
        await SharePlus.instance.share(
          ShareParams(
            text: shareText,
            files: filesToShare,
            sharePositionOrigin: origin,
          ),
        );
      } else {
        await SharePlus.instance.share(
          ShareParams(
            text: shareText,
            sharePositionOrigin: origin,
          ),
        );
      }
    } catch (e) {
      // Close loading dialog if open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      debugPrint('Error preparing media share: $e');
      try {
        await SharePlus.instance.share(
          ShareParams(
            text: shareText,
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
