import 'package:finance/add_client_page.dart';
import 'package:finance/date/client_model.dart';
import 'package:finance/date/currency_model.dart';
import 'package:finance/date/hive_boxes.dart';
import 'package:finance/detail_organization_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CustomerManagementPage extends StatefulWidget {
  const CustomerManagementPage({super.key});

  @override
  State<CustomerManagementPage> createState() => _CustomerManagementPageState();
}

class _CustomerManagementPageState extends State<CustomerManagementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
          child: ValueListenableBuilder(
              valueListenable:
                  Hive.box<ClientModel>(HiveBoxes.clientModel).listenable(),
              builder: (context, Box<ClientModel> box, _) {
                return Align(
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      SizedBox(
                        width: 340.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: Text(
                                "Customer management",
                                style: GoogleFonts.kronaOne(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18.sp,
                                    color: const Color(0xFF4B1535)),
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
                      SizedBox(
                        height: 27.h,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  const AddClientPage(),
                            ),
                          );
                        },
                        child: Container(
                          width: 182.w,
                          height: 35.h,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.r)),
                              color: const Color(0xFFD7493C)),
                          child: Center(
                            child: Text(
                              "+Add a client",
                              style: GoogleFonts.kronaOne(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 49.h,
                      ),
                      for (int index = 0; index < box.values.length; index++)
                        Padding(
                          padding: EdgeInsets.only(bottom: 14.h),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      DetailOrganizationPage(
                                    index: index,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 7.w,
                                  right: 10.w,
                                  top: 10.h,
                                  bottom: 10.h),
                              width: 340.w,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.r)),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 4.r,
                                        offset: Offset(0, 4.h),
                                        color: Colors.black
                                            .withValues(alpha: 0.25))
                                  ]),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/company.svg",
                                    width: 27.w,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 6.w),
                                      child: Text(
                                        box.getAt(index)?.company ?? "",
                                        style: TextStyle(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      textAlign: TextAlign.end,
                                      "Balance: ${box.getAt(index)?.paymentHistory.fold(0.0, (sum, element) => sum + element.sum) ?? 0} ${Hive.box<CurrencyModel>(HiveBoxes.currencyModel).getAt(0)?.currency ?? "\$"}",
                                      style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                    ],
                  )),
                );
              })),
    );
  }
}
