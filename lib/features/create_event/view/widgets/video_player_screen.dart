import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerScreen({super.key, required this.videoUrl});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _controller;
  bool _initialized = false;
  bool _downloading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    final String urlStr = widget.videoUrl;
    debugPrint('=== VideoPlayerScreen _initVideo: urlStr = $urlStr ===');
    if (urlStr.startsWith('http')) {
      setState(() {
        _downloading = true;
      });
      try {
        final tempDir = Directory.systemTemp;
        final String filename = 'video_${urlStr.hashCode}.mp4';
        final localFile = File('${tempDir.path}/$filename');

        if (!localFile.existsSync()) {
          final client = HttpClient();
          client.connectionTimeout = const Duration(seconds: 15);
          final request = await client.getUrl(Uri.parse(urlStr));
          final response = await request.close();
          if (response.statusCode == 200) {
            final IOSink sink = localFile.openWrite();
            await response.pipe(sink);
            await sink.close();
          } else {
            throw Exception(
              'Server returned status code ${response.statusCode}',
            );
          }
        }
        _controller = VideoPlayerController.file(localFile);
      } catch (e) {
        if (mounted) {
          setState(() {
            _downloading = false;
            _errorMessage = 'Failed to load video: $e';
          });
        }
        return;
      }
    } else {
      _controller = VideoPlayerController.file(File(urlStr));
    }

    try {
      await _controller!.initialize();
      if (mounted) {
        setState(() {
          _initialized = true;
          _downloading = false;
        });
        _controller!.play();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _downloading = false;
          _errorMessage = 'Failed to initialize player: $e';
        });
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: _downloading
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(color: Color(0xFFFF6FB6)),
                      SizedBox(height: 16.h),
                      Text(
                        'Buffering video...',
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: isTablet ? 14.0 : 14.sp,
                        ),
                      ),
                    ],
                  )
                : _errorMessage != null
                ? Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.redAccent,
                        fontSize: isTablet ? 14.0 : 14.sp,
                      ),
                    ),
                  )
                : _initialized && _controller != null
                ? AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  )
                : const CircularProgressIndicator(color: Colors.white),
          ),
          Positioned(
            top: 40.h,
            left: 20.w,
            child: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          if (_initialized &&
              _controller != null &&
              _errorMessage == null &&
              !_downloading)
            Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _controller!.value.isPlaying
                        ? _controller!.pause()
                        : _controller!.play();
                  });
                },
                child: CircleAvatar(
                  backgroundColor: Colors.black54,
                  radius: 30.r,
                  child: Icon(
                    _controller!.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white,
                    size: 32.sp,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
