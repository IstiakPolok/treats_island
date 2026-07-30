import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';

class Country {
  final String name;
  final String flag;
  final String code;

  const Country({required this.name, required this.flag, required this.code});
}

const List<Country> countriesList = [
  Country(name: 'Afghanistan', flag: '🇦🇫', code: '+93'),
  Country(name: 'Albania', flag: '🇦🇱', code: '+355'),
  Country(name: 'Algeria', flag: '🇩🇿', code: '+213'),
  Country(name: 'Andorra', flag: '🇦🇩', code: '+376'),
  Country(name: 'Angola', flag: '🇦🇴', code: '+244'),
  Country(name: 'Antigua and Barbuda', flag: '🇦🇬', code: '+1-268'),
  Country(name: 'Argentina', flag: '🇦🇷', code: '+54'),
  Country(name: 'Armenia', flag: '🇦🇲', code: '+374'),
  Country(name: 'Australia', flag: '🇦🇺', code: '+61'),
  Country(name: 'Austria', flag: '🇦🇹', code: '+43'),
  Country(name: 'Azerbaijan', flag: '🇦🇿', code: '+994'),
  Country(name: 'Bahamas', flag: '🇧🇸', code: '+1-242'),
  Country(name: 'Bahrain', flag: '🇧🇭', code: '+973'),
  Country(name: 'Bangladesh', flag: '🇧🇩', code: '+880'),
  Country(name: 'Barbados', flag: '🇧🇧', code: '+1-246'),
  Country(name: 'Belarus', flag: '🇧🇾', code: '+375'),
  Country(name: 'Belgium', flag: '🇧🇪', code: '+32'),
  Country(name: 'Belize', flag: '🇧🇿', code: '+501'),
  Country(name: 'Benin', flag: '🇧🇯', code: '+229'),
  Country(name: 'Bhutan', flag: '🇧🇹', code: '+975'),
  Country(name: 'Bolivia', flag: '🇧🇴', code: '+591'),
  Country(name: 'Bosnia and Herzegovina', flag: '🇧🇦', code: '+387'),
  Country(name: 'Botswana', flag: '🇧🇼', code: '+267'),
  Country(name: 'Brazil', flag: '🇧🇷', code: '+55'),
  Country(name: 'Brunei', flag: '🇧🇳', code: '+673'),
  Country(name: 'Bulgaria', flag: '🇧🇬', code: '+359'),
  Country(name: 'Burkina Faso', flag: '🇧🇫', code: '+226'),
  Country(name: 'Burundi', flag: '🇧🇮', code: '+257'),
  Country(name: 'Cambodia', flag: '🇰🇭', code: '+855'),
  Country(name: 'Cameroon', flag: '🇨🇲', code: '+237'),
  Country(name: 'Canada', flag: '🇨🇦', code: '+1'),
  Country(name: 'Cape Verde', flag: '🇨🇻', code: '+238'),
  Country(name: 'Central African Republic', flag: '🇨🇫', code: '+236'),
  Country(name: 'Chad', flag: '🇹🇩', code: '+235'),
  Country(name: 'Chile', flag: '🇨🇱', code: '+56'),
  Country(name: 'China', flag: '🇨🇳', code: '+86'),
  Country(name: 'Colombia', flag: '🇨🇴', code: '+57'),
  Country(name: 'Comoros', flag: '🇰🇲', code: '+269'),
  Country(name: 'Congo (Brazzaville)', flag: '🇨🇬', code: '+242'),
  Country(name: 'Congo (Kinshasa)', flag: '🇨🇩', code: '+243'),
  Country(name: 'Costa Rica', flag: '🇨🇷', code: '+506'),
  Country(name: 'Croatia', flag: '🇭🇷', code: '+385'),
  Country(name: 'Cuba', flag: '🇨🇺', code: '+53'),
  Country(name: 'Cyprus', flag: '🇨🇾', code: '+357'),
  Country(name: 'Czech Republic', flag: '🇨🇿', code: '+420'),
  Country(name: 'Denmark', flag: '🇩🇰', code: '+45'),
  Country(name: 'Djibouti', flag: '🇩🇯', code: '+253'),
  Country(name: 'Dominica', flag: '🇩🇲', code: '+1-767'),
  Country(name: 'Dominican Republic', flag: '🇩🇴', code: '+1-809'),
  Country(name: 'Ecuador', flag: '🇪🇨', code: '+593'),
  Country(name: 'Egypt', flag: '🇪🇬', code: '+20'),
  Country(name: 'El Salvador', flag: '🇸🇻', code: '+503'),
  Country(name: 'Equatorial Guinea', flag: '🇬🇶', code: '+240'),
  Country(name: 'Eritrea', flag: '🇪🇷', code: '+291'),
  Country(name: 'Estonia', flag: '🇪🇪', code: '+372'),
  Country(name: 'Eswatini', flag: '🇸🇿', code: '+268'),
  Country(name: 'Ethiopia', flag: '🇪🇹', code: '+251'),
  Country(name: 'Fiji', flag: '🇫🇯', code: '+679'),
  Country(name: 'Finland', flag: '🇫🇮', code: '+358'),
  Country(name: 'France', flag: '🇫🇷', code: '+33'),
  Country(name: 'Gabon', flag: '🇬🇦', code: '+241'),
  Country(name: 'Gambia', flag: '🇬🇲', code: '+220'),
  Country(name: 'Georgia', flag: '🇬🇪', code: '+995'),
  Country(name: 'Germany', flag: '🇩🇪', code: '+49'),
  Country(name: 'Ghana', flag: '🇬🇭', code: '+233'),
  Country(name: 'Greece', flag: '🇬🇷', code: '+30'),
  Country(name: 'Grenada', flag: '🇬🇩', code: '+1-473'),
  Country(name: 'Guatemala', flag: '🇬🇹', code: '+502'),
  Country(name: 'Guinea', flag: '🇬🇳', code: '+224'),
  Country(name: 'Guinea-Bissau', flag: '🇬🇼', code: '+245'),
  Country(name: 'Guyana', flag: '🇬🇾', code: '+592'),
  Country(name: 'Haiti', flag: '🇭🇹', code: '+509'),
  Country(name: 'Honduras', flag: '🇭🇳', code: '+504'),
  Country(name: 'Hong Kong', flag: '🇭🇰', code: '+852'),
  Country(name: 'Hungary', flag: '🇭🇺', code: '+36'),
  Country(name: 'Iceland', flag: '🇮🇸', code: '+354'),
  Country(name: 'India', flag: '🇮🇳', code: '+91'),
  Country(name: 'Indonesia', flag: '🇮🇩', code: '+62'),
  Country(name: 'Iran', flag: '🇮🇷', code: '+98'),
  Country(name: 'Iraq', flag: '🇮🇶', code: '+964'),
  Country(name: 'Ireland', flag: '🇮🇪', code: '+353'),
  Country(name: 'Israel', flag: '🇮🇱', code: '+972'),
  Country(name: 'Italy', flag: '🇮🇹', code: '+39'),
  Country(name: 'Jamaica', flag: '🇯🇲', code: '+1-876'),
  Country(name: 'Japan', flag: '🇯🇵', code: '+81'),
  Country(name: 'Jordan', flag: '🇯🇴', code: '+962'),
  Country(name: 'Kazakhstan', flag: '🇰🇿', code: '+7'),
  Country(name: 'Kenya', flag: '🇰🇪', code: '+254'),
  Country(name: 'Kiribati', flag: '🇰🇮', code: '+686'),
  Country(name: 'Kuwait', flag: '🇰🇼', code: '+965'),
  Country(name: 'Kyrgyzstan', flag: '🇰🇬', code: '+996'),
  Country(name: 'Laos', flag: '🇱🇦', code: '+856'),
  Country(name: 'Latvia', flag: '🇱🇻', code: '+371'),
  Country(name: 'Lebanon', flag: '🇱🇧', code: '+961'),
  Country(name: 'Lesotho', flag: '🇱🇸', code: '+266'),
  Country(name: 'Liberia', flag: '🇱🇷', code: '+231'),
  Country(name: 'Libya', flag: '🇱🇾', code: '+218'),
  Country(name: 'Liechtenstein', flag: '🇱🇮', code: '+423'),
  Country(name: 'Lithuania', flag: '🇱🇹', code: '+370'),
  Country(name: 'Luxembourg', flag: '🇱🇺', code: '+352'),
  Country(name: 'Macau', flag: '🇲🇴', code: '+853'),
  Country(name: 'Madagascar', flag: '🇲🇬', code: '+261'),
  Country(name: 'Malawi', flag: '🇲🇼', code: '+265'),
  Country(name: 'Malaysia', flag: '🇲🇾', code: '+60'),
  Country(name: 'Maldives', flag: '🇲🇻', code: '+960'),
  Country(name: 'Mali', flag: '🇲🇱', code: '+223'),
  Country(name: 'Malta', flag: '🇲🇹', code: '+356'),
  Country(name: 'Marshall Islands', flag: '🇲🇭', code: '+692'),
  Country(name: 'Mauritania', flag: '🇲🇷', code: '+222'),
  Country(name: 'Mauritius', flag: '🇲🇺', code: '+230'),
  Country(name: 'Mexico', flag: '🇲🇽', code: '+52'),
  Country(name: 'Micronesia', flag: '🇫🇲', code: '+691'),
  Country(name: 'Moldova', flag: '🇲🇩', code: '+373'),
  Country(name: 'Monaco', flag: '🇲🇨', code: '+377'),
  Country(name: 'Mongolia', flag: '🇲🇳', code: '+976'),
  Country(name: 'Montenegro', flag: '🇲🇪', code: '+382'),
  Country(name: 'Morocco', flag: '🇲🇦', code: '+212'),
  Country(name: 'Mozambique', flag: '🇲🇿', code: '+258'),
  Country(name: 'Myanmar', flag: '🇲🇲', code: '+95'),
  Country(name: 'Namibia', flag: '🇳🇦', code: '+264'),
  Country(name: 'Nauru', flag: '🇳🇷', code: '+674'),
  Country(name: 'Nepal', flag: '🇳🇵', code: '+977'),
  Country(name: 'Netherlands', flag: '🇳🇱', code: '+31'),
  Country(name: 'New Zealand', flag: '🇳🇿', code: '+64'),
  Country(name: 'Nicaragua', flag: '🇳🇮', code: '+505'),
  Country(name: 'Niger', flag: '🇳🇪', code: '+227'),
  Country(name: 'Nigeria', flag: '🇳🇬', code: '+234'),
  Country(name: 'North Korea', flag: '🇰🇵', code: '+850'),
  Country(name: 'North Macedonia', flag: '🇲🇰', code: '+389'),
  Country(name: 'Norway', flag: '🇳🇴', code: '+47'),
  Country(name: 'Oman', flag: '🇴🇲', code: '+968'),
  Country(name: 'Pakistan', flag: '🇵🇰', code: '+92'),
  Country(name: 'Palau', flag: '🇵🇼', code: '+680'),
  Country(name: 'Palestine', flag: '🇵🇸', code: '+970'),
  Country(name: 'Panama', flag: '🇵🇦', code: '+507'),
  Country(name: 'Papua New Guinea', flag: '🇵🇬', code: '+675'),
  Country(name: 'Paraguay', flag: '🇵🇾', code: '+595'),
  Country(name: 'Peru', flag: '🇵🇪', code: '+51'),
  Country(name: 'Philippines', flag: '🇵🇭', code: '+63'),
  Country(name: 'Poland', flag: '🇵🇱', code: '+48'),
  Country(name: 'Portugal', flag: '🇵🇹', code: '+351'),
  Country(name: 'Qatar', flag: '🇶🇦', code: '+974'),
  Country(name: 'Romania', flag: '🇷🇴', code: '+40'),
  Country(name: 'Russia', flag: '🇷🇺', code: '+7'),
  Country(name: 'Rwanda', flag: '🇷🇼', code: '+250'),
  Country(name: 'Saint Kitts and Nevis', flag: '🇰🇳', code: '+1-869'),
  Country(name: 'Saint Lucia', flag: '🇱🇨', code: '+1-758'),
  Country(
    name: 'Saint Vincent and the Grenadines',
    flag: '🇻🇨',
    code: '+1-784',
  ),
  Country(name: 'Samoa', flag: '🇼🇸', code: '+685'),
  Country(name: 'San Marino', flag: '🇸🇲', code: '+378'),
  Country(name: 'Sao Tome and Principe', flag: '🇸🇹', code: '+239'),
  Country(name: 'Saudi Arabia', flag: '🇸🇦', code: '+966'),
  Country(name: 'Senegal', flag: '🇸🇳', code: '+221'),
  Country(name: 'Serbia', flag: '🇷🇸', code: '+381'),
  Country(name: 'Seychelles', flag: '🇸🇨', code: '+248'),
  Country(name: 'Sierra Leone', flag: '🇸🇱', code: '+232'),
  Country(name: 'Singapore', flag: '🇸🇬', code: '+65'),
  Country(name: 'Slovakia', flag: '🇸🇰', code: '+421'),
  Country(name: 'Slovenia', flag: '🇸🇮', code: '+386'),
  Country(name: 'Solomon Islands', flag: '🇸🇧', code: '+677'),
  Country(name: 'Somalia', flag: '🇸🇴', code: '+252'),
  Country(name: 'South Africa', flag: '🇿🇦', code: '+27'),
  Country(name: 'South Korea', flag: '🇰🇷', code: '+82'),
  Country(name: 'South Sudan', flag: '🇸🇸', code: '+211'),
  Country(name: 'Spain', flag: '🇪🇸', code: '+34'),
  Country(name: 'Sri Lanka', flag: '🇱🇰', code: '+94'),
  Country(name: 'Sudan', flag: '🇸🇩', code: '+249'),
  Country(name: 'Suriname', flag: '🇸🇷', code: '+597'),
  Country(name: 'Sweden', flag: '🇸🇪', code: '+46'),
  Country(name: 'Switzerland', flag: '🇨🇭', code: '+41'),
  Country(name: 'Syria', flag: '🇸🇾', code: '+963'),
  Country(name: 'Taiwan', flag: '🇹🇼', code: '+886'),
  Country(name: 'Tajikistan', flag: '🇹🇯', code: '+992'),
  Country(name: 'Tanzania', flag: '🇹🇿', code: '+255'),
  Country(name: 'Thailand', flag: '🇹🇭', code: '+66'),
  Country(name: 'Timor-Leste', flag: '🇹🇱', code: '+670'),
  Country(name: 'Togo', flag: '🇹🇬', code: '+228'),
  Country(name: 'Tonga', flag: '🇹🇴', code: '+676'),
  Country(name: 'Trinidad and Tobago', flag: '🇹🇹', code: '+1-868'),
  Country(name: 'Tunisia', flag: '🇹🇳', code: '+216'),
  Country(name: 'Turkey', flag: '🇹🇷', code: '+90'),
  Country(name: 'Turkmenistan', flag: '🇹🇲', code: '+993'),
  Country(name: 'Tuvalu', flag: '🇹🇻', code: '+688'),
  Country(name: 'Uganda', flag: '🇺🇬', code: '+256'),
  Country(name: 'Ukraine', flag: '🇺🇦', code: '+380'),
  Country(name: 'United Arab Emirates', flag: '🇦🇪', code: '+971'),
  Country(name: 'United Kingdom', flag: '🇬🇧', code: '+44'),
  Country(name: 'United States', flag: '🇺🇸', code: '+1'),
  Country(name: 'Uruguay', flag: '🇺🇾', code: '+598'),
  Country(name: 'Uzbekistan', flag: '🇺🇿', code: '+998'),
  Country(name: 'Vanuatu', flag: '🇻🇺', code: '+678'),
  Country(name: 'Vatican City', flag: '🇻🇦', code: '+379'),
  Country(name: 'Venezuela', flag: '🇻🇪', code: '+58'),
  Country(name: 'Vietnam', flag: '🇻🇳', code: '+84'),
  Country(name: 'Yemen', flag: '🇾🇪', code: '+967'),
  Country(name: 'Zambia', flag: '🇿🇲', code: '+260'),
  Country(name: 'Zimbabwe', flag: '🇿🇼', code: '+263'),
];

