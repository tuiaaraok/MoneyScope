import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:finance/date/currency_model.dart';
import 'package:finance/date/hive_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  Box<CurrencyModel> currncyModel =
      Hive.box<CurrencyModel>(HiveBoxes.currencyModel);
  MenuElem menu = MenuElem(
    isOpen: false,
    selectedElem: "Dollar",
    listElements: [
      "Dollar",
      "Euro",
      "Yen",
      "Pound Sterling",
      "Australian Dollar",
      "Canadian Dollar",
      "Swiss Franc",
      "Chinese Yuan Renminbi",
      "Hong Kong Dollar",
      "New Zealand Dollar",
      "Swedish Krona",
      "South Korean Won",
      "Singapore Dollar",
      "Norwegian Krone",
      "Mexican Peso",
      "Indian Rupee",
      "Russian Ruble",
      "South African Rand",
      "Brazilian Real",
      "Danish Krone",
      "Polish Zloty",
      "Turkish Lira",
      "Thai Baht",
      "Indonesian Rupiah",
      "Czech Koruna",
      "Hungarian Forint",
      "Chilean Peso",
      "Israeli New Shekel",
      "Saudi Riyal",
      "Philippine Peso",
    ],
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    menu.selectedElem =
        getCurrencyName(currncyModel.getAt(0)?.currency.toString() ?? "Dollar");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(
              width: 340.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 32.w),
                  Text(
                    "Settings",
                    style: GoogleFonts.kronaOne(
                      fontWeight: FontWeight.w400,
                      fontSize: 18.sp,
                      color: const Color(0xFF4B1535),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(
                      "assets/icons/menu.svg",
                      width: 32.w,
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 47.h,
              width: 340.w,
              margin: EdgeInsets.only(top: 40.h, bottom: 43.h),
              padding: EdgeInsets.symmetric(horizontal: 17.w),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8.r)),
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(0, 4),
                        color: Colors.black.withValues(alpha: 0.25))
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Currency",
                    style:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 18.sp),
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      onChanged: (value) {
                        setState(() {
                          menu.selectedElem = value.toString();
                          currncyModel.putAt(
                              0,
                              CurrencyModel(
                                  currency:
                                      getCurrencySymbol(value.toString())));
                        });
                      },
                      onMenuStateChange: (isOpen) {
                        setState(() {
                          menu.isOpen = isOpen;
                        });
                      },
                      customButton: Row(
                        children: [
                          Text(
                            menu.selectedElem,
                            style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF0800FF)),
                          ),
                          Icon(
                              menu.isOpen
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              size: 30.h,
                              color: const Color(0xFF0800FF)),
                        ],
                      ),
                      items: menu.listElements.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: SizedBox(
                            width: 355.w,
                            height: 50.h,
                            child: Center(
                              child: Text(
                                item,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16.sp),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      dropdownStyleData: DropdownStyleData(
                        width: 300.w,
                        maxHeight: 300.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.white,
                        ),
                        offset: Offset(-60.w, 0),
                      ),
                      menuItemStyleData: MenuItemStyleData(
                        customHeights:
                            List.filled(menu.listElements.length, 50.h),
                        padding:
                            EdgeInsets.only(top: 5.h, left: 10.w, right: 10.w),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 340.w,
              height: 249.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () async {
                      String? encodeQueryParameters(
                          Map<String, String> params) {
                        return params.entries
                            .map((MapEntry<String, String> e) =>
                                '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                            .join('&');
                      }

                      // ···
                      final Uri emailLaunchUri = Uri(
                        scheme: 'mailto',
                        path: 'kuryarmamdav@icloud.com',
                        query: encodeQueryParameters(<String, String>{
                          '': '',
                        }),
                      );
                      try {
                        if (await canLaunchUrl(emailLaunchUri)) {
                          await launchUrl(emailLaunchUri);
                        } else {
                          throw Exception("Could not launch $emailLaunchUri");
                        }
                      } catch (e) {
                        log('Error launching email client: $e'); // Log the error
                      }
                    },
                    child: const InfoSettingWidget(
                      title: "Contact us",
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final Uri url = Uri.parse(
                          'https://docs.google.com/document/d/1p6miguUx5EVXSWoKV8JfbolcfGjXbFVhy5tNEuQSgHw/mobilebasic');
                      if (!await launchUrl(url)) {
                        throw Exception('Could not launch $url');
                      }
                    },
                    child: const InfoSettingWidget(
                      title: "Privacy policy",
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      InAppReview.instance.openStoreListing(
                        appStoreId: '6744488722',
                      );
                      // 6744488722
                    },
                    child: const InfoSettingWidget(
                      title: "Rate us",
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Image.asset(
              "assets/menu.png",
              width: 348.w,
              height: 348.h,
            )
          ],
        ),
      )),
    );
  }
}

