import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/services/api_service.dart';
import '../../../core/services/shared_preferences_helper.dart';
import '../../create_event/controller/schedule_event_controller.dart';

class StoreNoteScreen extends StatefulWidget {
  const StoreNoteScreen({super.key});

  @override
  State<StoreNoteScreen> createState() => _StoreNoteScreenState();
}

class _StoreNoteScreenState extends State<StoreNoteScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  final List<String> _inspirationTexts = [
    "Support our fundraiser with every sweet purchase!\nBrowse our selection of premium candies, shipped straight to you. Thank you for helping us reach our goal!",
    "Sweet treats for a great cause!\nShop premium candies you won't find in regular stores. Every order supports our fundraiser. Thanks for your support! 🍭🍫",
    "Welcome to my Treats Island Candy Pop-Up Store! 🍬\nEnjoy delicious premium candies while supporting our fundraiser. Every purchase helps our cause, and your order is shipped directly to your door. Thank you for your support!",
    "Help us hit our goal with some sweetness! Shipped straight to you. 🍬",
    "Support our team while treating yourself! Your order ships right to your door. 🍫",
    "Got a sweet tooth? Support our fundraiser and get premium candies shipped straight to you! 🍭",
    "Every sweet purchase brings us one step closer to our goal. Thank you for your support! 🌟",
    "Treat yourself and support our cause! Premium treats shipped directly to your home. 🏡🍬",
    "Thank you for visiting my store! Buy some premium candy today to support our fundraiser. 🍭❤️",
    "Sweeten your day and make a difference! 50% of every sale goes directly to our team goal. 🎉",
    "Love candy? Support our group fundraiser with a delicious pack shipped straight to you! 🍬📦",
    "Help us make a difference! Premium candies delivered right to your door. Thanks for supporting us! 🌟",
    "Handcrafted, premium sweets for a wonderful cause. Thank you for helping us succeed! 🍫✨",
    "Support our team with the sweetest purchase you’ll make all week! Shipped to your door. 🍭",
    "Treats Island premium candies are here! Every purchase helps us reach our fundraising goal. 🍬",
    "Craving something sweet? Shop here to support our fundraiser! Directly shipped to you. 📦🍬",
    "Delicious candy, delivered to your door, for an amazing cause! Thank you for your support! ❤️",
    "Support our campaign today! Premium candies delivered straight to your home. 🍭🏠",
    "Join in and help us reach our target! Browse our premium, contactless candy store. 🍫",
    "Every container of candy sold helps us hit our goal. Thank you for being a supporter! 🌟🍬",
    "Sweet bites for a sweet cause! 50% of your purchase directly supports our team. 🍭",
    "Premium sweets you can't buy in stores, shipped straight to you. Thank you for supporting us! 🍬📦",
    "Help us reach our goal! Enjoy these incredible premium treats shipped directly to your door. ✨",
    "Welcome to my candy store! Every purchase here helps our group succeed. Thank you! ❤️🍭",
    "Treats Island premium candies are the perfect gift or snack. Order today to support us! 🍫📦",
    "Make your day a little sweeter! 50% of all sales support our organization. Thank you! 🌟",
    "Delicious premium treats shipped straight to you. Thank you for backing our fundraiser! 🍬🏡",
    "Help us get there! Your purchase supports our team directly and ships to your door. 📦❤️",
    "Satisfy your sweet tooth and support a great cause! Shipped directly to your home. 🍭",
    "Welcome! Please help us reach our target by grabbing some premium Treats Island candy. 🍬✨",
    "Premium candies for our fundraiser! Fast and contactless shipping directly to your door. 📦🍫",
    "Support our team fundraiser! Every box of candy ordered brings us closer to our dream. 🌟",
    "The sweetest way to show your support! Grab some premium Treats Island candy today. 🍭❤️",
    "Fast shipping, contactless delivery, and a great cause! Thank you for your support. 📦🍬",
    "Enjoy premium treats while supporting our group! Shipped straight to your door. 🏡🍫",
    "Help us achieve our goal! Treat your family to some premium Treats Island candies. ✨🍬",
    "Every sweet purchase makes a big difference! Thank you for supporting our fundraiser. 🍭",
    "Premium candy delivered directly to you. Order now and support our team! 📦❤️",
    "Welcome to my Pop-Up Store! Thank you for helping us reach our fundraising milestone. 🍬✨",
    "Treat yourself, support our team! 50% of your order goes directly to our fundraiser. 🍫",
    "Incredible premium candies shipped straight to your door. Thank you for supporting us! 📦🍭",
    "Make a sweet impact today! Order premium Treats Island candies to support our cause. ❤️",
    "Help us win! Order delicious, premium candies and have them shipped directly to you. 🍬🏆",
    "Support our team and enjoy some premium candy! Shipped straight to your home. 🏡🍫",
    "Hand-selected premium candies for a sweet cause. Thank you for your generous support! 🌟",
    "100% contactless shipping. Every purchase helps us reach our fundraising goal. 📦🍬",
    "Welcome supporters! Every order here helps our team get one step closer to our goal. 🍭✨",
    "Grab some premium candy and help us succeed! Shipped straight to your door. 🏡📦",
    "Sweeten someone’s day or your own! Shop now to support our active fundraiser. 🍫❤️",
    "Help us make it to the top! Your sweet purchase goes a long way. Thank you! 🌟🍬",
    "Enjoy premium sweets you won't find anywhere else, while backing our group! 🍭📦",
    "Welcome to my Treats Island store! Get premium treats shipped straight to your door. 🍬🏡",
    "Your support means the world to us! Order premium candy today to help us hit our goal. ❤️🍫",
  ];

  void _getInspiration() {
    final currentText = _controller.text.trim();
    final available = _inspirationTexts
        .where((t) => t.trim() != currentText)
        .toList();
    final listToPick = available.isEmpty ? _inspirationTexts : available;
    final random = Random();
    _controller.text = listToPick[random.nextInt(listToPick.length)];
  }

  final ApiService _apiService = Get.isRegistered<ApiService>()
      ? Get.find<ApiService>()
      : Get.put(ApiService());

  late final ScheduleEventController _eventController;

  @override
  void initState() {
    super.initState();
    _eventController = Get.isRegistered<ScheduleEventController>()
        ? Get.find<ScheduleEventController>()
        : Get.put(ScheduleEventController());

    final descVal = _eventController.fundraiserDetails['description'];
    if (descVal != null) {
      _controller.text = descVal.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _saveDescription() async {
    final fundraiserId = _eventController.fundraiserDetails['id'];
    if (fundraiserId == null) {
      Get.snackbar(
        'Error',
        'Fundraiser details not found.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final token = await SharedPreferencesHelper.getAccessToken();
    if (token == null || token.isEmpty) {
      Get.snackbar(
        'Error',
        'Authentication required.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final desc = _controller.text.trim();
      final response = await _apiService.updateFundraiserDescription(
        token,
        int.parse(fundraiserId.toString()),
        desc,
      );

      if (response.status.isOk && response.body != null) {
        final body = response.body as Map;
        if (body.containsKey('fundraiser') && body['fundraiser'] is Map) {
          _eventController.fundraiserDetails.value = Map<String, dynamic>.from(
            body['fundraiser'],
          );
        } else {
          _eventController.fundraiserDetails['description'] = desc;
          _eventController.fundraiserDetails.refresh();
        }

        Get.back(result: true);
        Get.snackbar(
          'Success',
          body['message']?.toString() ?? 'Description updated successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        String errorMsg = 'Failed to update description';
        if (response.body != null && response.body is Map) {
          final bodyMap = response.body as Map;
          if (bodyMap.containsKey('detail')) {
            errorMsg = bodyMap['detail'].toString();
          } else if (bodyMap.isNotEmpty) {
            errorMsg = bodyMap.values.first.toString();
          }
        }
        Get.snackbar('Error', errorMsg, snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.info_outline),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: _getInspiration,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEAF4),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: const Color(0xFFFFC9E1)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          size: 14.sp,
                          color: const Color(0xFFFF6FB6),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'Get Inspiration',
                          style: GoogleFonts.poppins(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFFF6FB6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                "TELL SUPPORTERS WHY YOU'RE FUNDRAISING!",
                style: GoogleFonts.antonSc(
                  fontSize: 20.sp,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'This will appear on your pop-up store',
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  color: Colors.black45,
                ),
              ),
              SizedBox(height: 14.h),
              TextField(
                controller: _controller,
                maxLines: 5,
                style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  color: const Color(0xFF1A1A2E),
                ),
                decoration: InputDecoration(
                  hintText: "What's the goal of this fundraiser?",
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: Colors.black38,
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFEDEDF2)),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF6FB6)),
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveDescription,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6FB6),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Save',
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
