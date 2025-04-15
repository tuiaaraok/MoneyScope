import 'package:finance/menu_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      height: isActive ? 8.0.h : 8.h,
      width: isActive ? 40.w : 11.h,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : const Color(0xFF514EAA),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFEEEDFD),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: PageView(
                    physics: const ClampingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: const <Widget>[
                      WidgetForOnBoardingInfo(
                        assetImage: 'assets/onboarding1.png',
                        title:
                            'This is a universal financial management application for a company',
                      ),
                      WidgetForOnBoardingInfo(
                        assetImage: 'assets/onboarding2.png',
                        title:
                            'It allows you to issue invoices to clients, keep records of income and expenses, and analyze the financial situation',
                      ),
                      WidgetForOnBoardingInfo(
                        assetImage: 'assets/onboarding3.png',
                        title:
                            'Thanks to offline access, the app works in any environment, and the user-friendly interface makes it easy and efficient to use',
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 20.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _buildPageIndicator(),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_currentPage == 2) {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  const MenuPage(),
                            ),
                          );
                        }
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      },
                      child: Container(
                        width: 330.w,
                        height: 48.h,
                        decoration: BoxDecoration(
                            color: const Color(0xFF514EAA),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.r))),
                        child: Center(
                          child: _currentPage == 2
                              ? Text(
                                  'Let’s start!',
                                  style: GoogleFonts.kronaOne(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w400),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Next',
                                      style: GoogleFonts.kronaOne(
                                          color: Colors.white,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Colors.white,
                                      size: 20.w,
                                    )
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WidgetForOnBoardingInfo extends StatelessWidget {
  final String title;

  final String assetImage;

  const WidgetForOnBoardingInfo(
      {super.key, required this.title, required this.assetImage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 40.h, bottom: 40.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image(
            image: AssetImage(
              assetImage,
            ),
            fit: BoxFit.fitHeight,
            height: 311.h,
            width: 311.w,
          ),
          SizedBox(height: 41.h),
          SizedBox(
            width: 350.w,
            child: Text(
              title,
              textAlign: TextAlign.start,
              style: kTitleStyle,
            ),
          ),
        ],
      ),
    );
  }
}

final kTitleStyle = TextStyle(
  color: const Color(0xFF4B1535),
  fontWeight: FontWeight.w500,
  fontSize: 24.sp,
);

final kSubtitleStyle = TextStyle(
  color: Colors.grey,
  fontSize: 18.sp,
);
