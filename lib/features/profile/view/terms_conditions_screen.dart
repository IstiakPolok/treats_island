import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsConditionsScreen extends StatelessWidget {
  final bool isEmbedded;
  const TermsConditionsScreen({super.key, this.isEmbedded = false});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: !isEmbedded,
        leading: isEmbedded
            ? null
            : IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: const Color(0xFF1A1A2E),
                  size: isTablet ? 20.0 : 20.sp,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
        title: Text(
          'Terms & Conditions',
          style: GoogleFonts.poppins(
            color: const Color(0xFF1A1A2E),
            fontWeight: FontWeight.w600,
            fontSize: isTablet ? 16.0 : 16.sp,
          ),
        ),
        centerTitle: !isEmbedded,
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isTablet ? 650.0 : double.infinity,
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 20.0 : 20.w,
              vertical: isTablet ? 16.0 : 16.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Terms of Service',
                  style: GoogleFonts.poppins(
                    fontSize: isTablet ? 20.0 : 20.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                SizedBox(height: isTablet ? 8.0 : 8.h),
                Text(
                  'Last Updated: June 2026',
                  style: GoogleFonts.poppins(
                    fontSize: isTablet ? 12.0 : 12.sp,
                    color: Colors.black38,
                  ),
                ),
                SizedBox(height: isTablet ? 20.0 : 20.h),
                _buildSection(
                  context: context,
                  title: '1. Acceptance of Terms',
                  content:
                      'By downloading, installing, or using the Treats Island mobile application, you agree to be bound by these Terms & Conditions. If you do not agree, please do not use the application.',
                ),
                _buildSection(
                  context: context,
                  title: '2. User Accounts',
                  content:
                      'You are responsible for maintaining the confidentiality of your account information, including your password, and for all activity that occurs under your account. You agree to notify us immediately of any unauthorized use of your account.',
                ),
                _buildSection(
                  context: context,
                  title: '3. Pop-Up Stores & Fundraising',
                  content:
                      'Treats Island offers platforms for users to create virtual pop-up stores and run fundraising events. Organizers are responsible for verifying their payout credentials and complying with all local laws and regulations regarding fundraising and sales.',
                ),
                _buildSection(
                  context: context,
                  title: '4. Fees and Payments',
                  content:
                      'Transaction processing fees may apply to sales and donations. Details of applicable fees are provided during the setup of your store or fundraising event. All payouts are processed securely through our authorized payment providers.',
                ),
                _buildSection(
                  context: context,
                  title: '5. Prohibited Activities',
                  content:
                      'You agree not to use the application for any unlawful purposes, fraudulent activities, or to publish content that is misleading, offensive, or violates intellectual property rights.',
                ),
                _buildSection(
                  context: context,
                  title: '6. Limitation of Liability',
                  content:
                      'To the maximum extent permitted by law, Treats Island shall not be liable for any indirect, incidental, special, or consequential damages resulting from the use or inability to use our services.',
                ),
                _buildSection(
                  context: context,
                  title: '7. Changes to Terms',
                  content:
                      'We reserve the right to modify or replace these Terms & Conditions at any time. Your continued use of the application following any changes constitutes acceptance of those changes.',
                ),
                SizedBox(height: isTablet ? 30.0 : 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required String content,
  }) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return Padding(
      padding: EdgeInsets.only(bottom: isTablet ? 20.0 : 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: isTablet ? 14.0 : 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1A2E),
            ),
          ),
          SizedBox(height: isTablet ? 6.0 : 6.h),
          Text(
            content,
            style: GoogleFonts.poppins(
              fontSize: isTablet ? 12.0 : 12.sp,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
