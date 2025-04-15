import 'package:finance/add_operation_page.dart';
import 'package:finance/date/currency_model.dart';
import 'package:finance/date/finance_operation_model.dart';
import 'package:finance/date/hive_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class AccountingForFinancesPage extends StatefulWidget {
  const AccountingForFinancesPage({super.key});

  @override
  State<AccountingForFinancesPage> createState() =>
      _AccountingForFinancesPageState();
}

class _AccountingForFinancesPageState extends State<AccountingForFinancesPage> {
  String value =
      Hive.box<CurrencyModel>(HiveBoxes.currencyModel).getAt(0)?.currency ??
          "\$";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: ValueListenableBuilder(
            valueListenable:
                Hive.box<FinanceOperationModel>(HiveBoxes.financeOperationModel)
                    .listenable(),
            builder: (context, Box<FinanceOperationModel> box, _) {
              return Padding(
                padding:
                    EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
                child: SizedBox(
                  width: 360.w,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 32.w),
                          Expanded(
                            child: Text(
                              "Accounting for finances",
                              style: GoogleFonts.kronaOne(
                                fontWeight: FontWeight.w400,
                                fontSize: 18.sp,
                                color: const Color(0xFF4B1535),
                              ),
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
                      SizedBox(
                        height: 25.h,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  const AddOperationPage(),
                            ),
                          );
                        },
                        child: Container(
                          width: 209.w,
                          height: 35.h,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.r)),
                              color: const Color(0xFFD7493C)),
                          child: Center(
                            child: Text(
                              "+Add operation",
                              style: GoogleFonts.kronaOne(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minWidth: 152.w),
                          child: Container(
                            padding: EdgeInsets.only(
                                right: 27.w, left: 12.w, top: 3.h, bottom: 3.h),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.r)),
                                boxShadow: [
                                  BoxShadow(
                                      offset: const Offset(0, 4),
                                      color:
                                          Colors.black.withValues(alpha: 0.25))
                                ]),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Balance",
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w400),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: const Color(0xFF56AA4E),
                                      radius: 13.r,
                                      child: Center(
                                          child: Text(
                                        value,
                                        style: TextStyle(
                                            height: 1,
                                            fontSize: 22.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      )),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Text(
                                      textAlign: TextAlign.end,
                                      "${Hive.box<FinanceOperationModel>(HiveBoxes.financeOperationModel).values.fold(0.0, (sum, element) => element.operationType == "Income" ? sum + element.sum : sum - element.sum)}$value",
                                      style: TextStyle(
                                          height: 1,
                                          fontSize: 22.sp,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      ...box.values.map(
                        (e) {
                          return Container(
                            width: 360.w,
                            margin: EdgeInsets.only(top: 17.h),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.r)),
                                boxShadow: [
                                  BoxShadow(
                                      offset: const Offset(0, 4),
                                      color:
                                          Colors.black.withValues(alpha: 0.25))
                                ]),
                            padding: EdgeInsets.symmetric(
                                horizontal: 6.w, vertical: 6.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    e.operationType == "Income"
                                        ? CircleAvatar(
                                            radius: 13.r,
                                            backgroundColor:
                                                const Color(0xFF514EAA),
                                            child: Center(
                                              child: Icon(
                                                Icons.arrow_upward_outlined,
                                                size: 24.w,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                        : CircleAvatar(
                                            radius: 13.r,
                                            backgroundColor:
                                                const Color(0xFFD7493C),
                                            child: Center(
                                              child: Icon(
                                                Icons.arrow_downward,
                                                size: 24.w,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                    SizedBox(
                                      width: 13.w,
                                    ),
                                    Text(
                                        DateFormat("dd.MM.yyyy").format(e.date),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 22.sp))
                                  ],
                                ),
                                Text(
                                    "${e.operationType == "Income" ? "+" : "-"}${e.sum} $value",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 22.sp))
                              ],
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
