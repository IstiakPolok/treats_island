import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'shop_hero_card.dart';
import 'shop_info_card.dart';

class ShopEmptyView extends StatelessWidget {
  const ShopEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ShopHeroCard(),
        SizedBox(height: 14.h),
        const ShopInfoCard(
          icon: Icons.star_border_rounded,
          title: 'Sell with your team',
          subtitle:
              '98% of Organizers that participate in their\nfundraiser help raise 2x more!',
        ),
        SizedBox(height: 12.h),
        const ShopInfoCard(
          icon: Icons.storefront_outlined,
          title: 'Your virtual Pop-Up Store',
          subtitle:
              'You\'ll have a unique link to share with your\nfriends and family',
        ),
        SizedBox(height: 24.h),
      ],
    );
  }
}
