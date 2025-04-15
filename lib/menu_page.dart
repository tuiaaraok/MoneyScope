import 'package:finance/accounting_for_finances_page.dart';
import 'package:finance/creating_reports_page.dart';
import 'package:finance/customer_management_page.dart';
import 'package:finance/issue_an_invoice_page.dart';
import 'package:finance/setting_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Image.asset(
              "assets/menu.png",
              width: 348.w,
              height: 348.h,
            ),
            SizedBox(
              height: 21.h,
            ),
            SizedBox(
              width: 330.w,
              height: 430.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MenuWidgetPage(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              const CustomerManagementPage(),
                        ),
                      );
                    },
                    title: "Customer management",
                  ),
                  MenuWidgetPage(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              const IssueAnInvoicePage(),
                        ),
                      );
                    },
                    title: "Issue an invoice",
                  ),
                  MenuWidgetPage(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              const AccountingForFinancesPage(),
                        ),
                      );
                    },
                    title: "Accounting for finances",
                  ),
                  MenuWidgetPage(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              const CreatingReportsPage(),
                        ),
                      );
                    },
                    title: "Reports",
                  ),
                  MenuWidgetPage(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              const SettingPage(),
                        ),
                      );
                    },
                    title: "Settings",
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class MenuWidgetPage extends StatelessWidget {
  MenuWidgetPage({super.key, required this.title, required this.onTap});
  final String title;
  Function() onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }
}