class InfoSettingWidget extends StatelessWidget {
  const InfoSettingWidget({
    super.key,
    required this.title,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340.w,
      height: 69.h,
      decoration: BoxDecoration(
          color: const Color(0xFF514EAA),
          borderRadius: BorderRadius.all(Radius.circular(10.62.r)),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 4),
                blurRadius: 3.54.r,
                color: Colors.black.withValues(alpha: 0.25))
          ]),
      child: Center(
        child: Text(
          title,
          style: GoogleFonts.kronaOne(
              fontSize: 15.93.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white),
        ),
      ),
    );
  }
}

class MenuElem {
  bool isOpen;
  String selectedElem;
  List<String> listElements;

  MenuElem({
    required this.isOpen,
    required this.selectedElem,
    required this.listElements,
  });
}

String getCurrencySymbol(String currencyName) {
  switch (currencyName) {
    case "Dollar":
      return "\$";
    case "Euro":
      return "€";
    case "Yen":
      return "¥";
    case "Pound Sterling":
      return "£";
    case "Australian Dollar":
      return "A\$";
    case "Canadian Dollar":
      return "C\$";
    case "Swiss Franc":
      return "CHF";
    case "Chinese Yuan Renminbi":
      return "¥";
    case "Hong Kong Dollar":
      return "HK\$";
    case "New Zealand Dollar":
      return "NZ\$";
    case "Swedish Krona":
      return "SEK";
    case "South Korean Won":
      return "₩";
    case "Singapore Dollar":
      return "S\$";
    case "Norwegian Krone":
      return "NOK";
    case "Mexican Peso":
      return "Mex\$";
    case "Indian Rupee":
      return "₹";
    case "Russian Ruble":
      return "₽";
    case "South African Rand":
      return "R";
    case "Brazilian Real":
      return "R\$";
    case "Danish Krone":
      return "DKK";
    case "Polish Zloty":
      return "zł";
    case "Turkish Lira":
      return "₺";
    case "Thai Baht":
      return "฿";
    case "Indonesian Rupiah":
      return "Rp";
    case "Czech Koruna":
      return "Kč";
    case "Hungarian Forint":
      return "Ft";
    case "Chilean Peso":
      return "CLP\$";
    case "Israeli New Shekel":
      return "₪";
    case "Saudi Riyal":
      return "﷼";
    case "Philippine Peso":
      return "₱";
    default:
      return "\$"; // По умолчанию возвращаем доллар
  }
}

String getCurrencyName(String currencySymbol) {
  switch (currencySymbol) {
    case "\$":
      return "Dollar";
    case "€":
      return "Euro";
    case "¥":
      return "Yen";
    case "£":
      return "Pound Sterling";
    case "A\$":
      return "Australian Dollar";
    case "C\$":
      return "Canadian Dollar";
    case "CHF":
      return "Swiss Franc";
    case "¥/CNY":
      return "Chinese Yuan Renminbi";
    case "HK\$":
      return "Hong Kong Dollar";
    case "NZ\$":
      return "New Zealand Dollar";
    case "SEK":
      return "Swedish Krona";
    case "₩":
      return "South Korean Won";
    case "S\$":
      return "Singapore Dollar";
    case "NOK":
      return "Norwegian Krone";
    case "Mex\$":
      return "Mexican Peso";
    case "₹":
      return "Indian Rupee";
    case "₽":
      return "Russian Ruble";
    case "R":
      return "South African Rand";
    case "R\$":
      return "Brazilian Real";
    case "DKK":
      return "Danish Krone";
    case "zł":
      return "Polish Zloty";
    case "₺":
      return "Turkish Lira";
    case "฿":
      return "Thai Baht";
    case "Rp":
      return "Indonesian Rupiah";
    case "Kč":
      return "Czech Koruna";
    case "Ft":
      return "Hungarian Forint";
    case "CLP\$":
      return "Chilean Peso";
    case "₪":
      return "Israeli New Shekel";
    case "﷼":
      return "Saudi Riyal";
    case "₱":
      return "Philippine Peso";
    default:
      return "Dollar"; // По умолчанию
  }
}
