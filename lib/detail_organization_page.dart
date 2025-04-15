import 'package:finance/date/client_model.dart';
import 'package:finance/date/currency_model.dart';
import 'package:finance/date/hive_boxes.dart';
import 'package:finance/edit_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class DetailOrganizationPage extends StatefulWidget {
  DetailOrganizationPage({super.key, required this.index});

  int index;
  @override
  State<DetailOrganizationPage> createState() => _DetailOrganizationPageState();
}

class _DetailOrganizationPageState extends State<DetailOrganizationPage> {
  String valut =
      Hive.box<CurrencyModel>(HiveBoxes.currencyModel).getAt(0)?.currency ??
          "\$";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
          child: LayoutBuilder(builder: (context, constraint) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraint.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      SizedBox(
                        width: 340.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(Icons.arrow_back,
                                  size: 32.w, color: const Color(0xFF4B1535)),
                            ),
                            Text(
                              Hive.box<ClientModel>(HiveBoxes.clientModel)
                                  .getAt(widget.index)!
                                  .company,
                              style: GoogleFonts.kronaOne(
                                fontWeight: FontWeight.w400,
                                fontSize: 18.sp,
                                color: const Color(0xFF4B1535),
                              ),
                            ),
                            SizedBox(width: 15.h),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 19.h,
                      ),
                      Container(
                        width: 362.w,
                        padding: EdgeInsets.only(
                            top: 24.h, bottom: 17.h, left: 13.w),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.r)),
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(0, 4),
                                  color: Colors.black.withValues(alpha: 0.25))
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 16.h),
                              child: GeneralInformationWidget(
                                title: "Contact person",
                                subtitle:
                                    Hive.box<ClientModel>(HiveBoxes.clientModel)
                                        .getAt(widget.index)!
                                        .contactPerson,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 16.h),
                              child: GeneralInformationWidget(
                                title: "Phone number",
                                subtitle:
                                    Hive.box<ClientModel>(HiveBoxes.clientModel)
                                        .getAt(widget.index)!
                                        .phoneNumber,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 16.h),
                              child: GeneralInformationWidget(
                                title: "Email",
                                subtitle:
                                    Hive.box<ClientModel>(HiveBoxes.clientModel)
                                        .getAt(widget.index)!
                                        .email,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Balance",
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w400),
                                ),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: const Color(0xFF56AA4E),
                                      radius: 13.r,
                                      child: Center(
                                          child: Text(
                                        valut,
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
                                      "${Hive.box<ClientModel>(HiveBoxes.clientModel).getAt(widget.index)!.paymentHistory.fold(0.0, (sum, element) => sum + element.sum)}$valut",
                                      style: TextStyle(
                                          height: 1,
                                          fontSize: 22.sp,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                SizedBox(
                                  width: 320.w,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 5.h),
                                        child: Text(
                                          "Payment history",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 18.sp),
                                        ),
                                      ),
                                      for (int i = 0;
                                          i <
                                              Hive.box<ClientModel>(
                                                      HiveBoxes.clientModel)
                                                  .getAt(widget.index)!
                                                  .paymentHistory
                                                  .length;
                                          i++)
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 13.r,
                                                  backgroundColor:
                                                      const Color(0xFF514EAA),
                                                  child: Center(
                                                    child: Icon(
                                                      Icons
                                                          .arrow_upward_outlined,
                                                      size: 24.w,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 13.w,
                                                ),
                                                Text(
                                                    DateFormat("dd.MM.yyyy")
                                                        .format(Hive.box<
                                                                    ClientModel>(
                                                                HiveBoxes
                                                                    .clientModel)
                                                            .getAt(
                                                                widget.index)!
                                                            .paymentHistory[i]
                                                            .paymentDate),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 22.sp))
                                              ],
                                            ),
                                            Text(
                                                "${Hive.box<ClientModel>(HiveBoxes.clientModel).getAt(widget.index)!.paymentHistory[i].sum} $valut",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 22.sp))
                                          ],
                                        )
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.paddingOf(context).bottom),
                        child: SizedBox(
                          width: 347.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          EditPage(
                                        index: widget.index,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 170.w,
                                  height: 47.h,
                                  decoration: BoxDecoration(
                                      color: const Color(0xFF514EAA),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.r))),
                                  child: Center(
                                    child: Text(
                                      "Edit",
                                      style: GoogleFonts.kronaOne(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Hive.box<ClientModel>(HiveBoxes.clientModel)
                                      .deleteAt(widget.index);
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: 170.w,
                                  height: 47.h,
                                  decoration: BoxDecoration(
                                      color: const Color(0xFFD7493C),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.r))),
                                  child: Center(
                                    child: Text(
                                      "Delete",
                                      style: GoogleFonts.kronaOne(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class GeneralInformationWidget extends StatelessWidget {
  const GeneralInformationWidget(
      {super.key, required this.title, required this.subtitle});
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w400),
        ),
        Text(
          subtitle,
          style: TextStyle(
              height: 1, fontSize: 22.sp, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}