class CountryCodePicker extends StatelessWidget {
  final Country selectedCountry;
  final ValueChanged<Country> onSelect;

  const CountryCodePicker({
    super.key,
    required this.selectedCountry,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return GestureDetector(
      onTap: () => _showCountryPickerBottomSheet(context),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: isTablet ? 12.0 : 12.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: const Color(0xFFE0E0E0),
              width: isTablet ? 1.5 : 1.5.w,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedCountry.flag,
              style: TextStyle(fontSize: isTablet ? 20.0 : 20.sp),
            ),
            SizedBox(width: isTablet ? 6.0 : 6.w),
            Text(
              selectedCountry.code,
              style: GoogleFonts.poppins(
                fontSize: isTablet ? 16.0 : 16.sp,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: AppColors.textHint,
              size: isTablet ? 20.0 : 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  void _showCountryPickerBottomSheet(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      constraints: isTablet ? const BoxConstraints(maxWidth: 450) : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(isTablet ? 20.0 : 20.r),
        ),
      ),
      builder: (context) {
        return _CountryPickerSheet(onSelect: onSelect);
      },
    );
  }
}

class _CountryPickerSheet extends StatefulWidget {
  final ValueChanged<Country> onSelect;

  const _CountryPickerSheet({required this.onSelect});

  @override
  State<_CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<_CountryPickerSheet> {
  late List<Country> filteredCountries;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredCountries = countriesList;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterCountries(String query) {
    setState(() {
      filteredCountries = countriesList
          .where(
            (country) =>
                country.name.toLowerCase().contains(query.toLowerCase()) ||
                country.code.contains(query),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(bottom: bottomInset),
      constraints: BoxConstraints(maxHeight: size.height * 0.7),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: isTablet ? 8.0 : 8.h),
          // Drag handle
          Container(
            width: isTablet ? 40.0 : 40.w,
            height: isTablet ? 4.0 : 4.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(isTablet ? 2.0 : 2.r),
            ),
          ),
          SizedBox(height: isTablet ? 16.0 : 16.h),
          // Title row
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isTablet ? 20.0 : 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Select Country',
                    style: GoogleFonts.poppins(
                      fontSize: isTablet ? 18.0 : 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.close,
                    color: AppColors.textPrimary,
                    size: isTablet ? 22.0 : 22.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: isTablet ? 12.0 : 12.h),
          // Search input field
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isTablet ? 20.0 : 20.w),
            child: TextField(
              controller: searchController,
              onChanged: _filterCountries,
              cursorColor: AppColors.primary,
              style: GoogleFonts.poppins(
                fontSize: isTablet ? 14.0 : 14.sp,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Search country or code...',
                hintStyle: GoogleFonts.poppins(
                  fontSize: isTablet ? 14.0 : 14.sp,
                  color: AppColors.textHint,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.textHint,
                  size: isTablet ? 20.0 : 20.sp,
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: isTablet ? 10.0 : 10.h,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(isTablet ? 10.0 : 10.r),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(isTablet ? 10.0 : 10.r),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(isTablet ? 10.0 : 10.r),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: isTablet ? 12.0 : 12.h),
          Expanded(
            child: filteredCountries.isEmpty
                ? Center(
                    child: Text(
                      'No countries found',
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 14.0 : 14.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 10.0 : 10.w,
                    ),
                    itemCount: filteredCountries.length,
                    itemBuilder: (context, index) {
                      final country = filteredCountries[index];
                      return ListTile(
                        leading: Text(
                          country.flag,
                          style: TextStyle(fontSize: isTablet ? 24.0 : 24.sp),
                        ),
                        title: Text(
                          country.name,
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 15.0 : 15.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        trailing: Text(
                          country.code,
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 15.0 : 15.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        onTap: () {
                          widget.onSelect(country);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
